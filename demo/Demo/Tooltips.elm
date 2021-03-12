module Demo.Tooltips exposing (Model, Msg(..), defaultModel, subscriptions, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text, a)
import Html.Attributes as Html exposing (href)
import Html.Events as Html
import Material exposing (Index)
import Material.Options as Options exposing (aria, attribute, css, id, styled, when)
import Material.PlainTooltip as PlainTooltip exposing (withTooltip)
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , show : Bool
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , show = False
    }


type Msg m
    = Mdc (Material.Msg m)
    | ShowTooltip


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ShowTooltip ->
            ( { model | show = True }, Cmd.none )


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model


heroTooltip : (Msg m -> m) -> Model m -> Html m
heroTooltip lift model =
    PlainTooltip.view (lift << Mdc)
        "tooltip-hero"
        model.mdc
        [ PlainTooltip.shown
        , css "position" "static"
        ]
        [ text "lorem ipsum dolor" ]


plainTooltip : (Msg m -> m) -> Index -> Model m -> Html m
plainTooltip lift index model =
    PlainTooltip.view (lift << Mdc)
        index
        model.mdc
        []
        [ text "lorem ipsum dolor" ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Tooltip"
              , Hero.intro "Tooltips display informative text when users hover over, focus on, or tap an element."
              , Hero.component [] [ heroTooltip lift model ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "sliders" "input-controls/sliders" "mdc-slider"
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Plain tooltips" ]
            , plainTooltip lift "tooltip-id" model
            , styled a
                [ attribute <| href "www.google.com"
                , withTooltip (lift << Mdc) "link-id" "tooltip-id"
                ]
                [ text "Link" ]
            ]
        ]
