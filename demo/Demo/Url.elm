module Demo.Url
    exposing
        ( ToolbarPage(..)
        , TopAppBarPage(..)
        , Url(..)
        , fromString
        , toString
        )


type Url
    = StartPage
    | Button
    | Card
    | Checkbox
    | Chips
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
    | ImageList
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
    | TopAppBar (Maybe TopAppBarPage)
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


type TopAppBarPage
    = StandardTopAppBar
    | FixedTopAppBar
    | DenseTopAppBar
    | ProminentTopAppBar
    | ShortTopAppBar
    | ShortCollapsedTopAppBar


toString : Url -> String
toString url =
    let
        toolbarCase toolbar =
            case toolbar of
                Nothing ->
                    "#toolbar"

                Just DefaultToolbar ->
                    "#toolbar/default-toolbar"

                Just FixedToolbar ->
                    "#toolbar/fixed-toolbar"

                Just MenuToolbar ->
                    "#toolbar/menu-toolbar"

                Just WaterfallToolbar ->
                    "#toolbar/waterfall-toolbar"

                Just DefaultFlexibleToolbar ->
                    "#toolbar/default-flexible-toolbar"

                Just WaterfallFlexibleToolbar ->
                    "#toolbar/waterfall-flexible-toolbar"

                Just WaterfallToolbarFix ->
                    "#toolbar/waterfall-toolbar-fix-last-row"

        topAppBarCase topAppBar =
            case topAppBar of
                Nothing ->
                    "#top-app-bar"

                Just StandardTopAppBar ->
                    "#top-app-bar/standard"

                Just FixedTopAppBar ->
                    "#top-app-bar/fixed"

                Just DenseTopAppBar ->
                    "#top-app-bar/dense"

                Just ProminentTopAppBar ->
                    "#top-app-bar/prominent"

                Just ShortTopAppBar ->
                    "#top-app-bar/short"

                Just ShortCollapsedTopAppBar ->
                    "#top-app-bar/short-collapsed"
    in
    case url of
        StartPage ->
            "#"

        Button ->
            "#buttons"

        Card ->
            "#cards"

        Checkbox ->
            "#checkbox"

        Chips ->
            "#chips"

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

        ImageList ->
            "#image-list"

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

        Toolbar toolbar ->
            toolbarCase toolbar

        TopAppBar topAppBar ->
            topAppBarCase topAppBar

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

                Just ( '#', "chips" ) ->
                    Just <| Chips

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

                Just ( '#', "image-list" ) ->
                    Just <| ImageList

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

                _ ->
                    Nothing

        case3 str =
            case String.uncons str of
                Just ( '#', "toolbar" ) ->
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

                Just ( '#', "top-app-bar" ) ->
                    Just <| TopAppBar Nothing

                Just ( '#', "top-app-bar/standard" ) ->
                    Just <| TopAppBar (Just StandardTopAppBar)

                Just ( '#', "top-app-bar/fixed" ) ->
                    Just <| TopAppBar (Just FixedTopAppBar)

                Just ( '#', "top-app-bar/dense" ) ->
                    Just <| TopAppBar (Just DenseTopAppBar)

                Just ( '#', "top-app-bar/prominent" ) ->
                    Just <| TopAppBar (Just ProminentTopAppBar)

                Just ( '#', "top-app-bar/short" ) ->
                    Just <| TopAppBar (Just ShortTopAppBar)

                Just ( '#', "top-app-bar/short-collapsed" ) ->
                    Just <| TopAppBar (Just ShortCollapsedTopAppBar)

                Just ( '#', "typography" ) ->
                    Just Typography

                _ ->
                    Nothing
    in
    [ case1 str
    , case2 str
    , case3 str
    ]
        |> List.filterMap identity
        |> List.head
        |> Maybe.withDefault (Error404 str)
