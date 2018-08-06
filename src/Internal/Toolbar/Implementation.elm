module Internal.Toolbar.Implementation
    exposing
        ( Property
        , alignEnd
        , alignStart
        , backgroundImage
        , fixed
        , fixedAdjust
        , fixedLastRow
        , flexible
        , flexibleDefaultBehavior
        , icon
        , iconToggle
        , menuIcon
        , react
        , row
        , section
        , shrinkToFit
        , title
        , view
        , waterfall
        )

import DOM
import Dict exposing (Dict)
import Html exposing (Html, text)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.GlobalEvents as GlobalEvents
import Internal.Icon.Implementation as Icon
import Internal.IconToggle.Implementation as IconToggle
import Internal.Msg
import Internal.Options as Options exposing (cs, css, nop, styled, when)
import Internal.Toolbar.Model exposing (Calculations, Config, Geometry, Model, Msg(..), defaultCalculations, defaultConfig, defaultModel)
import Json.Decode as Json exposing (Decoder)


cssClasses :
    { fixed : String
    , fixedLastRow : String
    , fixedAtLastRow : String
    , toolbarRowFlexible : String
    , flexibleDefaultBehavior : String
    , flexibleMax : String
    , flexibleMin : String
    }
cssClasses =
    { fixed = "mdc-toolbar--fixed"
    , fixedLastRow = "mdc-toolbar--fixed-lastrow-only"
    , fixedAtLastRow = "mdc-toolbar--fixed-at-last-row"
    , toolbarRowFlexible = "mdc-toolbar--flexible"
    , flexibleDefaultBehavior = "mdc-toolbar--flexible-default-behavior"
    , flexibleMax = "mdc-toolbar--flexible-space-maximized"
    , flexibleMin = "mdc-toolbar--flexible-space-minimized"
    }


strings :
    { titleSelector : String
    , firstRowSelector : String
    , changeEvent : String
    }
strings =
    { titleSelector = "mdc-toolbar__title"
    , firstRowSelector = "mdc-toolbar__row:first-child"
    , changeEvent = "MDCToolbar:change"
    }


numbers :
    { minTitleSize : Float
    , maxTitleSize : Float
    , toolbarRowHeight : Float
    , toolbarRowMobileHeight : Float
    , toolbarMobileBreakpoint : Float
    }
numbers =
    { maxTitleSize = 2.125
    , minTitleSize = 1.25
    , toolbarRowHeight = 64
    , toolbarRowMobileHeight = 56
    , toolbarMobileBreakpoint = 600
    }


update : Msg -> Model -> ( Model, Cmd m )
update msg model =
    case msg of
        Init config geometry ->
            let
                calculations =
                    initKeyRatio config geometry
                        |> setKeyHeights geometry
            in
            ( { model
                | geometry = Just geometry
                , calculations = Just calculations
                , config = Just config
              }
            , Cmd.none
            )

        Resize config geometry ->
            let
                calculations =
                    Maybe.map (setKeyHeights geometry) model.calculations
            in
            ( { model
                | geometry = Just geometry
                , calculations = calculations
                , config = Just config
              }
            , Cmd.none
            )

        Scroll config scrollTop ->
            ( { model | scrollTop = scrollTop, config = Just config }, Cmd.none )


decodeGeometry : Decoder Geometry
decodeGeometry =
    let
        viewportWidth =
            DOM.target <|
                Json.at [ "ownerDocument", "defaultView", "innerWidth" ] Json.float

        getRowHeight =
            viewportWidth
                |> Json.map
                    (\viewportWidth ->
                        if viewportWidth < numbers.toolbarMobileBreakpoint then
                            numbers.toolbarRowMobileHeight
                        else
                            numbers.toolbarRowHeight
                    )

        getFirstRowElementOffsetHeight =
            firstRowElement DOM.offsetHeight

        firstRowElement decoder =
            DOM.target <|
                DOM.childNode 0 decoder

        getOffsetHeight =
            DOM.target <|
                DOM.offsetHeight
    in
    Json.map3
        (\getRowHeight getFirstRowElementOffsetHeight getOffsetHeight ->
            { getRowHeight = getRowHeight
            , getFirstRowElementOffsetHeight = getFirstRowElementOffsetHeight
            , getOffsetHeight = getOffsetHeight
            }
        )
        getRowHeight
        getFirstRowElementOffsetHeight
        getOffsetHeight


decodeScrollTop : Decoder Float
decodeScrollTop =
    DOM.target <|
        Json.at [ "ownerDocument", "defaultView", "scrollY" ] Json.float



-- VIEW


toolbar : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
toolbar lift model options nodes =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        { toolbarProperties, flexibleRowElementStyles, elementStylesDefaultBehavior } =
            Maybe.map2
                (\geometry calculations ->
                    toolbarStyles config geometry model.scrollTop calculations
                )
                model.geometry
                model.calculations
                |> Maybe.map
                    (\styles ->
                        { toolbarProperties = Just styles.toolbarProperties
                        , flexibleRowElementStyles = styles.flexibleRowElementStyles
                        , elementStylesDefaultBehavior = styles.elementStylesDefaultBehavior
                        }
                    )
                |> Maybe.withDefault
                    { toolbarProperties = Nothing
                    , flexibleRowElementStyles = Nothing
                    , elementStylesDefaultBehavior = Nothing
                    }

        flexibleRowElementStylesHack =
            flexibleRowElementStyles
                |> Maybe.map
                    (\{ height } ->
                        let
                            className =
                                "mdc-toolbar-flexible-row-element-styles-hack-"
                                    ++ String.join "-" (String.split "." height)

                            text =
                                "."
                                    ++ className
                                    ++ " .mdc-toolbar__row:first-child{height:"
                                    ++ height
                                    ++ ";}"
                        in
                        { className = className, text = text }
                    )

        elementStylesDefaultBehaviorHack =
            elementStylesDefaultBehavior
                |> Maybe.map
                    (\{ fontSize } ->
                        let
                            className =
                                "mdc-toolbar-flexible-default-behavior-hack-"
                                    ++ String.join "-" (String.split "." fontSize)

                            text =
                                "."
                                    ++ className
                                    ++ " .mdc-toolbar__title{font-size:"
                                    ++ fontSize
                                    ++ ";}"
                        in
                        { className = className, text = text }
                    )

        backgroundImageHack =
            config.backgroundImage
                |> Maybe.map
                    (\backgroundImage ->
                        let
                            className =
                                (++) "mdc-toolbar-background-image-back-"
                                    (backgroundImage
                                        |> String.split "."
                                        |> String.join "-"
                                        |> String.split "/"
                                        |> String.join "-"
                                    )

                            text =
                                "."
                                    ++ className
                                    ++ " .mdc-toolbar__row:first-child::after {"
                                    ++ "background-image:url("
                                    ++ backgroundImage
                                    ++ ");"
                                    ++ "background-position:center;"
                                    ++ "background-size:cover;}"
                        in
                        { className = className, text = text }
                    )
    in
    Options.apply summary
        Html.header
        (cs "mdc-toolbar"
            :: (when config.fixed <|
                    cs cssClasses.fixed
               )
            :: (when (config.fixed && config.fixedLastrow) <|
                    cs cssClasses.fixedLastRow
               )
            :: (when config.waterfall <|
                    cs "mdc-toolbar--waterfall"
               )
            :: (when config.flexible <|
                    cs "mdc-toolbar--flexible"
               )
            :: (when (config.flexible && config.useFlexibleDefaultBehavior) <|
                    cs "mdc-toolbar--flexible-default-behavior"
               )
            :: (when (model.geometry == Nothing) <|
                    GlobalEvents.onTick (Json.map (lift << Init config) decodeGeometry)
               )
            :: GlobalEvents.onResize (Json.map (lift << Resize config) decodeGeometry)
            :: GlobalEvents.onScroll (Json.map (lift << Scroll config) decodeScrollTop)
            :: (toolbarProperties
                    |> Maybe.map Options.many
                    |> Maybe.withDefault nop
               )
            :: (flexibleRowElementStylesHack
                    |> Maybe.map (.className >> cs)
                    |> Maybe.withDefault nop
               )
            :: (elementStylesDefaultBehaviorHack
                    |> Maybe.map (.className >> cs)
                    |> Maybe.withDefault nop
               )
            :: (backgroundImageHack
                    |> Maybe.map (.className >> cs)
                    |> Maybe.withDefault nop
               )
            :: options
        )
        []
        (nodes
            ++ [ Html.node "style"
                    [ Html.type_ "text/css"
                    ]
                    [ text <|
                        String.join "\n" <|
                            List.filterMap (Maybe.map .text)
                                [ flexibleRowElementStylesHack
                                , elementStylesDefaultBehaviorHack
                                , backgroundImageHack
                                ]
                    ]
               ]
        )


adjustElementStyles : Config -> Calculations -> Maybe (Options.Property c m)
adjustElementStyles config calculations =
    let
        marginTop =
            calculations.toolbarHeight
    in
    if config.fixed then
        Just (css "margin-top" (toString marginTop ++ "px"))
    else
        Nothing


flexibleExpansionRatio : Calculations -> Float -> Float
flexibleExpansionRatio calculations scrollTop =
    let
        delta =
            0.0001
    in
    max 0 (1 - scrollTop / (calculations.flexibleExpansionHeight + delta))


initKeyRatio : Config -> Geometry -> Calculations
initKeyRatio config geometry =
    let
        toolbarRowHeight =
            geometry.getRowHeight

        firstRowMaxRatio =
            if toolbarRowHeight == 0 then
                0
            else
                geometry.getFirstRowElementOffsetHeight / toolbarRowHeight

        toolbarRatio =
            if toolbarRowHeight == 0 then
                0
            else
                geometry.getOffsetHeight / toolbarRowHeight

        flexibleExpansionRatio =
            firstRowMaxRatio - 1

        maxTranslateYRatio =
            if config.fixedLastrow then
                toolbarRatio - firstRowMaxRatio
            else
                0

        scrollThresholdRatio =
            if config.fixedLastrow then
                toolbarRatio - 1
            else
                firstRowMaxRatio - 1
    in
    { defaultCalculations
        | toolbarRatio = toolbarRatio
        , flexibleExpansionRatio = flexibleExpansionRatio
        , maxTranslateYRatio = maxTranslateYRatio
        , scrollThresholdRatio = scrollThresholdRatio
    }


setKeyHeights : Geometry -> Calculations -> Calculations
setKeyHeights geometry calculations =
    let
        toolbarRowHeight =
            geometry.getRowHeight

        toolbarHeight =
            calculations.toolbarRatio * toolbarRowHeight

        flexibleExpansionHeight =
            calculations.flexibleExpansionRatio * toolbarRowHeight

        maxTranslateYDistance =
            calculations.maxTranslateYRatio * toolbarRowHeight

        scrollThreshold =
            calculations.scrollThresholdRatio * toolbarRowHeight
    in
    { calculations
        | toolbarRowHeight = toolbarRowHeight
        , toolbarHeight = toolbarHeight
        , flexibleExpansionHeight = flexibleExpansionHeight
        , maxTranslateYDistance = maxTranslateYDistance
        , scrollThreshold = scrollThreshold
    }


toolbarStyles :
    Config
    -> Geometry
    -> Float
    -> Calculations
    ->
        { toolbarProperties : List (Property m)
        , flexibleRowElementStyles : Maybe { height : String }
        , elementStylesDefaultBehavior : Maybe { fontSize : String }
        }
toolbarStyles config geometry scrollTop calculations =
    let
        hasScrolledOutOfThreshold =
            scrollTop > calculations.scrollThreshold

        flexibleExpansionRatio_ =
            flexibleExpansionRatio calculations scrollTop

        toolbarFlexibleState =
            case flexibleExpansionRatio_ of
                1 ->
                    cs cssClasses.flexibleMax

                0 ->
                    cs cssClasses.flexibleMin

                _ ->
                    nop

        toolbarFixedState =
            let
                translateDistance =
                    max 0 <|
                        min (scrollTop - calculations.flexibleExpansionHeight) <|
                            calculations.maxTranslateYDistance
            in
            when config.fixedLastrow
                << Options.many
            <|
                [ css "transform" ("translateY(-" ++ toString translateDistance ++ "px)")
                , when (translateDistance == calculations.maxTranslateYDistance) <|
                    cs cssClasses.fixedAtLastRow
                ]

        flexibleRowElementStyles =
            if config.flexible && config.fixed then
                let
                    height =
                        calculations.flexibleExpansionHeight * flexibleExpansionRatio_
                in
                Just { height = toString (height + calculations.toolbarRowHeight) ++ "px" }
            else
                Nothing

        elementStylesDefaultBehavior =
            if config.useFlexibleDefaultBehavior then
                let
                    maxTitleSize =
                        numbers.maxTitleSize

                    minTitleSize =
                        numbers.minTitleSize

                    currentTitleSize =
                        (maxTitleSize - minTitleSize)
                            * flexibleExpansionRatio_
                            + minTitleSize
                in
                Just { fontSize = toString currentTitleSize ++ "rem" }
            else
                Nothing
    in
    { toolbarProperties =
        [ toolbarFlexibleState
        , toolbarFixedState
        ]
    , flexibleRowElementStyles =
        flexibleRowElementStyles
    , elementStylesDefaultBehavior =
        elementStylesDefaultBehavior
    }



-- COMPONENT


type alias Store s =
    { s | toolbar : Indexed Model }


( get, set ) =
    Component.indexed .toolbar (\x y -> { y | toolbar = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Internal.Msg.ToolbarMsg (Component.generalise update)



-- API


type alias Property m =
    Options.Property Config m


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render get toolbar Internal.Msg.ToolbarMsg


fixed : Property m
fixed =
    Options.option (\config -> { config | fixed = True })


waterfall : Property m
waterfall =
    Options.option (\config -> { config | waterfall = True })


flexible : Property m
flexible =
    Options.option (\config -> { config | flexible = True })


flexibleDefaultBehavior : Property m
flexibleDefaultBehavior =
    Options.option (\config -> { config | useFlexibleDefaultBehavior = True })


fixedLastRow : Property m
fixedLastRow =
    Options.option (\config -> { config | fixedLastrow = True })


backgroundImage : String -> Property m
backgroundImage backgroundImage =
    Options.option (\config -> { config | backgroundImage = Just backgroundImage })


row : List (Property m) -> List (Html m) -> Html m
row options =
    styled Html.div
        (cs "mdc-toolbar__row"
            :: options
        )


section : List (Property m) -> List (Html m) -> Html m
section options =
    styled Html.section
        (cs "mdc-toolbar__section"
            :: options
        )


alignStart : Property m
alignStart =
    cs "mdc-toolbar__section--align-start"


alignEnd : Property m
alignEnd =
    cs "mdc-toolbar__section--align-end"


shrinkToFit : Property m
shrinkToFit =
    cs "mdc-toolbar__section--shrink-to-fit"


menuIcon : Icon.Property m
menuIcon =
    cs "mdc-toolbar__menu-icon"


title : List (Property m) -> List (Html m) -> Html m
title options =
    styled Html.span
        (cs "mdc-toolbar__title"
            :: options
        )


icon : Icon.Property m
icon =
    cs "mdc-toolbar__icon"


iconToggle : IconToggle.Property m
iconToggle =
    cs "mdc-toolbar__icon"


fixedAdjust : Index -> Store s -> Options.Property c m
fixedAdjust index store =
    let
        model =
            Dict.get index store.toolbar
                |> Maybe.withDefault defaultModel

        styles =
            Maybe.map2 (,) model.config model.calculations
                |> Maybe.andThen
                    (\( config, calculations ) ->
                        adjustElementStyles config calculations
                    )
    in
    Options.many
        [ cs "mdc-toolbar-fixed-adjust"
        , Maybe.withDefault nop styles
        ]
