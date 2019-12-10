module Demo exposing (main)

import Array
import Browser
import Browser.Events
import Browser.Navigation
import Browser.Dom
import Demo.Buttons
import Demo.Cards
import Demo.Checkbox
import Demo.Chips
import Demo.DataTable
import Demo.Dialog
import Demo.DismissibleDrawer
import Demo.Drawer
import Demo.Elevation
import Demo.Fabs
import Demo.IconButton
import Demo.ImageList
import Demo.LayoutGrid
import Demo.LinearProgress
import Demo.Lists
import Demo.Menus
import Demo.ModalDrawer
import Demo.Page as Page
import Demo.PermanentDrawer
import Demo.RadioButtons
import Demo.Ripple
import Demo.Selects
import Demo.Slider
import Demo.Snackbar
import Demo.Startpage
import Demo.Switch
import Demo.TabBar
import Demo.TextFields
import Demo.Theme
import Demo.TopAppBar
import Demo.Typography
import Demo.Url exposing (Url, TopAppBarPage(..))
import Html exposing (Html, div, text)
import Material
import Material.Drawer.Modal as Drawer
import Material.Drawer.Dismissible as DismissibleDrawer
import Material.Options as Options exposing (cs, css, styled, when)
import Material.TopAppBar as TopAppBar
import Material.Typography as Typography
import Task
import Url


type alias Model =
    { mdc : Material.Model Msg
    , useDismissibleDrawer: Bool
    , is_drawer_open : Bool
    , navigateToUrl : Maybe Url               -- Used for animations
    , transition : Page.Transition
    , key : Browser.Navigation.Key
    , url : Demo.Url.Url
    , buttons : Demo.Buttons.Model Msg
    , cards : Demo.Cards.Model Msg
    , checkbox : Demo.Checkbox.Model Msg
    , chips : Demo.Chips.Model Msg
    , dataTable : Demo.DataTable.Model Msg
    , dialog : Demo.Dialog.Model Msg
    , dismissibleDrawer : Demo.DismissibleDrawer.Model Msg
    , drawer : Demo.Drawer.Model Msg
    , elevation : Demo.Elevation.Model Msg
    , fabs : Demo.Fabs.Model Msg
    , iconToggle : Demo.IconButton.Model Msg
    , imageList : Demo.ImageList.Model Msg
    , layoutGrid : Demo.LayoutGrid.Model Msg
    , linearProgress : Demo.LinearProgress.Model Msg
    , lists : Demo.Lists.Model Msg
    , menus : Demo.Menus.Model Msg
    , permanentDrawer : Demo.PermanentDrawer.Model Msg
    , radio : Demo.RadioButtons.Model Msg
    , ripple : Demo.Ripple.Model Msg
    , selects : Demo.Selects.Model Msg
    , slider : Demo.Slider.Model Msg
    , snackbar : Demo.Snackbar.Model Msg
    , switch : Demo.Switch.Model Msg
    , tabbar : Demo.TabBar.Model Msg
    , modalDrawer : Demo.ModalDrawer.Model Msg
    , textfields : Demo.TextFields.Model Msg
    , theme : Demo.Theme.Model Msg
    , topAppBar : Demo.TopAppBar.Model Msg
    , typography : Demo.Typography.Model Msg
    }


defaultModel : Browser.Navigation.Key -> Model
defaultModel key =
    { mdc = Material.defaultModel
    , useDismissibleDrawer = True
    , is_drawer_open = False
    , navigateToUrl = Nothing
    , transition = Page.None
    , key = key
    , url = Demo.Url.StartPage
    , buttons = Demo.Buttons.defaultModel
    , cards = Demo.Cards.defaultModel
    , checkbox = Demo.Checkbox.defaultModel
    , chips = Demo.Chips.defaultModel
    , dataTable = Demo.DataTable.defaultModel
    , dialog = Demo.Dialog.defaultModel
    , dismissibleDrawer = Demo.DismissibleDrawer.defaultModel
    , drawer = Demo.Drawer.defaultModel
    , elevation = Demo.Elevation.defaultModel
    , fabs = Demo.Fabs.defaultModel
    , iconToggle = Demo.IconButton.defaultModel
    , imageList = Demo.ImageList.defaultModel
    , layoutGrid = Demo.LayoutGrid.defaultModel
    , linearProgress = Demo.LinearProgress.defaultModel
    , lists = Demo.Lists.defaultModel
    , menus = Demo.Menus.defaultModel
    , permanentDrawer = Demo.PermanentDrawer.defaultModel
    , radio = Demo.RadioButtons.defaultModel
    , ripple = Demo.Ripple.defaultModel
    , selects = Demo.Selects.defaultModel
    , slider = Demo.Slider.defaultModel
    , snackbar = Demo.Snackbar.defaultModel
    , switch = Demo.Switch.defaultModel
    , tabbar = Demo.TabBar.defaultModel
    , modalDrawer = Demo.ModalDrawer.defaultModel
    , textfields = Demo.TextFields.defaultModel
    , theme = Demo.Theme.defaultModel
    , topAppBar = Demo.TopAppBar.defaultModel
    , typography = Demo.Typography.defaultModel
    }


type Msg
    = Mdc (Material.Msg Msg)
    | GotViewportWidth Browser.Dom.Viewport
    | WindowResized Int Int
    | UrlChanged Url.Url
    | UrlRequested Browser.UrlRequest
    | Navigate Demo.Url.Url
    | OpenDrawer
    | CloseDrawer
    | ToggleDrawer
    | SelectDrawerItem Int
    | AnimationTick Float
    | ButtonsMsg (Demo.Buttons.Msg Msg)
    | CardsMsg (Demo.Cards.Msg Msg)
    | CheckboxMsg (Demo.Checkbox.Msg Msg)
    | ChipsMsg (Demo.Chips.Msg Msg)
    | DataTableMsg (Demo.DataTable.Msg Msg)
    | DialogMsg (Demo.Dialog.Msg Msg)
    | DismissibleDrawerMsg (Demo.DismissibleDrawer.Msg Msg)
    | DrawerMsg (Demo.Drawer.Msg Msg)
    | ElevationMsg (Demo.Elevation.Msg Msg)
    | FabsMsg (Demo.Fabs.Msg Msg)
    | IconButtonMsg (Demo.IconButton.Msg Msg)
    | ImageListMsg (Demo.ImageList.Msg Msg)
    | LayoutGridMsg (Demo.LayoutGrid.Msg Msg)
    | LinearProgressMsg (Demo.LinearProgress.Msg Msg)
    | ListsMsg (Demo.Lists.Msg Msg)
    | MenuMsg (Demo.Menus.Msg Msg)
    | PermanentDrawerMsg (Demo.PermanentDrawer.Msg Msg)
    | RadioButtonsMsg (Demo.RadioButtons.Msg Msg)
    | RippleMsg (Demo.Ripple.Msg Msg)
    | SelectMsg (Demo.Selects.Msg Msg)
    | SliderMsg (Demo.Slider.Msg Msg)
    | SnackbarMsg (Demo.Snackbar.Msg Msg)
    | SwitchMsg (Demo.Switch.Msg Msg)
    | TabBarMsg (Demo.TabBar.Msg Msg)
    | ModalDrawerMsg (Demo.ModalDrawer.Msg Msg)
    | TextFieldMsg (Demo.TextFields.Msg Msg)
    | ThemeMsg (Demo.Theme.Msg Msg)
    | TypographyMsg (Demo.Typography.Msg Msg)
    | TopAppBarMsg (Demo.TopAppBar.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        enableDismissibleDrawer x =
            x > 1490
    in
    case msg of
        Mdc msg_ ->
            Material.update Mdc msg_ model

        GotViewportWidth viewport ->
            ( { model | useDismissibleDrawer = enableDismissibleDrawer viewport.scene.width }, Cmd.none )

        WindowResized x y ->
            ( { model | useDismissibleDrawer = enableDismissibleDrawer x }, Cmd.none )

        Navigate url ->
            ( { model | url = url, is_drawer_open = if not model.useDismissibleDrawer then False else model.is_drawer_open, transition = if model.navigateToUrl /= Nothing then Page.Active else Page.None, navigateToUrl = Nothing }
            , Cmd.batch
                [ Browser.Navigation.pushUrl model.key (Demo.Url.toString url)

                -- , scrollTop () TODO
                ]
            )

        OpenDrawer ->
            ( { model | is_drawer_open = True }, Cmd.none )

        CloseDrawer ->
            ( { model | is_drawer_open = False }, Cmd.none )

        ToggleDrawer ->
            ( { model | is_drawer_open = not model.is_drawer_open }, Cmd.none )

        SelectDrawerItem index ->
            let
                item = Array.get index Page.drawerItems
            in
                case item of
                    Just ( title, url ) -> ( { model | navigateToUrl = Just url, transition = Page.Enter }, Cmd.none )
                    Nothing -> ( model, Cmd.none )

        AnimationTick _ ->
            case model.navigateToUrl of
                Just url -> update ( Navigate url ) model
                Nothing -> ( model, Cmd.none )

        UrlRequested (Browser.Internal url) ->
            ( { model | url = Demo.Url.fromUrl url, is_drawer_open = False }
            , Browser.Navigation.load (Demo.Url.toString (Demo.Url.fromUrl url))
            )

        UrlRequested (Browser.External string) ->
            ( model, Cmd.none )

        UrlChanged url ->
            ( { model | url = Demo.Url.fromUrl url }, Cmd.none )

        -- TODO: scrollTop ())
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

        DataTableMsg msg_ ->
            let
                ( dataTable, effects ) =
                    Demo.DataTable.update DataTableMsg msg_ model.dataTable
            in
            ( { model | dataTable = dataTable }, effects )

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

        DismissibleDrawerMsg msg_ ->
            let
                ( dismissibleDrawer, effects ) =
                    Demo.DismissibleDrawer.update DismissibleDrawerMsg msg_ model.dismissibleDrawer
            in
            ( { model | dismissibleDrawer = dismissibleDrawer }, effects )

        ModalDrawerMsg msg_ ->
            let
                ( modalDrawer, effects ) =
                    Demo.ModalDrawer.update ModalDrawerMsg msg_ model.modalDrawer
            in
            ( { model | modalDrawer = modalDrawer }, effects )

        PermanentDrawerMsg msg_ ->
            let
                ( permanentDrawer, effects ) =
                    Demo.PermanentDrawer.update PermanentDrawerMsg msg_ model.permanentDrawer
            in
            ( { model | permanentDrawer = permanentDrawer }, effects )

        FabsMsg msg_ ->
            let
                ( fabs, effects ) =
                    Demo.Fabs.update FabsMsg msg_ model.fabs
            in
            ( { model | fabs = fabs }, effects )

        IconButtonMsg msg_ ->
            let
                ( iconToggle, effects ) =
                    Demo.IconButton.update IconButtonMsg msg_ model.iconToggle
            in
            ( { model | iconToggle = iconToggle }, effects )

        ImageListMsg msg_ ->
            let
                ( imageList, effects ) =
                    Demo.ImageList.update ImageListMsg msg_ model.imageList
            in
            ( { model | imageList = imageList }, effects )

        LinearProgressMsg msg_ ->
            let
                ( linearProgress, effects ) =
                    Demo.LinearProgress.update LinearProgressMsg msg_ model.linearProgress
            in
            ( { model | linearProgress = linearProgress }, effects )

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

        TextFieldMsg msg_ ->
            let
                ( textfields, effects ) =
                    Demo.TextFields.update TextFieldMsg msg_ model.textfields
            in
            ( { model | textfields = textfields }, effects )

        TabBarMsg msg_ ->
            let
                ( tabbar, effects ) =
                    Demo.TabBar.update TabBarMsg msg_ model.tabbar
            in
            ( { model | tabbar = tabbar }, effects )

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

        TopAppBarMsg msg_ ->
            let
                ( topAppBar, effects ) =
                    Demo.TopAppBar.update TopAppBarMsg msg_ model.topAppBar
            in
            ( { model | topAppBar = topAppBar }, effects )

        TypographyMsg msg_ ->
            let
                ( typography, effects ) =
                    Demo.Typography.update TypographyMsg msg_ model.typography
            in
            ( { model | typography = typography }, effects )


view : Model -> Browser.Document Msg
view model =
    { title = "The elm-mdc library"
    , body = [ view_ model ]
    }


{-| TODO: Should be: Html.Lazy.lazy view\_, but triggers virtual-dom bug #110
-}
view_ : Model -> Html Msg
view_ model =
    let
        bar = Page.topappbar Mdc "page-topappbar" model.mdc ToggleDrawer model.url

        page =
            { topappbar = bar
            , navigate = Navigate
            , body =
                \nodes ->
                    styled div
                        [ css "display" "flex"
                        , css "flex-flow" "column"
                        , css "height" "100%"
                        , Typography.typography
                        ]
                        [ bar "Material components for the Web"
                        , styled div
                            [ cs "demo-panel"
                            , css "display" "flex"
                            , css "position" "relative"
                            , css "height" "100vh" |> when model.useDismissibleDrawer
                            , css "overflow" "hidden" |> when model.useDismissibleDrawer
                            ]
                            [ if model.useDismissibleDrawer then
                                  Page.drawer Mdc "page-drawer" model.mdc CloseDrawer SelectDrawerItem model.url model.useDismissibleDrawer model.is_drawer_open
                              else
                                  div
                                      []
                                      [ Page.drawer Mdc "page-drawer" model.mdc CloseDrawer SelectDrawerItem model.url model.useDismissibleDrawer model.is_drawer_open
                                      , Drawer.scrim [ Options.onClick CloseDrawer ] []
                                      ]
                            , styled div
                                  [ cs "demo-content"
                                  , DismissibleDrawer.appContent
                                  , TopAppBar.onScroll Mdc "page-topappbar"
                                  , TopAppBar.fixedAdjust
                                  , css "width" "100%"
                                  , css "display" "flex"
                                  , css "justify-content" "flex-start"
                                  , css "flex-direction" "column"
                                  , css "align-items" "center"
                                  , css "overflow" "auto"
                                  ]
                                  [ styled div
                                    [ cs "demo-content-transition"
                                    , css "width" "100%"
                                    , css "max-width" "1200px"
                                    ]
                                    [ Page.componentCatalogPanel model.transition nodes ]
                                  ]
                            ]
                        ]
            }
    in
    case model.url of
        Demo.Url.StartPage ->
            Demo.Startpage.view page

        Demo.Url.Button ->
            Demo.Buttons.view ButtonsMsg page model.buttons

        Demo.Url.Card ->
            Demo.Cards.view CardsMsg page model.cards

        Demo.Url.Checkbox ->
            Demo.Checkbox.view CheckboxMsg page model.checkbox

        Demo.Url.Chips ->
            Demo.Chips.view ChipsMsg page model.chips

        Demo.Url.DataTable ->
            Demo.DataTable.view DataTableMsg page model.dataTable

        Demo.Url.Dialog ->
            Demo.Dialog.view DialogMsg page model.dialog

        Demo.Url.Drawer ->
            Demo.Drawer.view DrawerMsg page model.drawer

        Demo.Url.DismissibleDrawer ->
            Demo.DismissibleDrawer.view DismissibleDrawerMsg page model.dismissibleDrawer

        Demo.Url.ModalDrawer ->
            Demo.ModalDrawer.view ModalDrawerMsg page model.modalDrawer

        Demo.Url.PermanentDrawer ->
            Demo.PermanentDrawer.view PermanentDrawerMsg page model.permanentDrawer

        Demo.Url.Elevation ->
            Demo.Elevation.view ElevationMsg page model.elevation

        Demo.Url.Fabs ->
            Demo.Fabs.view FabsMsg page model.fabs

        Demo.Url.IconButton ->
            Demo.IconButton.view IconButtonMsg page model.iconToggle

        Demo.Url.ImageList ->
            Demo.ImageList.view ImageListMsg page model.imageList

        Demo.Url.LinearProgress ->
            Demo.LinearProgress.view LinearProgressMsg page model.linearProgress

        Demo.Url.List ->
            Demo.Lists.view ListsMsg page model.lists

        Demo.Url.RadioButton ->
            Demo.RadioButtons.view RadioButtonsMsg page model.radio

        Demo.Url.Select ->
            Demo.Selects.view SelectMsg page model.selects

        Demo.Url.Menu ->
            Demo.Menus.view MenuMsg page model.menus

        Demo.Url.Slider ->
            Demo.Slider.view SliderMsg page model.slider

        Demo.Url.Snackbar ->
            Demo.Snackbar.view SnackbarMsg page model.snackbar

        Demo.Url.Switch ->
            Demo.Switch.view SwitchMsg page model.switch

        Demo.Url.TabBar ->
            Demo.TabBar.view TabBarMsg page model.tabbar

        Demo.Url.TextField ->
            Demo.TextFields.view TextFieldMsg page model.textfields

        Demo.Url.Theme ->
            Demo.Theme.view ThemeMsg page model.theme

        Demo.Url.TopAppBar topAppBarPage ->
            Demo.TopAppBar.view TopAppBarMsg page topAppBarPage model.topAppBar

        Demo.Url.LayoutGrid ->
            Demo.LayoutGrid.view LayoutGridMsg page model.layoutGrid

        Demo.Url.Ripple ->
            Demo.Ripple.view RippleMsg page model.ripple

        Demo.Url.Typography ->
            Demo.Typography.view TypographyMsg page model.typography

        Demo.Url.Error404 requestedHash ->
            div
                []
                [ Options.styled Html.h1
                    [ Typography.display4
                    ]
                    [ text "404" ]
                , text requestedHash
                ]



main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , subscriptions = subscriptions
        , update = update
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }


type alias Flags =
    { horizontalScrollbarHeight : Int
    }


init : () -> Url.Url -> Browser.Navigation.Key -> ( Model, Cmd Msg )
init flags url key =
    let
        initialModel =
            defaultModel key
    in
    ( { initialModel | url = Demo.Url.fromUrl url }
    , Cmd.batch [ Material.init Mdc, Task.perform GotViewportWidth Browser.Dom.getViewport ]
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Material.subscriptions Mdc model
        , Browser.Events.onResize WindowResized
        , if model.navigateToUrl == Nothing then Sub.none else Browser.Events.onAnimationFrameDelta AnimationTick
        , Demo.DismissibleDrawer.subscriptions DismissibleDrawerMsg model.dismissibleDrawer
        , Demo.Drawer.subscriptions DrawerMsg model.drawer
        , Demo.Menus.subscriptions MenuMsg model.menus
        , Demo.PermanentDrawer.subscriptions PermanentDrawerMsg model.permanentDrawer
        , Demo.Selects.subscriptions SelectMsg model.selects
        , Demo.Slider.subscriptions SliderMsg model.slider
        , Demo.TabBar.subscriptions TabBarMsg model.tabbar
        , Demo.ModalDrawer.subscriptions ModalDrawerMsg model.modalDrawer
        , Demo.TextFields.subscriptions TextFieldMsg model.textfields
        , Demo.TopAppBar.subscriptions TopAppBarMsg model.topAppBar
        ]
