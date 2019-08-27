module Demo.Url exposing
    ( TopAppBarPage(..)
    , Url(..)
    , fromString
    , fromUrl
    , toString
    )

import Url


type Url
    = StartPage
    | Button
    | Card
    | Checkbox
    | Chips
    | DataTable
    | Dialog
    | Drawer
    | DismissibleDrawer
    | ModalDrawer
    | PermanentDrawer
    | Elevation
    | Fabs
    | IconButton
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
    | TabBar
    | TextField
    | Theme
    | TopAppBar (Maybe TopAppBarPage)
    | Typography
    | Error404 String


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

        DataTable ->
            "#data-table"

        Dialog ->
            "#dialog"

        Drawer ->
            "#drawer"

        DismissibleDrawer ->
            "#dismissible-drawer"

        ModalDrawer ->
            "#modal-drawer"

        PermanentDrawer ->
            "#permanent-drawer"

        Elevation ->
            "#elevation"

        Fabs ->
            "#fab"

        IconButton ->
            "#icon-button"

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

        TabBar ->
            "#tabbar"

        TextField ->
            "#text-field"

        Theme ->
            "#theme"

        TopAppBar topAppBar ->
            topAppBarCase topAppBar

        Typography ->
            "#typography"

        Error404 requestedHash ->
            requestedHash


fromUrl : Url.Url -> Url
fromUrl url =
    fromString (Maybe.withDefault "" url.fragment)


fromString : String -> Url
fromString url =
    case url of
        "" ->
            StartPage

        "buttons" ->
            Button

        "cards" ->
            Card

        "checkbox" ->
            Checkbox

        "chips" ->
            Chips

        "data-table" ->
            DataTable

        "dialog" ->
            Dialog

        "drawer" ->
            Drawer

        "dismissible-drawer" ->
            DismissibleDrawer

        "modal-drawer" ->
            ModalDrawer

        "permanent-drawer" ->
            PermanentDrawer

        "elevation" ->
            Elevation

        "fab" ->
            Fabs

        "icon-button" ->
            IconButton

        "image-list" ->
            ImageList

        "layout-grid" ->
            LayoutGrid

        "linear-progress" ->
            LinearProgress

        "lists" ->
            List

        "radio-buttons" ->
            RadioButton

        "ripple" ->
            Ripple

        "select" ->
            Select

        "menu" ->
            Menu

        "slider" ->
            Slider

        "snackbar" ->
            Snackbar

        "switch" ->
            Switch

        "tabbar" ->
            TabBar

        "text-field" ->
            TextField

        "theme" ->
            Theme

        "top-app-bar" ->
            TopAppBar Nothing

        "top-app-bar/standard" ->
            TopAppBar (Just StandardTopAppBar)

        "top-app-bar/fixed" ->
            TopAppBar (Just FixedTopAppBar)

        "top-app-bar/dense" ->
            TopAppBar (Just DenseTopAppBar)

        "top-app-bar/prominent" ->
            TopAppBar (Just ProminentTopAppBar)

        "top-app-bar/short" ->
            TopAppBar (Just ShortTopAppBar)

        "top-app-bar/short-collapsed" ->
            TopAppBar (Just ShortCollapsedTopAppBar)

        "typography" ->
            Typography

        _ ->
            Error404 url
