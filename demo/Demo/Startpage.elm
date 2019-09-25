module Demo.Startpage exposing (view)

import Demo.Page exposing (Page)
import Demo.Startpage.Svg.Button as ButtonSvg
import Demo.Startpage.Svg.Card as CardSvg
import Demo.Startpage.Svg.Checkbox as CheckboxSvg
import Demo.Startpage.Svg.Chips as ChipsSvg
import Demo.Startpage.Svg.DataTable as DataTableSvg
import Demo.Startpage.Svg.Dialog as DialogSvg
import Demo.Startpage.Svg.Drawer as DrawerSvg
import Demo.Startpage.Svg.Elevation as ElevationSvg
import Demo.Startpage.Svg.Fab as FabSvg
import Demo.Startpage.Svg.IconButton as IconButtonSvg
import Demo.Startpage.Svg.ImageList as ImageListSvg
import Demo.Startpage.Svg.LayoutGrid as LayoutGridSvg
import Demo.Startpage.Svg.LinearProgress as LinearProgressSvg
import Demo.Startpage.Svg.List as ListSvg
import Demo.Startpage.Svg.Menu as MenuSvg
import Demo.Startpage.Svg.Radio as RadioSvg
import Demo.Startpage.Svg.Ripple as RippleSvg
import Demo.Startpage.Svg.Select as SelectSvg
import Demo.Startpage.Svg.Slider as SliderSvg
import Demo.Startpage.Svg.Snackbar as SnackbarSvg
import Demo.Startpage.Svg.Switch as SwitchSvg
import Demo.Startpage.Svg.TabBar as TabBarSvg
import Demo.Startpage.Svg.TextField as TextFieldSvg
import Demo.Startpage.Svg.Theme as ThemeSvg
import Demo.Startpage.Svg.TopAppBar as TopAppBarSvg
import Demo.Startpage.Svg.Typography as TypographySvg
import Demo.Url exposing (Url(..))
import Html exposing (Html, text)
import Html.Attributes exposing (href)
import Material.ImageList as ImageList
import Material.Options as Options exposing (attribute, cs, css, id, styled)


view : Page m -> Html m
view page =
    styled Html.div
        []
        [ page.topappbar "Material Components for the Web"
        , styled Html.nav
            []
            [ ImageList.view
                [ id "catalog-image-list" ]
                (List.map
                    (\{ url, title, subtitle, icon } ->
                        ImageList.item
                            [ ]
                            [ styled Html.a
                                [ attribute ( href (Demo.Url.toString url) )
                                , css "text-decoration" "none"
                                ]
                                [ ImageList.imageAspectContainer
                                    [ css "padding-bottom" "100%"
                                    , css "background-color" "#f5f5f5"
                                    ]
                                    [ ImageList.divImage [] [ icon ] ]
                                , ImageList.supporting []
                                    [ ImageList.label
                                        [ cs
                                            "catalog-image-list-label"
                                        ]
                                        [ text title ]
                                    ]
                                ]
                            ]
                    )
                    [ { url = Button
                      , icon = ButtonSvg.view
                      , title = "Button"
                      , subtitle = "Raised and flat buttons"
                      }
                    , { url = Card
                      , icon = CardSvg.view
                      , title = "Card"
                      , subtitle = "Various card layout styles"
                      }
                    , { url = Checkbox
                      , icon = CheckboxSvg.view
                      , title = "Checkbox"
                      , subtitle = "Multi-selection controls"
                      }
                    , { url = Chips
                      , icon = ChipsSvg.view
                      , title = "Chips"
                      , subtitle = "Chips"
                      }
                    , { url = DataTable
                      , icon = DataTableSvg.view
                      , title = "Data Table"
                      , subtitle = "Data Table"
                      }
                    , { url = Dialog
                      , icon = DialogSvg.view
                      , title = "Dialog"
                      , subtitle = "Secondary text"
                      }
                    , { url = Drawer
                      , icon = DrawerSvg.view
                      , title = "Drawer"
                      , subtitle = "Various drawer styles"
                      }
                    , { url = Elevation
                      , icon = ElevationSvg.view
                      , title = "Elevation"
                      , subtitle = "Shadow for different elevations"
                      }
                    , { url = Fabs
                      , icon = FabSvg.view
                      , title = "FAB"
                      , subtitle = "The primary action in an application"
                      }
                    , { url = IconButton
                      , icon = IconButtonSvg.view
                      , title = "Icon Button"
                      , subtitle = "Toggling icon states"
                      }
                    , { url = ImageList
                      , icon = ImageListSvg.view
                      , title = "Image List"
                      , subtitle = "An Image List consists of several items, each containing an image and optionally supporting content (i.e. a text label)"
                      }
                    , { url = LayoutGrid
                      , icon = LayoutGridSvg.view
                      , title = "Layout Grid"
                      , subtitle = "Grid and gutter support"
                      }
                    , { url = List
                      , icon = ListSvg.view
                      , title = "List"
                      , subtitle = "Item layouts in lists"
                      }
                    , { url = LinearProgress
                      , icon = LinearProgressSvg.view
                      , title = "Linear progress"
                      , subtitle = "Fills from 0% to 100%, represented by bars"
                      }
                    , { url = Menu
                      , icon = MenuSvg.view
                      , title = "Menu"
                      , subtitle = "Pop over menus"
                      }
                    , { url = RadioButton
                      , icon = RadioSvg.view
                      , title = "Radio"
                      , subtitle = "Single selection controls"
                      }
                    , { url = Ripple
                      , icon = RippleSvg.view
                      , title = "Ripple"
                      , subtitle = "Touch ripple"
                      }
                    , { url = Select
                      , icon = SelectSvg.view
                      , title = "Select"
                      , subtitle = "Popover selection menus"
                      }
                    , { url = Slider
                      , icon = SliderSvg.view
                      , title = "Slider"
                      , subtitle = "Range Controls"
                      }
                    , { url = Snackbar
                      , icon = SnackbarSvg.view
                      , title = "Snackbar"
                      , subtitle = "Transient messages"
                      }
                    , { url = Switch
                      , icon = SwitchSvg.view
                      , title = "Switch"
                      , subtitle = "On off switches"
                      }
                    , { url = TabBar
                      , icon = TabBarSvg.view
                      , title = "Tab Bar"
                      , subtitle = "Tabs organize and allow navigation between groups of content that are related and at the same level of hierarchy"
                      }
                    , { url = TextField
                      , icon = TextFieldSvg.view
                      , title = "Text field"
                      , subtitle = "Single and multiline text fields"
                      }
                    , { url = Theme
                      , icon = ThemeSvg.view
                      , title = "Theme"
                      , subtitle = "Using primary and accent colors"
                      }
                    , { url = TopAppBar Nothing
                      , icon = TopAppBarSvg.view
                      , title = "Top App Bar"
                      , subtitle = "Container for items such as application title, navigation icon, and action items."
                      }
                    , { url = Typography
                      , icon = TypographySvg.view
                      , title = "Typography"
                      , subtitle = "Type hierarchy"
                      }
                    ]
                )
            ]
        ]
