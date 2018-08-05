module Demo.Typography exposing (view)

import Demo.Page exposing (Page)
import Html exposing (..)
import Material.Options as Options exposing (cs, css, nop, styled)
import Material.Typography as Typography


view : Page m -> Html m
view page =
    page.body "Typography"
        [ example "Styles"
        ]


example : String -> Html m
example title =
    styled Html.section
        [ cs "demo-typography--section"
        , css "margin" "24px"
        , css "padding" "24px"
        , css "border" "1px solid #ddd"
        , Typography.typography
        ]
        [ styled Html.h2
            [ Typography.display1
            ]
            [ text title
            ]
        , styled Html.h1 [ Typography.headline1 ] [ text "Headline 1" ]
        , styled Html.h2 [ Typography.headline2 ] [ text "Headline 2" ]
        , styled Html.h3 [ Typography.headline3 ] [ text "Headline 3" ]
        , styled Html.h4 [ Typography.headline4 ] [ text "Headline 4" ]
        , styled Html.h5 [ Typography.headline5 ] [ text "Headline 5" ]
        , styled Html.h6 [ Typography.headline6 ] [ text "Headline 6" ]
        , styled Html.h6 [ Typography.subtitle1 ] [ text "Subtitle 1" ]
        , styled Html.h6 [ Typography.subtitle2 ] [ text "Subtitle 2" ]
        , styled Html.p
            [ Typography.body1
            ]
            [ text "Body 1. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quos blanditiis tenetur unde suscipit, quam beatae rerum inventore consectetur, neque doloribus, cupiditate numquam dignissimos laborum fugiat deleniti? Eum quasi quidem quibusdam."
            ]
        , styled Html.p
            [ Typography.body2
            ]
            [ text "Body 2. Lorem ipsum dolor sit amet consectetur adipisicing elit. Cupiditate aliquid ad quas sunt voluptatum officia dolorum cumque, possimus nihil molestias sapiente necessitatibus dolor saepe inventore, soluta id accusantium voluptas beatae."
            ]
        , styled Html.div
            [ Typography.button
            ]
            [ text "Button text"
            ]
        , styled Html.div
            [ Typography.caption
            ]
            [ text "Caption text"
            ]
        , styled Html.div
            [ Typography.overline
            ]
            [ text "Overline text"
            ]
        ]
