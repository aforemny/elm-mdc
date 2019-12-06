module Demo.Helper.Hero exposing
    ( view
    , component
    , options
    , header
    , intro
    , tabBar
    , tabContainer
    , tabContent
    )

import Html exposing (Html, div, p, text)
import Material.Options as Options exposing (Property, cs, css, styled)
import Material.TabBar as TabBar
import Material.Typography as Typography


{-| The demo part of the hero area.
-}
component : List (Property c m) -> List (Html m) -> Html m
component options_ =
    styled Html.div
        ( cs "hero"
        :: css "box-sizing" "border-box"
        :: css "display" "flex"
        :: css "-webkit-box-orient" "horizontal"
        :: css "-webkit-box-direction" "normal"
        :: css "-ms-flex-flow" "row nowrap"
        :: css "flex-flow" "column nowrap"
        :: css "-webkit-box-align" "center"
        :: css "-ms-flex-align" "center"
        :: css "align-items" "center"
        :: css "-webkit-box-pack" "center"
        :: css "-ms-flex-pack" "center"
        :: css "justify-content" "center"
        :: css "order" "4"
        :: css "flex" "1 1 100%"
        :: css "min-height" "360px"
        :: css "max-width" "860px"
        :: css "background-color" "#f7f7f7"
        :: css "overflow" "auto"
        :: options_
        )


header : String -> Html m
header title =
    styled Html.h1
        [ Typography.headline3
        , cs "component-catalog-panel__header-elements"
        ]
        [ text title ]


intro t =
    styled p
        [ Typography.body1
        , cs "component-catalog-panel__header-elements"
        ]
    [ text t ]


options nodes =
    styled div
        [ cs "hero-options component-catalog-panel__header-elements component-catalog-panel__header__hero-options"
        , css "max-height" "312px"
        ]
        nodes


{-| Style the hero area.
 -}
view : List (Html m) -> Html m
view nodes =
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
              nodes
        ]



tabBar msg model demoMsg elmMsg =
    let
        active_tab_index = 0
    in
    TabBar.view msg
        "catalog-hero-tab-bar"
        model.mdc
        [ TabBar.activeTab active_tab_index
        , css "background-color" "white"
        ]
        [ TabBar.tab
              [ cs "hero-tab"
              , Options.onClick demoMsg
              ]
              [ text "Demo" ]
        , TabBar.tab
              [ cs "hero-tab"
              , Options.onClick elmMsg
              ]
              [ text "Elm" ]
        ]

tabContainer options_ nodes =
    styled div
        ( cs "tab-container" :: options_ )
        nodes


tabContent : List (Property c m) -> List (Html m) -> Html m
tabContent options_ nodes =
    styled div
        ( cs "tab-content" :: options_ )
        nodes
