module Demo.Url exposing
  ( fromString
  , ToolbarPage(..)
  , toString
  , Url(..)
  )


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


toString : Url -> String
toString url =
    case url of
        StartPage ->
            "#"

        Button ->
            "#buttons"

        Card ->
            "#cards"

        Checkbox ->
            "#checkbox"

        Dialog ->
            "#dialog"

        Drawer ->
            "#drawer"

        TemporaryDrawer ->
            "#temporary-drawer"

        PersistentDrawer ->
            "#persistent-drawer"

        PermanentAboveDrawer ->
            "#permanent-drawer-above"

        PermanentBelowDrawer ->
            "#permanent-drawer-below"

        Elevation ->
            "#elevation"

        Fabs ->
            "#fab"

        GridList ->
            "#grid-list"

        IconToggle ->
            "#icon-toggle"

        LayoutGrid ->
            "#layout-grid"

        LinearProgress ->
            "#linear-progress"

        List ->
            "#lists"

        RadioButton ->
            "#radio-buttons"

        Ripple ->
            "#ripple"

        Select ->
            "#select"

        Menu ->
            "#menu"

        Slider ->
            "#slider"

        Snackbar ->
            "#snackbar"

        Switch ->
            "#switch"

        Tabs ->
            "#tabs"

        TextField ->
            "#text-field"

        Theme ->
            "#theme"

        Toolbar Nothing ->
            "#toolbar"

        Toolbar (Just DefaultToolbar) ->
            "#toolbar/default-toolbar"

        Toolbar (Just FixedToolbar) ->
            "#toolbar/fixed-toolbar"

        Toolbar (Just MenuToolbar) ->
            "#toolbar/menu-toolbar"

        Toolbar (Just WaterfallToolbar) ->
            "#toolbar/waterfall-toolbar"

        Toolbar (Just DefaultFlexibleToolbar) ->
            "#toolbar/default-flexible-toolbar"

        Toolbar (Just WaterfallFlexibleToolbar) ->
            "#toolbar/waterfall-flexible-toolbar"

        Toolbar (Just WaterfallToolbarFix) ->
            "#toolbar/waterfall-toolbar-fix-last-row"

        Typography ->
            "#typography"

        Error404 requestedHash ->
            requestedHash


fromString : String -> Url
fromString str =
    let
        case1 str =
            case String.uncons str of
                Nothing ->
                    Just <| StartPage

                Just ( '#', "" ) ->
                    Just <| StartPage

                Just ( '#', "buttons" ) ->
                    Just <| Button

                Just ( '#', "cards" ) ->
                    Just <| Card

                Just ( '#', "checkbox" ) ->
                    Just <| Checkbox

                Just ( '#', "dialog" ) ->
                    Just <| Dialog

                Just ( '#', "drawer" ) ->
                    Just <| Drawer

                Just ( '#', "temporary-drawer" ) ->
                    Just <| TemporaryDrawer

                Just ( '#', "persistent-drawer" ) ->
                    Just <| PersistentDrawer

                Just ( '#', "permanent-drawer-above" ) ->
                    Just <| PermanentAboveDrawer

                Just ( '#', "permanent-drawer-below" ) ->
                    Just <| PermanentBelowDrawer

                Just ( '#', "elevation" ) ->
                    Just <| Elevation

                Just ( '#', "fab" ) ->
                    Just <| Fabs

                Just ( '#', "grid-list" ) ->
                    Just <| GridList

                Just ( '#', "icon-toggle" ) ->
                    Just <| IconToggle

                Just ( '#', "layout-grid" ) ->
                    Just <| LayoutGrid

                Just ( '#', "linear-progress" ) ->
                    Just <| LinearProgress

                Just ( '#', "lists" ) ->
                    Just <| List

                _ ->
                    Nothing

        case2 str =
            case String.uncons str of
                Just ( '#', "radio-buttons" ) ->
                    Just <| RadioButton

                Just ( '#', "ripple" ) ->
                    Just <| Ripple

                Just ( '#', "select" ) ->
                    Just <| Select

                Just ( '#', "menu" ) ->
                    Just <| Menu

                Just ( '#', "slider" ) ->
                    Just <| Slider

                Just ( '#', "snackbar" ) ->
                    Just <| Snackbar

                Just ( '#', "switch" ) ->
                    Just <| Switch

                Just ( '#', "tabs" ) ->
                    Just <| Tabs

                Just ( '#', "text-field" ) ->
                    Just <| TextField

                Just ( '#', "theme" ) ->
                    Just <| Theme

                Just ( '#',  "toolbar" ) ->
                    Just <| Toolbar Nothing

                Just ( '#', "toolbar/default-toolbar" ) ->
                    Just <| Toolbar (Just DefaultToolbar)

                Just ( '#', "toolbar/fixed-toolbar" ) ->
                    Just <| Toolbar (Just FixedToolbar)

                Just ( '#', "toolbar/waterfall-toolbar" ) ->
                    Just <| Toolbar (Just WaterfallToolbar)

                Just ( '#', "toolbar/default-flexible-toolbar" ) ->
                    Just <| Toolbar (Just DefaultFlexibleToolbar)

                Just ( '#', "toolbar/waterfall-flexible-toolbar" ) ->
                    Just <| Toolbar (Just WaterfallFlexibleToolbar)

                Just ( '#', "toolbar/waterfall-toolbar-fix-last-row" ) ->
                    Just <| Toolbar (Just WaterfallToolbarFix)

                Just ( '#', "typography" ) ->
                    Just Typography

                _ ->
                    Nothing

    in
    case case1 str of
        Just url ->
            url

        Nothing ->
            case case2 str of
                Just url ->
                    url

                Nothing ->
                    Error404 str
