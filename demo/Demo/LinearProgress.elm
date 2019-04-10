module Demo.LinearProgress exposing (view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material.LinearProgress as LinearProgress
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Typography as Typography


view : Page m -> Html m
view page =
    page.body "Linear Progress Indicator"
        "Progress indicators display the length of a process or express an unspecified wait time."
        [ Hero.view []
            [ LinearProgress.view [ LinearProgress.determinate 0.5 ] []
            ]
        , styled Html.h2
            [ Typography.headline6
            , css "border-bottom" "1px solid rgba(0,0,0,.87)"
            ]
            [ text "Resources"
            ]
        , ResourceLink.view
            { link = "https://material.io/go/design-progress-indicators"
            , title = "Material Design Guidelines"
            , icon = "images/material.svg"
            , altText = "Material Design Guidelines icon"
            }
        , ResourceLink.view
            { link = "https://material.io/components/web/catalog/linear-progress/"
            , title = "Documentation"
            , icon = "images/ic_drive_document_24px.svg"
            , altText = "Documentation icon"
            }
        , ResourceLink.view
            { link = "https://github.com/material-components/material-components-web/tree/master/packages/mdc-linear-progress"
            , title = "Source Code (Material Components Web)"
            , icon = "images/ic_code_24px.svg"
            , altText = "Source Code"
            }
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Buffered" ]
            , LinearProgress.view [ LinearProgress.buffered 0.5 0.75 ] []
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Indeterminate" ]
            , LinearProgress.view [ LinearProgress.indeterminate ] []
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Reversed" ]
            , LinearProgress.view
                [ LinearProgress.determinate 0.5
                , LinearProgress.reversed
                ]
                []
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Reversed Buffered" ]
            , LinearProgress.view
                [ LinearProgress.buffered 0.5 0.75
                , LinearProgress.reversed
                ]
                []
            ]
        ]
