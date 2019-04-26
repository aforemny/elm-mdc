module Main exposing (main)

import Browser
import Browser.Navigation
import Demo.Buttons
import Demo.Cards
import Demo.Checkbox
import Demo.Chips
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
import Demo.Toolbar
import Demo.TopAppBar
import Demo.Typography
import Demo.Url exposing (ToolbarPage(..), TopAppBarPage(..))
import Html exposing (Html, p, text)
import Material
import Material.Options as Options exposing (cs, css, styled, when)
import Material.TopAppBar as TopAppBar
import Material.Typography as Typography
import Platform.Cmd exposing (..)
import Url


type alias Model =
    { mdc : Material.Model Msg
    , key : Browser.Navigation.Key
    , url : Demo.Url.Url
    , buttons : Demo.Buttons.Model Msg
    , cards : Demo.Cards.Model Msg
    , checkbox : Demo.Checkbox.Model Msg
    , chips : Demo.Chips.Model Msg
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
    , toolbar : Demo.Toolbar.Model Msg
    , topAppBar : Demo.TopAppBar.Model Msg
    , typography : Demo.Typography.Model Msg
    }


defaultModel : Browser.Navigation.Key -> Model
defaultModel key =
    { mdc = Material.defaultModel
    , key = key
    , url = Demo.Url.StartPage
    , buttons = Demo.Buttons.defaultModel
    , cards = Demo.Cards.defaultModel
    , checkbox = Demo.Checkbox.defaultModel
    , chips = Demo.Chips.defaultModel
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
    , toolbar = Demo.Toolbar.defaultModel
    , topAppBar = Demo.TopAppBar.defaultModel
    , typography = Demo.Typography.defaultModel
    }


{-| TODO: Remove Navigate
-}
type Msg
    = Mdc (Material.Msg Msg)
    | NoOp
    | UrlChanged Url.Url
    | UrlRequested Browser.UrlRequest
    | Navigate Demo.Url.Url
    | ButtonsMsg (Demo.Buttons.Msg Msg)
    | CardsMsg (Demo.Cards.Msg Msg)
    | CheckboxMsg (Demo.Checkbox.Msg Msg)
    | ChipsMsg (Demo.Chips.Msg Msg)
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
    | ToolbarMsg (Demo.Toolbar.Msg Msg)
    | TopAppBarMsg (Demo.TopAppBar.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdc msg_ ->
            Material.update Mdc msg_ model

        NoOp ->
            ( model, Cmd.none )

        Navigate url ->
            ( { model | url = url }
            , Cmd.batch
                [ Browser.Navigation.pushUrl model.key (Demo.Url.toString url)

                -- , scrollTop () TODO
                ]
            )

        UrlRequested (Browser.Internal url) ->
            ( { model | url = Demo.Url.fromUrl url }
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
        page =
            { toolbar = Page.toolbar Mdc "page-toolbar" model.mdc Navigate model.url
            , navigate = Navigate
            , body =
                \title intro nodes ->
                    styled Html.div
                        [ css "display" "flex"
                        , css "flex-flow" "column"
                        , css "height" "100%"
                        , Typography.typography
                        ]
                        [ Page.toolbar Mdc
                            "page-toolbar"
                            model.mdc
                            Navigate
                            model.url
                            title
                        , styled Html.div
                            [ cs "demo-content"
                            , css "max-width" "900px"
                            , css "width" "100%"
                            , css "margin-left" "auto"
                            , css "margin-right" "auto"
                            ]
                            (styled Html.div
                                [ TopAppBar.fixedAdjust ]
                                [ Page.header title
                                , styled p
                                    [ Typography.body1 ]
                                    [ text intro ]
                                ]
                                :: nodes
                            )
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

        Demo.Url.Toolbar toolbarPage ->
            Demo.Toolbar.view ToolbarMsg page toolbarPage model.toolbar

        Demo.Url.TopAppBar topAppBarPage ->
            Demo.TopAppBar.view TopAppBarMsg page topAppBarPage model.topAppBar

        Demo.Url.LayoutGrid ->
            Demo.LayoutGrid.view LayoutGridMsg page model.layoutGrid

        Demo.Url.Ripple ->
            Demo.Ripple.view RippleMsg page model.ripple

        Demo.Url.Typography ->
            Demo.Typography.view TypographyMsg page model.typography

        Demo.Url.Error404 requestedHash ->
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
    Demo.Url.toString model.url


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
    , Material.init Mdc
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Material.subscriptions Mdc model
        , Demo.DismissibleDrawer.subscriptions DismissibleDrawerMsg model.dismissibleDrawer
        , Demo.Drawer.subscriptions DrawerMsg model.drawer
        , Demo.Menus.subscriptions MenuMsg model.menus
        , Demo.PermanentDrawer.subscriptions PermanentDrawerMsg model.permanentDrawer
        , Demo.Selects.subscriptions SelectMsg model.selects
        , Demo.Slider.subscriptions SliderMsg model.slider
        , Demo.TabBar.subscriptions TabBarMsg model.tabbar
        , Demo.ModalDrawer.subscriptions ModalDrawerMsg model.modalDrawer
        , Demo.Toolbar.subscriptions ToolbarMsg model.toolbar
        , Demo.TopAppBar.subscriptions TopAppBarMsg model.topAppBar
        ]
