module Demo.Page exposing
    ( Page
    , Transition(..)
    , demos
    , drawer
    , drawerItems
    , subheader
    , topappbar
    , componentCatalogPanel
    )

import Array exposing (Array)
import Demo.Helper.Hero as Hero
import Demo.Url as Url exposing (Url)
import Html exposing (Html, div, h2, span, section, text)
import Html.Attributes as Html
import Material
import Material.Drawer.Dismissible as DismissibleDrawer
import Material.Drawer.Modal as ModalDrawer
import Material.Icon as Icon
import Material.Options as Options exposing (Property, cs, css, styled, when)
import Material.List as Lists
import Material.TopAppBar as TopAppBar
import Material.Typography as Typography


type alias Page m =
    { topappbar : String -> Html m
    , navigate : Url -> m
    , body : List (Html m) -> Html m
    }


topappbar :
    (Material.Msg m -> m)
    -> Material.Index
    -> Material.Model m
    -> m
    -> Url
    -> String
    -> Html m
topappbar lift idx mdc cmd url title =
    TopAppBar.view lift
        idx
        mdc
        [ cs "catalog-top-app-bar"
        ]
        [ TopAppBar.section
            [ TopAppBar.alignStart
            ]
            [ case url of
                  Url.StartPage ->
                      styled Html.img
                          [ cs "mdc-toolbar__menu-icon"
                          , Options.attribute (Html.src "images/ic_component_24px_white.svg")
                          ]
                          []

                  _ ->
                      TopAppBar.navigationIcon lift "my-menu" mdc
                          [ Options.onClick cmd ]
                          "menu"
            , TopAppBar.title
                  [ cs "catalog-top-app-bar__title"
                  ]
                  [ styled span [ cs "catalog-top-app-bar__title--small-screen" ] [ text "MDC Web" ]
                  , styled span [ cs "catalog-top-app-bar__title--large-screen" ] [ text title ]
                  ]
            ]
        ]


drawerItems : Array ( String, Url )
drawerItems =
    Array.fromList
        [ ( "Home", Url.StartPage )
        , ( "Button", Url.Button )
        , ( "Card", Url.Card )
        , ( "Checkbox", Url.Checkbox )
        , ( "Chips", Url.Chips )
        , ( "Data Table", Url.DataTable )
        , ( "Dialog", Url.Dialog )
        , ( "Drawer", Url.Drawer )
        , ( "Elevation", Url.Elevation )
        , ( "FAB", Url.Fabs )
        , ( "Icon Button", Url.IconButton )
        , ( "Image List", Url.ImageList )
        , ( "Layout Grid", Url.LayoutGrid )
        , ( "Linear Progress Indicator", Url.LinearProgress )
        , ( "List", Url.List )
        , ( "Menu", Url.Menu )
        , ( "Radio Button", Url.RadioButton )
        , ( "Ripple", Url.Ripple )
        , ( "Select", Url.Select )
        , ( "Slider", Url.Slider )
        , ( "Snackbar", Url.Snackbar )
        , ( "Switch", Url.Switch )
        , ( "Tab Bar", Url.TabBar )
        , ( "Text Field", Url.TextField )
        , ( "Theme", Url.Theme )
        , ( "Top App Bar", (Url.TopAppBar Nothing) )
        , ( "Typograpy", Url.Typography )
        ]

drawer :
    (Material.Msg m -> m)
    -> Material.Index
    -> Material.Model m
    -> m
    -> (Int -> m)
    -> Url
    -> Bool
    -> Bool
    -> Html m
drawer lift idx mdc close select current_url dismissible_drawer open =
    let
        a ( title, url ) =
            listItem title url current_url
    in
    ( if dismissible_drawer then DismissibleDrawer.view else ModalDrawer.view ) lift
        idx
        mdc
        [ ModalDrawer.open |> when open
        , ModalDrawer.onClose close
        , TopAppBar.fixedAdjust
        , css "z-index" "1" |> when dismissible_drawer
        ]
        [ ModalDrawer.header
              [ css "position" "absolute"
              , css "top" "18px"
              , css "opacity" ".74"
              , css "padding" "0 16px 4px 16px"
              ]
              [ styled Html.img
                    [ Options.attribute (Html.src "https://material-components.github.io/material-components-web-catalog/static/media/ic_material_design_24px.svg")
                    ]
                    [ ]
              ]
        , ModalDrawer.content
            [ ]
            [ Lists.nav lift "drawer-list" mdc
                  [ Lists.singleSelection
                  , Lists.useActivated
                  , Lists.onSelectListItem select
                  ]
                  ( List.map a ( Array.toList drawerItems) )
            ]
        ]


listItem : String -> Url -> Url -> Lists.ListItem m
listItem title url current_url =
    Lists.a
        [ Lists.activated |> when  ( current_url == url )
        ]
        [ text title
        ]


subheader : String -> Html m
subheader title =
    styled Html.h3
        [ Typography.subtitle1 ]
        [ text title ]


type Transition
    = None
    | Enter
    | Active
    | Done

componentCatalogPanel : Transition -> List (Html m) -> Html m
componentCatalogPanel transition nodes =
    styled section
        [ cs "component-catalog-panel"
        , cs "loadComponent-enter" |> when (transition == Enter || transition == Active)
        , cs "loadComponent-enter-active" |> when (transition == Active)
        , css "margin-top" "24px"
        , css "padding-bottom" "24px"
        ]
        nodes


demos : List (Html m) -> Html m
demos nodes =
    styled div
        [ css "padding-bottom" "20px" ]
        (styled h2
            [ Typography.headline6
            , css "border-bottom" "1px solid rgba(0,0,0,.87)"
            ]
            [ text "Demos" ]
            :: nodes
        )
