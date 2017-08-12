module Demo.Page exposing (Page, Url(..), toolbar, hero)

import Html.Attributes as Html
import Html exposing (Html, text)
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
    | Toolbar
    | Typography
    | Error404 String


toolbar : (Url -> m) -> Url -> String -> Html m
toolbar setUrl url title =
    Toolbar.view
    [ Toolbar.fixed
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
