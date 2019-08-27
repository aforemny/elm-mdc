module Demo.Helper.Hero exposing
    ( view
    , area )

import Html exposing (Html, div, p, text)
import Material.Options exposing (Property, cs, css, styled)
import Material.Typography as Typography


{-| The demo part of the hero area.
-}
view : List (Property c m) -> List (Html m) -> Html m
view options =
    styled Html.div
        ( cs "hero"
        :: css "box-sizing" "border-box"
        :: css "display" "-webkit-box"
        :: css "display" "-ms-flexbox"
        :: css "display" "flex"
        :: css "-webkit-box-orient" "horizontal"
        :: css "-webkit-box-direction" "normal"
        :: css "-ms-flex-flow" "row nowrap"
        :: css "flex-flow" "row nowrap"
        :: css "-webkit-box-align" "center"
        :: css "-ms-flex-align" "center"
        :: css "align-items" "center"
        :: css "-webkit-box-pack" "center"
        :: css "-ms-flex-pack" "center"
        :: css "justify-content" "center"
        :: css "order" "4"
        :: css "flex" "1 1 100%"
        :: css "min-height" "360px"
        :: css "padding" "24px"
        :: css "background-color" "#f2f2f2"
        :: css "overflow" "auto"
        :: options
        )


header : String -> Html m
header title =
    styled Html.h1
        [ Typography.headline3
        , cs "component-catalog-panel__header-elements"
        ]
        [ text title ]


{-| Style the hero area.
 -}
area : String -> String -> Html m -> Html m
area title intro demo =
    styled div
        [ cs "component-catalog-panel__hero-area"
        , css "height" "100%"
        , css "margin-bottom" "48px"
        ]
        [ styled div
              [ cs "component-catalog-panel__header"
              , css "display" "flex"
              , css "align-items" "flex-start"
              , css "height" "550px"
              ]
              [ header title
              , styled p
                  [ Typography.body1
                  , cs "component-catalog-panel__header-elements"
                  ]
                  [ text intro ]
              , demo
              ]
        ]
