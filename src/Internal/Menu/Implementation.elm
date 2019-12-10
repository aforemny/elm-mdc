module Internal.Menu.Implementation exposing
    ( Corner
    , Item(..)
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
    , selected
    , disabled
    , selectionGroup
    , selectionGroupIcon
    , subs
    , subscriptions
    , surfaceAnchor
    , text
    , topEndCorner
    , topLeftCorner
    , topRightCorner
    , topStartCorner
    , ul
    , update
    , view
    )

import Array exposing (Array)
import Browser.Dom
import Browser.Events
import DOM
import Html exposing (Html, div, span)
import Html.Attributes as Html
import Html.Events as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.GlobalEvents as GlobalEvents
import Internal.Helpers as Helpers
import Internal.Keyboard as Keyboard exposing (Key, KeyCode, Meta, decodeMeta, decodeKey, decodeKeyCode)
import Internal.List.Implementation as Lists
import Internal.List.Model as Lists
import Internal.Menu.Model exposing (Geometry, Model, Msg(..), Viewport, defaultGeometry, defaultModel)
import Internal.Msg
import Internal.Options as Options exposing (aria, cs, css, role, styled, tabindex, when)
import Json.Decode as Decode exposing (Decoder)
import Task


subscriptions : Model -> Sub (Msg m)
subscriptions model =
    -- Note: Clicking to open a Menu immediately triggers a click on document.
    -- To prevent the Menu from closing immediately, we ignore Document clicks
    -- in the first animation frame after Open by watching model.geometry.
    --
    -- Note: It seems that there is a bug with dynamic subscriptions. Setting
    -- this conditionally does not fire `DocumentClick` reliably.
    --
    -- > if model.open && (model.geometry /= Nothing) then
    -- >     …
    -- > else
    -- >     Sub.none
    Browser.Events.onClick (Decode.succeed DocumentClick)


type Item m
    = ListItem ( List (Lists.Property m) ) ( List (Html m) )
    | Divider ( List (Lists.Property m) ) ( List (Html m) )
    | Group ( List (Lists.Property m) ) ( List (Item m) )


li : List (Lists.Property m) -> List (Html m) -> Item m
li options children =
    ListItem ( role "menuitem" :: options ) children


divider : List (Lists.Property m) -> List (Html m) -> Item m
divider options children =
    Divider options children


selectionGroup : List (Lists.Property m) -> List (Item m) -> Item m
selectionGroup options children =
    Group options children


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
            if not model.open then
                ( Just
                    { model
                        | open = True
                        , animating = True
                        , geometry = Nothing
                    }
                , Cmd.none
                )

            else
                ( Nothing, Cmd.none )

        Close ->
            if model.open then
                ( Just
                    { model
                        | open = False
                        , animating = True
                    }
                , if Maybe.withDefault False model.quickOpen then
                    Helpers.delayedCmd 70 (lift AnimationEnd)

                  else
                    Helpers.delayedCmd 0 (lift AnimationEnd)
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
                }
            , Cmd.batch
                [ Task.attempt (\_ -> lift NoOp) (Browser.Dom.focus config.focusedItemId)
                , if config.quickOpen then
                    Helpers.delayedCmd 120 (lift AnimationEnd)

                  else
                    Helpers.delayedCmd 0 (lift AnimationEnd)
                ]
            )

        AnimationEnd ->
            ( Just { model | animating = False }, Cmd.none )

        DocumentClick ->
            -- Note: See the second note at the definition of `subscriptions`
            if model.open && (model.geometry /= Nothing) then
                update lift Close model

            else
                ( Nothing, Cmd.none )

        KeyDown { shiftKey, altKey, ctrlKey, metaKey } key keyCode ->
            let
                isEscape =
                    key == "Escape" || keyCode == 27

                isSpace =
                    key == "Space" || keyCode == 32

                isEnter =
                    key == "Enter" || keyCode == 13
            in
            if isEscape || isSpace || isEnter then
                ( Just { model | keyDownWithinMenu = True }, Cmd.none )

            else
                ( Nothing, Cmd.none )

        KeyUp { shiftKey, altKey, ctrlKey, metaKey } key keyCode ->
            let
                isEscape =
                    key == "Escape" || keyCode == 27

                isSpace =
                    key == "Space" || keyCode == 32

                isEnter =
                    key == "Enter" || keyCode == 13
            in
            (if
                (isEscape || isSpace || isEnter)
                    && not (altKey || ctrlKey || metaKey)
                    && model.keyDownWithinMenu
             then
                update lift Close model

             else
                ( Nothing, Cmd.none )
            )
                |> Tuple.mapFirst
                    (Maybe.map (\newModel -> { newModel | keyDownWithinMenu = False }))

        ListMsg msg_ ->
            Lists.update (lift << ListMsg) msg_ model.list
                |> Tuple.mapFirst
                    (\maybeNewList ->
                        case maybeNewList of
                            Just newList ->
                                Just { model | list = newList }

                            Nothing ->
                                Nothing
                    )


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


surfaceAnchor : Options.Property c m
surfaceAnchor =
    cs "mdc-menu-surface--anchor"


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
    Component.Index
    -> (Msg m -> m)
    -> Model
    -> List (Property m)
    -> Menu m
    -> Html m
menu domId lift model options ulNode =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        geometry =
            Maybe.withDefault defaultGeometry model.geometry

        { position, transformOrigin, maxHeight } =
            autoPosition config geometry

        listId =
            domId ++ "__list"
    in
    Options.apply summary
        div
        [ cs "mdc-menu mdc-menu-surface"
        , when (model.animating && not config.quickOpen) <|
            if model.open then
                cs "mdc-menu-surface--animating-open"
            else
                cs "mdc-menu-surface--animating-closed"

        , -- Note: .mdc-menu--open has to be added one frame after
          -- .mdc-menu-surface--animating-open has been set, except when
          -- quickly opening:
          when (model.open && (model.geometry /= Nothing || config.quickOpen)) <|
            Options.many <|
                [ cs "mdc-menu-surface--open"
                , Options.onWithOptions "click"
                    (Decode.succeed
                        { message = lift CloseDelayed
                        , stopPropagation = True
                        , preventDefault = False
                        }
                    )
                ]
        , when ((model.open || model.animating) && (model.geometry /= Nothing))
            << Options.many
          <|
            [ css "transform-origin" transformOrigin
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
        , when ((model.open || model.animating) && (model.geometry == Nothing)) <|
            GlobalEvents.onTickWith
                { targetRect = False
                , parentRect = True
                }
            <|
                Decode.map
                    (lift
                        << Init
                            { quickOpen = config.quickOpen
                            , index = config.index
                            , focusedItemId =
                                listId
                                    ++ "--"
                                    ++ String.fromInt (Maybe.withDefault 0 config.index)
                            }
                    )
                    decodeGeometry
        , Options.on "keyup" <|
            Decode.map lift <|
                Decode.map3 KeyUp decodeMeta decodeKey decodeKeyCode
        , Options.on "keydown" <|
            Decode.map lift <|
                Decode.map3 KeyDown decodeMeta decodeKey decodeKeyCode
        ]
        []
        [ Lists.ul listId
            (lift << ListMsg)
            model.list
            (ulNode.options
                ++ [ role "menu"
                   , aria "hidden" "true"
                   , aria "orientation" "vertical"
                   , tabindex -1
                   ]
            )
            ( toListItem ulNode.items )
        ]


toListItem :
    List (Item m)
    -> List (Lists.ListItem m)
toListItem items =
    List.indexedMap
        (\i item ->
             case item of
                 Divider options children ->
                     Lists.divider options children
                 ListItem options children ->
                     Lists.li
                         options children
                 Group options children ->
                     Lists.nestedUl selectionGroupView options (toListItem children)
        )
        items


selectionGroupView :
    Index
    -> (Lists.Msg m -> m)
    -> Lists.Model
    -> Lists.Config m
    -> Array String
    -> Int
    -> Int
    -> List (Lists.Property m)
    -> List (Html m)
    -> Html m
selectionGroupView domId lift model config listItemIds focusedIndex an_index options children =
    let
        summary =
            Options.collect Lists.defaultConfig options
    in
    Options.apply summary
        (Maybe.withDefault Html.div summary.config.node)
        [ cs "mdc-menu__selection-group" ]
        []
        children




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
                geometry.viewportDistance.top
                    + geometry.anchor.height
                    + config.anchorMargin.bottom

            else
                geometry.viewportDistance.top + config.anchorMargin.top

        availableBottom =
            if isBottomAligned then
                geometry.viewportDistance.bottom - config.anchorMargin.bottom

            else
                geometry.viewportDistance.bottom
                    + geometry.anchor.height
                    + config.anchorMargin.top

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
                geometry.viewportDistance.left
                    + geometry.anchor.width
                    + config.anchorMargin.right

            else
                geometry.viewportDistance.left + config.anchorMargin.left

        availableRight =
            if isAlignedRight then
                geometry.viewportDistance.right - config.anchorMargin.right

            else
                geometry.viewportDistance.right
                    + geometry.anchor.width
                    - config.anchorMargin.left

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
        if
            canOverlapVertically
                && (geometry.menu.height
                        > geometry.viewportDistance.top
                        + geometry.anchor.height
                   )
        then
            -(min geometry.menu.height (geometry.viewport.height - marginToEdge)
                - (geometry.viewportDistance.top + geometry.anchor.height)
             )

        else if avoidVerticalOverlap then
            geometry.anchor.height - config.anchorMargin.top

        else
            -config.anchorMargin.bottom

    else if
        canOverlapVertically
            && (geometry.menu.height
                    > geometry.viewportDistance.bottom
                    + geometry.anchor.height
               )
    then
        -(min geometry.menu.height (geometry.viewport.height - marginToEdge)
            - (geometry.viewportDistance.top + geometry.anchor.height)
         )

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
            if
                not config.anchorCorner.bottom
                    && (abs (verticalOffset_ / geometry.menu.height) > 0.1)
            then
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
    { transformOrigin = horizontalAlignment_ ++ " " ++ verticalAlignment_
    , position = position
    , maxHeight =
        if maxMenuHeight /= 0 then
            String.fromFloat maxMenuHeight ++ "px"

        else
            "auto"
    }


type alias Store s =
    { s | menu : Indexed Model }


getSet :
    { get : Index -> { a | menu : Indexed Model } -> Model
    , set :
        Index
        -> { a | menu : Indexed Model }
        -> Model
        -> { a | menu : Indexed Model }
    }
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
    \lift domId ->
        Component.render getSet.get (menu domId) Internal.Msg.MenuMsg lift domId


subs : (Internal.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Component.subs Internal.Msg.MenuMsg .menu subscriptions


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
                , right =
                    decodedViewport.width
                        - decodedAnchorRect.left
                        - decodedAnchorRect.width
                , left = decodedAnchorRect.left
                , bottom =
                    decodedViewport.height
                        - decodedAnchorRect.top
                        - decodedAnchorRect.height
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


selected : Lists.Property m
selected =
    cs "mdc-menu-item--selected"


disabled : Lists.Property m
disabled =
    Options.many [ cs "mdc-list-item--disabled", aria "disabled" "true" ]


graphic : Lists.Property m
graphic =
    cs "mdc-list-item__graphic"


text : List (Lists.Property m) -> List (Html m) -> Html m
text options nodes =
    styled span ( cs "mdc-list-item__text" :: options ) nodes


selectionGroupIcon : List (Lists.Property m) -> List (Html m) -> Html m
selectionGroupIcon options nodes =
    styled span ( graphic :: cs "mdc-menu__selection-group-icon" :: options ) nodes

