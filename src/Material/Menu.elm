module Material.Menu exposing (..)

import DOM
import GlobalEvents
import Html.Events as Html
import Html exposing (..)
import Json.Decode as Json exposing (Decoder)
import Material.Component as Component exposing (Indexed)
import Material.Helpers as Helpers exposing (map1st)
import Material.Internal.Menu exposing (Msg(..), KeyCode, Key, Meta, Geometry, defaultGeometry, Viewport)
import Material.Internal.Options as Internal
import Material.Msg exposing (Index) 
import Material.Options as Options exposing (cs, css, styled, when)
import Mouse
import Time


subscriptions : Model -> Sub (Msg m)
subscriptions model =
    Sub.batch
    [
      if model.open then
        Mouse.clicks (\ _ -> DocumentClick)
      else
        Sub.none
    ]


type alias Model =
    { index : Maybe Int
    , open : Bool
    , animating : Bool
    , geometry : Maybe Geometry
    , quickOpen : Maybe Bool
    }


defaultModel : Model
defaultModel =
    { index = Nothing
    , open = False
    , animating = False
    , geometry = Nothing
    , quickOpen = Nothing
    }


{-| TODO
-}
type alias Item c m =
    { node : List (Options.Property c m) -> List (Html m) -> Html m
    , options : List (Options.Property c m)
    , childs : List (Html m)
    }


{-| TODO
-}
li
    : (List (Options.Property c m) -> List (Html m) -> Html m)
    -> List (Options.Property c m)
    -> List (Html m)
    -> Item c m
li node options childs =
    { node = node, options = options, childs = childs }


{-| TODO
-}
ul
    : (List (Options.Property c m) -> List (Html m) -> Html m)
    -> List (Options.Property c m)
    -> List (Item c m)
    -> { node : (List (Options.Property c m) -> List (Html m) -> Html m)
       , options : List (Options.Property c m)
       , items : List (Item c m)
       }
ul node options items =
    { node = node, options = options, items = items }


attach : (Material.Msg.Msg m -> m) -> Index -> Options.Property c m
attach lift idx =
    Options.onClick (lift (Material.Msg.MenuMsg idx Toggle))


connect : (Material.Internal.Menu.Msg m -> m) -> Options.Property c m
connect lift =
    Options.onClick (lift Toggle)


update : (Msg msg -> msg) -> Msg msg -> Model -> ( Maybe Model, Cmd msg )
update lift msg model =
    case msg of

        NoOp ->
            ( Nothing, Cmd.none )

        Toggle ->
            update lift (if model.open then Close else Open) model

        Init { quickOpen } geometry ->
            ( Just
              { model
                | geometry = Just geometry
                , quickOpen = Just quickOpen
              }
            ,
              Cmd.none
            )

        AnimationEnd ->
            ( Just { model | animating = False }, Cmd.none )

        Open ->
            let
                quickOpen =
                    Maybe.withDefault False model.quickOpen
            in
            if not model.open then
                (
                  Just
                  { model
                    | open = True
                    , animating = True
                    , geometry = Nothing
                  }
                ,
                  if not quickOpen then
                      Helpers.delay (120*Time.millisecond) (lift AnimationEnd)
                  else
                      Helpers.cmd (lift AnimationEnd)
                )
            else
                ( Nothing, Cmd.none )

        Close ->
            let
                quickOpen =
                    Maybe.withDefault False model.quickOpen
            in
            if model.open then
                (
                  Just
                  { model
                    | open = False
                    , animating = True
                    , quickOpen = Nothing
                  }
                ,
                  if not quickOpen then
                      Helpers.delay (70*Time.millisecond) (lift AnimationEnd)
                  else
                      Helpers.cmd (lift AnimationEnd)
                )
            else
                ( Nothing, Cmd.none )

        CloseDelayed ->
            ( Nothing, Helpers.delay (50*Time.millisecond) (lift Close) )

        DocumentClick ->
            if model.open then
                update lift Close model
            else
                ( Nothing, Cmd.none )

        KeyDown { shiftKey, altKey, ctrlKey, metaKey } key keyCode ->
            let
                isTab =
                    key == "Tab" || keyCode == 9

                isArrowUp =
                    key == "ArrowUp" || keyCode == 38

                isArrowDown =
                    key == "ArrowDown" || keyCode == 40

                isSpace =
                    key == "Space" || keyCode == 32
            in
            if altKey || ctrlKey || metaKey then
                ( Nothing, Cmd.none )
            else
                -- TODO: focus handling
                ( Nothing, Cmd.none )

        KeyUp { shiftKey, altKey, ctrlKey, metaKey } key keyCode ->
            let
                isEnter =
                    key == "Enter" || keyCode == 13

                isSpace =
                    key == "Space" || keyCode == 32

                isEscape =
                    key == "Escape" || keyCode == 27
            in
            if altKey || ctrlKey || metaKey then
                ( Nothing, Cmd.none )
            else
                if isEnter || isSpace then
                    -- TODO: trigger selected
                    update lift Close model
                else
                    if isEscape then
                        update lift Close model
                    else
                        ( Nothing, Cmd.none )


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
index index =
    Internal.option (\config -> { config | index = Just index })


--open : Bool -> Property m
--open =
--    Internal.option (\ config -> { config | open = open })


anchorCorner : Corner -> Property m
anchorCorner anchorCorner =
    Internal.option (\ config -> { config | anchorCorner = anchorCorner })


anchorMargin : Margin -> Property m
anchorMargin anchorMargin =
    Internal.option (\ config -> { config | anchorMargin = anchorMargin })


quickOpen : Property m
quickOpen =
    Internal.option (\ config -> { config | quickOpen = True })


view
    : (Msg m -> m)
    -> Model
    -> List (Property m)
    -> { node : (List (Options.Property c m) -> List (Html m) -> Html m)
       , options : List (Options.Property c m)
       , items : List (Item c m)
       }
    -> Html m
view lift model options ul =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

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
    in
    Internal.apply summary
    div
    [ cs "mdc-menu"
    ,
      when (model.animating && not (Maybe.withDefault False model.quickOpen)) <|
      if model.open then
          cs "mdc-menu--animating-open"
      else
          cs "mdc-menu--animating-closed"
    ,
      when isOpen << Options.many <|
      [
        cs "mdc-menu--open" |> when isOpen
      , Options.onWithOptions
          "click" 
          { stopPropagation = True
          , preventDefault = False
          }
          (Json.succeed (lift (CloseDelayed)))
      ]
    ,
      when (isOpen || model.animating) << Options.many <|
      [
        css "position" "absolute"
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
    ,
      when (model.animating && model.geometry == Nothing) <|
      Options.many << List.map Options.attribute <|
      GlobalEvents.onTick <|
      Json.map (lift << Init { quickOpen = config.quickOpen }) decodeGeometry
    ]
    []
    [ ul.node (cs "mdc-menu__items" :: ul.options)
      ( List.indexedMap (\i item ->
             item.node item.options item.childs
           )
           ul.items
      )
    ]


type alias Corner
    = { bottom : Bool
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
originCorner { anchorCorner, anchorMargin } { viewportDistance, anchor, menu } =
    let
        isBottomAligned =
            anchorCorner.bottom

        availableTop =
            if isBottomAligned then
                viewportDistance.top + anchor.height + anchorMargin.bottom
            else
                viewportDistance.top + anchorMargin.top

        availableBottom =
            if isBottomAligned then
                viewportDistance.bottom - anchorMargin.bottom
            else
                viewportDistance.bottom + anchor.height + anchorMargin.top

        topOverflow =
            menu.height - availableTop

        bottomOverflow =
            menu.height - availableBottom

        bottom =
            (bottomOverflow > 0) && (topOverflow < bottomOverflow)

        isRtl =
            False -- TODO

        isFlipRtl =
            anchorCorner.flipRtl

        avoidHorizontalOverlap =
            anchorCorner.right

        isAlignedRight =
            (avoidHorizontalOverlap && not isRtl) ||
            (not avoidHorizontalOverlap && isFlipRtl && isRtl)

        availableLeft =
            if isAlignedRight then
                viewportDistance.left + anchor.width + anchorMargin.right
            else
                viewportDistance.left + anchorMargin.left

        availableRight =
            if isAlignedRight then
                viewportDistance.right - anchorMargin.right
            else
                viewportDistance.right + anchor.width - anchorMargin.left

        leftOverflow =
            menu.width - availableLeft

        rightOverflow =
            menu.width - availableRight

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
horizontalOffset { anchorCorner, anchorMargin } corner { anchor } =
    let
        isRightAligned =
            corner.right

        avoidHorizontalOverlap =
            anchorCorner.right
    in
    if isRightAligned then
        if avoidHorizontalOverlap then
            anchor.width - anchorMargin.left
        else
            anchorMargin.right
    else
        if avoidHorizontalOverlap then
            anchor.width - anchorMargin.right
        else
            anchorMargin.left


verticalOffset : Config -> Corner -> Geometry -> Float
verticalOffset { anchorCorner, anchorMargin } corner geometry =
    let
        { viewport
        , viewportDistance
        , anchor
        , menu
        } =
            geometry

        isBottomAligned =
            corner.bottom

        marginToEdge =
            32

        avoidVerticalOverlap =
            anchorCorner.bottom

        canOverlapVertically =
            not avoidVerticalOverlap
    in
    if isBottomAligned then
        if canOverlapVertically && (menu.height > viewportDistance.top + anchor.height) then
            -(min menu.height (viewport.height - marginToEdge) - (viewportDistance.top + anchor.height))
        else
            if avoidVerticalOverlap then
                anchor.height - anchorMargin.top
            else
                -anchorMargin.bottom
    else
        if canOverlapVertically && (menu.height > viewportDistance.bottom + anchor.height) then
            -(min menu.height (viewport.height - marginToEdge) - (viewportDistance.top + anchor.height))
            
        else
            if avoidVerticalOverlap then
                anchor.height + anchorMargin.bottom
            else
                anchorMargin.top


menuMaxHeight : Config -> Corner -> Geometry -> Float
menuMaxHeight { anchorCorner, anchorMargin } corner { viewportDistance } =
    let
        isBottomAligned =
            corner.bottom
    in
    if anchorCorner.bottom then
        if isBottomAligned then
            viewportDistance.top + anchorMargin.top
        else
            viewportDistance.bottom - anchorMargin.bottom
    else
        0


autoPosition
    : Config
    -> Geometry
    -> { transformOrigin : String
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
                if (verticalAlignment == "top") then
                    Just (toString verticalOffset_ ++ "px")
                else
                    Nothing
            , left =
                if (horizontalAlignment == "left") then
                    Just (toString horizontalOffset_ ++ "px")
                else
                    Nothing
            , bottom =
                if (verticalAlignment == "bottom") then
                    Just (toString verticalOffset_ ++ "px")
                else
                    Nothing
            , right =
                if (horizontalAlignment == "right") then
                    Just (toString horizontalOffset_ ++ "px")
                else
                    Nothing
            }

        { anchor, menu } =
            geometry

        horizontalAlignment_ =
            if (anchor.width / menu.width) > 0.67 then
                "center"
            else
                horizontalAlignment

        { anchorCorner } =
            config

        verticalAlignment_ =
            if (not anchorCorner.bottom) && (abs (verticalOffset_ / menu.height) > 0.1) then
                let
                    verticalOffsetPercent =
                        abs (verticalOffset_ / menu.height) * 100

                    originPercent =
                        if corner.bottom then
                            100 - verticalOffsetPercent
                        else
                            verticalOffsetPercent
                in
                toString (toFloat (round (originPercent * 100)) / 100) ++ "%"
            else
                verticalAlignment
    in
    { transformOrigin = horizontalAlignment_ ++ " " ++ verticalAlignment
    , position = position
    , maxHeight = if maxMenuHeight /= 0 then toString maxMenuHeight ++ "px" else ""
    }


type alias Store s =
    { s | menu : Indexed Model }


( get, set ) =
    Component.indexed .menu (\x y -> { y | menu = x }) defaultModel


react :
    (Material.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.MenuMsg update


render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> { items : List (Item c m)
       , node : List (Options.Property c m) -> List (Html m) -> Html m
       , options : List (Options.Property c m)
       }
    -> Html m
render =
    Component.render get view Material.Msg.MenuMsg


subs : (Material.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Component.subs Material.Msg.MenuMsg .menu subscriptions


decodeMeta : Decoder Meta
decodeMeta =
    Json.map4 (\altKey ctrlKey metaKey shiftKey ->
        { altKey = altKey
        , ctrlKey = ctrlKey
        , metaKey = metaKey
        , shiftKey = shiftKey
        }
    )
    (Json.at ["altKey"] Json.bool)
    (Json.at ["ctrlKey"] Json.bool)
    (Json.at ["metaKey"] Json.bool)
    (Json.at ["shiftKey"] Json.bool)


decodeKey : Decoder Key
decodeKey =
    Json.at ["key"] Json.string


decodeKeyCode : Decoder KeyCode
decodeKeyCode =
    Html.keyCode


decodeGeometry : Decoder Geometry
decodeGeometry =
    let
        anchorRect =
            DOM.parentElement DOM.boundingClientRect

        viewport =
            Json.at ["ownerDocument", "defaultView"] <|
            Json.map2 Viewport
              (Json.at ["innerWidth"] Json.float)
              (Json.at ["innerHeight"] Json.float)

        viewportDistance viewport anchorRect =
            Json.succeed
            { top = anchorRect.top
            , right = viewport.width - anchorRect.left - anchorRect.width
            , left = anchorRect.left
            , bottom = viewport.height - anchorRect.top - anchorRect.height
            }

        anchor { width, height } =
            Json.succeed { width = width, height = height }

        menu =
            Json.map2
              (\ offsetWidth offsetHeight ->
                  { width = offsetWidth, height = offsetHeight }
              )
              DOM.offsetWidth
              DOM.offsetHeight
    in
    DOM.target
    (
      Json.map2 (,) viewport anchorRect
      |> Json.andThen (\ ( viewport, anchorRect ) ->
           Json.map3 (Geometry viewport)
               (viewportDistance viewport anchorRect)
               (anchor anchorRect)
               menu
         )
    )


onSelect : m -> Property m
onSelect msg =
    Options.onClick msg
