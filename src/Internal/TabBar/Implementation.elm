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
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Internal.Ripple.Implementation as Ripple
import Internal.Ripple.Model as Ripple
import Internal.TabBar.Model exposing (Geometry, Model, Msg(..), defaultGeometry, defaultModel)
import Json.Decode as Json exposing (Decoder)
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
            ( let
                tabBarWidth =
                    geometry.tabBar.offsetWidth

                scrollAreaWidth =
                    geometry.scrollArea.offsetWidth

                isOverflowing =
                    tabBarWidth > scrollAreaWidth

                translateOffset =
                    if not isOverflowing then
                        0

                    else
                        model.translateOffset
              in
              Just
                { model
                    | geometry = Just geometry
                    , translateOffset = translateOffset
                }
            , Cmd.none
            )

        SetActiveTab domId tab_index scrollPosition ->
            let
                geometry =
                    Maybe.withDefault defaultGeometry model.geometry

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
                        geometry.scrollArea.offsetWidth

                    else
                        scrollPosition + scrollIncrement

                -- TODO: properly animate new scroll position using FLIP
            in
            ( Just { model | activeTab = tab_index }
            , Browser.Dom.setViewportOf (domId ++ "__scroll-area") newScrollPosition 0
                |> Task.map (\_ -> NoOp)
                |> Task.onError (\_ -> Task.succeed NoOp)
                |> Task.perform lift
            )


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

        -- TODO
        {-
           tabBarTransform =
               let
                   shiftAmount =
                       if isRtl then
                           model.translateOffset

                       else
                           -model.translateOffset
               in
               "translateX(" ++ String.fromFloat shiftAmount ++ "px)"
        -}
        tab_nodes =
            List.indexedMap (tabView domId lift model options) nodes
    in
    Options.apply summary
        nav
        [ cs "mdc-tab-bar"
        , Options.role "tablist"
        , when stateChanged <|
            GlobalEvents.onTick <|
                Json.map (lift << SetActiveTab domId config.activeTab) <|
                    decodeScrollLeft

        -- , when stateChanged <|
        --     GlobalEvents.onTick (Json.succeed (lift (SetActiveTab domId config.activeTab)))
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
    in
    styled div
        [ cs "mdc-tab-scroller"
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

                -- It's easiest to do geometry decoding on the immediate container of the tabs
                , when (model.geometry == Nothing) <|
                    GlobalEvents.onTick <|
                        Json.map (lift << Init) <|
                            decodeGeometryOnScrollContent
                , GlobalEvents.onResize <|
                    Json.map (lift << Init) <|
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
    DOM.target <| DOM.childNode 0 <| DOM.childNode 0 <| Json.map (\scrollLeft -> scrollLeft) DOM.scrollLeft


decodeGeometryOnScrollContent : Decoder Geometry
decodeGeometryOnScrollContent =
    DOM.target <|
        -- .mdc-tab-scroller___scroll-content
        decodeGeometry



-- Current element when we arrive here should be .mdc-tab-scroller__scroll-content
-- i.e. the immediate container for the tabs.


decodeGeometry : Decoder Geometry
decodeGeometry =
    Json.map3 Geometry
        (Json.map (List.filterMap identity) <|
            DOM.childNodes
                (Json.at [ "tagName" ] Json.string
                    |> Json.andThen
                        (\tagName ->
                            case String.toLower tagName of
                                "button" ->
                                    let
                                        -- TODO: get node with appropriate class name
                                        content =
                                            DOM.childNode 0

                                        {-
                                        dimensions =
                                            content <|
                                                Json.map2
                                                    (\offsetLeft offsetWidth ->
                                                        { offsetLeft = offsetLeft
                                                        , offsetWidth = offsetWidth
                                                        }
                                                    )
                                                    DOM.offsetLeft
                                                    DOM.offsetWidth
                                        -}
                                    in
                                    Json.map Just <|
                                        Json.map2
                                            (\offsetLeft offsetWidth ->
                                                { offsetLeft = offsetLeft
                                                , offsetWidth = offsetWidth

                                                -- TODO: get content left and right here
                                                , contentLeft = offsetLeft + 24
                                                , contentRight = offsetLeft + offsetWidth - 24 - 24
                                                }
                                            )
                                            DOM.offsetLeft
                                            DOM.offsetWidth

                                _ ->
                                    Json.succeed Nothing
                        )
                )
        )
        (DOM.parentElement <|
            -- .mdc-tab-scroller__scroll-area
            Json.map (\offsetWidth -> { offsetWidth = offsetWidth }) DOM.offsetWidth
        )
        (DOM.parentElement <|
            -- .mdc-tab-scroller__scroll-area
            DOM.parentElement
            <|
                -- .mdc-tab-scroller
                DOM.parentElement
                <|
                    -- .mdc-tab-bar
                    Json.map (\offsetWidth -> { offsetWidth = offsetWidth }) DOM.offsetWidth
        )
