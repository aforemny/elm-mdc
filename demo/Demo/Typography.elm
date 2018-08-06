module Demo.Typography exposing (view)

import Demo.Page exposing (Page)
import Html exposing (..)
import Material.Options as Options exposing (cs, css, nop, styled)
import Material.Typography as Typography


view : Page m -> Html m
view page =
    page.body "Typography"
        [ example "Styles" nop
        , example "Styles with margin adjustments" Typography.adjustMargin
        ]


example : String -> Options.Property c m -> Html m
example title adjustMargin =
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
        , styled Html.h1 [ Typography.display4, adjustMargin ] [ text "Display 4" ]
        , styled Html.h1 [ Typography.display3, adjustMargin ] [ text "Display 3" ]
        , styled Html.h1 [ Typography.display2, adjustMargin ] [ text "Display 2" ]
        , styled Html.h1 [ Typography.display1, adjustMargin ] [ text "Display 1" ]
        , styled Html.h1 [ Typography.headline, adjustMargin ] [ text "Headline" ]
        , styled Html.h2
            [ Typography.title, adjustMargin ]
            [ text "Title"
            , styled Html.span [ Typography.caption, adjustMargin ] [ text "Caption." ]
            ]
        , styled Html.h3 [ Typography.subheading2, adjustMargin ] [ text "Subheading 2" ]
        , styled Html.h4 [ Typography.subheading1, adjustMargin ] [ text "Subheading 1" ]
        , styled Html.p
            [ Typography.body2
            , adjustMargin
            ]
            [ text """Body 1 paragraph. Lorem ipsum dolor sit amet, consectetur
      adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore
      magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco
      laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in
      reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla
      pariatur."""
            ]
        , styled Html.aside
            [ Typography.body2
            , adjustMargin
            ]
            [ text "Body 2 text, calling something out."
            ]
        ]
