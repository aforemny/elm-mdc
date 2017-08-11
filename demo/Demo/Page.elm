module Demo.Page exposing (Page, Url(..), toolbar)

import Html.Attributes as Html
import Html exposing (Html, text)
import Material.Options as Options exposing (styled, cs, css, when)
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
