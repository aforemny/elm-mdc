module Demo.LinearProgress exposing (view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material.LinearProgress as LinearProgress
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Typography as Typography


view : Page m -> Html m
view page =
    let
        linearProgressDemo caption options nodes =
            styled Html.figure
                [ css "margin" "64px"
                ]
                (List.concat
                    [ nodes
                    , [ styled Html.figcaption
                            [ css "margin-top" "16px"
                            ]
                            [ text caption
                            ]
                      ]
                    ]
                )
    in
    page.body "Linear Progress Indicators"
        [ Page.hero []
            [ LinearProgress.view
                [ LinearProgress.indeterminate
                ]
                []
            ]
        , styled Html.section
            []
            [ styled Html.div
                [ css "margin" "24px"
                , css "margin-top" "0"
                , css "margin-bottom" "16px"
                ]
                [ styled Html.legend
                    [ Typography.title
                    , css "display" "block"
                    , css "padding" "16px"
                    , css "padding-top" "64px"
                    , css "padding-bottom" "24px"
                    ]
                    [ text "Linear Progress Indicators"
                    ]
                , linearProgressDemo "Determinate"
                    []
                    [ LinearProgress.view
                        [ LinearProgress.determinate 0.5
                        ]
                        []
                    ]
                , linearProgressDemo "Indeterminate"
                    []
                    [ LinearProgress.view
                        [ LinearProgress.indeterminate
                        ]
                        []
                    ]
                , linearProgressDemo "Buffer"
                    []
                    [ LinearProgress.view
                        [ LinearProgress.buffered 0.5 0.75
                        ]
                        []
                    ]
                , linearProgressDemo "Reversed"
                    []
                    [ LinearProgress.view
                        [ LinearProgress.reversed
                        , LinearProgress.determinate 0.5
                        ]
                        []
                    ]
                , linearProgressDemo "Indeterminate Reversed"
                    []
                    [ LinearProgress.view
                        [ LinearProgress.reversed
                        , LinearProgress.indeterminate
                        ]
                        []
                    ]
                , linearProgressDemo "Buffer Reversed"
                    []
                    [ LinearProgress.view
                        [ LinearProgress.reversed
                        , LinearProgress.buffered 0.5 0.75
                        ]
                        []
                    ]
                ]
            ]
        ]
