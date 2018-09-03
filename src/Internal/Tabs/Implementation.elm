module Internal.Tabs.Implementation
    exposing
        ( Property
        , Tab
        , icon
        , iconText
        , indicator
        , react
        , scrolling
        , tab
        , view
        , withIconAndText
        )

import DOM
import Dict exposing (Dict)
import Html exposing (Html, text)
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
import Internal.Tabs.Model exposing (Geometry, Model, Msg(..), defaultGeometry, defaultModel)
import Json.Decode as Json exposing (Decoder)
import Json.Encode


update : (Msg m -> m) -> Msg m -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    let
        isRtl =
            False

        -- TODO
        scrollToTabAtIndex isRtl geometry i =
            let
                tab =
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
                    tab.offsetLeft

                scrollTargetOffsetWidth =
                    tab.offsetWidth

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

        Select index geometry ->
            ( Just
                { model
                    | index = index
                    , scale = computeScale geometry index
                    , geometry = Just geometry
                }
            , Cmd.none
            )

        ScrollBack geometry ->
            let
                tabBarWidth =
                    geometry.tabBar.offsetWidth

                scrollFrameWidth =
                    geometry.scrollFrame.offsetWidth

                currentTranslateOffset =
                    model.translateOffset

                loop ( i, tab ) ({ scrollTargetIndex, tabWidthAccumulator } as result) =
                    if scrollTargetIndex /= Nothing then
                        result
                    else
                        let
                            tabOffsetLeft =
                                tab.offsetLeft

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
                                    tabWidthAccumulator + tab.offsetWidth

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
                            (List.reverse (List.indexedMap (,) geometry.tabs))

                translateOffset =
                    scrollToTabAtIndex isRtl geometry scrollTargetIndex

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

                loop ( i, tab ) ({ scrollTargetIndex } as result) =
                    if scrollTargetIndex /= Nothing then
                        result
                    else
                        let
                            tabOffsetLeftAndWidth =
                                tab.offsetLeft + tab.offsetWidth

                            scrollTargetDetermined =
                                if not isRtl then
                                    tabOffsetLeftAndWidth > scrollFrameWidth
                                else
                                    let
                                        frameOffsetAndTabWidth =
                                            scrollFrameWidth - tab.offsetWidth

                                        tabRightOffset =
                                            tab.offsetWidth - tabOffsetLeftAndWidth
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
                            (List.indexedMap (,) geometry.tabs)

                translateOffset =
                    scrollToTabAtIndex isRtl geometry scrollTargetIndex

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

                tab =
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
                    tab.offsetLeft

                rightEdge =
                    leftEdge + tab.offsetWidth

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
                    , scale = computeScale geometry model.index
                    , forwardIndicator = forwardIndicator
                    , backIndicator = backIndicator
                    , translateOffset = translateOffset
                    , indicatorShown = False || model.indicatorShown
                }
            , Helpers.delayedCmd 0 (lift SetIndicatorShown)
            )

        SetIndicatorShown ->
            ( Just { model | indicatorShown = True }, Cmd.none )


type alias Config =
    { active : Int
    , scroller : Bool
    , indicator : Bool
    }


defaultConfig : Config
defaultConfig =
    { active = 0
    , scroller = False
    , indicator = False
    }


scrolling : Property m
scrolling =
    Options.option (\config -> { config | scroller = True })


indicator : Property m
indicator =
    Options.option (\config -> { config | indicator = True })


type alias Tab m =
    { options : List (Property m)
    , childs : List (Html m)
    }


tab : List (Property m) -> List (Html m) -> Tab m
tab options childs =
    { options = options
    , childs = childs
    }


withIconAndText : Property m
withIconAndText =
    cs "mdc-tab--with-icon-and-text"


icon : List (Options.Property c m) -> String -> Html m
icon options icon =
    Icon.view
        [ cs "mdc-tab__icon"
        ]
        icon


iconText : List (Options.Property c m) -> String -> Html m
iconText options str =
    styled Html.span
        (cs "mdc-tab__icon-text"
            :: options
        )
        [ text str
        ]


type alias Property m =
    Options.Property Config m


tabs :
    (Msg m -> m)
    -> Model
    -> List (Property m)
    -> List (Tab m)
    -> Html m
tabs lift model options nodes =
    let
        summary =
            Options.collect defaultConfig options

        config =
            summary.config

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
            "translateX(" ++ toString shiftAmount ++ "px)"

        geometry =
            Maybe.withDefault defaultGeometry model.geometry

        indicatorTransform =
            let
                tabLeft =
                    geometry.tabs
                        |> List.drop model.index
                        |> List.head
                        |> Maybe.map .offsetLeft
                        |> Maybe.withDefault 0
            in
            String.join " "
                [ "translateX(" ++ toString tabLeft ++ "px)"
                , "scale(" ++ toString model.scale ++ ",1)"
                ]

        tabBarScroller tabBar =
            styled Html.div
                [ cs "mdc-tab-bar-scroller"
                ]
                [ styled Html.div
                    [ cs "mdc-tab-bar-scroller__indicator"
                    , cs "mdc-tab-bar-scroller__indicator--back"
                    , cs "mdc-tab-bar-scroller__indicator--enabled"
                    , css "display" "none" |> when (not model.backIndicator)
                    , Options.on "click" <|
                        Json.map (lift << ScrollBack) <|
                            decodeGeometryOnIndicator config.indicator
                    ]
                    [ styled Html.a
                        [ cs "mdc-tab-bar__indicator__inner"
                        , cs "material-icons"
                        , css "pointer-events" "none"
                        ]
                        [ text "navigate_before"
                        ]
                    ]
                , styled Html.div
                    [ cs "mdc-tab-bar-scroller__scroll-frame"
                    , Options.attribute
                        << Html.property "scrollLeft"
                      <|
                        Json.Encode.int model.scrollLeftAmount
                    ]
                    [ tabBar
                    ]
                , styled Html.div
                    [ cs "mdc-tab-bar-scroller__indicator"
                    , cs "mdc-tab-bar-scroller__indicator--next"
                    , cs "mdc-tab-bar-scroller__indicator--enabled"
                    , Options.on "click" <|
                        Json.map (lift << ScrollForward) <|
                            decodeGeometryOnIndicator config.indicator
                    , css "display" "none" |> when (not model.forwardIndicator)
                    ]
                    [ styled Html.a
                        [ cs "mdc-tab-bar__indicator__inner"
                        , cs "material-icons"
                        , css "pointer-events" "none"
                        ]
                        [ text "navigate_next"
                        ]
                    ]
                ]
    in
    (if config.scroller then
        tabBarScroller
     else
        identity
    )
    <|
        Options.apply summary
            Html.nav
            [ cs "mdc-tab-bar"
            , cs "mdc-tab-bar-upgraded"
            , Options.many
                [ cs "mdc-tab-bar-scroller__scroller-frame__tabs"
                , css "transform" tabBarTransform
                ]
            , when (model.geometry == Nothing) <|
                GlobalEvents.onTick <|
                    Json.map (lift << Init) <|
                        decodeGeometryOnTabBar config.indicator
            , GlobalEvents.onResize <|
                Json.map (lift << Init) <|
                    decodeGeometryOnTabBar config.indicator
            ]
            []
            (List.concat
                [ nodes
                    |> List.indexedMap
                        (\index { options, childs } ->
                            let
                                ripple =
                                    Ripple.view False
                                        (lift << RippleMsg index)
                                        (Dict.get index model.ripples
                                            |> Maybe.withDefault Ripple.defaultModel
                                        )
                                        []
                            in
                            [ -- Note: We need to manually install event
                              -- dispatching here, because both mdc-tab and
                              -- ripple listen on focus events, and the global
                              -- dispatch only accounts for dispatching in
                              -- mdc-tab-bar options.
                              Html.a
                                (Options.addAttributes
                                    (Options.recollect
                                        { summary
                                            | classes = []
                                            , css = []
                                            , attrs = []
                                            , internal = []
                                            , config = defaultConfig
                                            , dispatch = Dispatch.clear summary.dispatch
                                        }
                                        (cs "mdc-tab"
                                            :: when (model.index == index) (cs "mdc-tab--active")
                                            :: Options.attribute (Html.tabindex 0)
                                            :: (Options.on "click" <|
                                                    Json.map (lift << Select index) <|
                                                        decodeGeometryOnTab config.indicator
                                               )
                                            :: (Options.on "keydown" <|
                                                    Json.map lift <|
                                                        Json.map3
                                                            (\key keyCode geometry ->
                                                                if key == Just "Enter" || keyCode == 13 then
                                                                    Select index geometry
                                                                else
                                                                    NoOp
                                                            )
                                                            (Json.oneOf
                                                                [ Json.map Just (Json.at [ "key" ] Json.string)
                                                                , Json.succeed Nothing
                                                                ]
                                                            )
                                                            (Json.at [ "keyCode" ] Json.int)
                                                            (decodeGeometryOnTab config.indicator)
                                               )
                                            :: Options.many
                                                [ ripple.interactionHandler
                                                , ripple.properties
                                                ]
                                            :: (when config.scroller <|
                                                    Options.on "focus" <|
                                                        Json.map (lift << Focus index) <|
                                                            decodeGeometryOnTab config.indicator
                                               )
                                            :: options
                                        )
                                    )
                                    []
                                )
                                (childs ++ [ ripple.style ])
                            ]
                        )
                    |> List.concat
                , if config.indicator then
                    let
                        indicatorFirstRender =
                            not model.indicatorShown
                    in
                    [ styled Html.div
                        [ cs "mdc-tab-bar__indicator"
                        , css "transform" indicatorTransform
                        , when (numTabs > 0) <|
                            css "visibility" "visible"
                        , when indicatorFirstRender <|
                            css "display" "none"
                        ]
                        []
                    ]
                  else
                    []
                ]
            )


type alias Store s =
    { s | tabs : Indexed Model }


( get, set ) =
    Component.indexed .tabs (\x y -> { y | tabs = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Internal.Msg.TabsMsg update


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Tab m)
    -> Html m
view =
    Component.render get tabs Internal.Msg.TabsMsg


computeScale : Geometry -> Int -> Float
computeScale geometry index =
    let
        totalTabsWidth =
            List.foldl (+) 0 (List.map .offsetWidth geometry.tabs)
    in
    case List.head (List.drop index geometry.tabs) of
        Nothing ->
            1

        Just tab ->
            if totalTabsWidth == 0 then
                1
            else
                tab.offsetWidth / totalTabsWidth


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
        traverseToTabBar cont =
            Json.oneOf
                [ DOM.className
                    |> Json.andThen
                        (\className ->
                            if String.contains " mdc-tab-bar " (" " ++ className ++ " ") then
                                cont
                            else
                                Json.fail "Material.Tabs.decodeGeometryOnTabBar"
                        )
                , DOM.parentElement (Json.lazy (\_ -> traverseToTabBar cont))
                ]
    in
    DOM.target <|
        -- .mdc-tab [*]
        traverseToTabBar
        <|
            decodeGeometry hasIndicator


decodeGeometryOnTabBar : Bool -> Decoder Geometry
decodeGeometryOnTabBar hasIndicator =
    DOM.target <|
        -- .mdc-tab-bar
        decodeGeometry hasIndicator


decodeGeometry : Bool -> Decoder Geometry
decodeGeometry hasIndicator =
    Json.map3 Geometry
        (Json.map
            (if hasIndicator then
                \xs -> List.take (List.length xs - 1) xs
             else
                identity
            )
         <|
            Json.map (List.filterMap identity) <|
                DOM.childNodes
                    (Json.at [ "tagName" ] Json.string
                        |> Json.andThen
                            (\tagName ->
                                case String.toLower tagName of
                                    "style" ->
                                        Json.succeed Nothing

                                    _ ->
                                        Json.map Just <|
                                            Json.map2
                                                (\offsetLeft offsetWidth ->
                                                    { offsetLeft = offsetLeft
                                                    , offsetWidth = offsetWidth
                                                    }
                                                )
                                                DOM.offsetLeft
                                                DOM.offsetWidth
                            )
                    )
        )
        (Json.map (\offsetWidth -> { offsetWidth = offsetWidth }) DOM.offsetWidth)
        (DOM.parentElement <|
            -- .mdc-tab-bar-scroller__scroll-frame
            Json.map (\offsetWidth -> { offsetWidth = offsetWidth }) DOM.offsetWidth
        )
