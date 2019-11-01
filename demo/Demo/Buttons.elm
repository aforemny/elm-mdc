module Demo.Buttons exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.Button as Button
import Material.Options exposing (css, styled)
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    }


type Msg m
    = Mdc (Material.Msg m)


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    let
        textButtons idx =
            example idx
                lift
                model
                { title = "Text Button"
                , additionalOptions = []
                }

        raisedButtons idx =
            example idx
                lift
                model
                { title = "Raised Button"
                , additionalOptions = [ Button.raised ]
                }

        unelevatedButtons idx =
            example idx
                lift
                model
                { title = "Unelevated Button"
                , additionalOptions = [ Button.unelevated ]
                }

        outlinedButtons idx =
            example idx
                lift
                model
                { title = "Outlined Button"
                , additionalOptions = [ Button.outlined ]
                }

        shapedButtons idx =
            example idx
                lift
                model
                { title = "Shaped Button"
                , additionalOptions =
                    [ Button.unelevated
                    , css "border-radius" "18px"
                    ]
                }
    in
    page.body
        "Button"
        "Buttons communicate an action a user can take. They are typically placed throughout your UI, in places like dialogs, forms, cards, and toolbars."
        (Hero.view []
            [ Button.view (lift << Mdc)
                "buttons-hero-button-text"
                model.mdc
                [ Button.label "Text"
                , Button.ripple
                , css "margin" "16px 32px"
                ]
                []
            , Button.view (lift << Mdc)
                "buttons-hero-button-raised"
                model.mdc
                [ Button.label "Raised"
                , Button.ripple
                , Button.raised
                , css "margin" "16px 32px"
                ]
                []
            , Button.view (lift << Mdc)
                "buttons-hero-button-unelevated"
                model.mdc
                [ Button.label "Unelevated"
                , Button.ripple
                , Button.unelevated
                , css "margin" "16px 32px"
                ]
                []
            , Button.view (lift << Mdc)
                "buttons-hero-button-outlined"
                model.mdc
                [ Button.label "Outlined"
                , Button.ripple
                , Button.outlined
                , css "margin" "16px 32px"
                ]
                []
            ]
        )
        [ ResourceLink.links (lift << Mdc) model.mdc "buttons" "buttons" "mdc-button"
        , Page.demos
            [ textButtons "buttons-text-buttons"
            , raisedButtons "buttons-raised-buttons"
            , unelevatedButtons "buttons-unelevated-buttons"
            , outlinedButtons "buttons-outlined-buttons"
            , shapedButtons "buttons-shaped-buttons"
            ]
        ]


example :
    String
    -> (Msg m -> m)
    -> { a | mdc : Material.Model m }
    ->
        { title : String
        , additionalOptions : List (Button.Property m)
        }
    -> Html m
example idx lift model { title, additionalOptions } =
    styled Html.div
        []
        [ styled Html.h3
            [ Typography.subtitle1
            ]
            [ text title
            ]
        , styled Html.div
            []
            [ Button.view (lift << Mdc)
                (idx ++ "-default-button")
                model.mdc
                (css "margin" "8px 16px"
                    :: Button.label "Default"
                    :: Button.ripple
                    :: additionalOptions
                )
                []
            , Button.view (lift << Mdc)
                (idx ++ "-dense-button")
                model.mdc
                (css "margin" "8px 16px"
                    :: Button.label "Dense"
                    :: Button.ripple
                    :: Button.dense
                    :: additionalOptions
                )
                []
            , Button.view (lift << Mdc)
                (idx ++ "-icon-button")
                model.mdc
                (css "margin" "8px 16px"
                    :: Button.label "Icon"
                    :: Button.ripple
                    :: Button.icon "favorite"
                    :: additionalOptions
                )
                []
            ]
        ]
