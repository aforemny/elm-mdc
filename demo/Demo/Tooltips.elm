module Demo.Tooltips exposing (Model, Msg(..), defaultModel, subscriptions, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text, a, br, h2, p)
import Html.Attributes as Html exposing (href)
import Html.Events as Html
import Material exposing (Index)
import Material.Button as Button
import Material.Options as Options exposing (aria, attribute, css, id, styled, when)
import Material.PlainTooltip as PlainTooltip exposing (withTooltip)
import Material.RichTooltip as RichTooltip
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
              --, Hero.component [] [ heroTooltip lift model ]
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
            , br [] []
            , br [] []
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Rich tooltip without interactive content" ]
            , RichTooltip.wrapper
                [ id "rich-tooltip-wrapper" ]
                [ Button.view (lift << Mdc)
                      "rich-tooltip-button"
                      model.mdc
                      [ Button.ripple
                      , RichTooltip.withTooltip (lift << Mdc) "rich-tooltip-wrapper" "rich-tooltip-button" "tt0"
                      , aria "describedby" "tt0"
                      ]
                      [ text "Button"
                      ]
                , RichTooltip.view (lift << Mdc)
                    "tt0"
                    model.mdc
                    [ id "tt0" ]
                    [ styled p [ RichTooltip.content ]
                          [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur pretium vitae est et dapibus. Aenean sit amet felis eu lorem fermentum aliquam sit amet sit amet eros." ]
                    ]
                ]
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Rich tooltip with interactive content" ]
            , RichTooltip.wrapper
                [ id "rich-interactive-tooltip-wrapper" ]
                [ Button.view (lift << Mdc)
                      "rich-interactive-tooltip-button"
                      model.mdc
                      [ Button.ripple
                      , RichTooltip.withInteractiveTooltip (lift << Mdc) model.mdc "rich-interactive-tooltip-wrapper" "rich-interactive-tooltip-button" "tt1"
                      ]
                      [ text "Button"
                      ]
                , RichTooltip.view (lift << Mdc)
                    "tt1"
                    model.mdc
                    [ id "tt1"
                    , RichTooltip.interactive
                    ]
                    [ styled h2 [ RichTooltip.title ] [ text "Lorem Ipsum" ]
                    , styled p [ RichTooltip.content ]
                          [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur pretium vitae est et dapibus. Aenean sit amet felis eu lorem fermentum aliquam sit amet sit amet eros. "
                          , styled a [ RichTooltip.contentLink, attribute <| href "google.com" ] [ text "link" ]
                          ]
                    , RichTooltip.actions []
                        [ RichTooltip.button [] [ text "action" ]
                        ]
                    ]
                ]
            , styled p [ css "padding" "3em" ] []
            ]
        ]
