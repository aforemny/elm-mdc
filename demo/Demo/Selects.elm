module Demo.Selects exposing (Model, Msg(..), defaultModel, subscriptions, update, view)

import Array
import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, p, text)
import Html.Attributes as Html
import Html.Events as Html
import Material
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Select as Select
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m
    , selects : Dict Material.Index String
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , selects = Dict.empty
    }


type Msg m
    = Mdc (Material.Msg m)
    | Select Material.Index String


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        Select index value ->
            ( { model | selects = Dict.insert index value model.selects }, Cmd.none )


items : List (Html m)
items =
    [ Select.option [ Select.value "Apple" ] [ text "Apple" ]
    , Select.option [ Select.value "Orange" ] [ text "Orange" ]
    , Select.option [ Select.value "Banana" ] [ text "Banana" ]
    ]


heroSelect : (Msg m -> m) -> Model m -> Html m
heroSelect lift model =
    Select.view (lift << Mdc)
        "selects-hero-select"
        model.mdc
        [ Select.label "Fruit" ]
        items


filledSelect : (Msg m -> m) -> Model m -> Html m
filledSelect lift model =
    Select.view (lift << Mdc)
        "selects-filled-select"
        model.mdc
        [ Select.label "Fruit" ]
        items


outlinedSelect : (Msg m -> m) -> Model m -> Html m
outlinedSelect lift model =
    Select.view (lift << Mdc)
        "selects-outlined-select"
        model.mdc
        [ Select.label "Fruit"
        , Select.outlined
        ]
        items


shapedFilledSelect : (Msg m -> m) -> Model m -> Html m
shapedFilledSelect lift model =
    Select.view (lift << Mdc)
        "selects-shaped-filled-select"
        model.mdc
        [ Select.label "Fruit"
        , css "border-radius" "17.92px 17.92px 0 0"
        ]
        items


shapedOutlinedSelect : (Msg m -> m) -> Model m -> Html m
shapedOutlinedSelect lift model =
    Select.view (lift << Mdc)
        "selects-shaped-outlined-select"
        model.mdc
        [ Select.label "Fruit"
        , Select.outlined
        , cs "demo-select-outline-shaped"
        ]
        items


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body "Select"
        "Selects allow users to select from a single-option menu. It functions as a wrapper around the browser's native <select> element."
        [ Hero.view [] [ heroSelect lift model ]
        , ResourceLink.links (lift << Mdc) model.mdc "text-fields" "input-controls/select-menus" "mdc-select"
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Filled" ]
            , filledSelect lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Outlined" ]
            , outlinedSelect lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Shaped Filled" ]
            , shapedFilledSelect lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Shaped Outlined" ]
            , shapedOutlinedSelect lift model
            ]
        ]


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
