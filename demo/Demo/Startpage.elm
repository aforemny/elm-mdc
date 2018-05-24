module Demo.Startpage exposing (..)

import Demo.Page exposing (Page)
import Demo.Url exposing (Url(..))
import Html.Attributes as Html
import Html exposing (Html, text)
import Material.List as Lists
import Material.Options as Options exposing (styled, cs, css, when)


view : Page m -> Html m
view page =
    styled Html.div
    []
    [
      page.toolbar "elm-mdc demo"

    , styled Html.nav
      [ page.fixedAdjust
      ]
      [ Lists.ul
        [ Lists.twoLine
        ]
        ( [ { url = Button, icon = "ic_button_24px.svg"
            , title = "Button", subtitle = "Raised and flat buttons" }
          , { url = Card, icon = "ic_card_24px.svg"
            , title = "Card", subtitle = "Various card layout styles" }
          , { url = Checkbox, icon = "ic_selection_control_24px.svg"
            , title = "Checkbox", subtitle = "Multi-selection controls" }
          , { url = Dialog, icon = "ic_dialog_24px.svg"
            , title = "Dialog", subtitle = "Secondary text" }
          , { url = Drawer, icon = "ic_side_navigation_24px.svg"
            , title = "Drawer", subtitle = "Various drawer styles" }
          , { url = Elevation, icon = "ic_shadow_24px.svg"
            , title = "Elevation", subtitle = "Shadow for different elevations" }
          , { url = Fabs, icon = "ic_button_24px.svg"
            , title = "Floating action button", subtitle = "The primary action in an application" }
          , { url = GridList, icon = "ic_card_24px.svg"
            , title = "Grid list", subtitle = "2D grid layouts" }
          , { url = IconToggle, icon = "ic_component_24px.svg"
            , title = "Icon toggle", subtitle = "Toggling icon states" }
          , { url = LayoutGrid, icon = "ic_card_24px.svg"
            , title = "Layout grid", subtitle = "Grid and gutter support" }
          , { url = LinearProgress, icon = "ic_progress_activity.svg"
            , title = "Linear progress", subtitle = "Fills from 0% to 100%, represented by bars" }
          , { url = List, icon = "ic_list_24px.svg"
            , title = "List", subtitle = "Item layouts in lists" }
          , { url = Menu, icon = "ic_menu_24px.svg"
            , title = "Menu", subtitle = "Pop over menus" }
          , { url = RadioButton, icon = "ic_radio_button_24px.svg"
            , title = "Radio buttons", subtitle = "Single selection controls" }
          , { url = Ripple, icon = "ic_ripple_24px.svg"
            , title = "Ripple", subtitle = "Touch ripple" }
          , { url = Select, icon = "ic_menu_24px.svg"
            , title = "Select", subtitle = "Popover selection menus" }
          , { url = Slider, icon = "slider.svg"
            , title = "Slider", subtitle = "Range Controls" }
          , { url = Snackbar, icon = "ic_toast_24px.svg"
            , title = "Snackbar", subtitle = "Transient messages" }
          , { url = Switch, icon = "ic_switch_24px.svg"
            , title = "Switch", subtitle = "On off switches" }
          , { url = Tabs, icon = "ic_tabs_24px.svg"
            , title = "Tabs", subtitle = "Tabs with support for icon and text labels" }
          , { url = TextField, icon = "ic_text_field_24px.svg"
            , title = "Text field", subtitle = "Single and multiline text fields" }
          , { url = Theme, icon = "ic_theme_24px.svg"
            , title = "Theme", subtitle = "Using primary and accent colors" }
          , { url = Toolbar Nothing, icon = "ic_toolbar_24px.svg"
            , title = "Toolbar", subtitle = "Header and footers" }
          , { url = TopAppBar Nothing, icon = "ic_toolbar_24px.svg"
            , title = "Top App Bar", subtitle = "container for items such as application title, navigation icon, and action items." }
          , { url = Typography, icon = "ic_typography_24px.svg"
            , title = "Typography", subtitle = "Type hierarchy" }
          ]
          |> List.map (\{ url, title, subtitle, icon } ->
               Lists.li
               [ Options.onClick (page.navigate url)
               , css "cursor" "pointer"
               , css "height" "72px"
               ]
               [ Lists.graphic
                 [ cs "demo-catalog-list-icon"
                 , css "margin" "0 24px 0 12px"
                 ]
                 [ Html.img
                   [ Html.src ("images/" ++ icon)
                   ]
                   []
                 ]
               , Lists.text []
                 [ text title
                 , Lists.secondaryText []
                   [ text subtitle
                   ]
                 ]
               ]
             )
        )
      ]
    ]
