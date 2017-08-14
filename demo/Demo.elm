port module Main exposing (..)

import Demo.Buttons
import Demo.Cards
import Demo.Checkbox
import Demo.Dialog
import Demo.Elevation
import Demo.Fabs
import Demo.GridList
import Demo.IconToggle
import Demo.LayoutGrid
import Demo.Lists
import Demo.Loading
import Demo.Menus
import Demo.Page as Page exposing (Url(..))
import Demo.PermanentAboveDrawer
import Demo.PermanentBelowDrawer
import Demo.PersistentDrawer
import Demo.Radio
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
import Demo.Typography
import Html exposing (Html, text)
import Material
import Material.Options as Options exposing (styled, css, when)
import Material.Toolbar as Toolbar
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
    , elevation : Demo.Elevation.Model
    , fabs : Demo.Fabs.Model
    , iconToggle : Demo.IconToggle.Model
    , menus : Demo.Menus.Model
    , permanentAboveDrawer : Demo.PermanentAboveDrawer.Model
    , permanentBelowDrawer : Demo.PermanentBelowDrawer.Model
    , persistentDrawer : Demo.PersistentDrawer.Model
    , radio : Demo.Radio.Model
    , ripple : Demo.Ripple.Model
    , selects : Demo.Selects.Model
    , slider : Demo.Slider.Model
    , snackbar : Demo.Snackbar.Model
    , switch : Demo.Switch.Model
    , tabs : Demo.Tabs.Model
    , temporaryDrawer : Demo.TemporaryDrawer.Model
    , textfields : Demo.Textfields.Model
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , url = StartPage
    , buttons = Demo.Buttons.defaultModel
    , cards = Demo.Cards.defaultModel
    , checkbox = Demo.Checkbox.defaultModel
    , dialog = Demo.Dialog.defaultModel
    , elevation = Demo.Elevation.defaultModel
    , fabs = Demo.Fabs.defaultModel
    , iconToggle = Demo.IconToggle.defaultModel
    , menus = Demo.Menus.defaultModel
    , permanentAboveDrawer = Demo.PermanentAboveDrawer.defaultModel
    , permanentBelowDrawer = Demo.PermanentBelowDrawer.defaultModel
    , persistentDrawer = Demo.PersistentDrawer.defaultModel
    , radio = Demo.Radio.defaultModel
    , ripple = Demo.Ripple.defaultModel
    , selects = Demo.Selects.defaultModel
    , slider = Demo.Slider.defaultModel
    , snackbar = Demo.Snackbar.defaultModel
    , switch = Demo.Switch.defaultModel
    , tabs = Demo.Tabs.defaultModel
    , temporaryDrawer = Demo.TemporaryDrawer.defaultModel
    , textfields = Demo.Textfields.defaultModel
    }


type Msg
    = Mdl (Material.Msg Msg)

    | SetUrl Url

    | ButtonsMsg (Demo.Buttons.Msg Msg)
    | CardsMsg (Demo.Cards.Msg Msg)
    | CheckboxMsg (Demo.Checkbox.Msg Msg)
    | DialogMsg (Demo.Dialog.Msg Msg)
    | ElevationMsg (Demo.Elevation.Msg Msg)
    | FabsMsg (Demo.Fabs.Msg Msg)
    | IconToggleMsg (Demo.IconToggle.Msg Msg)
    | SimpleMenuMsg (Demo.Menus.Msg Msg)
    | PermanentAboveDrawerMsg (Demo.PermanentAboveDrawer.Msg Msg)
    | PermanentBelowDrawerMsg (Demo.PermanentBelowDrawer.Msg Msg)
    | PersistentDrawerMsg (Demo.PersistentDrawer.Msg Msg)
    | RadioMsg (Demo.Radio.Msg Msg)
    | RippleMsg (Demo.Ripple.Msg Msg)
    | SelectMsg (Demo.Selects.Msg Msg)
    | SliderMsg (Demo.Slider.Msg Msg)
    | SnackbarMsg (Demo.Snackbar.Msg Msg)
    | SwitchMsg (Demo.Switch.Msg Msg)
    | TabsMsg (Demo.Tabs.Msg Msg)
    | TemporaryDrawerMsg (Demo.TemporaryDrawer.Msg Msg)
    | TextfieldMsg (Demo.Textfields.Msg Msg)


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

        SimpleMenuMsg msg_ ->
            let
                (menus, effects) =
                    Demo.Menus.update SimpleMenuMsg msg_ model.menus
            in
                ( { model | menus = menus }, effects )

        RadioMsg msg_ ->
            let
                (radio, effects) =
                    Demo.Radio.update RadioMsg msg_ model.radio
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


view : Model -> Html Msg
view =
    view_
    -- TODO: Should be: Html.Lazy.lazy view_, but triggers virtual-dom bug #110


view_ : Model -> Html Msg
view_ model =
    let
        page =
            { toolbar = Page.toolbar SetUrl model.url
            , setUrl = SetUrl
            , body =
                \title nodes ->
                styled Html.div
                    [ Toolbar.fixedAdjust
                    ]
                    ( List.concat
                      [ [ Page.toolbar SetUrl model.url title
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
            Demo.Loading.view page

        List ->
            Demo.Lists.view page

        RadioButton ->
            Demo.Radio.view RadioMsg page model.radio

        Select ->
            Demo.Selects.view SelectMsg page model.selects

        SimpleMenu ->
            Demo.Menus.view SimpleMenuMsg page model.menus

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
            Demo.Theme.view page

        Toolbar ->
            Demo.Toolbar.view page

        GridList ->
            Demo.GridList.view page

        LayoutGrid ->
            Demo.LayoutGrid.view page

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
        TemporaryDrawer -> "#temporary-drawer"
        PersistentDrawer -> "#persistent-drawer"
        PermanentAboveDrawer -> "#permanent-drawer-above"
        PermanentBelowDrawer -> "#permanent-drawer-below"
        Elevation -> "#elevation"
        Fabs -> "#fabs"
        GridList -> "#grid-list"
        IconToggle -> "#icon-toggle"
        LayoutGrid -> "#layout-grid"
        LinearProgress -> "#linear-progress"
        List -> "#lists"
        RadioButton -> "#radio-buttons"
        Ripple -> "#ripple"
        Select -> "#select"
        SimpleMenu -> "#simple-menu"
        Slider -> "#slider"
        Snackbar -> "#snackbar"
        Switch -> "#switch"
        Tabs -> "#tabs"
        TextField -> "#text-field"
        Theme -> "#theme"
        Toolbar -> "#toolbar"
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
          "#temporary-drawer" -> TemporaryDrawer
          "#persistent-drawer" -> PersistentDrawer
          "#permanent-drawer-above" -> PermanentAboveDrawer
          "#permanent-drawer-below" -> PermanentBelowDrawer
          "#elevation" -> Elevation
          "#fabs" -> Fabs
          "#grid-list" -> GridList
          "#icon-toggle" -> IconToggle
          "#layout-grid" -> LayoutGrid
          "#linear-progress" -> LinearProgress
          "#lists" -> List
          "#radio-buttons" -> RadioButton
          "#ripple" -> Ripple
          "#select" -> Select
          "#simple-menu" -> SimpleMenu
          "#slider" -> Slider
          "#snackbar" -> Snackbar
          "#switch" -> Switch
          "#tabs" -> Tabs
          "#text-field" -> TextField
          "#theme" -> Theme
          "#toolbar" -> Toolbar
          "#typography" -> Typography
          _ -> Error404 location.hash
    ]


main : Routing.RouteUrlProgram Never Model Msg
main =
    Routing.program
        { delta2url = delta2url
        , location2messages = location2messages
        , init =
            ( defaultModel
            , Material.init Mdl
            )
        , view = view
        , subscriptions = subscriptions
        , update = update
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [
          Material.subscriptions Mdl model

        , Demo.Menus.subscriptions SimpleMenuMsg model.menus
        , Demo.PermanentAboveDrawer.subscriptions PermanentAboveDrawerMsg model.permanentAboveDrawer
        , Demo.PermanentBelowDrawer.subscriptions PermanentBelowDrawerMsg model.permanentBelowDrawer
        , Demo.PersistentDrawer.subscriptions PersistentDrawerMsg model.persistentDrawer
        , Demo.Selects.subscriptions SelectMsg model.selects
        , Demo.TemporaryDrawer.subscriptions TemporaryDrawerMsg model.temporaryDrawer
        , Demo.Slider.subscriptions SliderMsg model.slider
        ]
