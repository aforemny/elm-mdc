module Demo.Selects exposing (Model, Msg(..), defaultModel, subscriptions, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Html.Attributes as Html
import Html.Events as Html
import Material
import Material.Menu as Menu
import Material.Options exposing (cs, css, styled, when)
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


fruits =
        [ ( "apple", "Apple" )
        , ( "orange", "Orange" )
        , ( "banana", "Banana")
        ]

fruitsDict : Dict String String
fruitsDict =
    Dict.fromList fruits

items : String -> List (Menu.Item m)
items selectedValue =
    List.map
        (\(value, display) ->
             Select.option
             [ Select.value value
             , Select.selected |> when (value == selectedValue)
             ]
             [ text display ]
        )
        fruits


heroSelect : (Msg m -> m) -> Model m -> Html m
heroSelect lift model =
    Select.view (lift << Mdc)
        "selects-hero-select"
        model.mdc
        [ Select.label "Fruit" ]
        ( items "" )


theSelect : (Msg m -> m) -> Material.Index -> Model m -> List (Select.Property m) -> Html m
theSelect lift index model options =
    let
        selectedValue =
            Dict.get index model.selects
                |> Maybe.withDefault ""

        selectedText =
            Dict.get selectedValue fruitsDict
                |> Maybe.withDefault ""

    in
    Select.view (lift << Mdc)
        index
        model.mdc
        ( [ Select.label "Fruit"
        , Select.selectedText selectedText
        , Select.onSelect (Select index >> lift)
        ]
        ++ options )
        ( items selectedValue )


filledSelect : (Msg m -> m) -> Model m -> Html m
filledSelect lift model =
    theSelect lift "selects-filled-select" model []


outlinedSelect : (Msg m -> m) -> Model m -> Html m
outlinedSelect lift model =
    theSelect lift "selects-outlined-select" model
        [ Select.outlined
        ]


shapedFilledSelect : (Msg m -> m) -> Model m -> Html m
shapedFilledSelect lift model =
    theSelect lift "selects-shaped-filled-select" model
        [ css "border-radius" "17.92px 17.92px 0 0"
        ]


shapedOutlinedSelect : (Msg m -> m) -> Model m -> Html m
shapedOutlinedSelect lift model =
    theSelect lift "selects-shaped-outlined-select" model
        [ Select.outlined
        , cs "demo-select-outline-shaped"
        ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Select"
              , Hero.intro "Selects allow users to select from a single-option menu."
              , Hero.component [] [ heroSelect lift model ]
              ]
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
