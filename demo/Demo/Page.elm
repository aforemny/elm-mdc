module Demo.Page exposing (Page, ToolbarPage(..), Url(..), toolbar, hero)

import Html.Attributes as Html
import Html exposing (Html, text)
import Material
import Material.Msg
import Material.Options as Options exposing (Property, styled, cs, css, when)
import Material.Toolbar as Toolbar


type alias Page m =
    { toolbar : String -> Html m
    , setUrl : Url -> m
    , body : String -> List (Html m) -> Html m
    }


type Url
    = StartPage
    | Button
    | Card
    | Checkbox
    | Dialog
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
    | SimpleMenu
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
    | CustomToolbar



toolbar
  : (Material.Msg.Msg m -> m)
  -> Material.Msg.Index
  -> Material.Model
  -> (Url -> m)
  -> Url
  -> String
  -> Html m
toolbar lift idx mdl setUrl url title =
    Toolbar.render lift idx mdl
    [ Toolbar.fixed
    , when ( url == SimpleMenu ) <|
      css "z-index" "10"
    ]
    [ Toolbar.row []
      [ Toolbar.section
        [ Toolbar.alignStart
        ]
        [ Toolbar.icon_
          [ Toolbar.menu
          ]
          [ case url of
                StartPage ->
                    Html.img
                    [ Html.src "images/ic_component_24px_white.svg"
                    ]
                    []
                _ ->
                    styled Html.i
                    [ cs "material-icons"
                    , Options.onClick (setUrl StartPage)
                    , css "cursor" "pointer"
                    ]
                    [ text "arrow_back" ]
          ]
        , Toolbar.title [] [ text title ]
        ]
      ]
    ]


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
