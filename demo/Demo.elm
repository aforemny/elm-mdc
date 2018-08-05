port module Main exposing (..)

import Demo.Buttons
import Demo.Cards
import Demo.Checkbox
import Demo.Chips
import Demo.Dialog
import Demo.Drawer
import Demo.Elevation
import Demo.Fabs
import Demo.GridList
import Demo.IconToggle
import Demo.ImageList
import Demo.LayoutGrid
import Demo.LinearProgress
import Demo.Lists
import Demo.Menus
import Demo.Page as Page
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
import Demo.Toolbar
import Demo.TopAppBar
import Demo.Typography
import Demo.Url as Url exposing (ToolbarPage(..), TopAppBarPage(..), Url(..))
import Html exposing (Html, text)
import Material
import Material.Options as Options exposing (css, styled, when)
import Material.Toolbar as Toolbar
import Material.Typography as Typography
import Navigation
import Platform.Cmd exposing (..)


port scrollTop : () -> Cmd msg


type alias Model =
    { mdc : Material.Model Msg
    , url : Url
    , buttons : Demo.Buttons.Model Msg
    , cards : Demo.Cards.Model Msg
    , checkbox : Demo.Checkbox.Model Msg
    , chips : Demo.Chips.Model Msg
    , dialog : Demo.Dialog.Model Msg
    , drawer : Demo.Drawer.Model Msg
    , elevation : Demo.Elevation.Model Msg
    , fabs : Demo.Fabs.Model Msg
    , gridList : Demo.GridList.Model Msg
    , iconToggle : Demo.IconToggle.Model Msg
    , imageList : Demo.ImageList.Model Msg
    , layoutGrid : Demo.LayoutGrid.Model
    , lists : Demo.Lists.Model Msg
    , menus : Demo.Menus.Model Msg
    , permanentAboveDrawer : Demo.PermanentAboveDrawer.Model Msg
    , permanentBelowDrawer : Demo.PermanentBelowDrawer.Model Msg
    , persistentDrawer : Demo.PersistentDrawer.Model Msg
    , radio : Demo.RadioButtons.Model Msg
    , ripple : Demo.Ripple.Model Msg
    , selects : Demo.Selects.Model Msg
    , slider : Demo.Slider.Model Msg
    , snackbar : Demo.Snackbar.Model Msg
    , switch : Demo.Switch.Model Msg
    , tabs : Demo.Tabs.Model Msg
    , temporaryDrawer : Demo.TemporaryDrawer.Model Msg
    , textfields : Demo.Textfields.Model Msg
    , theme : Demo.Theme.Model Msg
    , toolbar : Demo.Toolbar.Model Msg
    , topAppBar : Demo.TopAppBar.Model Msg
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    , url = StartPage
    , buttons = Demo.Buttons.defaultModel
    , cards = Demo.Cards.defaultModel
    , checkbox = Demo.Checkbox.defaultModel
    , chips = Demo.Chips.defaultModel
    , dialog = Demo.Dialog.defaultModel
    , drawer = Demo.Drawer.defaultModel
    , elevation = Demo.Elevation.defaultModel
    , fabs = Demo.Fabs.defaultModel
    , gridList = Demo.GridList.defaultModel
    , iconToggle = Demo.IconToggle.defaultModel
    , imageList = Demo.ImageList.defaultModel
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
    , topAppBar = Demo.TopAppBar.defaultModel
    }


type Msg
    = Mdc (Material.Msg Msg)
    | SetUrl Url
    | Navigate Url
    | ButtonsMsg (Demo.Buttons.Msg Msg)
    | CardsMsg (Demo.Cards.Msg Msg)
    | CheckboxMsg (Demo.Checkbox.Msg Msg)
    | ChipsMsg (Demo.Chips.Msg Msg)
    | DialogMsg (Demo.Dialog.Msg Msg)
    | DrawerMsg (Demo.Drawer.Msg Msg)
    | ElevationMsg (Demo.Elevation.Msg Msg)
    | FabsMsg (Demo.Fabs.Msg Msg)
    | GridListMsg (Demo.GridList.Msg Msg)
    | IconToggleMsg (Demo.IconToggle.Msg Msg)
    | ImageListMsg (Demo.ImageList.Msg Msg)
    | LayoutGridMsg Demo.LayoutGrid.Msg
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
    | TopAppBarMsg (Demo.TopAppBar.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdc msg ->
            Material.update Mdc msg model

        Navigate url ->
            { model | url = url }
                ! [ Navigation.newUrl (Url.toString url)
                  , scrollTop ()
                  ]

        SetUrl url ->
            { model | url = url }
                ! [ scrollTop ()
                  ]

        ButtonsMsg msg_ ->
            let
                ( buttons, effects ) =
                    Demo.Buttons.update ButtonsMsg msg_ model.buttons
            in
            ( { model | buttons = buttons }, effects )

        CardsMsg msg_ ->
            let
                ( cards, effects ) =
                    Demo.Cards.update CardsMsg msg_ model.cards
            in
            ( { model | cards = cards }, effects )

        CheckboxMsg msg_ ->
            let
                ( checkbox, effects ) =
                    Demo.Checkbox.update CheckboxMsg msg_ model.checkbox
            in
            ( { model | checkbox = checkbox }, effects )

        ChipsMsg msg_ ->
            let
                ( chips, effects ) =
                    Demo.Chips.update ChipsMsg msg_ model.chips
            in
            ( { model | chips = chips }, effects )

        DialogMsg msg_ ->
            let
                ( dialog, effects ) =
                    Demo.Dialog.update DialogMsg msg_ model.dialog
            in
            ( { model | dialog = dialog }, effects )

        ElevationMsg msg_ ->
            let
                ( elevation, effects ) =
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
                ( temporaryDrawer, effects ) =
                    Demo.TemporaryDrawer.update TemporaryDrawerMsg msg_ model.temporaryDrawer
            in
            ( { model | temporaryDrawer = temporaryDrawer }, effects )

        PersistentDrawerMsg msg_ ->
            let
                ( persistentDrawer, effects ) =
                    Demo.PersistentDrawer.update PersistentDrawerMsg msg_ model.persistentDrawer
            in
            ( { model | persistentDrawer = persistentDrawer }, effects )

        PermanentAboveDrawerMsg msg_ ->
            let
                ( permanentAboveDrawer, effects ) =
                    Demo.PermanentAboveDrawer.update PermanentAboveDrawerMsg msg_ model.permanentAboveDrawer
            in
            ( { model | permanentAboveDrawer = permanentAboveDrawer }, effects )

        PermanentBelowDrawerMsg msg_ ->
            let
                ( permanentBelowDrawer, effects ) =
                    Demo.PermanentBelowDrawer.update PermanentBelowDrawerMsg msg_ model.permanentBelowDrawer
            in
            ( { model | permanentBelowDrawer = permanentBelowDrawer }, effects )

        FabsMsg msg_ ->
            let
                ( fabs, effects ) =
                    Demo.Fabs.update FabsMsg msg_ model.fabs
            in
            ( { model | fabs = fabs }, effects )

        IconToggleMsg msg_ ->
            let
                ( iconToggle, effects ) =
                    Demo.IconToggle.update IconToggleMsg msg_ model.iconToggle
            in
            ( { model | iconToggle = iconToggle }, effects )

        ImageListMsg msg_ ->
            let
                ( imageList, effects ) =
                    Demo.ImageList.update ImageListMsg msg_ model.imageList
            in
            ( { model | imageList = imageList }, effects )

        MenuMsg msg_ ->
            let
                ( menus, effects ) =
                    Demo.Menus.update MenuMsg msg_ model.menus
            in
            ( { model | menus = menus }, effects )

        RadioButtonsMsg msg_ ->
            let
                ( radio, effects ) =
                    Demo.RadioButtons.update RadioButtonsMsg msg_ model.radio
            in
            ( { model | radio = radio }, effects )

        RippleMsg msg_ ->
            let
                ( ripple, effects ) =
                    Demo.Ripple.update RippleMsg msg_ model.ripple
            in
            ( { model | ripple = ripple }, effects )

        SelectMsg msg_ ->
            let
                ( selects, effects ) =
                    Demo.Selects.update SelectMsg msg_ model.selects
            in
            ( { model | selects = selects }, effects )

        SliderMsg msg_ ->
            let
                ( slider, effects ) =
                    Demo.Slider.update SliderMsg msg_ model.slider
            in
            ( { model | slider = slider }, effects )

        SnackbarMsg msg_ ->
            let
                ( snackbar, effects ) =
                    Demo.Snackbar.update SnackbarMsg msg_ model.snackbar
            in
            ( { model | snackbar = snackbar }, effects )

        SwitchMsg msg_ ->
            let
                ( switch, effects ) =
                    Demo.Switch.update SwitchMsg msg_ model.switch
            in
            ( { model | switch = switch }, effects )

        TextfieldMsg msg_ ->
            let
                ( textfields, effects ) =
                    Demo.Textfields.update TextfieldMsg msg_ model.textfields
            in
            ( { model | textfields = textfields }, effects )

        TabsMsg msg_ ->
            let
                ( tabs, effects ) =
                    Demo.Tabs.update TabsMsg msg_ model.tabs
            in
            ( { model | tabs = tabs }, effects )

        GridListMsg msg_ ->
            let
                ( gridList, effects ) =
                    Demo.GridList.update GridListMsg msg_ model.gridList
            in
            ( { model | gridList = gridList }, effects )

        LayoutGridMsg msg_ ->
            let
                ( layoutGrid, effects ) =
                    Demo.LayoutGrid.update LayoutGridMsg msg_ model.layoutGrid
            in
            ( { model | layoutGrid = layoutGrid }, effects )

        ListsMsg msg_ ->
            let
                ( lists, effects ) =
                    Demo.Lists.update ListsMsg msg_ model.lists
            in
            ( { model | lists = lists }, effects )

        ThemeMsg msg_ ->
            let
                ( theme, effects ) =
                    Demo.Theme.update ThemeMsg msg_ model.theme
            in
            ( { model | theme = theme }, effects )

        ToolbarMsg msg_ ->
            let
                ( toolbar, effects ) =
                    Demo.Toolbar.update ToolbarMsg msg_ model.toolbar
            in
            ( { model | toolbar = toolbar }, effects )

        TopAppBarMsg msg_ ->
            let
                ( topAppBar, effects ) =
                    Demo.TopAppBar.update TopAppBarMsg msg_ model.topAppBar
            in
            ( { model | topAppBar = topAppBar }, effects )


view : Model -> Html Msg
view =
    view_



-- TODO: Should be: Html.Lazy.lazy view_, but triggers virtual-dom bug #110


view_ : Model -> Html Msg
view_ model =
    let
        page =
            { toolbar = Page.toolbar Mdc "page-toolbar" model.mdc Navigate model.url
            , fixedAdjust = Page.fixedAdjust "page-toolbar" model.mdc
            , navigate = Navigate
            , body =
                \title nodes ->
                    styled Html.div
                        [ css "display" "flex"
                        , css "flex-flow" "column"
                        , css "height" "100%"
                        , Typography.typography
                        ]
                        (List.concat
                            [ [ Page.toolbar Mdc "page-toolbar" model.mdc Navigate model.url title
                              ]
                            , [ styled Html.div [ Toolbar.fixedAdjust "page-toolbar" model.mdc ] []
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

        Chips ->
            Demo.Chips.view ChipsMsg page model.chips

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

        ImageList ->
            Demo.ImageList.view ImageListMsg page model.imageList

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

        Toolbar toolbarPage ->
            Demo.Toolbar.view ToolbarMsg page toolbarPage model.toolbar

        TopAppBar topAppBarPage ->
            Demo.TopAppBar.view TopAppBarMsg page topAppBarPage model.topAppBar

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
                    [ Typography.display4
                    ]
                    [ text "404" ]
                , text requestedHash
                ]


urlOf : Model -> String
urlOf model =
    Url.toString model.url


main : Program Never Model Msg
main =
    Navigation.program
        (.hash >> Url.fromString >> SetUrl)
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        }


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        ( layoutGrid, layoutGridEffects ) =
            Demo.LayoutGrid.init LayoutGridMsg
    in
    ( { defaultModel
        | layoutGrid = layoutGrid
        , url = Url.fromString location.hash
      }
    , Cmd.batch
        [ Material.init Mdc
        , layoutGridEffects
        ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Material.subscriptions Mdc model
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
        , Demo.TopAppBar.subscriptions TopAppBarMsg model.topAppBar
        ]
