module Material.Layout
  ( setupSizeChangeSignal
  , Model, initState
  , Action(SwitchTab, ToggleDrawer), update
  , spacer, title, navigation, link
  , Mode, Config, config, view
  ) where

{-| From the 
[Material Design Lite documentation](https://www.getmdl.io/components/index.html#layout-section):
    
> The Material Design Lite (MDL) layout component is a comprehensive approach to
> page layout that uses MDL development tenets, allows for efficient use of MDL
> components, and automatically adapts to different browsers, screen sizes, and
> devices.
> 
> Appropriate and accessible layout is a critical feature of all user interfaces,
> regardless of a site's content or function. Page design and presentation is
> therefore an important factor in the overall user experience. See the layout
> component's 
> [Material Design specifications page](https://www.google.com/design/spec/layout/structure.html#structure-system-bars)
> for details.  
>
> Use of MDL layout principles simplifies the creation of scalable pages by
> providing reusable components and encourages consistency across environments by
> establishing recognizable visual elements, adhering to logical structural
> grids, and maintaining appropriate spacing across multiple platforms and screen
> sizes. MDL layout is extremely powerful and dynamic, allowing for great
> consistency in outward appearance and behavior while maintaining development
> flexibility and ease of use.

# Model & Actions
@docs Model, initState, Action, update

# Sub-components
@docs spacer, title, navigation, link

# View
@docs Mode, Config, config, view

# Setup
@docs setupSizeChangeSignal
-}


import Dict exposing (Dict)
import Maybe exposing (andThen, map)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects)
import Window

import Material.Aux exposing (..)
import Material.Ripple as Ripple
import Material.Icon as Icon


-- SETUP


{-| Setup signal for registering changes in display size. Use with StartApp
like so, supposing you have a `LayoutAction` encapsulating actions of the
layout:

    inputs : List (Signal.Signal Action)
    inputs =
      [ Layout.setupSizeChangeSignal LayoutAction
      ]
-}
setupSizeChangeSignal : (Action -> a) -> Signal a
setupSizeChangeSignal f =
  Window.width
  |> Signal.map ((>) 1024)
  |> Signal.dropRepeats
  |> Signal.map (SmallScreen >> f)


-- MODEL


type alias TabState =
  { titles : List String
  , ripples : Dict String Ripple.Model
  }

type alias State' =
  { tabs : TabState
  , isSmallScreen : Bool
  }


{-| Component private state. Construct with `initState`.
-}
type State = S State'


s : Model -> State'
s model = case model.state of (S state) -> state


{-| Layout model. If your layout view has tabs, any tab with the same name as
`selectedTab` will be highlighted as selected; otherwise, `selectedTab` has no
significance. `isDrawerOpen` indicates whether the drawer, if the layout has
such, is open; otherwise, it has no significance. The `state` is the opaque
layout component state; use the function `initState` to construct it. (The names
of your tabs lives in this state; so you must use `initState` to set those
names.)
-}
type alias Model =
  { selectedTab : String
  , isDrawerOpen : Bool
  , state : State
  }


{-| Initialiser for Layout component state. Supply a list of tab titles
or the empty list if your layout should have no tabs. E.g.,

    initState ["About", "Main", "Contact"]
-}
initState : List String -> State
initState titles =
  let ripples =
    titles
    |> List.map (\title -> (title, Ripple.model))
    |> Dict.fromList
  in
    S { tabs =
          { titles = titles
          , ripples = ripples
          }
      , isSmallScreen = False -- TODO
      }


hasTabs : Model -> Bool
hasTabs model =
  case (s model).tabs.titles of
    [] -> False
    [x] -> False -- MDL spec says tabs should come in at least pairs.
    _ -> True


-- ACTIONS, UPDATE


{-| Component actions. 
Use `SwitchTab` to request a switch of tabs. Use `ToggleDrawer` to toggle the
opened/closed state of the drawer.
-}
type Action
  = SwitchTab String
  | ToggleDrawer
  -- Private
  | SmallScreen Bool -- True means small screen
  | ScrollTab Int
  | Ripple String Ripple.Action


{-| Component update.
-}
update : Action -> Model -> (Model, Effects Action)
update action model =
  let (S state) = model.state in
  case action of
    SmallScreen isSmall ->
      { model
      | state = S ({ state | isSmallScreen = isSmall })
      , isDrawerOpen = not isSmall && model.isDrawerOpen
      }
      |> pure

    SwitchTab tab ->
      { model | selectedTab = tab } |> pure

    ToggleDrawer ->
      { model | isDrawerOpen = not model.isDrawerOpen } |> pure

    Ripple tab action' ->
      let
        tabs = state.tabs
        (state', effect) =
          Dict.get tab tabs.ripples
          |> Maybe.map (Ripple.update action')
          |> Maybe.map (\(ripple', effect) ->
            ({ state
             | tabs =
               { tabs
               | ripples = Dict.insert tab ripple' tabs.ripples
               }
             }, Effects.map (Ripple tab) effect))
          |> Maybe.withDefault (pure state)
      in
        ({ model | state = S state' }, effect)

    ScrollTab tab ->
      (model, Effects.none) -- TODO



-- AUXILIARY VIEWS



{-| Push subsequent elements in header row or drawer column to the right/bottom.
-}
spacer : Html
spacer = div [class "mdl-layout-spacer"] []


{-| Title in header row or drawer.
-}
title : String -> Html
title t = span [class "mdl-layout__title"] [text t]


{-| Container for links.
-}
navigation : List Html -> Html
navigation contents =
  nav [class "mdl-navigation"] contents


{-| Link.
-}
link : List Attribute -> List Html -> Html
link attrs contents =
  a (class "mdl-navigation__link" :: attrs) contents




-- MAIN VIEWS



{-| Mode for the header.
- A `Standard` header casts shadow, is permanently affixed to the top of the screen.
- A `Seamed` header does not cast shadow, is permanently affixed to the top of the
  screen.
- A `Scroll`'ing header scrolls with contents.
-}
type Mode
  = Standard
  | Seamed
  | Scroll
--  | Waterfall


{-| Layout view configuration. The header disappears on small devices unless
`fixedHeader` is true. The drawer opens and closes with user interactions
unless `fixedDrawer` is true, in which case it is permanently open on large
screens. Tabs scroll horisontally unless `fixedTabs` is true. Tabs have a
ripple-animation when clicked if `rippleTabs` is true. Finally, the header
respects `mode`
 -}
type alias Config =
  { fixedHeader : Bool
  , fixedDrawer : Bool
  , fixedTabs : Bool
  , rippleTabs : Bool
  , mode : Mode
  }


{-| Default configuration of the layout: Fixed header, non-fixed drawer,
non-fixed tabs, tabs ripple, standard header behaviour.
-}
config : Config
config =
  { fixedHeader = True
  , fixedDrawer = False
  , fixedTabs = False
  , rippleTabs = True
  , mode = Standard
  }


type alias Addr = Signal.Address Action


tabsView : Addr -> Config -> Model -> Html
tabsView addr config model =
  let chevron direction offset =
        div
          [ classList
              [ ("mdl-layout__tab-bar-button", True)
              , ("mdl-layout__tab-bar-" ++ direction ++ "-button", True)
              ]
          ]
          [ Icon.view ("chevron_" ++ direction) Icon.S
              [onClick addr (ScrollTab offset)]
                -- TODO: Scroll event
          ]
  in
    div
      [ class "mdl-layout__tab-bar-container"]
      [ chevron "left" -100
      , div
          [ classList
              [ ("mdl-layout__tab-bar", True)
              , ("mdl-js-ripple-effect", config.rippleTabs)
              , ("mds-js-ripple-effect--ignore-events", config.rippleTabs)
              ]
          ]
          (let (S state) = model.state in
           state.tabs.titles |> List.map (\tab ->
            filter a
              [ classList
                  [ ("mdl-layout__tab", True)
                  , ("is-active", tab == model.selectedTab)
                  ]
              , onClick addr (SwitchTab tab)
              ]
              [ text tab |> Just
              , if config.rippleTabs then
                  Dict.get tab state.tabs.ripples |> Maybe.map (
                    Ripple.view
                      (Signal.forwardTo addr (Ripple tab))
                      [ class "mdl-layout__tab-ripple-container" ]
                  )
                else
                  Nothing
              ]
           ))
      , chevron "right" 100
      ]


headerView : Config -> Model -> (Maybe Html, Maybe (List Html), Maybe Html) ->  Html
headerView config model (drawerButton, row, tabs) =
  filter Html.header
    [ classList
        [ ("mdl-layout__header", True)
        , ("is-casting-shadow", config.mode == Standard)
        ]
    ]
    [ drawerButton
    , row |> Maybe.map (div [ class "mdl-layout__header-row" ])
    , tabs
    ]


{-}
visibilityClasses : Visibility -> List (String, Bool)
visibilityClasses v =
  [ ("mdl-layout--large-screen-only", v == LargeScreenOnly)
  , ("mdl-layout--small-screen-only", v == SmallScreenOnly)
  ]
-}


drawerButton : Addr -> Html
drawerButton addr =
  div
    [ class "mdl-layout__drawer-button"
    , onClick addr ToggleDrawer
    ]
    [ Icon.i "menu" ]


obfuscator : Addr -> Model -> Html
obfuscator addr model =
  div
    [ classList
        [ ("mdl-layout__obfuscator", True)
        , ("is-visible", model.isDrawerOpen)
        ]
    , onClick addr ToggleDrawer
    ]
    []


drawerView : Addr -> Model -> List Html -> Html
drawerView addr model elems =
  div
    [ classList
        [ ("mdl-layout__drawer", True)
        , ("is-visible", model.isDrawerOpen)
        ]
    ]
    elems


type alias Content = (Maybe (List Html), Maybe (List Html))


{-| Main layout view. The `Content` argument contains the body
of the drawer and header (or `Nothing`). The final argument is
the contents of the main pane.
-}
view : Addr -> Config -> Model -> Content -> List Html -> Html
view addr config model (drawer, header) main =
  let (contentDrawerButton, headerDrawerButton) =
        case (drawer, header, config.fixedHeader) of
          (Just _, Just _, True) ->
            -- Drawer with fixedHeader: Add the button to the header
             (Nothing, Just <| drawerButton addr)

          (Just _, _, _) ->
            -- Drawer, no or non-fixed header: Add the button before contents.
             (Just <| drawerButton addr, Nothing)

          _ ->
            -- No drawer: no button.
             (Nothing, Nothing)
      mode =
        case config.mode of
          Standard  -> ""
          Scroll    -> "mdl-layout__header-scroll"
    --      Waterfall -> "mdl-layout__header-waterfall"
          Seamed    -> "mdl-layout__header-seamed"
      tabs =
        if hasTabs model then
          tabsView addr config model |> Just
        else
          Nothing
  in
  div
    [ class "mdl-layout__container" ]
    [ filter div
        [ classList
            [ ("mdl-layout", True)
            , ("is-upgraded", True)
            , ("is-small-screen", let (S state) = model.state in state.isSmallScreen)
            , ("has-drawer", drawer /= Nothing)
            , ("has-tabs", hasTabs model)
            , ("mdl-js-layout", True)
            , ("mdl-layout--fixed-drawer", config.fixedDrawer && drawer /= Nothing)
            , ("mdl-layout--fixed-header", config.fixedHeader && header /= Nothing)
            , ("mdl-layout--fixed-tabs", config.fixedTabs && hasTabs model)
            ]
        ]
        [ header |> Maybe.map (\_ -> headerView config model (headerDrawerButton, header, tabs))
        , drawer |> Maybe.map (\_ -> obfuscator addr model)
        , drawer |> Maybe.map (drawerView addr model)
        , contentDrawerButton
        , Just <| main' [ class "mdl-layout__content" ] main
        ]
    ]
