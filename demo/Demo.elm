port module Main exposing (..)

import Demo.Buttons
import Demo.Cards
import Demo.Checkbox
import Demo.Dialog
import Demo.Drawer
import Demo.Elevation
import Demo.Fabs
import Demo.GridList
import Demo.IconToggle
import Demo.LayoutGrid
import Demo.LinearProgress
import Demo.Lists
import Demo.Menus
import Demo.Page as Page exposing (Url(..), ToolbarPage(..))
import Demo.PermanentAboveDrawer
import Demo.PermanentBelowDrawer
import Demo.PersistentDrawer
import Demo.RadioButtons
import Demo.Ripple
import Demo.Selects
import Demo.Slider
import Demo.Snackbar
import Demo.Startpage
import Demo.Switch
import Demo.Tabs
import Demo.TemporaryDrawer
import Demo.Textfields
import Demo.Theme
import Demo.Theme
import Demo.Toolbar
import Demo.Typography
import Html exposing (Html, text)
import Material
import Material.Options as Options exposing (styled, css, when)
import Material.Toolbar as Toolbar
import Material.Typography as Typography
import Navigation
import Platform.Cmd exposing (..)
import RouteUrl as Routing


port scrollTop : () -> Cmd msg


type alias Model =
    { mdl : Material.Model
    , url : Url
    , buttons : Demo.Buttons.Model
    , cards : Demo.Cards.Model
    , checkbox : Demo.Checkbox.Model
    , dialog : Demo.Dialog.Model
    , drawer : Demo.Drawer.Model
    , elevation : Demo.Elevation.Model
    , fabs : Demo.Fabs.Model
    , gridList : Demo.GridList.Model
    , iconToggle : Demo.IconToggle.Model
    , layoutGrid : Demo.LayoutGrid.Model
    , lists : Demo.Lists.Model
    , menus : Demo.Menus.Model
    , permanentAboveDrawer : Demo.PermanentAboveDrawer.Model
    , permanentBelowDrawer : Demo.PermanentBelowDrawer.Model
    , persistentDrawer : Demo.PersistentDrawer.Model
    , radio : Demo.RadioButtons.Model
    , ripple : Demo.Ripple.Model
    , selects : Demo.Selects.Model
    , slider : Demo.Slider.Model
    , snackbar : Demo.Snackbar.Model
    , switch : Demo.Switch.Model
    , tabs : Demo.Tabs.Model
    , temporaryDrawer : Demo.TemporaryDrawer.Model
    , textfields : Demo.Textfields.Model
    , theme : Demo.Theme.Model
    , toolbar : Demo.Toolbar.Model
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , url = StartPage
    , buttons = Demo.Buttons.defaultModel
    , cards = Demo.Cards.defaultModel
    , checkbox = Demo.Checkbox.defaultModel
    , dialog = Demo.Dialog.defaultModel
    , drawer = Demo.Drawer.defaultModel
    , elevation = Demo.Elevation.defaultModel
    , fabs = Demo.Fabs.defaultModel
    , gridList = Demo.GridList.defaultModel
    , iconToggle = Demo.IconToggle.defaultModel
    , layoutGrid = Demo.LayoutGrid.defaultModel
    , lists = Demo.Lists.defaultModel
    , menus = Demo.Menus.defaultModel
    , permanentAboveDrawer = Demo.PermanentAboveDrawer.defaultModel
    , permanentBelowDrawer = Demo.PermanentBelowDrawer.defaultModel
    , persistentDrawer = Demo.PersistentDrawer.defaultModel
    , radio = Demo.RadioButtons.defaultModel
    , ripple = Demo.Ripple.defaultModel
    , selects = Demo.Selects.defaultModel
    , slider = Demo.Slider.defaultModel
    , snackbar = Demo.Snackbar.defaultModel
    , switch = Demo.Switch.defaultModel
    , tabs = Demo.Tabs.defaultModel
    , temporaryDrawer = Demo.TemporaryDrawer.defaultModel
    , textfields = Demo.Textfields.defaultModel
    , theme = Demo.Theme.defaultModel
    , toolbar = Demo.Toolbar.defaultModel
    }


type Msg
    = Mdl (Material.Msg Msg)
    | SetUrl Url
    | ButtonsMsg (Demo.Buttons.Msg Msg)
    | CardsMsg (Demo.Cards.Msg Msg)
    | CheckboxMsg (Demo.Checkbox.Msg Msg)
    | DialogMsg (Demo.Dialog.Msg Msg)
    | DrawerMsg (Demo.Drawer.Msg Msg)
    | ElevationMsg (Demo.Elevation.Msg Msg)
    | FabsMsg (Demo.Fabs.Msg Msg)
    | GridListMsg (Demo.GridList.Msg Msg)
    | IconToggleMsg (Demo.IconToggle.Msg Msg)
    | LayoutGridMsg (Demo.LayoutGrid.Msg)
    | ListsMsg (Demo.Lists.Msg Msg)
    | PermanentAboveDrawerMsg (Demo.PermanentAboveDrawer.Msg Msg)
    | PermanentBelowDrawerMsg (Demo.PermanentBelowDrawer.Msg Msg)
    | PersistentDrawerMsg (Demo.PersistentDrawer.Msg Msg)
    | RadioButtonsMsg (Demo.RadioButtons.Msg Msg)
    | RippleMsg (Demo.Ripple.Msg Msg)
    | SelectMsg (Demo.Selects.Msg Msg)
    | MenuMsg (Demo.Menus.Msg Msg)
    | SliderMsg (Demo.Slider.Msg Msg)
    | SnackbarMsg (Demo.Snackbar.Msg Msg)
    | SwitchMsg (Demo.Switch.Msg Msg)
    | TabsMsg (Demo.Tabs.Msg Msg)
    | TemporaryDrawerMsg (Demo.TemporaryDrawer.Msg Msg)
    | TextfieldMsg (Demo.Textfields.Msg Msg)
    | ThemeMsg (Demo.Theme.Msg Msg)
    | ToolbarMsg (Demo.Toolbar.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg ->
            Material.update Mdl msg model

        SetUrl url ->
            { model | url = url } ! [ scrollTop () ]

        ButtonsMsg msg_ ->
            let
                (buttons, effects) =
                    Demo.Buttons.update ButtonsMsg msg_ model.buttons
            in
                ( { model | buttons = buttons }, effects )

        CardsMsg msg_ ->
            let
                (cards, effects) =
                    Demo.Cards.update CardsMsg msg_ model.cards
            in
                ( { model | cards = cards }, effects )

        CheckboxMsg msg_ ->
            let
                (checkbox, effects) =
                    Demo.Checkbox.update CheckboxMsg msg_ model.checkbox
            in
                ( { model | checkbox = checkbox }, effects )

        DialogMsg msg_ ->
            let
                (dialog, effects) =
                    Demo.Dialog.update DialogMsg msg_ model.dialog
            in
                ( { model | dialog = dialog }, effects )

        ElevationMsg msg_ ->
            let
                (elevation, effects) =
                    Demo.Elevation.update ElevationMsg msg_ model.elevation
            in
                ( { model | elevation = elevation }, effects )

        DrawerMsg msg_ ->
            let
                ( drawer, effects ) =
                    Demo.Drawer.update DrawerMsg msg_ model.drawer
            in
                ( { model | drawer = drawer }, effects )

        TemporaryDrawerMsg msg_ ->
            let
                (temporaryDrawer, effects) =
                    Demo.TemporaryDrawer.update TemporaryDrawerMsg msg_ model.temporaryDrawer
            in
                ( { model | temporaryDrawer = temporaryDrawer }, effects )

        PersistentDrawerMsg msg_ ->
            let
                (persistentDrawer, effects) =
                    Demo.PersistentDrawer.update PersistentDrawerMsg msg_ model.persistentDrawer
            in
                ( { model | persistentDrawer = persistentDrawer }, effects )

        PermanentAboveDrawerMsg msg_ ->
            let
                (permanentAboveDrawer, effects) =
                    Demo.PermanentAboveDrawer.update PermanentAboveDrawerMsg msg_ model.permanentAboveDrawer
            in
                ( { model | permanentAboveDrawer = permanentAboveDrawer }, effects )

        PermanentBelowDrawerMsg msg_ ->
            let
                (permanentBelowDrawer, effects) =
                    Demo.PermanentBelowDrawer.update PermanentBelowDrawerMsg msg_ model.permanentBelowDrawer
            in
                ( { model | permanentBelowDrawer = permanentBelowDrawer }, effects )

        FabsMsg msg_ ->
            let
                (fabs, effects) =
                    Demo.Fabs.update FabsMsg msg_ model.fabs
            in
                ( { model | fabs = fabs }, effects )

        IconToggleMsg msg_ ->
            let
                (iconToggle, effects) =
                    Demo.IconToggle.update IconToggleMsg msg_ model.iconToggle
            in
                ( { model | iconToggle = iconToggle }, effects )

        MenuMsg msg_ ->
            let
                (menus, effects) =
                    Demo.Menus.update MenuMsg msg_ model.menus
            in
                ( { model | menus = menus }, effects )

        RadioButtonsMsg msg_ ->
            let
                (radio, effects) =
                    Demo.RadioButtons.update RadioButtonsMsg msg_ model.radio
            in
                ( { model | radio = radio }, effects )

        RippleMsg msg_ ->
            let
                (ripple, effects) =
                    Demo.Ripple.update RippleMsg msg_ model.ripple
            in
                ( { model | ripple = ripple }, effects )

        SelectMsg msg_ ->
            let
                (selects, effects) =
                    Demo.Selects.update SelectMsg msg_ model.selects
            in
                ( { model | selects = selects }, effects )

        SliderMsg msg_ ->
            let
                (slider, effects) =
                    Demo.Slider.update SliderMsg msg_ model.slider
            in
                ( { model | slider = slider }, effects )

        SnackbarMsg msg_ ->
            let
                (snackbar, effects) =
                    Demo.Snackbar.update SnackbarMsg msg_ model.snackbar
            in
                ( { model | snackbar = snackbar }, effects ) 

        SwitchMsg msg_ ->
            let
                (switch, effects) =
                    Demo.Switch.update SwitchMsg msg_ model.switch
            in
                ( { model | switch = switch }, effects ) 

        TextfieldMsg msg_ ->
            let
                (textfields, effects) =
                    Demo.Textfields.update TextfieldMsg msg_ model.textfields
            in
                ( { model | textfields = textfields }, effects ) 

        TabsMsg msg_ ->
            let
                (tabs, effects) =
                    Demo.Tabs.update TabsMsg msg_ model.tabs
            in
                ( { model | tabs = tabs }, effects ) 

        GridListMsg msg_ ->
            let
                (gridList, effects) =
                    Demo.GridList.update GridListMsg msg_ model.gridList
            in
                ( { model | gridList = gridList }, effects ) 

        LayoutGridMsg msg_ ->
            let
                (layoutGrid, effects) =
                    Demo.LayoutGrid.update LayoutGridMsg msg_ model.layoutGrid
            in
                ( { model | layoutGrid = layoutGrid }, effects ) 

        ListsMsg msg_ ->
            let
                (lists, effects) =
                    Demo.Lists.update ListsMsg msg_ model.lists
            in
                ( { model | lists = lists }, effects ) 

        ThemeMsg msg_ ->
            let
                (theme, effects) =
                    Demo.Theme.update ThemeMsg msg_ model.theme
            in
                ( { model | theme = theme }, effects ) 

        ToolbarMsg msg_ ->
            let
                (toolbar, effects) =
                    Demo.Toolbar.update ToolbarMsg msg_ model.toolbar
            in
                ( { model | toolbar = toolbar }, effects )


view : Model -> Html Msg
view =
    view_
    -- TODO: Should be: Html.Lazy.lazy view_, but triggers virtual-dom bug #110


view_ : Model -> Html Msg
view_ model =
    let
        page =
            { toolbar = Page.toolbar Mdl [0] model.mdl SetUrl model.url
            , fixedAdjust = Page.fixedAdjust [0] model.mdl
            , setUrl = SetUrl
            , body =
                \title nodes ->
                styled Html.div
                [ css "display" "flex"
                , css "flex-flow" "column"
                , css "height" "100%"
                , Typography.typography
                ]
                ( List.concat
                  [ [ Page.toolbar Mdl [0] model.mdl SetUrl model.url title
                    ]
                  , [ styled Html.div [ Toolbar.fixedAdjust [0] model.mdl ] []
                    ]
                  , nodes
                  ]
                )
            }
    in
    case model.url of
        StartPage ->
            Demo.Startpage.view page

        Button ->
            Demo.Buttons.view ButtonsMsg page model.buttons

        Card ->
            Demo.Cards.view CardsMsg page model.cards

        Checkbox ->
            Demo.Checkbox.view CheckboxMsg page model.checkbox

        Dialog ->
            Demo.Dialog.view DialogMsg page model.dialog

        Drawer ->
            Demo.Drawer.view DrawerMsg page model.drawer

        TemporaryDrawer ->
            Demo.TemporaryDrawer.view TemporaryDrawerMsg page model.temporaryDrawer

        PersistentDrawer ->
            Demo.PersistentDrawer.view PersistentDrawerMsg page model.persistentDrawer

        PermanentAboveDrawer ->
            Demo.PermanentAboveDrawer.view PermanentAboveDrawerMsg page model.permanentAboveDrawer

        PermanentBelowDrawer ->
            Demo.PermanentBelowDrawer.view PermanentBelowDrawerMsg page model.permanentBelowDrawer

        Elevation ->
            Demo.Elevation.view ElevationMsg page model.elevation

        Fabs ->
            Demo.Fabs.view FabsMsg page model.fabs

        IconToggle ->
            Demo.IconToggle.view IconToggleMsg page model.iconToggle

        LinearProgress ->
            Demo.LinearProgress.view page

        List ->
            Demo.Lists.view ListsMsg page model.lists

        RadioButton ->
            Demo.RadioButtons.view RadioButtonsMsg page model.radio

        Select ->
            Demo.Selects.view SelectMsg page model.selects

        Menu ->
            Demo.Menus.view MenuMsg page model.menus

        Slider ->
            Demo.Slider.view SliderMsg page model.slider

        Snackbar ->
            Demo.Snackbar.view SnackbarMsg page model.snackbar

        Switch ->
            Demo.Switch.view SwitchMsg page model.switch

        Tabs ->
            Demo.Tabs.view TabsMsg page model.tabs

        TextField ->
            Demo.Textfields.view TextfieldMsg page model.textfields

        Theme ->
            Demo.Theme.view ThemeMsg page model.theme

        Toolbar toolparPage ->
            Demo.Toolbar.view ToolbarMsg page toolparPage model.toolbar

        GridList ->
            Demo.GridList.view GridListMsg page model.gridList

        LayoutGrid ->
            Demo.LayoutGrid.view LayoutGridMsg page model.layoutGrid

        Ripple ->
            Demo.Ripple.view RippleMsg page model.ripple

        Typography ->
            Demo.Typography.view page

        Error404 requestedHash ->
            Html.div
                []
                [ Options.styled Html.h1
                    [ Options.cs "mdl-typography--display-4"
                    ]
                    [ text "404" ]
                , text requestedHash
                ]


urlOf : Model -> String
urlOf model =
    case model.url of
        StartPage -> "#"
        Button -> "#buttons"
        Card -> "#cards"
        Checkbox -> "#checkbox"
        Dialog -> "#dialog"
        Drawer -> "#drawer"
        TemporaryDrawer -> "#temporary-drawer"
        PersistentDrawer -> "#persistent-drawer"
        PermanentAboveDrawer -> "#permanent-drawer-above"
        PermanentBelowDrawer -> "#permanent-drawer-below"
        Elevation -> "#elevation"
        Fabs -> "#fab"
        GridList -> "#grid-list"
        IconToggle -> "#icon-toggle"
        LayoutGrid -> "#layout-grid"
        LinearProgress -> "#linear-progress"
        List -> "#lists"
        RadioButton -> "#radio-buttons"
        Ripple -> "#ripple"
        Select -> "#select"
        Menu -> "#menu"
        Slider -> "#slider"
        Snackbar -> "#snackbar"
        Switch -> "#switch"
        Tabs -> "#tabs"
        TextField -> "#text-field"
        Theme -> "#theme"
        Toolbar Nothing -> "#toolbar"
        Toolbar (Just DefaultToolbar) -> "#toolbar/default-toolbar"
        Toolbar (Just FixedToolbar) -> "#toolbar/fixed-toolbar"
        Toolbar (Just MenuToolbar) -> "#toolbar/menu-toolbar"
        Toolbar (Just WaterfallToolbar) -> "#toolbar/waterfall-toolbar"
        Toolbar (Just DefaultFlexibleToolbar) -> "#toolbar/default-flexible-toolbar"
        Toolbar (Just WaterfallFlexibleToolbar) -> "#toolbar/waterfall-flexible-toolbar"
        Toolbar (Just WaterfallToolbarFix) -> "#toolbar/waterfall-toolbar-fix-last-row"
        Typography -> "#typography"
        Error404 requestedHash -> requestedHash


delta2url : Model -> Model -> Maybe Routing.UrlChange
delta2url model1 model2 =
    if model1.url /= model2.url then
        { entry = Routing.NewEntry
        , url = urlOf model2
        }
            |> Just
    else
        Nothing


location2messages : Navigation.Location -> List Msg
location2messages location =
    [ SetUrl <|
      case location.hash of
          "" -> StartPage
          "#" -> StartPage
          "#buttons" -> Button
          "#cards" -> Card
          "#checkbox" -> Checkbox
          "#dialog" -> Dialog
          "#drawer" -> Drawer
          "#temporary-drawer" -> TemporaryDrawer
          "#persistent-drawer" -> PersistentDrawer
          "#permanent-drawer-above" -> PermanentAboveDrawer
          "#permanent-drawer-below" -> PermanentBelowDrawer
          "#elevation" -> Elevation
          "#fab" -> Fabs
          "#grid-list" -> GridList
          "#icon-toggle" -> IconToggle
          "#layout-grid" -> LayoutGrid
          "#linear-progress" -> LinearProgress
          "#lists" -> List
          "#radio-buttons" -> RadioButton
          "#ripple" -> Ripple
          "#select" -> Select
          "#menu" -> Menu
          "#slider" -> Slider
          "#snackbar" -> Snackbar
          "#switch" -> Switch
          "#tabs" -> Tabs
          "#text-field" -> TextField
          "#theme" -> Theme
          "#toolbar" -> Toolbar Nothing
          "#toolbar/default-toolbar" -> Toolbar (Just DefaultToolbar)
          "#toolbar/fixed-toolbar" -> Toolbar (Just FixedToolbar)
          "#toolbar/menu-toolbar" -> Toolbar (Just MenuToolbar)
          "#toolbar/waterfall-toolbar" -> Toolbar (Just WaterfallToolbar)
          "#toolbar/default-flexible-toolbar" -> Toolbar (Just DefaultFlexibleToolbar)
          "#toolbar/waterfall-flexible-toolbar" -> Toolbar (Just WaterfallFlexibleToolbar)
          "#toolbar/waterfall-toolbar-fix-last-row" -> Toolbar (Just WaterfallToolbarFix)
          "#typography" -> Typography
          _ -> Error404 location.hash
    ]


main : Routing.RouteUrlProgram Never Model Msg
main =
    Routing.program
        { delta2url = delta2url
        , location2messages = location2messages
        , init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }


init : ( Model, Cmd Msg )
init =
    let
        ( layoutGrid, layoutGridEffects ) =
            Demo.LayoutGrid.init LayoutGridMsg
    in
    ( { defaultModel
          | layoutGrid = layoutGrid
      }
    ,
      Cmd.batch
      [ Material.init Mdl
      , layoutGridEffects
      ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [
          Material.subscriptions Mdl model
        , Demo.Drawer.subscriptions DrawerMsg model.drawer
        , Demo.GridList.subscriptions GridListMsg model.gridList
        , Demo.LayoutGrid.subscriptions LayoutGridMsg model.layoutGrid
        , Demo.Menus.subscriptions MenuMsg model.menus
        , Demo.PermanentAboveDrawer.subscriptions PermanentAboveDrawerMsg model.permanentAboveDrawer
        , Demo.PermanentBelowDrawer.subscriptions PermanentBelowDrawerMsg model.permanentBelowDrawer
        , Demo.PersistentDrawer.subscriptions PersistentDrawerMsg model.persistentDrawer
        , Demo.Selects.subscriptions SelectMsg model.selects
        , Demo.Slider.subscriptions SliderMsg model.slider
        , Demo.Tabs.subscriptions TabsMsg model.tabs
        , Demo.TemporaryDrawer.subscriptions TemporaryDrawerMsg model.temporaryDrawer
        , Demo.Toolbar.subscriptions ToolbarMsg model.toolbar
        ]
