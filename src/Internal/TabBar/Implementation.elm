module Internal.TabBar.Implementation exposing
    ( Property
    , Tab
    , activeTab
    , icon
    , react
    , smallIndicator
    , stacked
    , tab
    , view
    )

import DOM
import Browser.Dom as Dom
import Task
import Dict exposing (Dict)
import Html exposing (Html, text, nav, div, span, button)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Dispatch as Dispatch
import Internal.GlobalEvents as GlobalEvents
import Internal.Helpers as Helpers
import Internal.Icon.Implementation as Icon
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Internal.Ripple.Implementation as Ripple
import Internal.Ripple.Model as Ripple
import Internal.TabBar.Model exposing (Geometry, Model, Msg(..), defaultGeometry, defaultModel)
import Json.Decode as Json exposing (Decoder)
import Json.Encode


update : (Msg m -> m) -> Msg m -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    let
        isRtl =
            False

        -- TODO
        scrollToTabAtIndex geometry i =
            let
                tab_ =
                    geometry.tabs
                        |> List.drop i
                        |> List.head
                        |> Maybe.withDefault
                            { offsetLeft = 0
                            , offsetWidth = 0
                            }

                tabBarWidth =
                    geometry.tabBar.offsetWidth

                scrollTargetOffsetLeft =
                    tab_.offsetLeft

                scrollTargetOffsetWidth =
                    tab_.offsetWidth

                normalizeForRtl left width =
                    if isRtl then
                        tabBarWidth - (left + width)

                    else
                        left
            in
            normalizeForRtl scrollTargetOffsetLeft scrollTargetOffsetWidth

        indicatorEnabledStates geometry translateOffset =
            let
                backIndicator =
                    translateOffset /= 0

                tabBarWidth =
                    geometry.tabBar.offsetWidth

                remainingTabBarWidth =
                    tabBarWidth - translateOffset

                scrollFrameWidth =
                    geometry.scrollFrame.offsetWidth

                forwardIndicator =
                    remainingTabBarWidth > scrollFrameWidth
            in
            { forwardIndicator = forwardIndicator
            , backIndicator = backIndicator
            }
    in
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

        Select geometry ->
            ( Just { model | geometry = Just geometry }
            , Cmd.none
            -- TODO: really want to focus tab here with something like:
            -- Task.attempt (\_ -> NoOp) (Dom.focus "tabs-hero-tabs--0")
            )

        ScrollBack geometry ->
            let
                tabBarWidth =
                    geometry.tabBar.offsetWidth

                scrollFrameWidth =
                    geometry.scrollFrame.offsetWidth

                currentTranslateOffset =
                    model.translateOffset

                loop ( i, tab_ ) result =
                    if result.scrollTargetIndex /= Nothing then
                        result

                    else
                        let
                            tabOffsetLeft =
                                tab_.offsetLeft

                            tabBarWidthLessTabOffsetLeft =
                                tabBarWidth - tabOffsetLeft

                            tabIsNotOccluded =
                                if not isRtl then
                                    tabOffsetLeft > currentTranslateOffset

                                else
                                    tabBarWidthLessTabOffsetLeft > currentTranslateOffset
                        in
                        if tabIsNotOccluded then
                            result

                        else
                            let
                                newTabWidthAccumulator =
                                    result.tabWidthAccumulator + tab_.offsetWidth

                                scrollTargetDetermined =
                                    newTabWidthAccumulator > scrollFrameWidth

                                newScrollTargetIndex =
                                    if scrollTargetDetermined then
                                        Just <|
                                            if isRtl then
                                                i + 1

                                            else
                                                i

                                    else
                                        Nothing
                            in
                            { scrollTargetIndex = newScrollTargetIndex
                            , tabWidthAccumulator = newTabWidthAccumulator
                            }

                scrollTargetIndex =
                    Maybe.withDefault 0
                        << .scrollTargetIndex
                    <|
                        List.foldl loop
                            { scrollTargetIndex = Nothing
                            , tabWidthAccumulator = 0
                            }
                            (List.reverse (List.indexedMap (\index tab_ -> ( index, tab_ )) geometry.tabs))

                translateOffset =
                    scrollToTabAtIndex geometry scrollTargetIndex

                { forwardIndicator, backIndicator } =
                    indicatorEnabledStates geometry translateOffset
            in
            ( Just
                { model
                    | geometry = Just geometry
                    , translateOffset = translateOffset
                    , forwardIndicator = forwardIndicator
                    , backIndicator = backIndicator
                }
            , Cmd.none
            )

        ScrollForward geometry ->
            let
                currentTranslationOffset =
                    model.translateOffset

                scrollFrameWidth =
                    geometry.scrollFrame.offsetWidth + currentTranslationOffset

                loop ( i, tab_ ) result =
                    if result.scrollTargetIndex /= Nothing then
                        result

                    else
                        let
                            tabOffsetLeftAndWidth =
                                tab_.offsetLeft + tab_.offsetWidth

                            scrollTargetDetermined =
                                if not isRtl then
                                    tabOffsetLeftAndWidth > scrollFrameWidth

                                else
                                    let
                                        frameOffsetAndTabWidth =
                                            scrollFrameWidth - tab_.offsetWidth

                                        tabRightOffset =
                                            tab_.offsetWidth - tabOffsetLeftAndWidth
                                    in
                                    tabRightOffset > frameOffsetAndTabWidth
                        in
                        if scrollTargetDetermined then
                            { scrollTargetIndex = Just i
                            }

                        else
                            { scrollTargetIndex = Nothing
                            }

                scrollTargetIndex =
                    Maybe.withDefault 0
                        << .scrollTargetIndex
                    <|
                        List.foldl loop
                            { scrollTargetIndex = Nothing
                            }
                            (List.indexedMap (\index tab_ -> ( index, tab_ )) geometry.tabs)

                translateOffset =
                    scrollToTabAtIndex geometry scrollTargetIndex

                { forwardIndicator, backIndicator } =
                    indicatorEnabledStates geometry translateOffset
            in
            ( Just
                { model
                    | geometry = Just geometry
                    , translateOffset = translateOffset
                    , forwardIndicator = forwardIndicator
                    , backIndicator = backIndicator
                }
            , Cmd.none
            )

        Focus i geometry ->
            let
                resetAmt =
                    if isRtl then
                        model.scrollLeftAmount

                    else
                        0

                tab_ =
                    geometry.tabs
                        |> List.drop i
                        |> List.head
                        |> Maybe.withDefault
                            { offsetLeft = 0
                            , offsetWidth = 0
                            }

                scrollFrameWidth =
                    geometry.scrollFrame.offsetWidth

                tabBarWidth =
                    geometry.tabBar.offsetWidth

                leftEdge =
                    tab_.offsetLeft

                rightEdge =
                    leftEdge + tab_.offsetWidth

                normalizedLeftOffset =
                    tabBarWidth - leftEdge

                currentTranslateOffset =
                    model.translateOffset

                shouldScrollBack =
                    if not isRtl then
                        rightEdge <= currentTranslateOffset

                    else
                        leftEdge >= tabBarWidth - currentTranslateOffset

                shouldScrollForward =
                    if not isRtl then
                        rightEdge > currentTranslateOffset + scrollFrameWidth

                    else
                        normalizedLeftOffset > scrollFrameWidth + currentTranslateOffset
            in
            if shouldScrollForward then
                update lift (ScrollForward geometry) model

            else if shouldScrollBack then
                update lift (ScrollBack geometry) model

            else
                ( Nothing, Cmd.none )

        Init geometry ->
            ( let
                tabBarWidth =
                    geometry.tabBar.offsetWidth

                scrollFrameWidth =
                    geometry.scrollFrame.offsetWidth

                isOverflowing =
                    tabBarWidth > scrollFrameWidth

                translateOffset =
                    if not isOverflowing then
                        0

                    else
                        model.translateOffset

                { forwardIndicator, backIndicator } =
                    indicatorEnabledStates geometry translateOffset
              in
              Just
                { model
                    | geometry = Just geometry
                    , forwardIndicator = forwardIndicator
                    , backIndicator = backIndicator
                    , translateOffset = translateOffset
                    , indicatorShown = False || model.indicatorShown
                }
            , Helpers.delayedCmd 0 (lift SetIndicatorShown)
            )

        SetIndicatorShown ->
            ( Just { model | indicatorShown = True }, Cmd.none )

        SetActiveTab tab_index ->
            ( Just { model | activeTab = tab_index }, Cmd.none )


-- Note: tab bar and tab state use the same config.
type alias Config =
    { indicator : Bool
    , activeTab : Int
    , icon : Maybe String
    , smallIndicator : Bool
    -- This value is computed by computeHorizontalScrollbarHeight in mdc-tab-sroller/util.js.
    -- No clue how to do that in Elm beside using a port. Should we?
    , horizontalScrollbarHeight : Int
    }


defaultConfig : Config
defaultConfig =
    { indicator = True
    , activeTab = 0
    , icon = Nothing
    , smallIndicator = False
    , horizontalScrollbarHeight = 10
    }


indicator : Property m
indicator =
    Options.option (\config -> { config | indicator = True })


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

        numTabs =
            List.length nodes

        isRtl =
            False

        -- TODO
        tabBarTransform =
            let
                shiftAmount =
                    if isRtl then
                        model.translateOffset

                    else
                        -model.translateOffset
            in
            "translateX(" ++ String.fromFloat shiftAmount ++ "px)"

        tab_nodes = List.indexedMap (tabView domId lift model options) nodes

    in
        Options.apply summary
            nav
            [ cs "mdc-tab-bar"
            , Options.role "tablist"
            , when stateChanged <|
                GlobalEvents.onTick (Json.succeed (lift (SetActiveTab ( config.activeTab ))))
            ]
            []
            [ scroller lift model
                  []
                  tab_nodes
            ]


{-| The scroll area view.
-}
scroller :
    (Msg m -> m)
    -> Model
    -> List (Property m)
    -> List (Html m)
    -> Html m
scroller lift model options nodes =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    styled div
        [ cs "mdc-tab-scroller"
        ]
        [ styled div
              [ cs "mdc-tab-scroller__scroll-area"
              , cs "mdc-tab-scroller__scroll-area--scroll"
              , css "margin-bottom" ((String.fromInt -config.horizontalScrollbarHeight) ++ "px")
              ]
              [ Options.apply summary
                    div
                    [ cs "mdc-tab-scroller__scroll-content"

                    -- It's easiest to do geometry decoding on the immediate container of the tabs
                    , when (model.geometry == Nothing) <|
                        GlobalEvents.onTick <|
                            Json.map (lift << Init) <|
                                decodeGeometryOnScrollContent config.indicator
                    , GlobalEvents.onResize <|
                        Json.map (lift << Init) <|
                            decodeGeometryOnScrollContent config.indicator
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

        stateChanged = config.activeTab /= model.activeTab

        -- Only set tab to active on next tick
        to_be_selected = stateChanged && config.activeTab == index

        selected = model.activeTab == index

        tab_summary = Options.collect defaultConfig tab_.options

        tab_config = tab_summary.config

        tabDomId = domId ++ "--" ++ String.fromInt index

        ripple =
            Ripple.view False
                tabDomId
                (lift << RippleMsg index)
                (Dict.get index model.ripples
                |> Maybe.withDefault Ripple.defaultModel
                )
            []

        -- Tried to do that mdc does:
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

                    xPosition = fromX - currentX

                    widthDelta = previousTabWidth / currentTabWidth

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

        indicator_span =
            styled span
                [ cs "mdc-tab-indicator"
                , cs "mdc-tab-indicator--active" |> when selected
                , cs "mdc-tab-indicator--no-transition" |> when to_be_selected
                ]
                [ styled span
                    [ cs "mdc-tab-indicator__content"
                    , cs "mdc-tab-indicator__content--underline"
                    , css "transform" indicatorTransform |> when to_be_selected
                    ]
                    []
                ]

    in
        -- TODO: may need manual event dispatching here according to Tabs implementation?
        -- Because the tab should get focus, but failed to do so.
        Options.apply tab_summary
        button
            [ cs "mdc-tab"
            , cs "mdc-tab--active" |> when selected
            , Options.role "tab"
            , Options.aria "selected" (if selected then "true" else "false")
            , Options.tabindex (if selected then 0 else -1)

            -- TODO: not sure what the purpose of this is
            , Options.on "click" <|
                Json.map (lift << Select) <|
                    decodeGeometryOnTab config.indicator
            -- TODO: not sure what the purpose of this is
            -- , Options.on "focus" <|
            --     Json.map (lift << Focus index) <|
            --         decodeGeometryOnTab config.indicator

            -- TODO: somehow ripple needs to interact with ripple span I think?
            -- Now it sets "mdc-ripple-upgraded on the button class which is wrong.
            , ripple.interactionHandler
            , ripple.properties
            ]
            []
            [ styled span
                  [ cs "mdc-tab__content" ]
                  [ icon_span
                  , styled span
                        [ cs "mdc-tab__text-label" ]
                        tab_.childs
                  , if tab_config.smallIndicator then indicator_span else text ""
                  ]
            , if tab_config.smallIndicator then text "" else indicator_span
            , styled span
                [ cs "mdc-tab__ripple"
                ]
                  []
            ]


type alias Store s =
    { s | tabbar : Indexed Model }


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


-- TODO: probably rework, indicator is gone, but we still have some kind of scrolling.
decodeGeometryOnIndicator : Bool -> Decoder Geometry
decodeGeometryOnIndicator hasIndicator =
    DOM.target <|
        -- .mdc-tab-bar-scroller__indicator
        DOM.parentElement
        <|
            -- .mdc-tab-bar-scroller
            DOM.childNode 1
            <|
                -- .mdc-tab-bar-scroller__scroll-frame
                DOM.childNode 0
                <|
                    -- .mdc-tab-bar
                    decodeGeometry hasIndicator


decodeGeometryOnTab : Bool -> Decoder Geometry
decodeGeometryOnTab hasIndicator =
    let
        traverseToScrollContent cont =
            Json.oneOf
                [ DOM.className
                    |> Json.andThen
                        (\className ->
                            if String.contains " mdc-tab-scroller___scroll-content " (" " ++ className ++ " ") then
                                cont

                            else
                                Json.fail "Material.TabBar.decodeGeometryOnTabBar"
                        )
                , DOM.parentElement (Json.lazy (\_ -> traverseToScrollContent cont))
                ]
    in
    DOM.target <|
        -- .mdc-tab [*]
        traverseToScrollContent
        <|
            decodeGeometry hasIndicator


decodeGeometryOnTabBar : Bool -> Decoder Geometry
decodeGeometryOnTabBar hasIndicator =
    DOM.target <|
        -- .mdc-tab-bar
        decodeGeometry hasIndicator


decodeGeometryOnScrollContent : Bool -> Decoder Geometry
decodeGeometryOnScrollContent hasIndicator =
    DOM.target <|
        -- .mdc-tab-scroller___scroll-content
        decodeGeometry hasIndicator


decodeGeometry : Bool -> Decoder Geometry
decodeGeometry hasIndicator =
    Json.map3 Geometry
        (Json.map (List.filterMap identity) <|
                DOM.childNodes
                    (Json.at [ "tagName" ] Json.string
                        |> Json.andThen
                            (\tagName ->
                                case String.toLower tagName of
                                    "button" ->
                                        Json.map Just <|
                                            Json.map2
                                                (\offsetLeft offsetWidth ->
                                                    { offsetLeft = offsetLeft
                                                    , offsetWidth = offsetWidth
                                                    }
                                                )
                                                DOM.offsetLeft
                                                DOM.offsetWidth

                                    _ ->
                                        Json.succeed Nothing
                            )
                    )
        )
        (Json.map (\offsetWidth -> { offsetWidth = offsetWidth }) DOM.offsetWidth)
        (DOM.parentElement <|
             -- .mdc-tab-scroller__scroll-area
             DOM.parentElement <|
                 -- .mdc-tab-scroller
                 DOM.parentElement <|
                     -- .mdc-tab-bar
                     Json.map (\offsetWidth -> { offsetWidth = offsetWidth }) DOM.offsetWidth
        )
