module Material.Layout exposing
  ( init, subscriptions , Model, defaultModel, Msg(ToggleDrawer), update
  , Property
  , fixedDrawer, fixedTabs, fixedHeader, rippleTabs
  , waterfall, seamed, scrolling, selectedTab, onSelectTab
  , row, spacer, title, navigation, link, onClick, href
  , Contents, view
  , sub0, subs, render, toggleDrawer
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

# Subscriptions

The layout needs to be initialised with and subscribe to changes in viewport
sizes. Example initialisation of containing app: 

    import Material.Layout as Layout
    import Material

    type Msg = 
      ...
      | Mdl Material.Msg -- Boilerplate

    ...

    App.program 
      { init = ( model, Layout.sub0 Mdl )
      , view = view
      , subscriptions = Layout.subs Mdl
      , update = update
      }


@docs sub0, subs

# Render
@docs Contents, render, toggleDrawer

# Options
@docs Property

## Tabs
@docs fixedTabs, rippleTabs

## Header
@docs fixedHeader, fixedDrawer
@docs waterfall, seamed, scrolling, selectedTab

## Events
@docs onSelectTab

# Sub-views
@docs row, spacer, title, navigation, link, onClick, href

# Elm architecture
@docs view, Msg, Model, defaultModel, update, init, subscriptions


-}


import Dict exposing (Dict)
import Maybe exposing (andThen, map)
import Html exposing (..)
import Html.App as App
import Html.Attributes exposing (class, classList, tabindex)
import Html.Events as Events exposing (on)
import Platform.Cmd exposing (Cmd)
import Window
import Json.Decode as Decoder
import Task

import Parts
import Material.Helpers as Helpers exposing (filter, delay, pure, map1st, map2nd)
import Material.Ripple as Ripple
import Material.Icon as Icon
import Material.Options as Options exposing (Style, cs, nop, css, styled)
import Material.Options.Internal exposing (attribute)

import DOM


-- SETUP


smallScreenWatch : Int -> Msg
smallScreenWatch = 
  (>) 1024 >> SmallScreen 


{-| Layout needs initial viewport size
-}
init : (Model, Cmd Msg)
init = 
  let
    msg = 
      Task.perform 
        (\_ -> smallScreenWatch (Debug.log "Can't get initial window dimensions. Guessing " 1025))
        smallScreenWatch Window.width
  in
    (defaultModel, msg)


{-| Layout subscribes to changes in viewport size. 
-}
subscriptions : x -> Sub Msg
subscriptions =
  let 
    sub = 
      Window.resizes (.width >> smallScreenWatch)
  in
    always sub


-- MODEL


{-| Component mode. 
-}
type alias Model =
  { ripples : Dict Int Ripple.Model
  , isSmallScreen : Bool
  , isCompact : Bool
  , isAnimating : Bool
  , isScrolled : Bool
  , isDrawerOpen : Bool
  }


{-| Default component model. 
-}
defaultModel : Model
defaultModel =
  { ripples = Dict.empty
  , isSmallScreen = False 
  , isCompact = False
  , isAnimating = False
  , isScrolled = False
  , isDrawerOpen = False
  }


-- ACTIONS, UPDATE


{-| Component messages.
-}
type Msg
  = ToggleDrawer
  | SmallScreen Bool -- True means small screen
  | ScrollTab Float
  | ScrollPane Bool Float -- True means fixedHeader
  | TransitionHeader { toCompact : Bool, fixedHeader : Bool }
  | TransitionEnd
  | NOP
  -- Subcomponents
  | Ripple Int Ripple.Msg


{-| Component update.
-}
update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    NOP -> 
      ( model, Cmd.none ) 

    SmallScreen isSmall ->
      { model  
      | isSmallScreen = isSmall 
      , isDrawerOpen = not isSmall && model.isDrawerOpen
      }
      |> pure

    ToggleDrawer ->
      { model | isDrawerOpen = not model.isDrawerOpen } |> pure

    Ripple tabIndex action' ->
      Dict.get tabIndex model.ripples
      |> Maybe.withDefault Ripple.model
      |> Ripple.update action'
      |> map1st (\ripple' -> 
          { model | ripples = Dict.insert tabIndex ripple' model.ripples })
      |> map2nd (Cmd.map (Ripple tabIndex))

    ScrollTab tab ->
      (model, Cmd.none) -- TODO

    ScrollPane fixedHeader offset -> 
      let 
        isScrolled = 0.0 < offset 
      in
        if isScrolled /= model.isScrolled then
          update 
            (TransitionHeader { toCompact = isScrolled, fixedHeader = fixedHeader })
            model
        else
          pure model

    TransitionHeader { toCompact, fixedHeader } -> 
      let 
        headerVisible = (not model.isSmallScreen) || fixedHeader
        model' = 
          { model 
          | isCompact = toCompact
          , isAnimating = headerVisible 
          }
      in
        if not model.isAnimating then 
          ( { model 
            | isCompact = toCompact
            , isAnimating = headerVisible 
            }
          , delay 200 TransitionEnd -- See comment on transitionend in view. 
          )
        else
          pure model


    TransitionEnd -> 
      ( { model | isAnimating = False }
      , Cmd.none
      )


-- PROPERTIES


type alias Config m = 
  { fixedHeader : Bool
  , fixedDrawer : Bool
  , fixedTabs : Bool
  , rippleTabs : Bool
  , mode : Mode
  , selectedTab : Int
  , onSelectTab : Maybe (Int -> Attribute m)
  }


defaultConfig : Config m
defaultConfig = 
  { fixedHeader = False
  , fixedDrawer = False
  , fixedTabs = False
  , rippleTabs = True
  , mode = Standard
  , onSelectTab = Nothing
  , selectedTab = -1
  }


{-| Layout options. 
-}
type alias Property m = 
  Options.Property (Config m) m


{-| Header is "fixed": It appears even on small screens. 
-}
fixedHeader : Property m
fixedHeader =
  Options.set (\config -> { config | fixedHeader = True })



{-| Drawer is "fixed": It is always open on large screens. 
-}
fixedDrawer : Property m
fixedDrawer =
  Options.set (\config -> { config | fixedDrawer = True })


{-| Tabs are spread out to consume available space and do not scroll horisontally.
-}
fixedTabs : Property m
fixedTabs =
  Options.set (\config -> { config | fixedTabs = True })


{-| Make tabs ripple when clicked. 
-}
rippleTabs : Property m
rippleTabs =
  Options.set (\config -> { config | rippleTabs = True })


{-| Header behaves as "Waterfall" header: On scroll, the top (argument `True`) or
the bottom (argument `False`) of the header disappears. 
-}
waterfall : Bool -> Property m
waterfall b =
  Options.set (\config -> { config | mode = Waterfall b })


{-| Header behaves as "Seamed" header: it does not cast shadow, is permanently
affixed to the top of the screen.
-}
seamed : Property m
seamed = 
  Options.set (\config -> { config | mode = Seamed })


{-| Header scrolls with contents. 
-}
scrolling : Property m
scrolling = 
  Options.set (\config -> { config | mode = Scrolling })

{-| Set the selected tab. 
-}
selectedTab : Int -> Property m
selectedTab k =
  Options.set (\config -> { config | selectedTab = k })

{-| Receieve notification when tab `k` is selected.
-}
onSelectTab : (Int -> m) -> Property m
onSelectTab f = 
  Options.set (\config -> { config | onSelectTab = Just (f >> Events.onClick) })


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


type LinkProp = LinkProp


type alias LinkProperty m = 
  Options.Property LinkProp m


{-| onClick for Links.
-}
onClick : m -> LinkProperty m 
onClick = 
  Events.onClick >> attribute


{-| href for Links.
-}
href : String -> LinkProperty m
href = 
  Html.Attributes.href >> attribute


{-| Link.
-}
link : List (LinkProperty m) -> List (Html m) -> Html m
link styles contents =
  Options.styled a 
    (cs "mdl-navigation__link" 
     :: attribute (Html.Attributes.attribute "tabindex" "1")
     :: styles) 
    contents


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
      styled div
        [ cs "mdl-layout__tab-bar-button"
        , cs ("mdl-layout__tab-bar-" ++ direction ++ "-button")
        , Options.many tabStyles
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
              , config.onSelectTab 
                  |> Maybe.map ((|>) tabIndex)
                  |> Maybe.withDefault Helpers.noAttr
              , Html.Attributes.href ("#mdl-layout-tab-" ++ toString tabIndex)
              ]
              [ Just tab
              , if config.rippleTabs then
                  Dict.get tabIndex model.ripples 
                    |> Maybe.withDefault Ripple.model
                    |> Ripple.view [ class "mdl-layout__tab-ripple-container" ]
                    |> App.map (Ripple tabIndex >> lift)
                    |> Just
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
              (isWaterfall config.mode && model.isCompact)
            )
          , ("is-animating", model.isAnimating)
          , ("is-compact", model.isCompact)
          , (mode, mode /= "")
          ]
      ]
      |> List.append (
        if isWaterfall config.mode then 
          [  
          --  Events.onClick addr Click
          --, on "transitionend" Json.value (\_ -> Signal.message addr TransitionEnd)
            {- There is no "ontransitionend" property; you'd have to add a listener, 
            which Elm won't let us. We manually fire a delayed tick instead. 
            See also: https://github.com/evancz/virtual-dom/issues/30
            -}
            Events.onClick 
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


onKeypressFilterSpaceAndEnter : Html.Attribute x
onKeypressFilterSpaceAndEnter = """
  (function (evt) {
     if (evt && evt.type === "keydown" && (evt.keyCode === 32 || evt.keyCode === 13)) {
       evt.preventDefault();
     }
   })(window.event);
  """
    |> Html.Attributes.attribute "onkeypress"



drawerButton : (Msg -> m) -> Html m
drawerButton lift =
  div 
    [ --onKeypressFilterSpaceAndEnter
    ]
    [
      div
        [ class "mdl-layout__drawer-button"
        , tabindex 1
        , Events.onClick (lift ToggleDrawer)
        , Events.onWithOptions 
            "keydown"
            { stopPropagation = False
            , preventDefault = False --  True
              {- TODO: Should stop propagation exclusively on ENTER, but elm
              currently require me to decide on options before the keycode value is
              available. -} 
            }
            (Decoder.map 
              (lift << \key -> case key of 
                  32 {- SPACE -} -> ToggleDrawer
                  13 {- ENTER -} -> ToggleDrawer
                  _ -> NOP)
              Events.keyCode)
        ]
        [ Icon.i "menu" ]
      ]


obfuscator : (Msg -> m) -> Model -> Html m
obfuscator lift model =
  div
    [ classList
        [ ("mdl-layout__obfuscator", True)
        , ("is-visible", model.isDrawerOpen)
        ]
    , Events.onClick (lift ToggleDrawer)
    ]
    []


drawerView : (Msg -> m) -> Model -> List (Html m) -> Html m
drawerView lift model elems =
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

    hasDrawer = 
      drawer /= [] 
        && model.isDrawerOpen 
        && (not config.fixedDrawer || model.isSmallScreen) 

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
        ([ Just <| classList
            [ ("mdl-layout ", True)
            , ("is-upgraded", True)
            , ("is-small-screen", model.isSmallScreen)
            , ("has-drawer", drawer /= [])
            , ("has-tabs", hasTabs)
            , ("mdl-js-layout", True)
            , ("mdl-layout--fixed-drawer", config.fixedDrawer && drawer /= [])
            , ("mdl-layout--fixed-header", config.fixedHeader && hasHeader)
            , ("mdl-layout--fixed-tabs", config.fixedTabs && hasTabs)
            ]
        {- MDL has code to close drawer on ESC, but it seems to be
           non-operational. We fix it here. Elm 0.17 doesn't give us a way to
           catch global keyboard events, but we can reasonably assume something inside
           mdl-layout__container is focused. 
        -} 
        , if hasDrawer then
            on "keydown" 
               (Decoder.map 
                 (lift << \key -> if key == 27 then ToggleDrawer else NOP) 
                 Events.keyCode)
            |> Just
          else
            Nothing
        ] |> List.filterMap identity)
        [ if hasHeader then
            headerView lift config model (headerDrawerButton, header, tabsElems)
              |> Just
          else
            Nothing
        , if hasDrawer then Nothing else Just (drawerView lift model drawer)
        , if hasDrawer then Nothing else Just (obfuscator lift model)
        , contentDrawerButton
        , main' 
            ( class "mdl-layout__content" 
            --:: Helpers.key ("elm-mdl-layout-" ++ toString config.selectedTab)
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


type alias Container c =
  { c | layout : Model }


{-| Component render. Refer to `demo/Demo.elm` on github for an example use. 
Excerpt:

    Layout.render Mdl model.mdl
      [ Layout.selectedTab model.selectedTab
      , Layout.onSelectTab SelectTab
      , Layout.fixedHeader
      ]
      { header = myHeader
      , drawer = myDrawer
      , tabs = (tabTitles, [])
      , main = [ MyComponent.view model ]
      }
-}
render 
  : (Parts.Msg (Container b) -> c)
 -> Container b
 -> List (Property c) 
 -> Contents c 
 -> Html c
render =
  Parts.create1 
    view update 
    .layout (\x c -> { c | layout = x }) 


pack : Msg -> Parts.Msg (Container b)
pack = 
  let
    embeddedUpdate = 
      Parts.embedUpdate .layout (\x c -> { c | layout = x }) update
  in
    Parts.pack embeddedUpdate


{-| Component subscriptions (type compatible with render). Either this or 
`subscriptions` must be connected for the Layout to be responsive under
viewport size changes. 
-}
subs : (Parts.Msg (Container b) -> c) -> x -> Sub c
subs lift = 
  subscriptions >> Sub.map (pack >> lift)


{-| Component subscription initialiser. Either this or 
`init` must be connected for the Layout to be responsive under
viewport size changes. Example use: 
-}
sub0 : (Parts.Msg (Container b) -> c) -> Cmd c
sub0 lift = 
  snd init |> Cmd.map (pack >> lift)


{-| Toggle drawer. 

This function is for use with parts typing. For plain TEA, simply issue 
an update for the exposed Msg `ToggleDrawer`. 
-}
toggleDrawer : (Parts.Msg (Container b) -> c) -> c
toggleDrawer lift = 
  (pack >> lift) ToggleDrawer 
