module Demo.Page exposing (Page, ToolbarPage(..), Url(..), toolbar, fixedAdjust, hero)

import Html.Attributes as Html
import Html exposing (Html, text)
import Material
import Material.Msg
import Material.Options as Options exposing (Property, styled, cs, css, when)
import Material.Toolbar as Toolbar


type alias Page m =
    { toolbar : String -> Html m
    , fixedAdjust : Options.Property () m
    , setUrl : Url -> m
    , body : String -> List (Html m) -> Html m
    }


type Url
    = StartPage
    | Button
    | Card
    | Checkbox
    | Dialog
    | Drawer
    | TemporaryDrawer
    | PersistentDrawer
    | PermanentAboveDrawer
    | PermanentBelowDrawer
    | Elevation
    | Fabs
    | GridList
    | IconToggle
    | LayoutGrid
    | LinearProgress
    | List
    | RadioButton
    | Ripple
    | Select
    | Menu
    | Slider
    | Snackbar
    | Switch
    | Tabs
    | TextField
    | Theme
    | Toolbar (Maybe ToolbarPage)
    | Typography
    | Error404 String


type ToolbarPage
    = DefaultToolbar
    | FixedToolbar
    | MenuToolbar
    | WaterfallToolbar
    | DefaultFlexibleToolbar
    | WaterfallFlexibleToolbar
    | WaterfallToolbarFix


toolbar
  : (Material.Msg.Msg m -> m)
  -> Material.Msg.Index
  -> Material.Model
  -> (Url -> m)
  -> Url
  -> String
  -> Html m
toolbar lift idx mdl setUrl url title =
    Toolbar.view lift idx mdl
    [ Toolbar.fixed
    ]
    [ Toolbar.row []
      [ Toolbar.section
        [ Toolbar.alignStart
        ]
        [ styled Html.div
          [ cs "catalog-back"
          , css "padding-right" "24px"
          ]
          [ case url of
              StartPage ->
                  styled Html.img
                  [ cs "mdc-toolbar__menu-icon"
                  , Options.attribute (Html.src "images/ic_component_24px_white.svg")
                  ]
                  []

              _ ->
                  Toolbar.menuIcon
                  [ Options.onClick (setUrl StartPage)
                  ]
                  "arrow_back"
          ]
        , Toolbar.title
          [ cs "cataloge-title"
          , css "margin-left"
            ( if url == StartPage then
                  "8px"
              else
                  "24"
            )
          , css "font-family" "'Roboto Mono', monospace"
          ]
          [ text title ]
        ]
      ]
    ]



fixedAdjust : List Int -> Material.Model -> Options.Property c m
fixedAdjust idx mdl =
    Toolbar.fixedAdjust idx mdl


hero : List (Property c m) -> List (Html m) -> Html m
hero options =
    styled Html.section
    ( List.reverse -- TODO: dang it
      ( cs "hero"
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
      :: css "height" "360px"
      :: css "min-height" "360px"
      :: css "background-color" "rgba(0, 0, 0, 0.05)"
      :: options
      )
    )
