module Internal.Menu.Implementation
    exposing
        ( Corner
        , Item
        , Margin
        , Menu
        , Property
        , anchorCorner
        , anchorMargin
        , attach
        , bottomEndCorner
        , bottomLeftCorner
        , bottomRightCorner
        , bottomStartCorner
        , connect
        , divider
        , index
        , li
        , menu
        , onSelect
        , quickOpen
        , react
        , subs
        , subscriptions
        , topEndCorner
        , topLeftCorner
        , topRightCorner
        , topStartCorner
        , ul
        , update
        , view
        )

import Browser
import Browser.Events
import DOM
import Html exposing (Html, text)
import Html.Attributes as Html
import Html.Events as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Dispatch as Dispatch
import Internal.GlobalEvents as GlobalEvents
import Internal.Helpers as Helpers
import Internal.List.Implementation as Lists
import Internal.Menu.Model exposing (Geometry, Key, KeyCode, Meta, Model, Msg(..), Viewport, defaultGeometry, defaultModel)
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Json.Decode as Decode exposing (Decoder)


subscriptions : Model -> Sub (Msg m)
subscriptions model =
    -- Note: Clicking to open a Menu immediately triggers a click on document.
    -- To prevent the Menu from closing immediately, we ignore Document clicks
    -- in the first animation frame after Open by watching model.geometry.
    if model.open && (model.geometry /= Nothing) then
        Browser.Events.onClick (Decode.succeed DocumentClick)
    else
        Sub.none


type alias Item m =
    { options : List (Lists.Property m)
    , childs : List (Html m)
    , divider : Bool
    }


li : List (Lists.Property m) -> List (Html m) -> Item m
li options childs =
    { options = options, childs = childs, divider = False }


divider : List (Lists.Property m) -> List (Html m) -> Item m
divider options childs =
    { options = options, childs = childs, divider = True }


type alias Menu m =
    { options : List (Lists.Property m)
    , items : List (Item m)
    }


ul : List (Lists.Property m) -> List (Item m) -> Menu m
ul options items =
    { options = options, items = items }


attach : (Internal.Msg.Msg m -> m) -> Index -> Options.Property c m
attach lift idx =
    Options.onClick (lift (Internal.Msg.MenuMsg idx Toggle))


connect : (Internal.Menu.Model.Msg m -> m) -> Options.Property c m
connect lift =
    Options.onClick (lift Toggle)


update : (Msg msg -> msg) -> Msg msg -> Model -> ( Maybe Model, Cmd msg )
update lift msg model =
    case msg of
        NoOp ->
            ( Nothing, Cmd.none )

        Toggle ->
            update lift
                (if model.open then
                    Close
                 else
                    Open
                )
                model

        Open ->
            let
                doQuickOpen =
                    Maybe.withDefault False model.quickOpen
            in
            if not model.open then
                ( Just
                    { model
                        | open = True
                        , animating = True
                        , geometry = Nothing
                    }
                , if not doQuickOpen then
                    Helpers.delayedCmd 120 (lift AnimationEnd)
                  else
                    Helpers.cmd (lift AnimationEnd)
                )
            else
                ( Nothing, Cmd.none )

        Close ->
            let
                doQuickOpen =
                    Maybe.withDefault False model.quickOpen
            in
            if model.open then
                ( Just
                    { model
                        | open = False
                        , animating = True
                        , quickOpen = Nothing
                        , focusedItemAtIndex = Nothing
                    }
                , if not doQuickOpen then
                    Helpers.delayedCmd 70 (lift AnimationEnd)
                  else
                    Helpers.cmd (lift AnimationEnd)
                )
            else
                ( Nothing, Cmd.none )

        CloseDelayed ->
            ( Nothing, Helpers.delayedCmd 50 (lift Close) )

        Init config geometry ->
            ( Just
                { model
                    | geometry = Just geometry
                    , quickOpen = Just config.quickOpen
                    , focusedItemAtIndex = config.index
                }
            , Cmd.none
            )

        AnimationEnd ->
            ( Just { model | animating = False }, Cmd.none )

        DocumentClick ->
            update lift Close model

        KeyDown numItems { shiftKey, altKey, ctrlKey, metaKey } key keyCode ->
            let
                isTab =
                    key == "Tab" || keyCode == 9

                isArrowUp =
                    key == "ArrowUp" || keyCode == 38

                isArrowDown =
                    key == "ArrowDown" || keyCode == 40

                isSpace =
                    key == "Space" || keyCode == 32

                isEnter =
                    key == "Enter" || keyCode == 13

                lastItemIndex =
                    numItems - 1

                keyDownWithinMenu =
                    isEnter || isSpace

                focusedItemIndex =
                    model.focusedItemAtIndex
                        |> Maybe.withDefault 0
            in
            (if altKey || ctrlKey || metaKey then
                ( Nothing, Cmd.none )
             else if isArrowUp then
                ( Just <|
                    if focusedItemIndex == 0 then
                        { model | focusedItemAtIndex = Just lastItemIndex }
                    else
                        { model | focusedItemAtIndex = Just (focusedItemIndex - 1) }
                , Cmd.none
                )
             else if isArrowDown then
                ( Just <|
                    if focusedItemIndex == lastItemIndex then
                        { model | focusedItemAtIndex = Just 0 }
                    else
                        { model | focusedItemAtIndex = Just (focusedItemIndex + 1) }
                , Cmd.none
                )
             else if isSpace || isEnter then
                ( Just model, Cmd.none )
             else
                ( Nothing, Cmd.none )
            )
                |> Tuple.mapFirst
                    (Maybe.map
                        (\updatedModel ->
                            { updatedModel | keyDownWithinMenu = keyDownWithinMenu }
                        )
                    )

        KeyUp { shiftKey, altKey, ctrlKey, metaKey } key keyCode ->
            let
                isEscape =
                    key == "Escape" || keyCode == 27

                isSpace =
                    key == "Space" || keyCode == 32

                isEnter =
                    key == "Enter" || keyCode == 13
            in
            (if altKey || ctrlKey || metaKey then
                ( Nothing, Cmd.none )
             else if isEscape || ((isSpace || isEnter) && model.keyDownWithinMenu) then
                update lift Close model
             else
                ( Nothing, Cmd.none )
            )
                |> Tuple.mapFirst
                    (Maybe.map
                        (\updatedModel ->
                            if (isEnter || isSpace) && updatedModel.keyDownWithinMenu then
                                { updatedModel | keyDownWithinMenu = False }
                            else
                                updatedModel
                        )
                    )

        SetFocus focusedItemAtIndex ->
            ( Just { model | focusedItemAtIndex = Just focusedItemAtIndex }, Cmd.none )


type alias Config =
    { index : Maybe Int
    , open : Bool
    , anchorCorner : Corner
    , anchorMargin : Margin
    , quickOpen : Bool
    }


defaultConfig : Config
defaultConfig =
    { index = Nothing
    , open = False
    , anchorCorner = topLeftCorner
    , anchorMargin = defaultMargin
    , quickOpen = False
    }


type alias Margin =
    { top : Float
    , left : Float
    , bottom : Float
    , right : Float
    }


defaultMargin : Margin
defaultMargin =
    { top = 0
    , left = 0
    , bottom = 0
    , right = 0
    }


type alias Property m =
    Options.Property Config m


index : Int -> Property m
index value =
    Options.option (\config -> { config | index = Just value })


anchorCorner : Corner -> Property m
anchorCorner value =
    Options.option (\config -> { config | anchorCorner = value })


anchorMargin : Margin -> Property m
anchorMargin value =
    Options.option (\config -> { config | anchorMargin = value })


quickOpen : Property m
quickOpen =
    Options.option (\config -> { config | quickOpen = True })


menu :
    (Msg m -> m)
    -> Model
    -> List (Property m)
    -> Menu m
    -> Html m
menu lift model options ulNode =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        geometry =
            Maybe.withDefault defaultGeometry model.geometry

        { position, transformOrigin, maxHeight } =
            autoPosition config geometry

        -- Note: .mdc-menu--open has to be added one frame after
        -- .mdc-menu--animating-open has been set:
        isOpen =
            if model.animating then
                model.open && (model.geometry /= Nothing)
            else
                model.open

        focusedItemAtIndex =
            model.focusedItemAtIndex

        numDividersBeforeIndex i =
            ulNode.items
                |> List.take (i + 1)
                |> List.filter .divider
                |> List.length

        numItems =
            ulNode.items
                |> List.filter (not << .divider)
                |> List.length

        preventDefaultOnKeyDown { altKey, ctrlKey, metaKey, shiftKey } key keyCode =
            let
                isTab =
                    key == "Tab" || keyCode == 9

                isArrowUp =
                    key == "ArrowUp" || keyCode == 38

                isArrowDown =
                    key == "ArrowDown" || keyCode == 40

                isSpace =
                    key == "Space" || keyCode == 32

                lastItemIndex =
                    numItems - 1
            in
            if altKey || ctrlKey || metaKey then
                Decode.fail ""
            else if
                shiftKey
                    && isTab
                    && (Maybe.withDefault 0 focusedItemAtIndex == lastItemIndex)
            then
                Decode.succeed (lift NoOp)
            else if isArrowUp || isArrowDown || isSpace then
                Decode.succeed (lift NoOp)
            else
                Decode.fail ""
    in
    Options.apply summary
        Html.div
        [ cs "mdc-menu"
        , when (model.animating && not (Maybe.withDefault False model.quickOpen)) <|
            if model.open then
                cs "mdc-menu--animating-open"
            else
                cs "mdc-menu--animating-closed"
        , when isOpen
            << Options.many
          <|
            [ cs "mdc-menu--open"
            , Options.data "focustrap" ""
            , Options.onWithOptions "click"
                (Decode.succeed
                    { message = lift CloseDelayed
                    , stopPropagation = True
                    , preventDefault = False
                    }
                )
            ]
        , when (isOpen || model.animating)
            << Options.many
          <|
            [ css "position" "absolute"
            , css "transform-origin" transformOrigin
            , css "top" (Maybe.withDefault "" position.top)
                |> when (position.top /= Nothing)
            , css "left" (Maybe.withDefault "" position.left)
                |> when (position.left /= Nothing)
            , css "bottom" (Maybe.withDefault "" position.bottom)
                |> when (position.bottom /= Nothing)
            , css "right" (Maybe.withDefault "" position.right)
                |> when (position.right /= Nothing)
            , css "max-height" maxHeight
            ]
        , when (model.animating && model.geometry == Nothing) <|
            GlobalEvents.onTickWith
                { targetRect = False
                , parentRect = True
                }
            <|
                Decode.map (lift << Init { quickOpen = config.quickOpen, index = config.index })
                    decodeGeometry
        , Options.on "keyup" <|
            Decode.map lift <|
                Decode.map3 KeyUp decodeMeta decodeKey decodeKeyCode
        , Options.on "keydown" <|
            Decode.map lift <|
                Decode.map3 (KeyDown numItems) decodeMeta decodeKey decodeKeyCode
        ]
        []
        [ Lists.ul
            (cs "mdc-menu__items"
                -- TODO:
                --            :: Options.onWithOptions "keydown"
                --            { stopPropagation = False, preventDefault = True }
                --            (Decode.map3 preventDefaultOnKeyDown decodeMeta decodeKey decodeKeyCode
                --            |> Decode.andThen identity
                --            )
                :: ulNode.options
            )
            (List.indexedMap
                (\i item ->
                    let
                        focusIndex =
                            i - numDividersBeforeIndex i

                        hasFocus =
                            Just focusIndex == focusedItemAtIndex

                        autoFocus =
                            if hasFocus && model.open then
                                Options.data "autofocus" ""
                            else
                                Options.nop

                        itemSummary =
                            -- TODO:
                            Options.collect Lists.defaultConfig item.options

                        --                                |> (\freshItemSummary ->
                        --                                        if not model.keyDownWithinMenu then
                        --                                            let
                        --                                                dispatch =
                        --                                                    freshItemSummary.dispatch
                        --                                                        |> (\(Dispatch.Config ({ decoders } as dispatch)) ->
                        --                                                                Dispatch.Config
                        --                                                                    { dispatch
                        --                                                                        | decoders =
                        --                                                                            List.filter ((/=) "keyup" << Tuple.first)
                        --                                                                                decoders
                        --                                                                    }
                        --                                                           )
                        --                                            in
                        --                                            { freshItemSummary | dispatch = dispatch }
                        --                                        else
                        --                                            freshItemSummary
                        --                                   )
                    in
                    if item.divider then
                        Options.apply itemSummary
                            Html.hr
                            [ cs "mdc-list-divider"
                            ]
                            []
                            item.childs
                    else
                        Options.apply itemSummary
                            Html.li
                            [ cs "mdc-list-item"
                            , Options.attribute (Html.attribute "tabindex" "0")
                            , Options.on "focus" (Decode.succeed (lift (SetFocus focusIndex)))
                            , autoFocus
                            ]
                            []
                            item.childs
                )
                ulNode.items
            )
        ]


type alias Corner =
    { bottom : Bool
    , center : Bool
    , right : Bool
    , flipRtl : Bool
    }


topLeftCorner : Corner
topLeftCorner =
    { bottom = False
    , center = False
    , right = False
    , flipRtl = False
    }


topRightCorner : Corner
topRightCorner =
    { bottom = False
    , center = False
    , right = True
    , flipRtl = False
    }


bottomLeftCorner : Corner
bottomLeftCorner =
    { bottom = True
    , center = False
    , right = False
    , flipRtl = False
    }


bottomRightCorner : Corner
bottomRightCorner =
    { bottom = True
    , center = False
    , right = True
    , flipRtl = False
    }


topStartCorner : Corner
topStartCorner =
    { bottom = False
    , center = False
    , right = False
    , flipRtl = True
    }


topEndCorner : Corner
topEndCorner =
    { bottom = False
    , center = False
    , right = True
    , flipRtl = True
    }


bottomStartCorner : Corner
bottomStartCorner =
    { bottom = True
    , center = False
    , right = False
    , flipRtl = True
    }


bottomEndCorner : Corner
bottomEndCorner =
    { bottom = True
    , center = False
    , right = True
    , flipRtl = True
    }


originCorner : Config -> Geometry -> Corner
originCorner config geometry =
    let
        isBottomAligned =
            config.anchorCorner.bottom

        availableTop =
            if isBottomAligned then
                geometry.viewportDistance.top + geometry.anchor.height + config.anchorMargin.bottom
            else
                geometry.viewportDistance.top + config.anchorMargin.top

        availableBottom =
            if isBottomAligned then
                geometry.viewportDistance.bottom - config.anchorMargin.bottom
            else
                geometry.viewportDistance.bottom + geometry.anchor.height + config.anchorMargin.top

        topOverflow =
            geometry.menu.height - availableTop

        bottomOverflow =
            geometry.menu.height - availableBottom

        bottom =
            (bottomOverflow > 0) && (topOverflow < bottomOverflow)

        -- TODO:
        isRtl =
            False

        isFlipRtl =
            config.anchorCorner.flipRtl

        avoidHorizontalOverlap =
            config.anchorCorner.right

        isAlignedRight =
            (avoidHorizontalOverlap && not isRtl)
                || (not avoidHorizontalOverlap && isFlipRtl && isRtl)

        availableLeft =
            if isAlignedRight then
                geometry.viewportDistance.left + geometry.anchor.width + config.anchorMargin.right
            else
                geometry.viewportDistance.left + config.anchorMargin.left

        availableRight =
            if isAlignedRight then
                geometry.viewportDistance.right - config.anchorMargin.right
            else
                geometry.viewportDistance.right + geometry.anchor.width - config.anchorMargin.left

        leftOverflow =
            geometry.menu.width - availableLeft

        rightOverflow =
            geometry.menu.width - availableRight

        right =
            ((leftOverflow < 0) && isAlignedRight && isRtl)
                || (avoidHorizontalOverlap && not isAlignedRight && (leftOverflow < 0))
                || ((rightOverflow > 0) && (leftOverflow < rightOverflow))

        flipRtl =
            False

        center =
            False
    in
    { bottom = bottom
    , center = center
    , right = right
    , flipRtl = flipRtl
    }


horizontalOffset : Config -> Corner -> Geometry -> Float
horizontalOffset config corner geometry =
    let
        isRightAligned =
            corner.right

        avoidHorizontalOverlap =
            config.anchorCorner.right
    in
    if isRightAligned then
        if avoidHorizontalOverlap then
            geometry.anchor.width - config.anchorMargin.left
        else
            config.anchorMargin.right
    else if avoidHorizontalOverlap then
        geometry.anchor.width - config.anchorMargin.right
    else
        config.anchorMargin.left


verticalOffset : Config -> Corner -> Geometry -> Float
verticalOffset config corner geometry =
    let
        isBottomAligned =
            corner.bottom

        marginToEdge =
            32

        avoidVerticalOverlap =
            config.anchorCorner.bottom

        canOverlapVertically =
            not avoidVerticalOverlap
    in
    if isBottomAligned then
        if canOverlapVertically && (geometry.menu.height > geometry.viewportDistance.top + geometry.anchor.height) then
            -(min geometry.menu.height (geometry.viewport.height - marginToEdge) - (geometry.viewportDistance.top + geometry.anchor.height))
        else if avoidVerticalOverlap then
            geometry.anchor.height - config.anchorMargin.top
        else
            -config.anchorMargin.bottom
    else if canOverlapVertically && (geometry.menu.height > geometry.viewportDistance.bottom + geometry.anchor.height) then
        -(min geometry.menu.height (geometry.viewport.height - marginToEdge) - (geometry.viewportDistance.top + geometry.anchor.height))
    else if avoidVerticalOverlap then
        geometry.anchor.height + config.anchorMargin.bottom
    else
        config.anchorMargin.top


menuMaxHeight : Config -> Corner -> Geometry -> Float
menuMaxHeight config corner geometry =
    let
        isBottomAligned =
            corner.bottom
    in
    if config.anchorCorner.bottom then
        if isBottomAligned then
            geometry.viewportDistance.top + config.anchorMargin.top
        else
            geometry.viewportDistance.bottom - config.anchorMargin.bottom
    else
        0


autoPosition :
    Config
    -> Geometry
    ->
        { transformOrigin : String
        , position :
            { top : Maybe String
            , left : Maybe String
            , bottom : Maybe String
            , right : Maybe String
            }
        , maxHeight : String
        }
autoPosition config geometry =
    let
        corner =
            originCorner config geometry

        maxMenuHeight =
            menuMaxHeight config corner geometry

        verticalAlignment =
            if corner.bottom then
                "bottom"
            else
                "top"

        horizontalAlignment =
            if corner.right then
                "right"
            else
                "left"

        horizontalOffset_ =
            horizontalOffset config corner geometry

        verticalOffset_ =
            verticalOffset config corner geometry

        position =
            { top =
                if verticalAlignment == "top" then
                    Just (String.fromFloat verticalOffset_ ++ "px")
                else
                    Nothing
            , left =
                if horizontalAlignment == "left" then
                    Just (String.fromFloat horizontalOffset_ ++ "px")
                else
                    Nothing
            , bottom =
                if verticalAlignment == "bottom" then
                    Just (String.fromFloat verticalOffset_ ++ "px")
                else
                    Nothing
            , right =
                if horizontalAlignment == "right" then
                    Just (String.fromFloat horizontalOffset_ ++ "px")
                else
                    Nothing
            }

        horizontalAlignment_ =
            if (geometry.anchor.width / geometry.menu.width) > 0.67 then
                "center"
            else
                horizontalAlignment

        verticalAlignment_ =
            if not config.anchorCorner.bottom && (abs (verticalOffset_ / geometry.menu.height) > 0.1) then
                let
                    verticalOffsetPercent =
                        abs (verticalOffset_ / geometry.menu.height) * 100

                    originPercent =
                        if corner.bottom then
                            100 - verticalOffsetPercent
                        else
                            verticalOffsetPercent
                in
                String.fromFloat (toFloat (round (originPercent * 100)) / 100) ++ "%"
            else
                verticalAlignment
    in
    { transformOrigin = horizontalAlignment_ ++ " " ++ verticalAlignment
    , position = position
    , maxHeight =
        if maxMenuHeight /= 0 then
            String.fromFloat maxMenuHeight ++ "px"
        else
            ""
    }


type alias Store s =
    { s | menu : Indexed Model }


getSet =
    Component.indexed .menu (\x y -> { y | menu = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.MenuMsg update


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> Menu m
    -> Html m
view =
    Component.render getSet.get menu Internal.Msg.MenuMsg


subs : (Internal.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Component.subs Internal.Msg.MenuMsg .menu subscriptions


decodeMeta : Decoder Meta
decodeMeta =
    Decode.map4
        (\altKey ctrlKey metaKey shiftKey ->
            { altKey = altKey
            , ctrlKey = ctrlKey
            , metaKey = metaKey
            , shiftKey = shiftKey
            }
        )
        (Decode.at [ "altKey" ] Decode.bool)
        (Decode.at [ "ctrlKey" ] Decode.bool)
        (Decode.at [ "metaKey" ] Decode.bool)
        (Decode.at [ "shiftKey" ] Decode.bool)


decodeKey : Decoder Key
decodeKey =
    Decode.at [ "key" ] Decode.string


decodeKeyCode : Decoder KeyCode
decodeKeyCode =
    Html.keyCode


decodeGeometry : Decoder Geometry
decodeGeometry =
    let
        anchorRect =
            Decode.at [ "parentRect" ] <|
                Decode.map4
                    (\top left width height ->
                        { top = top
                        , left = left
                        , width = width
                        , height = height
                        }
                    )
                    (Decode.at [ "top" ] Decode.float)
                    (Decode.at [ "left" ] Decode.float)
                    (Decode.at [ "width" ] Decode.float)
                    (Decode.at [ "height" ] Decode.float)

        decodeViewport =
            DOM.target <|
                Decode.at [ "ownerDocument", "defaultView" ] <|
                    Decode.map2 Viewport
                        (Decode.at [ "innerWidth" ] Decode.float)
                        (Decode.at [ "innerHeight" ] Decode.float)

        decodeViewportDistance decodedViewport decodedAnchorRect =
            Decode.succeed
                { top = decodedAnchorRect.top
                , right = decodedViewport.width - decodedAnchorRect.left - decodedAnchorRect.width
                , left = decodedAnchorRect.left
                , bottom = decodedViewport.height - decodedAnchorRect.top - decodedAnchorRect.height
                }

        anchor { width, height } =
            Decode.succeed { width = width, height = height }

        decodeMenu =
            Decode.map2
                (\offsetWidth offsetHeight ->
                    { width = offsetWidth, height = offsetHeight }
                )
                DOM.offsetWidth
                DOM.offsetHeight
    in
    Decode.map2 (\x y -> ( x, y )) decodeViewport anchorRect
        |> Decode.andThen
            (\( decodedViewport, decodedeAnchorRect ) ->
                DOM.target <|
                    Decode.map3 (Geometry decodedViewport)
                        (decodeViewportDistance decodedViewport decodedeAnchorRect)
                        (anchor decodedeAnchorRect)
                        decodeMenu
            )


onSelect : m -> Lists.Property m
onSelect msg =
    let
        trigger key keyCode =
            let
                isSpace =
                    key == "Space" || keyCode == 32

                isEnter =
                    key == "Enter" || keyCode == 13
            in
            if isSpace || isEnter then
                Decode.succeed msg
            else
                Decode.fail ""
    in
    Options.many
        [ Options.onClick msg
        , Options.on "keyup"
            (Decode.map2 trigger decodeKey decodeKeyCode
                |> Decode.andThen identity
            )
        ]
