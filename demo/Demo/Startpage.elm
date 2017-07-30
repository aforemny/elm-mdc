module Demo.Startpage exposing (view)

import Html.Attributes as Html
import Html exposing (Html, text)
import Material.List as Lists
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Toolbar as Toolbar


view : (Int -> msg) -> Html msg
view selectTab =
    styled Html.div
    []
    [ styled Html.nav
      [ Toolbar.fixedAdjust
      ]
      [ Lists.ul
        [ Lists.twoLine
        , cs "catalog-list"
        , css "padding-left" "26px"
        ]
        ( [ { index = 0, icon = "ic_button_24px.svg", wip = False
            , title = "Button", subtitle = "Raised and flat buttons" }
          , { index = 1, icon = "ic_card_24px.svg", wip = False
            , title = "Card", subtitle = "Various card layout styles" }
          , { index = 2, icon = "ic_selection_control_24px.svg", wip = False
            , title = "Checkbox", subtitle = "Multi-selection controls" }
          , { index = 3, icon = "ic_dialog_24px.svg", wip = False
            , title = "Dialog", subtitle = "Secondary text" }
          , { index = -1, icon = "ic_side_navigation_24px.svg", wip = True
            , title = "Drawer", subtitle = "Temporary" }
          , { index = -1, icon = "ic_side_navigation_24px.svg", wip = True
            , title = "Drawer", subtitle = "Persistent" }
          , { index = -1, icon = "ic_side_navigation_24px.svg", wip = True
            , title = "Drawer", subtitle = "Permanent drawer above toolbar" }
          , { index = -1, icon = "ic_side_navigation_24px.svg", wip = True
            , title = "Drawer", subtitle = "Permanent drawer below toolbar" }
          , { index = 4, icon = "ic_shadow_24px.svg", wip = False
            , title = "Elevation", subtitle = "Shadow for different elevations" }
          , { index = -1, icon = "ic_button_24px.svg", wip = True
            , title = "Floating action button", subtitle = "The primary action in an application" }
          , { index = 5, icon = "ic_card_24px.svg", wip = False
            , title = "Grid list", subtitle = "2D grid layouts" }
          , { index = -1, icon = "ic_component_24px.svg", wip = True
            , title = "Icon toggle", subtitle = "Toggling icon states" }
          , { index = -1, icon = "ic_card_24px.svg", wip = True
            , title = "Layout grid", subtitle = "Grid and gutter support" }
          , { index = -1, icon = "ic_progress_activity.svg", wip = True
            , title = "Linear progress", subtitle = "Fills from 0% to 100%, represented by bars" }
          , { index = 6, icon = "ic_list_24px.svg", wip = False
            , title = "List", subtitle = "Item layouts in lists" }
          , { index = -1, icon = "ic_radio_button_24px.svg", wip = True
            , title = "Radio buttons", subtitle = "Single selection controls" }
          , { index = -1, icon = "ic_ripple_24px.svg", wip = True
            , title = "Ripple", subtitle = "Touch ripple" }
          , { index = -1, icon = "ic_menu_24px.svg", wip = True
            , title = "Select", subtitle = "Popover selection menus" }
          , { index = 7, icon = "ic_menu_24px.svg", wip = False
            , title = "Simple Menu", subtitle = "Pop over menus" }
          , { index = -1, icon = "slider.svg", wip = True
            , title = "Slider", subtitle = "Range Controls" }
          , { index = -1, icon = "ic_toast_24px.svg", wip = True
            , title = "Snackbar", subtitle = "Transient messages" }
          , { index = -1, icon = "ic_switch_24px.svg", wip = True
            , title = "Switch", subtitle = "On off switches" }
          , { index = 8, icon = "ic_tabs_24px.svg", wip = False
            , title = "Tabs", subtitle = "Tabs with support for icon and text labels" }
          , { index = 9, icon = "ic_text_field_24px.svg", wip = False
            , title = "Text field", subtitle = "Single and multiline text fields" }
          , { index = 10, icon = "ic_theme_24px.svg", wip = False
            , title = "Theme", subtitle = "Using primary and accent colors" }
          , { index = 11, icon = "ic_toolbar_24px.svg", wip = False
            , title = "Toolbar", subtitle = "Header and footers" }
          , { index = 12, icon = "ic_typography_24px.svg", wip = False
            , title = "Typography", subtitle = "Type hierarchy" }
          ]
          |> List.map (\{ index, title, subtitle, icon, wip } ->
               Lists.li
               [ Options.onClick (selectTab index)
                 |> when (not wip)
               , css "cursor" "pointer" |> when (not wip)
               , css "opacity" "0.5" |> when wip
               , css "height" "72px"
               ]
               [ Lists.startDetail
                 [ cs "catalog-list-icon"
                 ]
                 [ Html.img
                   [ Html.src ("images/" ++ icon)
                   ]
                   []
                 ]
               , Lists.text []
                 [ text title
                 , Lists.secondary []
                   [ text subtitle
                   ]
                 ]
               ]
             )
        )
      ]
    ]
