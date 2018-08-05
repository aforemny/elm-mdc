module Demo.Buttons exposing (Model, Msg(Mdc), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.Button as Button
import Material.Options as Options exposing (cs, css, styled, when)
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
                , additionalOptions =
                    [ Button.ripple
                    , css "margin" "8px 16px"
                    ]
                }

        raisedButtons idx =
            example idx
                lift
                model
                { title = "Raised Button"
                , additionalOptions =
                    [ Button.raised
                    , Button.ripple
                    , css "margin" "8px 16px"
                    ]
                }

        unelevatedButtons idx =
            example idx
                lift
                model
                { title = "Unelevated Button"
                , additionalOptions =
                    [ Button.unelevated
                    , Button.ripple
                    , css "margin" "8px 16px"
                    ]
                }

        outlinedButtons idx =
            example idx
                lift
                model
                { title = "Outlined Button"
                , additionalOptions =
                    [ Button.outlined
                    , Button.ripple
                    , css "margin" "8px 16px"
                    ]
                }
    in
    page.body "Buttons"
        [ styled Html.div
            [ cs "demo-wrapper"
            ]
            [ styled Html.h1
                [ cs "mdc-typography--headline5"

                -- TODO: Typography.headline5?
                ]
                [ styled Html.h1
                    [ Typography.headline5
                    ]
                    [ text "Button"
                    ]
                , styled Html.p
                    [ Typography.body1
                    ]
                    [ text """
Buttons communicate an action a user can take. They are typically placed
throughout your UI, in places like dialogs, forms, cards, and toolbars.
                        """
                    ]
                , Hero.view []
                    [ Button.view (lift << Mdc)
                        "buttons-hero-button-flat"
                        model.mdc
                        [ Button.ripple
                        , css "margin-right" "32px"
                        ]
                        [ text "Flat"
                        ]
                    , styled Html.h2
                        [ Typography.headline6
                        , css "border-bottom" "1px solid rgba(0,0,0,.87)"
                        ]
                        [ text "Raised"
                        ]
                    , ResourceLink.view
                        { link = "https://material.io/go/design-buttons"
                        , title = "Material Design Guidelines"
                        , icon = "images/material.svg"
                        , altText = "Material Design Guidelines icon"
                        }
                    , ResourceLink.view
                        { link = "https://material.io/components/web/catalog/buttons/"
                        , title = "Documentation"
                        , icon = "images/ic_drive_document_24px.svg"
                        , altText = "Documentation icon"
                        }
                    , ResourceLink.view
                        { link = "https://github.com/material-components/material-components-web/tree/master/packages/mdc-button"
                        , title = "Source Code (Material Components Web)"
                        , icon = "images/ic_code_24px.svg"
                        , altText = "Source Code"
                        }
                    , styled Html.h2
                        [ Typography.headline6
                        , css "border-bottom" "1px solid rgba(0,0,0,.87)"
                        ]
                        [ text "Outlined"
                        ]
                    ]
                , styled Html.h2
                    [ cs "mdc-typography--headline6"

                    -- TODO: Typography.headline6?
                    , css "border-bottom" "1px solid rgba(0,0,0,.87)"
                    ]
                    [ text "Resources"
                    ]
                , ResourceLink.view
                    { link = "https://material.io/go/design-buttons"
                    , title = "Material Design Guidelines"
                    , icon = "images/material.svg"
                    , altText = "Material Design Guidelines icon"
                    }
                , ResourceLink.view
                    { link = "https://material.io/components/web/catalog/buttons/"
                    , title = "Documentation"
                    , icon = "images/ic_drive_document_24px.svg"
                    , altText = "Documentation icon"
                    }
                , ResourceLink.view
                    { link = "https://github.com/material-components/material-components-web/tree/master/packages/mdc-button"
                    , title = "Source Code (Material Components Web)"
                    , icon = "images/ic_code_24px.svg"
                    , altText = "Source Code"
                    }
                , styled Html.h2
                    [ cs "mdc-typography--headline6"
                    , css "border-bottom" "1px solid rgba(0,0,0,.87)"
                    ]
                    [ text "Demos"
                    ]
                , textButtons "buttons-text-buttons"
                , raisedButtons "buttons-raised-buttons"
                , unelevatedButtons "buttons-unelevated-buttons"
                , outlinedButtons "buttons-outlined-buttons"
                ]
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
                (idx ++ "-baseline-button")
                model.mdc
                additionalOptions
                [ text "Baseline" ]
            , Button.view (lift << Mdc)
                (idx ++ "-dense-button")
                model.mdc
                (Button.dense :: additionalOptions)
                [ text "Dense" ]
            , Button.view (lift << Mdc)
                (idx ++ "-secondary-button")
                model.mdc
                (cs "secondary-button" :: additionalOptions)
                [ text "Secondary" ]
            , Button.view (lift << Mdc)
                (idx ++ "-icon-button")
                model.mdc
                (Button.icon "favorite" :: additionalOptions)
                [ text "Icon" ]
            , Button.view (lift << Mdc)
                (idx ++ "-link-button")
                model.mdc
                (Button.link "#buttons" :: additionalOptions)
                [ text "Link" ]
            ]
        ]
