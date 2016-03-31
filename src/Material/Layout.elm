module Material.Layout
  ( setupSizeChangeSignal
  , Mode, Model, defaultLayoutModel, initState
  , Action(SwitchTab, ToggleDrawer), update
  , spacer, title, navigation, link
  , Contents, view
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
@docs Mode, Model, defaultLayoutModel, initState, Action, update

# View
@docs Contents, view

## Sub-views
@docs spacer, title, navigation, link

# Setup
@docs setupSizeChangeSignal
-}


import Array exposing (Array)
import Maybe exposing (andThen, map)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects)
import Window

import Material.Helpers exposing (..)
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


type alias State' =
  { tabs : Array Ripple.Model
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
such, is open; otherwise, it has no significance.

The header disappears on small devices unless
`fixedHeader` is true. The drawer opens and closes with user interactions
unless `fixedDrawer` is true, in which case it is permanently open on large
screens. Tabs scroll horisontally unless `fixedTabs` is true.
Finally, the header respects `mode`

The `state` is the opaque
layout component state; use the function `initState` to construct it. If you
change the number of tabs, you must re-initialise this state.
-}
type alias Model =
  { selectedTab : Int
  , isDrawerOpen : Bool
  -- Configuration
  , fixedHeader : Bool
  , fixedDrawer : Bool
  , fixedTabs : Bool
  , rippleTabs : Bool
  , mode : Mode
  -- State
  , state : State
  }


{-| Initialiser for Layout component state. Supply a number of tabs you
use in your layout. If you subsequently change the number of tabs, you
must re-initialise the state.
-}
initState : Int -> State
initState no_tabs =
  S { tabs = Array.repeat no_tabs Ripple.model
    , isSmallScreen = False -- TODO
    }


{-| Default configuration of the layout: Fixed header, non-fixed drawer,
non-fixed tabs, tabs do not ripple, tab 0 is selected, standard header
behaviour.
-}
defaultLayoutModel : Model
defaultLayoutModel =
  { selectedTab = 0
  , isDrawerOpen = False
  , fixedHeader = True
  , fixedDrawer = False
  , fixedTabs = False
  , rippleTabs = True
  , mode = Standard
  , state = initState 0
  }


-- ACTIONS, UPDATE


{-| Component actions.
Use `SwitchTab` to request a switch of tabs. Use `ToggleDrawer` to toggle the
opened/closed state of the drawer.
-}
type Action
  = SwitchTab Int
  | ToggleDrawer
  -- Private
  | SmallScreen Bool -- True means small screen
  | ScrollTab Int
  | Ripple Int Ripple.Action


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

    Ripple tabIndex action' ->
      let
        (state', effect) =
          Array.get tabIndex (s model).tabs
          |> Maybe.map (Ripple.update action')
          |> Maybe.map (\(ripple', effect) ->
            ({ state | tabs = Array.set tabIndex ripple' (s model).tabs }
            , Effects.map (Ripple tabIndex) effect))
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



type alias Addr = Signal.Address Action


tabsView : Addr -> Model -> List Html -> Html
tabsView addr model tabs =
  let chevron direction offset =
        div
          [ classList
              [ ("mdl-layout__tab-bar-button", True)
              , ("mdl-layout__tab-bar-" ++ direction ++ "-button", True)
              ]
          ]
          [ Icon.view ("chevron_" ++ direction) [Icon.size24]
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
              , ("mdl-js-ripple-effect", model.rippleTabs)
              , ("mds-js-ripple-effect--ignore-events", model.rippleTabs)
              ]
          ]
          (tabs |> List.indexedMap (\tabIndex tab ->
            filter a
              [ classList
                  [ ("mdl-layout__tab", True)
                  , ("is-active", tabIndex == model.selectedTab)
                  ]
              , onClick addr (SwitchTab tabIndex)
              ]
              [ Just tab
              , if model.rippleTabs then
                  Array.get tabIndex (s model).tabs |> Maybe.map (
                    Ripple.view
                      (Signal.forwardTo addr (Ripple tabIndex))
                      [ class "mdl-layout__tab-ripple-container" ]
                  )
                else
                  Nothing
              ]
           ))
      , chevron "right" 100
      ]


headerView : Model -> (Maybe Html, Maybe (List Html), Maybe Html) ->  Html
headerView model (drawerButton, row, tabs) =
  filter Html.header
    [ classList
        [ ("mdl-layout__header", True)
        , ("is-casting-shadow", model.mode == Standard)
        ]
    ]
    [ drawerButton
    , row |> Maybe.map (div [ class "mdl-layout__header-row" ])
    , tabs
    ]


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


{-| Content of the layout only (contents of main pane is set elsewhere). Every
part is optional. If `header` is `Nothing`, tabs will not be shown.

The `header` and `drawer` contains the contents of the header row and drawer,
respectively.  Use `spacer`, `title`, `nav`, and
`link`, as well as regular Html to construct these. The `tabs` contains
the title of each tab.
-}
type alias Contents =
  { header : Maybe (List Html)
  , drawer : Maybe (List Html)
  , tabs : Maybe (List Html)
  , main : List Html
  }


{-| Main layout view.
-}
view : Addr -> Model -> Contents -> Html
view addr model { drawer, header, tabs, main } =
  let
    (contentDrawerButton, headerDrawerButton) =
      case (drawer, header, model.fixedHeader) of
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
      case model.mode of
        Standard  -> ""
        Scroll    -> "mdl-layout__header-scroll"
        -- Waterfall -> "mdl-layout__header-waterfall"
        Seamed    -> "mdl-layout__header-seamed"

    hasHeader =
      tabs /= Nothing || header /= Nothing
  in
  div
    [ class "mdl-layout__container" ]
    [ filter div
        [ classList
            [ ("mdl-layout", True)
            , ("is-upgraded", True)
            , ("is-small-screen", (s model).isSmallScreen)
            , ("has-drawer", drawer /= Nothing)
            , ("has-tabs", tabs /= Nothing)
            , ("mdl-js-layout", True)
            , ("mdl-layout--fixed-drawer", model.fixedDrawer && drawer /= Nothing)
            , ("mdl-layout--fixed-header", model.fixedHeader && hasHeader)
            , ("mdl-layout--fixed-tabs", model.fixedTabs && tabs /= Nothing)
            ]
        ]
        [ if hasHeader then
            Just <| headerView model (headerDrawerButton, header, Maybe.map (tabsView addr model) tabs)
          else
            Nothing
        , drawer |> Maybe.map (\_ -> obfuscator addr model)
        , drawer |> Maybe.map (drawerView addr model)
        , contentDrawerButton
        , Just <| main' [ class "mdl-layout__content" ] main
        ]
    ]
