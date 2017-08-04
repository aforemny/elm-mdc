port module Main exposing (..)

import Array exposing (Array)
import Demo.Badges
import Demo.Fabs
import Demo.Buttons
import Demo.Cards
import Demo.Selects
import Demo.Chips
import Demo.Dialog
import Demo.Elevation
import Demo.GridList
import Demo.LayoutGrid
import Demo.Lists
import Demo.Loading
import Demo.Menus
import Demo.Ripple
import Demo.Slider
import Demo.Snackbar
import Demo.Startpage
import Demo.Tabs
import Demo.Textfields
import Demo.Theme
import Demo.Checkbox
import Demo.Toolbar
import Demo.Tooltip
import Demo.Typography
import Dict exposing (Dict)
import Html.Attributes exposing (href, class, style)
import Html exposing (Html, text)
import Html.Lazy
import Material
import Material.Helpers exposing (pure, lift, map1st, map2nd)
import Material.Icon as Icon
import Material.Menu as Menu
import Material.Select as Select
import Material.Options as Options exposing (styled, css, when)
import Material.Toolbar as Toolbar
import Navigation
import Platform.Cmd exposing (..)
import RouteUrl as Routing
import String


-- PORTS


port scrollTop : () -> Cmd msg


-- MODEL


type alias Model =
    { mdl : Material.Model
    , buttons : Demo.Buttons.Model
    , selects : Demo.Selects.Model
    , fabs : Demo.Fabs.Model
    , badges : Demo.Badges.Model
    , layoutGrid : Demo.LayoutGrid.Model
    , menus : Demo.Menus.Model
    , textfields : Demo.Textfields.Model
    , theme : Demo.Theme.Model
    , checkbox : Demo.Checkbox.Model
    , snackbar : Demo.Snackbar.Model
    , loading : Demo.Loading.Model
    , tooltip : Demo.Tooltip.Model
    , toolbar : Demo.Toolbar.Model
    , tabs : Demo.Tabs.Model
    , slider : Demo.Slider.Model
    , typography : Demo.Typography.Model
    , cards : Demo.Cards.Model
    , lists : Demo.Lists.Model
    , dialog : Demo.Dialog.Model
    , elevation : Demo.Elevation.Model
    , ripple : Demo.Ripple.Model
    , chips : Demo.Chips.Model
    , selectedTab : Maybe Int
    , transparentHeader : Bool
    , logMessages : Bool
    }


model : Model
model =
    { mdl = Material.model
    , buttons = Demo.Buttons.model
    , selects = Demo.Selects.model
    , fabs = Demo.Fabs.model
    , badges = Demo.Badges.model
    , layoutGrid = Demo.LayoutGrid.model
    , menus = Demo.Menus.model
    , textfields = Demo.Textfields.model
    , theme = Demo.Theme.model
    , checkbox = Demo.Checkbox.model
    , snackbar = Demo.Snackbar.defaultModel
    , loading = Demo.Loading.model
    , tooltip = Demo.Tooltip.model
    , toolbar = Demo.Toolbar.model
    , tabs = Demo.Tabs.model
    , slider = Demo.Slider.model
    , typography = Demo.Typography.model
    , cards = Demo.Cards.model
    , lists = Demo.Lists.model
    , dialog = Demo.Dialog.model
    , elevation = Demo.Elevation.model
    , ripple = Demo.Ripple.model
    , chips = Demo.Chips.model
    , selectedTab = Nothing
    , transparentHeader = False
    , logMessages = False
    }



-- ACTION, UPDATE


type Msg
    = SelectTab Int
    | ClearTab
    | Mdl (Material.Msg Msg)
    | BadgesMsg Demo.Badges.Msg
    | ButtonsMsg Demo.Buttons.Msg
    | FabsMsg Demo.Fabs.Msg
    | LayoutGridMsg Demo.LayoutGrid.Msg
    | MenusMsg Demo.Menus.Msg
    | TextfieldMsg Demo.Textfields.Msg
    | SelectMsg Demo.Selects.Msg
    | ThemeMsg Demo.Theme.Msg
    | SnackbarMsg Demo.Snackbar.Msg
    | CheckboxMsg Demo.Checkbox.Msg
    | LoadingMsg Demo.Loading.Msg
    | TooltipMsg Demo.Tooltip.Msg
    | ToolbarMsg Demo.Toolbar.Msg
    | TabMsg Demo.Tabs.Msg
    | SliderMsg Demo.Slider.Msg
    | TypographyMsg Demo.Typography.Msg
    | CardsMsg Demo.Cards.Msg
    | ListsMsg Demo.Lists.Msg
    | DialogMsg Demo.Dialog.Msg
    | ElevationMsg Demo.Elevation.Msg
    | RippleMsg Demo.Ripple.Msg
    | ChipMsg Demo.Chips.Msg
    | ToggleHeader
    | ToggleLog


nth : Int -> List a -> Maybe a
nth k xs =
    List.drop k xs |> List.head


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let 
        log msg = 
            if model.logMessages then Debug.log "Msg" else identity
    in
      case log "Msg" msg of
          SelectTab k ->
              { model | selectedTab = Just k } ! [ scrollTop () ]

          ClearTab ->
              { model | selectedTab = Nothing } ! [ scrollTop () ]

          ToggleHeader ->
              ( { model | transparentHeader = not model.transparentHeader }, Cmd.none )

          ToggleLog -> 
              ( { model | logMessages = not model.logMessages }, Cmd.none )

          Mdl msg ->
              Material.update Mdl msg model

          ButtonsMsg a ->
              lift .buttons (\m x -> { m | buttons = x }) ButtonsMsg Demo.Buttons.update a model

          FabsMsg a ->
              lift .fabs (\m x -> { m | fabs = x }) FabsMsg Demo.Fabs.update a model

          BadgesMsg a ->
              lift .badges (\m x -> { m | badges = x }) BadgesMsg Demo.Badges.update a model

          LayoutGridMsg a ->
              lift .layoutGrid (\m x -> { m | layoutGrid = x }) LayoutGridMsg Demo.LayoutGrid.update a model

          MenusMsg a ->
              lift .menus (\m x -> { m | menus = x }) MenusMsg Demo.Menus.update a model

          TextfieldMsg m ->
              Demo.Textfields.update m model.textfields
                  |> Maybe.map (map1st (\x -> { model | textfields = x }))
                  |> Maybe.withDefault ( model, Cmd.none )
                  |> map2nd (Cmd.map TextfieldMsg)

          ThemeMsg a ->
              lift .theme (\m x -> { m | theme = x }) ThemeMsg Demo.Theme.update a model

          SnackbarMsg a ->
              lift .snackbar (\m x -> { m | snackbar = x }) SnackbarMsg Demo.Snackbar.update a model

          CheckboxMsg a ->
              lift .checkbox (\m x -> { m | checkbox = x }) CheckboxMsg Demo.Checkbox.update a model

          LoadingMsg a ->
              lift .loading (\m x -> { m | loading = x }) LoadingMsg Demo.Loading.update a model

          SliderMsg a ->
              lift .slider (\m x -> { m | slider = x }) SliderMsg Demo.Slider.update a model

          TooltipMsg a ->
              lift .tooltip (\m x -> { m | tooltip = x }) TooltipMsg Demo.Tooltip.update a model

          ToolbarMsg a ->
              lift .toolbar (\m x -> { m | toolbar = x }) ToolbarMsg Demo.Toolbar.update a model

          TabMsg a ->
              lift .tabs (\m x -> { m | tabs = x }) TabMsg Demo.Tabs.update a model

          TypographyMsg a ->
              lift .typography (\m x -> { m | typography = x }) TypographyMsg Demo.Typography.update a model

          CardsMsg a ->
              lift .cards (\m x -> { m | cards = x }) CardsMsg Demo.Cards.update a model

          ListsMsg a ->
              lift .lists (\m x -> { m | lists = x }) ListsMsg Demo.Lists.update a model

          DialogMsg a ->
              lift .dialog (\m x -> { m | dialog = x }) DialogMsg Demo.Dialog.update a model

          ElevationMsg a ->
              lift .elevation (\m x -> { m | elevation = x }) ElevationMsg Demo.Elevation.update a model

          RippleMsg a ->
              lift .ripple (\m x -> { m | ripple = x }) RippleMsg Demo.Ripple.update a model

          ChipMsg a ->
              lift .chips (\m x -> { m | chips = x }) ChipMsg Demo.Chips.update a model

          SelectMsg a ->
              lift .selects (\m x -> { m | selects = x }) SelectMsg Demo.Selects.update a model



-- VIEW


tabs : List ( String, String, Model -> Html Msg )
tabs =
    [ ( "Buttons", "buttons", .buttons >> Demo.Buttons.view >> Html.map ButtonsMsg )
    , ( "Card", "cards", .cards >> Demo.Cards.view >> Html.map CardsMsg )
    , ( "Checkbox", "checkbox", .checkbox >> Demo.Checkbox.view >> Html.map CheckboxMsg )
    , ( "Dialog", "dialog", .dialog >> Demo.Dialog.view >> Html.map DialogMsg )
    , ( "Elevation", "elevation", .elevation >> Demo.Elevation.view >> Html.map ElevationMsg )
    , ( "Floating action button", "fab", .fabs >> Demo.Fabs.view >> Html.map FabsMsg )
    , ( "Grid list", "grid-list", always Demo.GridList.view )
    , ( "Layout grid", "layout-grid", .layoutGrid >> Demo.LayoutGrid.view >> Html.map LayoutGridMsg )
    , ( "Lists", "lists", .lists >> Demo.Lists.view >> Html.map ListsMsg )
    , ( "Ripple", "ripple", .ripple >> Demo.Ripple.view >> Html.map RippleMsg )
    , ( "Select", "select", .selects >> Demo.Selects.view >> Html.map SelectMsg )
    , ( "Simple Menu", "menus", .menus >> Demo.Menus.view >> Html.map MenusMsg )
    , ( "Snackbar", "snackbar", .snackbar >> Demo.Snackbar.view >> Html.map SnackbarMsg )
    , ( "Tabs", "tabs", .tabs >> Demo.Tabs.view >> Html.map TabMsg )
    , ( "Textfields", "textfields", .textfields >> Demo.Textfields.view >> Html.map TextfieldMsg )
    , ( "Theme", "theme", .theme >> Demo.Theme.view >> Html.map ThemeMsg )
    , ( "Toolbar", "toolbar", .toolbar >> Demo.Toolbar.view >> Html.map ToolbarMsg )
    , ( "Typography", "typography", .typography >> Demo.Typography.view >> Html.map TypographyMsg )

    -- , ( "Badges", "badges", .badges >> Demo.Badges.view >> Html.map BadgesMsg )
    -- , ( "Chips", "chips", .chips >> Demo.Chips.view >> Html.map ChipMsg )
    -- , ( "Loading", "loading", .loading >> Demo.Loading.view >> Html.map LoadingMsg )
    -- , ( "Sliders", "sliders", .slider >> Demo.Slider.view >> Html.map SliderMsg )
    -- , ( "Tooltips", "tooltips", .tooltip >> Demo.Tooltip.view >> Html.map TooltipMsg )
    ]


tabTitles : List (Html a)
tabTitles =
    List.map (\( x, _, _ ) -> text x) tabs


tabViews : Array (Model -> Html Msg)
tabViews =
    List.map (\( _, _, v ) -> v) tabs |> Array.fromList


tabUrls : Array String
tabUrls =
    List.map (\( _, x, _ ) -> x) tabs |> Array.fromList


urlTabs : Dict String Int
urlTabs =
    List.indexedMap (\idx ( _, x, _ ) -> ( x, idx )) tabs |> Dict.fromList


e404 : Model -> Html Msg
e404 _ =
    Html.div
        []
        [ Options.styled Html.h1
            [ Options.cs "mdl-typography--display-4"
            ]
            [ text "404" ]
        ]


view : Model -> Html Msg
view =
    Html.Lazy.lazy view_


view_ : Model -> Html Msg
view_ model =
    let
        top =
            case model.selectedTab of
                Nothing ->
                    Demo.Startpage.view SelectTab
                Just selectedTab ->
                    (Array.get selectedTab tabViews |> Maybe.withDefault e404) model
        title =
            case model.selectedTab of
                Nothing ->
                    text "Material Components Catalog"
                Just selectedTab ->
                    nth selectedTab tabTitles |> Maybe.withDefault (text "")
    in
        Html.div
        [
        ]
        [ Toolbar.view
          [ Toolbar.fixed
          ]
          [ Toolbar.row []
            [ Toolbar.section
              [ Toolbar.alignStart
              ]
              [ Toolbar.icon_
                [ Toolbar.menu
                ]
                [ case model.selectedTab of
                      Nothing ->
                          Html.img
                          [ Html.Attributes.src "https://material-components-web.appspot.com/images/ic_component_24px_white.svg"
                          ]
                          []
                      Just _ ->
                          Icon.view "" [ Options.onClick ClearTab, css "cursor" "pointer" ]
                ]
              , Toolbar.title [] [ title ]
              ]
            ]
          ]
        , styled Html.div
          [ Toolbar.fixedAdjust
          ]
          [ top
          ]
        ]



{- ** End -}
-- ROUTING


urlOf : Model -> String
urlOf model =
    case model.selectedTab of
        Nothing ->
            "#"
        Just selectedTab ->
            "#" ++ (Array.get selectedTab tabUrls |> Maybe.withDefault "")


delta2url : Model -> Model -> Maybe Routing.UrlChange
delta2url model1 model2 =
    if model1.selectedTab /= model2.selectedTab then
        { entry = Routing.NewEntry
        , url = urlOf model2
        }
            |> Just
    else
        Nothing


location2messages : Navigation.Location -> List Msg
location2messages location =
    [ case String.dropLeft 1 location.hash of
        "" ->
            ClearTab

        x ->
            Dict.get x urlTabs
                |> Maybe.withDefault -1
                |> SelectTab
    ]



-- APP


main : Routing.RouteUrlProgram Never Model Msg
main =
    Routing.program
        { delta2url = delta2url
        , location2messages = location2messages
        , init =
            ( model
            , Material.init Mdl
            )
        , view = view
        , subscriptions =
            \model ->
                Sub.batch
                    [ Sub.map MenusMsg (Menu.subs Demo.Menus.Mdl model.menus.mdl)
                    , Sub.map SelectMsg (Select.subs Demo.Selects.Mdl model.selects.mdl)
                    , Material.subscriptions Mdl model
                    ]
        , update = update
        }



-- CSS


stylesheet : Html a
stylesheet =
    Options.stylesheet """
  /* The following line is better done in html. We keep it here for
     compatibility with elm-reactor.
   */
  @import url("assets/highlight/github-gist.css");

  blockquote:before { content: none; }
  blockquote:after { content: none; }
  blockquote {
    border-left-style: solid;
    border-width: 1px;
    padding-left: 1.3ex;
    border-color: rgb(255,82,82);
      /* Really need a way to specify "secondary color" in
         inline css.
       */
    font-style: normal;
  }
  p, blockquote {
    max-width: 40em;
  }

  pre {
    display: inline-block;
    box-sizing: border-box;
    min-width: 100%;
    padding-top: .5rem;
    padding-bottom: 1rem;
    padding-left:1rem;
    margin: 0;
  }
  code {
    font-family: 'Roboto Mono';
  }
  .mdl-layout__header--transparent {
    background: url('https://getmdl.io/assets/demos/transparent.jpg') center / cover;
  }
  .mdl-layout__header--transparent .mdl-layout__drawer-button {
    /* This background is dark, so we set text to white. Use 87% black instead if
       your background is light. */
    color: white;
  }
"""
