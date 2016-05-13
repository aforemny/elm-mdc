module Material.Layout exposing
  ( subscriptions
  , Mode(..), Model, defaultLayoutModel, initState
  , Msg, update
  , row, spacer, title, navigation, link
  , Contents, view
  )

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

# Setup
@docs subscriptions

# Model & Msgs
@docs Mode, Model, defaultLayoutModel, initState, Msg, update

# View
@docs Contents, view

## Sub-views
@docs row, spacer, title, navigation, link

-}

-- TODO: Component support

import Array exposing (Array)
import Maybe exposing (andThen, map)
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, on)
import Platform.Cmd exposing (Cmd)
import Window
import Json.Decode as Decoder

import Material.Helpers as Helpers exposing (filter, delay, pure)
import Material.Ripple as Ripple
import Material.Icon as Icon
import Material.Options as Options exposing (Style, cs, nop)

import DOM


-- SETUP


{-| Setup various signals layout needs (viewport size changes, scrolling). Use
with StartApp like so, supposing you have a `LayoutMsg` encapsulating
actions of the
layout:

    inputs : List (Signal.Signal Msg)
    inputs =
      [ Layout.subscriptions LayoutMsg
      ]
-}
subscriptions : (Msg -> msg) -> Sub msg
subscriptions f =
  Sub.batch 
    [ Window.resizes 
        (.width >> (>) 1024 >> SmallScreen >> f)
    ]


-- MODEL


type alias State' =
  { tabs : Array Ripple.Model
  , isSmallScreen : Bool
  , isCompact : Bool
  , isAnimating : Bool
  , isScrolled : Bool
  }


{-| Component private state. Construct with `initState`.
-}
type State = S State'


s : Model -> State'
s model = case model.state of (S state) -> state


{-| TODO. Layout model. If your layout view has tabs, any tab with the same name as
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
  { isDrawerOpen : Bool
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
    , isCompact = False
    , isAnimating = False
    , isScrolled = False
    }


{-| Default configuration of the layout: Fixed header, non-fixed drawer,
non-fixed tabs, tabs do not ripple, tab 0 is selected, standard header
behaviour.
TODO
-}
defaultLayoutModel : Model
defaultLayoutModel =
  { isDrawerOpen = False
  , state = initState 0
  }


-- ACTIONS, UPDATE


{-| Component actions.
TODO
-}
type Msg
  = ToggleDrawer
  -- Private
  | SmallScreen Bool -- True means small screen
  | ScrollTab Float
  | ScrollPane Bool Float -- True means fixedHeader
  | TransitionHeader { toCompact : Bool, fixedHeader : Bool }
  | TransitionEnd
  -- Subcomponents
  | Ripple Int Ripple.Msg


{-| Component update.
-}
update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  let (S state) = model.state in
    case action of
    SmallScreen isSmall ->
      { model
      | state = S ({ state | isSmallScreen = isSmall })
      , isDrawerOpen = not isSmall && model.isDrawerOpen
      }
      |> pure

    ToggleDrawer ->
      { model | isDrawerOpen = not model.isDrawerOpen } |> pure

    Ripple tabIndex action' ->
      let
        (state', effect) =
          Array.get tabIndex (s model).tabs
          |> Maybe.map (Ripple.update action')
          |> Maybe.map (\(ripple', effect) ->
            ({ state | tabs = Array.set tabIndex ripple' (s model).tabs }
            , Cmd.map (Ripple tabIndex) effect))
          |> Maybe.withDefault (pure state)
      in
        ({ model | state = S state' }, effect)


    ScrollTab tab ->
      (model, Cmd.none) -- TODO

    ScrollPane fixedHeader offset -> 
      let 
        isScrolled = 0.0 < offset 
      in
        if isScrolled /= state.isScrolled then
          update 
            (TransitionHeader { toCompact = isScrolled, fixedHeader = fixedHeader })
            model
        else
          (model, Cmd.none)

    TransitionHeader { toCompact, fixedHeader } -> 
      let 
        headerVisible = (not state.isSmallScreen) || fixedHeader
        state' = 
          { state 
          | isCompact = toCompact
          , isAnimating = headerVisible 
          }
      in
        if not state.isAnimating then 
          ( { model | state = S state' }
          , delay 200 TransitionEnd -- See comment on transitionend in view. 
          )
        else
          (model, Cmd.none)


    TransitionEnd -> 
      ( { model | state = S { state | isAnimating = False } }
      , Cmd.none
      )


-- PROPERTIES


{-|
-}
type alias Config m = 
  { fixedHeader : Bool
  , fixedDrawer : Bool
  , fixedTabs : Bool
  , rippleTabs : Bool
  , mode : Mode
  , selectedTab : Int
  , onSwitchTab : Maybe (Int -> Attribute m)
  }


{-|
-}
defaultConfig : Config m
defaultConfig = 
  { fixedHeader = False
  , fixedDrawer = False
  , fixedTabs = False
  , rippleTabs = True
  , mode = Standard
  , onSwitchTab = Nothing
  , selectedTab = -1
  }


type alias Property m = 
  Options.Property (Config m) m



fixedDrawer : Property m
fixedDrawer =
  Options.set (\config -> { config | fixedDrawer = True })


fixedTabs : Property m
fixedTabs =
  Options.set (\config -> { config | fixedTabs = True })


rippleTabs : Property m
rippleTabs =
  Options.set (\config -> { config | rippleTabs = True })


waterfall : Bool -> Property m
waterfall b =
  Options.set (\config -> { config | mode = Waterfall b })


seamed : Property m
seamed = 
  Options.set (\config -> { config | mode = Seamed })


scrolling : Property m
scrolling = 
  Options.set (\config -> { config | mode = Scrolling })


selectedTab : Int -> Property m
selectedTab k =
  Options.set (\config -> { config | selectedTab = k })


onSwitchTab : (Int -> m) -> Property m
onSwitchTab f = 
  Options.set (\config -> { config | onSwitchTab = Just (f >> onClick) })


-- AUXILIARY VIEWS



{-| Push subsequent elements in header row or drawer column to the right/bottom.
-}
spacer : (Html m)
spacer = div [class "mdl-layout-spacer"] []


{-| Title in header row or drawer.
-}
title : List (Property m) -> List (Html m) -> Html m
title styles = 
  Options.span (cs "mdl-layout__title" :: styles) 


{-| Container for links.
-}
navigation : List (Style m) -> List (Html m) -> Html m
navigation styles contents =
  nav [class "mdl-navigation"] contents


{-| Link.
-}
link : List (Property m) -> List (Html m) -> Html m
link styles contents =
  Options.styled a (cs "mdl-navigation__link" :: styles) contents


{-| Header row. 
-}
row : List (Property m) -> List (Html m) -> Html m
row styles = 
  Options.div (cs "mdl-layout__header-row" :: styles) 


-- MAIN VIEWS



{-| Mode for the header.
- A `Standard` header casts shadow, is permanently affixed to the top of the screen.
- A `Seamed` header does not cast shadow, is permanently affixed to the top of the
  screen.
- A `Scroll`'ing header scrolls with contents.
- A `Waterfall` header drops either the top (argument True) or bottom (argument False) 
header-row when content scrolls. 
-}
type Mode

  = Standard
  | Seamed
  | Scrolling
  | Waterfall Bool


isWaterfall : Mode -> Bool
isWaterfall mode = 
  case mode of 
    Waterfall _ -> True
    _ -> False


toList : Maybe a -> List a
toList x = 
  case x of 
    Nothing -> []
    Just y -> [y]


tabsView : 
  (Msg -> m) -> Config m -> Model -> (List (Html m), List (Style m)) -> Html m
tabsView lift config model (tabs, tabStyles) =
  let 
    chevron direction offset =
      div
        [ classList
            [ ("mdl-layout__tab-bar-button", True)
            , ("mdl-layout__tab-bar-" ++ direction ++ "-button", True)
            ]
        ]
        [ Icon.view ("chevron_" ++ direction) 
            [ Icon.size24
            , Icon.onClick (lift (ScrollTab offset))
            ]
          -- TODO: Scroll event
        ]
  in
    Options.div
      [ cs "mdl-layout__tab-bar-container"
      ]
      [ chevron "left" -100
      , Options.div
          [ cs "mdl-layout__tab-bar" 
          , if config.rippleTabs then 
              Options.many 
                [ cs "mdl-js-ripple-effect"
                , cs "mds-js-ripple-effect--ignore-events"
                ]
            else
              nop
          , if config.mode == Standard then cs "is-casting-shadow" else nop
          , Options.many tabStyles
          ]
          (tabs |> List.indexedMap (\tabIndex tab ->
            filter a
              [ classList
                  [ ("mdl-layout__tab", True)
                  , ("is-active", tabIndex == config.selectedTab)
                  ]
              , config.onSwitchTab 
                  |> Maybe.map ((|>) tabIndex)
                  |> Maybe.withDefault Helpers.noAttr
              ]
              [ Just tab
              , if config.rippleTabs then
                  Array.get tabIndex (s model).tabs |> Maybe.map (
                    Ripple.view [ class "mdl-layout__tab-ripple-container" ]
                    >> App.map (Ripple tabIndex >> lift)
                  )
                else
                  Nothing
              ]
           ))
      , chevron "right" 100
      ]


headerView 
  : (Msg -> m) -> Config m -> Model 
 -> (Maybe (Html m), List (Html m), Maybe (Html m)) 
 ->  Html m
headerView lift config model (drawerButton, rows, tabs) =
  let 
    mode =
      case config.mode of
        Standard  -> ""
        Scrolling -> "mdl-layout__header--scroll"
        Seamed    -> "mdl-layout__header--seamed"
        Waterfall True -> "mdl-layout__header--waterfall mdl-layout__header--waterfall-hide-top"
        Waterfall False -> "mdl-layout__header--waterfall"
  in
    Html.header
      ([ classList
          [ ("mdl-layout__header", True)
          , ("is-casting-shadow", 
              config.mode == Standard || 
              (isWaterfall config.mode && (s model).isCompact)
            )
          , ("is-animating", (s model).isAnimating)
          , ("is-compact", (s model).isCompact)
          , (mode, mode /= "")
          ]
      ]
      |> List.append (
        if isWaterfall config.mode then 
          [  
          --  onClick addr Click
          --, on "transitionend" Json.value (\_ -> Signal.message addr TransitionEnd)
            {- There is no "ontransitionend" property; you'd have to add a listener, 
            which Elm won't let us. We manually fire a delayed tick instead. 
            See also: https://github.com/evancz/virtual-dom/issues/30
            -}
            onClick 
              (TransitionHeader { toCompact=False, fixedHeader=config.fixedHeader }
               |> lift)
          ]
        else
          []
        )
      )
      (List.concatMap (\x -> x)
         [ toList drawerButton
         , rows 
         , toList tabs
         ]
      )


drawerButton : (Msg -> m) -> Html m
drawerButton lift =
  div
    [ class "mdl-layout__drawer-button"
    , onClick (lift ToggleDrawer)
    ]
    [ Icon.i "menu" ]


obfuscator : (Msg -> m) -> Model -> Html m
obfuscator lift model =
  div
    [ classList
        [ ("mdl-layout__obfuscator", True)
        , ("is-visible", model.isDrawerOpen)
        ]
    , onClick (lift ToggleDrawer)
    ]
    []


drawerView : Model -> List (Html m) -> Html m
drawerView model elems =
  div
    [ classList
        [ ("mdl-layout__drawer", True)
        , ("is-visible", model.isDrawerOpen)
        ]
    ]
    elems


{-| Content of the layout only (contents of main pane is set elsewhere). Every
part is optional; if you supply an empty list for either, the sub-component is 
omitted. 

The `header` and `drawer` contains the contents of the header rows and drawer,
respectively. Use `row`, `spacer`, `title`, `nav`, and `link`, as well as
regular Html to construct these. The `tabs` contains
the title of each tab.
-}
type alias Contents m =
  { header : List (Html m)
  , drawer : List (Html m)
  , tabs : (List (Html m), List (Style m))
  , main : List (Html m)
  }


{-| Main layout view.
-}
view : (Msg -> m) -> Model -> List (Property m) -> Contents m -> Html m
view lift model options { drawer, header, tabs, main } =
  let
    summary = 
      Options.collect defaultConfig options

    config = 
      summary.config 

    (contentDrawerButton, headerDrawerButton) =
      case (drawer, header, config.fixedHeader) of
        (_ :: _, _ :: _, True) ->
          -- Drawer with fixedHeader: Add the button to the header
           (Nothing, Just <| drawerButton lift)

        (_ :: _, _, _) ->
          -- Drawer, no or non-fixed header: Add the button before contents.
           (Just <| drawerButton lift, Nothing)

        _ ->
          -- No drawer: no button.
           (Nothing, Nothing)

    hasTabs = 
      not (List.isEmpty (fst tabs))

    hasHeader = 
      hasTabs || (not (List.isEmpty header))

    tabsElems = 
      if not hasTabs then
        Nothing
      else 
        Just (tabsView lift config model tabs)
  in
  div
    [ classList
        [ ("mdl-layout__container", True)
        , ("has-scrolling-header", config.mode == Scrolling)
        ]
    ]
    [ filter div
        [ classList
            [ ("mdl-layout ", True)
            , ("is-upgraded", True)
            , ("is-small-screen", (s model).isSmallScreen)
            , ("has-drawer", drawer /= [])
            , ("has-tabs", hasTabs)
            , ("mdl-js-layout", True)
            , ("mdl-layout--fixed-drawer", config.fixedDrawer && drawer /= [])
            , ("mdl-layout--fixed-header", config.fixedHeader && hasHeader)
            , ("mdl-layout--fixed-tabs", config.fixedTabs && hasTabs)
            ]
        ]
        [ if hasHeader then
            headerView lift config model (headerDrawerButton, header, tabsElems)
              |> Just
          else
            Nothing
        , if List.isEmpty drawer then Nothing else Just (obfuscator lift model)
        , if List.isEmpty drawer then Nothing else Just (drawerView model drawer)
        , contentDrawerButton
        , main' 
            ( class "mdl-layout__content" 
            :: Helpers.key ("elm-mdl-layout-" ++ toString config.selectedTab)
            :: (
              if isWaterfall config.mode then 
                [ on "scroll" 
                    (Decoder.map 
                      (ScrollPane config.fixedHeader >> lift) 
                      (DOM.target DOM.scrollTop))
                ]
              else 
                []
              )
            )
            main
          |> Just
        ]
    ]



