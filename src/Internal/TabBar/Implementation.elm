module Internal.TabBar.Implementation exposing
    ( Property
    , Tab
    , activeTab
    , fadingIconIndicator
    , icon
    , indicatorIcon
    , react
    , smallIndicator
    , stacked
    , tab
    , view
    )

import Browser.Dom
import DOM
import Dict
import Html exposing (Html, button, div, nav, span, text)
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Dispatch as Dispatch
import Internal.GlobalEvents as GlobalEvents
import Internal.Helpers exposing (cmd, succeedIfLeavingElement)
import Internal.Keyboard as Keyboard exposing (Key, KeyCode, Meta, decodeMeta, decodeKey, decodeKeyCode)
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Internal.Ripple.Implementation as Ripple
import Internal.Ripple.Model as Ripple
import Internal.TabBar.Model exposing (Geometry, Model, Msg(..), defaultGeometry, defaultModel)
import Json.Decode as Decode exposing (Decoder)
import Task


update : (Msg m -> m) -> Msg m -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    case msg of
        RippleMsg index msg_ ->
            let
                ( ripple, effects ) =
                    Ripple.update msg_
                        (Dict.get index model.ripples
                            |> Maybe.withDefault Ripple.defaultModel
                        )
            in
            ( Just { model | ripples = Dict.insert index ripple model.ripples }
            , Cmd.map (lift << RippleMsg index) effects
            )

        Dispatch msgs ->
            ( Nothing, Dispatch.forward msgs )

        NoOp ->
            ( Nothing, Cmd.none )

        Init geometry ->
            ( Just
                { model
                    | geometry = Just geometry
                }
            , Cmd.none
            )

        AnimationStart ->
            ( Just { model | animating = True, startAnimating = False, scrollDelta = 0 }, Cmd.none )

        SetActiveTab domId tab_index scrollPosition ->
            let
                geometry =
                    Maybe.withDefault defaultGeometry model.geometry

                tabBarWidth =
                    geometry.tabBar.offsetWidth

                scrollContentWidth =
                    geometry.scrollContent.offsetWidth

                isOverflowing =
                    scrollContentWidth > tabBarWidth

                tabAtIndex i =
                    geometry.tabs
                        |> List.drop i
                        |> List.head
                        |> Maybe.withDefault
                            { offsetLeft = 0
                            , offsetWidth = 0
                            , contentLeft = 0
                            , contentRight = 0
                            }

                tab_ =
                    tabAtIndex tab_index

                barWidth =
                    geometry.tabBar.offsetWidth

                next_tab_index =
                    findAdjacentTabIndexClosestToEdge tab_index tab_ scrollPosition barWidth

                scrollIncrement =
                    calculateScrollIncrement geometry tab_index next_tab_index scrollPosition barWidth

                newScrollPosition =
                    if tab_index == 0 then
                        -- Always scroll to 0 if scrolling to the 0th index
                        0
                    else if tab_index == List.length geometry.tabs - 1 then
                        -- Always scroll to the max value if scrolling to the Nth index
                        scrollContentWidth - tabBarWidth
                    else
                        scrollPosition + scrollIncrement

                scrollDelta = scrollPosition - newScrollPosition

                ( animate, m ) =
                    if isOverflowing then
                        ( True, AnimationStart )
                    else
                        ( False, NoOp )

            in
            ( Just { model | activeTab = tab_index, focusedTab = Nothing, scrollDelta = scrollDelta, startAnimating = animate, animating = False }
            , Browser.Dom.setViewportOf (domId ++ "__scroll-area") newScrollPosition 0
                |> Task.map (\_ -> m)
                |> Task.onError (\_ -> Task.succeed NoOp)
                |> Task.perform lift
            )

        FocusTab domId index ->
            ( Just model, Task.attempt (\_ -> lift NoOp) (Browser.Dom.focus (tabId domId index)) )

        ResetFocusedTab ->
            ( Just { model | focusedTab = Nothing }, Cmd.none )

        Left domId tab_index ->
            let
                focusedTab =
                    case model.focusedTab of
                        Just index -> index - 1
                        Nothing -> tab_index - 1
            in
                if focusedTab >= 0 then
                    update lift (FocusTab domId focusedTab) { model | focusedTab = Just focusedTab }
                else
                    ( Nothing, Cmd.none )

        Right domId tab_index ->
            let
                geometry =
                    Maybe.withDefault defaultGeometry model.geometry

                max_tabs = List.length geometry.tabs

                focusedTab =
                    case model.focusedTab of
                        Just index -> index + 1
                        Nothing -> tab_index + 1

            in
                if focusedTab < max_tabs then
                    update lift (FocusTab domId focusedTab) { model | focusedTab = Just focusedTab }
                else
                    ( Nothing, Cmd.none )

        SelectTab m tab_index ->
            ( Just { model | focusedTab = Nothing }, cmd (m tab_index) )



{-| Determines the index of the adjacent tab closest to either edge of the Tab Bar
TODO: Rtl
-}
findAdjacentTabIndexClosestToEdge : Int -> Internal.TabBar.Model.Tab -> Float -> Float -> Int
findAdjacentTabIndexClosestToEdge index tab_ scrollPosition barWidth =
    let
        rootLeft =
            tab_.offsetLeft

        rootRight =
            tab_.offsetLeft + tab_.offsetWidth

        relativeRootLeft =
            rootLeft - scrollPosition

        relativeRootRight =
            rootRight - scrollPosition - barWidth

        relativeRootDelta =
            relativeRootLeft + relativeRootRight

        leftEdgeIsCloser =
            relativeRootLeft < 0 || relativeRootDelta < 0

        rightEdgeIsCloser =
            relativeRootRight > 0 || relativeRootDelta > 0
    in
    if leftEdgeIsCloser then
        index - 1

    else if rightEdgeIsCloser then
        index + 1

    else
        -1


{-| Calculates the scroll increment that will make the tab at the given index visible
TODO: Rtl
-}
calculateScrollIncrement : Geometry -> Int -> Int -> Float -> Float -> Float
calculateScrollIncrement geometry index nextIndex scrollPosition barWidth =
    let
        maybe_next_tab =
            geometry.tabs
                |> List.drop nextIndex
                |> List.head

        extraScrollAmount =
            20
    in
    case maybe_next_tab of
        Just next_tab ->
            let
                relativeContentLeft =
                    next_tab.contentLeft - scrollPosition - barWidth

                relativeContentRight =
                    next_tab.contentRight - scrollPosition

                leftIncrement =
                    relativeContentRight - extraScrollAmount

                rightIncrement =
                    relativeContentLeft + extraScrollAmount
            in
            if nextIndex < index then
                min leftIncrement 0

            else
                max rightIncrement 0

        Nothing ->
            0



-- Note: tab bar and tab state use the same config.


type alias Config =
    { indicator : Bool
    , activeTab : Int
    , icon : Maybe String
    , smallIndicator : Bool
    , indicatorIcon : Maybe String
    , fadingIconIndicator : Bool
    }


defaultConfig : Config
defaultConfig =
    { indicator = True
    , activeTab = 0
    , icon = Nothing
    , smallIndicator = False
    , indicatorIcon = Nothing
    , fadingIconIndicator = False
    }


activeTab : Int -> Property m
activeTab value =
    Options.option (\config -> { config | activeTab = value })


type alias Tab m =
    { options : List (Property m)
    , childs : List (Html m)
    }


tab : List (Property m) -> List (Html m) -> Tab m
tab options childs =
    { options = options
    , childs = childs
    }


icon : String -> Property m
icon value =
    Options.option (\config -> { config | icon = Just value })


stacked : Property m
stacked =
    cs "mdc-tab--stacked"


smallIndicator : Property m
smallIndicator =
    Options.option (\config -> { config | smallIndicator = True })


indicatorIcon : String -> Property m
indicatorIcon value =
    Options.option (\config -> { config | indicatorIcon = Just value })


fadingIconIndicator : Property m
fadingIconIndicator =
    Options.option (\config -> { config | fadingIconIndicator = True })


type alias Property m =
    Options.Property Config m


tabbar :
    Index
    -> (Msg m -> m)
    -> Model
    -> List (Property m)
    -> List (Tab m)
    -> Html m
tabbar domId lift model options nodes =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        stateChanged =
            config.activeTab /= model.activeTab

        tab_nodes =
            List.indexedMap (tabView domId lift model options) nodes
    in
    Options.apply summary
        nav
        [ cs "mdc-tab-bar"
        , Options.id domId
        , Options.role "tablist"
        , when stateChanged <|
            GlobalEvents.onTick <|
                Decode.map (lift << SetActiveTab domId config.activeTab) <|
                    decodeScrollLeft

        -- , when stateChanged <|
        --     GlobalEvents.onTick (Decode.succeed (lift (SetActiveTab domId config.activeTab)))

        , Options.onAKeyDown Keyboard.arrowRight (lift <| Right domId config.activeTab)
        , Options.onAKeyDown Keyboard.arrowLeft (lift <| Left domId config.activeTab)

        -- If user tabs out of list, we reset the focused item to the
        -- selected one, so when the user tabs back in, that is the
        -- selected index.
        , Options.on "focusout" <|
            Decode.map (always (lift ResetFocusedTab)) (succeedIfLeavingElement domId)
        ]
        []
        [ scroller domId lift model options tab_nodes
        ]


{-| The scroll area view.
-}
scroller :
    String
    -> (Msg m -> m)
    -> Model
    -> List (Property m)
    -> List (Html m)
    -> Html m
scroller domId lift model options nodes =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        isRtl = False

        tabBarTransform =
            let
                shiftAmount =
                    if isRtl then
                        model.scrollDelta
                    else
                        -model.scrollDelta
            in
                "translateX(" ++ String.fromFloat shiftAmount ++ "px)"

    in
    styled div
        [ cs "mdc-tab-scroller"
        , when model.animating <|
            cs "mdc-tab-scroller--animating"
        ]
        [ styled div
            [ Options.id (domId ++ "__scroll-area")
            , cs "mdc-tab-scroller__scroll-area"
            , cs "mdc-tab-scroller__scroll-area--scroll"
            , css "margin-bottom" "calc(-1 * var(--elm-mdc-horizontal-scrollbar-height))"
            ]
            [ Options.apply summary
                div
                [ cs "mdc-tab-scroller__scroll-content"
                , when model.startAnimating <|
                    css "transform" tabBarTransform
                --, when model.startAnimating <|
                --    GlobalEvents.onTick (Decode.succeed (lift AnimationStart))
                , when model.animating <|
                    css "transform" "none"

                -- It's easiest to do geometry decoding on the immediate container of the tabs.
                -- Note that we do this as soon as the tab bar is created.
                -- It will do this given the currently available font.

                -- If the font changes, for example you load Roboto,
                -- but don't wait for it to become available before
                -- initialising Elm, the geometry will be wrong!
                -- TODO: recalculate if the font changes.
                -- Perhaps another solution might be to retrieve the
                -- geometry just before when we need it.
                , when (model.geometry == Nothing) <|
                    GlobalEvents.onTick <|
                        Decode.map (lift << Init) <|
                            decodeGeometryOnScrollContent
                , GlobalEvents.onResize <|
                    Decode.map (lift << Init) <|
                        decodeGeometryOnScrollContent
                ]
                []
                nodes
            ]
        ]


{-| Single tab view.
-}
tabView :
    Index
    -> (Msg m -> m)
    -> Model
    -> List (Property m)
    -> Int
    -> Tab m
    -> Html m
tabView domId lift model options index tab_ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        stateChanged =
            config.activeTab /= model.activeTab

        -- Only set tab to active on next tick
        to_be_selected =
            (stateChanged && config.activeTab == index) && not tab_config.fadingIconIndicator

        tab_summary =
            Options.collect defaultConfig tab_.options

        tab_config =
            tab_summary.config

        selected =
            (model.activeTab == index) || (tab_config.fadingIconIndicator && config.activeTab == index)

        tabDomId =
            domId ++ "--" ++ String.fromInt index

        ripple =
            Ripple.view False
                tabDomId
                (lift << RippleMsg index)
                (Dict.get index model.ripples
                    |> Maybe.withDefault Ripple.defaultModel
                )
                []

        -- Tried to do what mdc does:
        -- This animation uses the FLIP approach. You can read more about it at the link below:
        -- https://aerotwist.com/blog/flip-your-animations/
        indicatorTransform =
            if to_be_selected then
                let
                    geometry =
                        Maybe.withDefault defaultGeometry model.geometry

                    previousTab =
                        geometry.tabs
                            |> List.drop model.activeTab
                            |> List.head

                    currentTab =
                        geometry.tabs
                            |> List.drop config.activeTab
                            |> List.head

                    fromX =
                        previousTab
                            |> Maybe.map .offsetLeft
                            |> Maybe.withDefault 0

                    currentX =
                        currentTab
                            |> Maybe.map .offsetLeft
                            |> Maybe.withDefault 0

                    previousTabWidth =
                        previousTab
                            |> Maybe.map .offsetWidth
                            |> Maybe.withDefault 0

                    currentTabWidth =
                        currentTab
                            |> Maybe.map .offsetWidth
                            |> Maybe.withDefault 0

                    xPosition =
                        fromX - currentX

                    widthDelta =
                        previousTabWidth / currentTabWidth
                in
                String.join " "
                    [ "translateX(" ++ String.fromFloat xPosition ++ "px)"
                    , "scale(" ++ String.fromFloat widthDelta ++ ",1)"
                    ]

            else
                ""

        icon_span =
            case tab_config.icon of
                Just name ->
                    styled span
                        [ cs "mdc-tab__icon"
                        , cs "material-icons"
                        , Options.aria "hidden" "true"
                        ]
                        [ text name ]

                Nothing ->
                    text ""

        icon_indicator =
            case tab_config.indicatorIcon of
                Just _ ->
                    True

                Nothing ->
                    False

        icon_name =
            case tab_config.indicatorIcon of
                Just name ->
                    name

                Nothing ->
                    ""

        indicator_span =
            styled span
                [ cs "mdc-tab-indicator"
                , cs "mdc-tab-indicator--active" |> when selected
                , cs "mdc-tab-indicator--no-transition" |> when to_be_selected
                , cs "mdc-tab-indicator--fade" |> when tab_config.fadingIconIndicator
                ]
                [ styled span
                    [ cs "mdc-tab-indicator__content"
                    , cs "mdc-tab-indicator__content--underline" |> when (not icon_indicator)
                    , cs "mdc-tab-indicator__content--icon" |> when icon_indicator
                    , cs "material-icons" |> when icon_indicator
                    , css "transform" indicatorTransform |> when to_be_selected
                    ]
                    [ text icon_name ]
                ]
    in
    Options.apply tab_summary
        button
        [ cs "mdc-tab"
        , cs "mdc-tab--active" |> when selected
        , Options.id ( tabId domId index )
        , Options.role "tab"
        , Options.aria "selected"
            (if selected then
                "true"

             else
                "false"
            )
        , Options.tabindex
            (if selected then
                0

             else
                -1
            )
        , ripple.interactionHandler
        ]
        []
        [ styled span
            [ cs "mdc-tab__content" ]
            [ icon_span
            , styled span
                [ cs "mdc-tab__text-label" ]
                tab_.childs
            , if tab_config.smallIndicator then
                indicator_span

              else
                text ""
            ]
        , if tab_config.smallIndicator then
            text ""

          else
            indicator_span
        , styled span
            [ cs "mdc-tab__ripple"
            , ripple.properties
            ]
            []
        ]


tabId domId index =
    domId ++ "--button-" ++ (String.fromInt index)


type alias Store s =
    { s | tabbar : Indexed Model }


getSet :
    { get : Index -> { a | tabbar : Indexed Model } -> Model
    , set :
        Index
        -> { a | tabbar : Indexed Model }
        -> Model
        -> { a | tabbar : Indexed Model }
    }
getSet =
    Component.indexed .tabbar (\x y -> { y | tabbar = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.TabBarMsg update


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Tab m)
    -> Html m
view =
    \lift domId ->
        Component.render getSet.get (tabbar domId) Internal.Msg.TabBarMsg lift domId


decodeScrollLeft : Decoder Float
decodeScrollLeft =
    DOM.target <| DOM.childNode 0 <| DOM.childNode 0 <| Decode.map (\scrollLeft -> scrollLeft) DOM.scrollLeft


decodeGeometryOnScrollContent : Decoder Geometry
decodeGeometryOnScrollContent =
    DOM.target <|
        -- .mdc-tab-scroller___scroll-content
        decodeGeometry



-- Current element when we arrive here should be .mdc-tab-scroller__scroll-content
-- i.e. the immediate container for the tabs.

decodeGeometry : Decoder Geometry
decodeGeometry =
    Decode.map3 Geometry
        (Decode.map (List.filterMap identity) <|
            DOM.childNodes
                ( DOM.classList
                    |> Decode.andThen
                        (\classes ->
                             if List.member "mdc-tab" classes then
                                 tabDimensions
                             else
                                 Decode.succeed Nothing
                        )
                )
        )
        ( -- .mdc-tab-scroller__scroll-content
          Decode.map (\offsetWidth -> { offsetWidth = offsetWidth }) DOM.offsetWidth
        )
        (DOM.parentElement <|
            -- .mdc-tab-scroller__scroll-area
            DOM.parentElement
            <|
                -- .mdc-tab-scroller
                DOM.parentElement
                <|
                    -- .mdc-tab-bar
                    Decode.map (\offsetWidth -> { offsetWidth = offsetWidth }) DOM.offsetWidth
        )

{-| Decode .mdc-tab.
-}
tabDimensions : Decoder ( Maybe { offsetLeft : Float, offsetWidth : Float, contentLeft : Float, contentRight : Float } )
tabDimensions =
    Decode.map3
        (\rootLeft rootWidth content ->
             let
                 ( contentLeft, contentWidth ) =
                     case List.head content of
                         Just c -> ( c.contentLeft, c.contentWidth )
                         Nothing -> ( 0, 0 )
             in
             Just { offsetLeft = rootLeft
                  , offsetWidth = rootWidth
                  , contentLeft = rootLeft + contentLeft
                  , contentRight = rootLeft + contentLeft + contentWidth
             }
        )
        DOM.offsetLeft
        DOM.offsetWidth
        contentDimensions


{-| Decode .mdc-tab__content
-}
contentDimensions : Decoder ( List { contentLeft : Float, contentWidth : Float } )
contentDimensions =
    Decode.map (List.filterMap identity) <|
        DOM.childNodes
            ( DOM.classList
            |> Decode.andThen
                 (\classes ->
                      if List.member "mdc-tab__content" classes then
                          Decode.map Just <|
                              Decode.map2
                              (\contentLeft contentWidth ->
                                   { contentLeft = contentLeft
                                   , contentWidth = contentWidth
                                   }
                              )
                              DOM.offsetLeft
                              DOM.offsetWidth
                      else
                          Decode.succeed Nothing
                 )
            )
