module Material.Menu exposing (..)

import AnimationFrame
import DOM exposing (Rectangle)
import Html.Events as Html exposing (defaultOptions)
import Html exposing (..)
import Json.Decode as Json exposing (Decoder)
import Material.Component as Component exposing (Indexed)
import Material.Helpers as Helpers exposing (pure, map1st)
import Material.Internal.Menu exposing (Msg(..), KeyCode, Key, Meta, Geometry, defaultGeometry)
import Material.Internal.Options as Internal
import Material.Msg exposing (Index) 
import Material.Options as Options exposing (Style, cs, css, styled, styled_, when)
import Mouse
import String


subscriptions : Model -> Sub (Msg m)
subscriptions model =
    let
        transitionDurationMs =
            300 -- TODO: refactor `view'
    in
    Sub.batch
    [
      if model.open then
        Mouse.clicks Click
      else
        Sub.none
    , if model.animating then
        AnimationFrame.diffs (\dt -> Tick (dt / transitionDurationMs))
      else
        Sub.none
    ]


type alias Model =
    { index : Maybe Int
    , open : Bool
    , opening : Bool
    , geometry : Maybe Geometry
    , reconfigure : Bool
    , initialized : Bool

    -- animation:
    , animating : Bool
    , time : Float
    , startScaleX : Float
    , startScaleY : Float
    , scaleX : Float
    , scaleY : Float
    , invScaleX : Float
    , invScaleY : Float
    }


defaultModel : Model
defaultModel =
    { index = Nothing
    , open = False
    , geometry = Nothing
    , initialized = False
    , reconfigure = False
    , opening = False

    -- animation:
    , animating = False
    , time = 0
    , startScaleX = 0
    , startScaleY = 0
    , scaleX = 0
    , scaleY = 0
    , invScaleX = 1
    , invScaleY = 1
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
    Options.many
    [ Options.onClick (lift (Material.Msg.MenuMsg idx Toggle))
    ]


connect : (Material.Internal.Menu.Msg m -> m) -> Options.Property c m
connect lift =
    Options.many
    [ Options.onClick (lift Toggle)
    ]


update : (Msg msg -> msg) -> Msg msg -> Model -> ( Model, Cmd msg )
update fwd msg model =
    case msg of

        Toggle ->
            update fwd (if model.open then Close else Open) model

        Init geometry ->
            ( { model
                  | open = model.opening
                  , opening = False
                  , geometry = Just geometry
                  , reconfigure = False
                  , initialized = True
              }
            ,
              Cmd.none
            )

        Open ->
            { model
                | open = False
                , opening = True
                , geometry = Nothing
                , reconfigure = True

                -- animation:
                , animating = True
                , time = 0
                , startScaleX = model.scaleX
                , startScaleY = model.scaleY
            }
                ! []

        Close ->
            { model
                | open = False
                , opening = False

                -- animation:
                , animating = True
                , time = 0
                , startScaleX = model.scaleX
                , startScaleY = model.scaleY
            }
                ! []

        Click { x, y } ->
            if model.open then
                update fwd Close model
            else
                model ! []

        Tick dt ->
            let
                -- constants:

                selectedTriggerDelay =
                    50

                transitionDurationMs =
                    300

                transitionScaleAdjustmentX =
                    0.5

                transitionScaleAdjustmentY =
                    0.2

                transitionX1 =
                    0

                transitionY1 =
                    0

                transitionX2 =
                    0.2

                transitionY2 =
                    1

                -- animation:

                time =
                    model.time + dt
                    |> clamp 0 1


                timeX =
                    clamp 0 1 <|
                    if model.open then
                        time + transitionScaleAdjustmentX
                    else
                        (time - transitionScaleAdjustmentX) / (1 - transitionScaleAdjustmentX)

                timeY =
                    clamp 0 1 <|
                    if model.open then
                        (time - transitionScaleAdjustmentY) / (1 - transitionScaleAdjustmentY)
                    else
                        time

                easeX =
                    timeX -- TODO: bezierProgress

                easeY =
                    timeY -- TODO: bezierProgress

                targetScale =
                    if model.open then 1 else 0

                startScaleX =
                    model.startScaleX

                startScaleY =
                    model.startScaleY
--                    let
--                        geometry =
--                            Maybe.withDefault defaultGeometry model.geometry
--
--                        height =
--                            geometry.itemsContainer.height
--
--                        itemHeight =
--                            geometry.itemGeometries
--                            |> List.head
--                            |> Maybe.map .height
--                            |> Maybe.withDefault 0
--                    in
--                    if model.open then
--                        max (if height == 0 then 0 else itemHeight / height)
--                            (model.startScaleY)
--                    else
--                        model.startScaleY

                scaleX =
                    (startScaleX * (1 - easeX)) + (targetScale * easeX)

                scaleY =
                    (startScaleY * (1 - easeY)) + (targetScale * easeY)

                invScaleX =
                    1 / scaleX
                    -- if scaleX == 0 then 1 else  1 / scaleX

                invScaleY =
                    1 / scaleY
                    -- if scaleY == 0 then 1 else 1 / scaleY
            in
            { model
                | time = time
                , animating = time < 1
                , scaleX = scaleX
                , scaleY = scaleY
                , invScaleX = invScaleX
                , invScaleY = invScaleY
            }
                ! []

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
                model ! []
            else
                -- TODO: focus handling
                model ! []

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
                model ! []
            else
                if isEnter || isSpace then
                    -- TODO: trigger selected
                    update fwd Close model
                else
                    if isEscape then
                        update fwd Close model
                    else
                        model ! []


type alias Config =
    { index : Maybe Int
    , alignment : Maybe Alignment
    , open : Bool
    }


type Alignment
    = OpenFromTopLeft
    | OpenFromTopRight
    | OpenFromBottomLeft
    | OpenFromBottomRight


openFromTopLeft : Property m
openFromTopLeft =
    Internal.option (\ config -> { config | alignment = Just OpenFromTopLeft })


openFromTopRight : Property m
openFromTopRight =
    Internal.option (\ config -> { config | alignment = Just OpenFromTopRight })


openFromBottomLeft : Property m
openFromBottomLeft =
    Internal.option (\ config -> { config | alignment = Just OpenFromBottomLeft })


openFromBottomRight : Property m
openFromBottomRight =
    Internal.option (\ config -> { config | alignment = Just OpenFromBottomRight })


defaultConfig : Config
defaultConfig =
    { index = Nothing
    , alignment = Nothing
    , open = False
    }


type alias Property m =
    Options.Property Config m


--open : Property m
--open =
--    Internal.option (\config -> { config | open = True })
--
--
--openFromTopLeft : Property m
--openFromTopLeft =
--    Internal.option (\config -> { config | alignment = Just OpenFromTopLeft })
--
--
--openFromTopRight : Property m
--openFromTopRight =
--    Internal.option (\config -> { config | alignment = Just OpenFromTopRight })
--
--
--openFromBottomLeft : Property m
--openFromBottomLeft =
--    Internal.option (\config -> { config | alignment = Just OpenFromBottomLeft })
--
--
--openFromBottomRight : Property m
--openFromBottomRight =
--    Internal.option (\config -> { config | alignment = Just OpenFromBottomRight })


index : Int -> Property m
index =
    Internal.option << (\index config -> { config | index = Just index })


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

        transitionDelay i itemGeometry =
            let
                numItems =
                    List.length ul.items

                height =
                    geometry.itemsContainer.height

                transitionDuration =
                    transitionDurationMs / 1000

                transitionDurationMs = -- TODO: refactor `update'
                    300

                start =
                    transitionScaleAdjustmentY

                transitionScaleAdjustmentY = -- TODO: refactor `update'
                    0.2

                itemTop =
                    itemGeometry.top

                itemHeight =
                    itemGeometry.height

                itemDelayFraction =
                    if height == 0 then
                        0
                    else
--                        if (config.alignment == Just OpenFromBottomLeft)
--                           || (config.alignment == Just OpenFromBottomRight) then
--                            (height - itemTop - itemHeight) / height
--                        else
                            itemTop / height

                itemDelay =
                    (start + itemDelayFraction * (1 - start)) * transitionDuration

                toFixed value =
                    toFloat (floor (1000 * value)) / 1000
            in
                itemDelay |> toFixed

        (position, transformOrigin) =
            let
                windowWidth =
                    geometry.window.width

                windowHeight =
                    geometry.window.height

                adapter =
                    geometry.adapter

                anchor =
                    geometry.anchor

                width =
                    geometry.itemsContainer.width

                height =
                    geometry.itemsContainer.height

                topOverflow =
                    anchor.top + height - windowHeight

                bottomOverflow =
                    height - anchor.bottom

                extendsBeyondTopBounds =
                    topOverflow > 0

                vertical =
                    case config.alignment of
                        Just OpenFromTopLeft ->
                            "top"
                        Just OpenFromTopRight ->
                            "top"
                        Just OpenFromBottomLeft ->
                            "bottom"
                        Just OpenFromBottomRight ->
                            "bottom"
                        Nothing ->
                            if extendsBeyondTopBounds && (bottomOverflow < topOverflow) then
                                "bottom"
                            else
                                "top"

                leftOverflow =
                    anchor.left + width - windowWidth

                rightOverflow =
                    width - anchor.right

                extendsBeyondLeftBounds =
                    leftOverflow > 0

                extendsBeyondRightBounds =
                    rightOverflow > 0

                horizontal =
                    case config.alignment of
                        Just OpenFromTopLeft ->
                            "left"
                        Just OpenFromTopRight ->
                            "right"
                        Just OpenFromBottomLeft ->
                            "left"
                        Just OpenFromBottomRight ->
                            "right"
                        Nothing ->
                            if adapter.isRtl then
                                if extendsBeyondRightBounds && (leftOverflow < rightOverflow) then
                                    "left"
                                else
                                    "right"
                            else
                                if extendsBeyondLeftBounds && (rightOverflow < leftOverflow) then
                                    "right"
                                else
                                    "left"

                transformOrigin =
                    vertical ++ " " ++ horizontal

                position =
                    { horizontal = horizontal, vertical = vertical }
            in
            (position, transformOrigin)

        initOn event =
            Options.on event (Json.map (Init >> lift) decodeGeometry)
    in
    Internal.apply summary
    div
    [ cs "mdc-simple-menu"
    , cs "mdc-simple-menu--open" |> when (model.open || config.open)
    , cs "mdc-simple-menu--animating" |> when model.animating
    , initOn "ElmMdcReconfigure"
    , when model.reconfigure (cs "elm-mdc--reconfigure")

    , when (config.alignment /= Nothing) << cs <|
      case Maybe.withDefault OpenFromTopLeft config.alignment of
          OpenFromTopLeft ->
              "mdc-simple-menu--open-from-top-left"
          OpenFromTopRight ->
              "mdc-simple-menu--open-from-top-right"
          OpenFromBottomLeft ->
              "mdc-simple-menu--open-from-bottom-left"
          OpenFromBottomRight ->
              "mdc-simple-menu--open-from-bottom-right"

    , when model.initialized << Options.many <|
      [ css "position" "absolute"
      , css position.horizontal "0"
      , css position.vertical "0"
      , css "transform-origin" transformOrigin
      , css "transform"
            ("scale(" ++ toString model.scaleX ++ "," ++ toString model.scaleY ++ ")")
      ]
    ]
    []
    [ ul.node
      ( cs "mdc-simple-menu__items"
      :: css "transform" ("scale(" ++ toString model.invScaleX ++ "," ++ toString model.invScaleY ++ ")")
      :: ul.options
      )
      ( if model.open then
            List.map2 (,) ul.items geometry.itemGeometries
            |> List.indexedMap (\i (item, itemGeometry) ->
                 item.node
                 ( css "transition-delay" (toString (transitionDelay i itemGeometry) ++ "s")
                 :: item.options
                 )
                 item.childs
               )
        else
            ul.items
            |> List.map (\item ->
                 item.node
                 item.options
                 item.childs
               )
      )
    ]


type alias Store s =
    { s | menu : Indexed Model }


( get, set ) =
    Component.indexed .menu (\x y -> { y | menu = x }) defaultModel


react :
    (Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react lift msg idx store =
    update lift msg (get idx store)
        |> map1st (set idx store >> Just)


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
    DOM.target <|
    Json.map5 Geometry
    ( DOM.childNode 0 <| -- ".mdc-simple-menu__items.mdc-list"
      Json.map2
        (\offsetWidth offsetHeight -> { width = offsetWidth, height = offsetHeight })
        DOM.offsetWidth DOM.offsetHeight
    )
    ( DOM.childNode 0 <| -- ".mdc-simple-menu__items.mdc-list"
      DOM.childNodes  <|
      Json.map2
        (\offsetTop offsetHeight -> { top = offsetTop, height = offsetHeight })
        DOM.offsetTop DOM.offsetHeight
    )
    ( Json.succeed { isRtl = False } -- TODO: RTL
    )
    ( ( DOM.parentElement <| -- ".parent"
        DOM.boundingClientRect
      )
      |> Json.map (\rect ->
             { top = rect.top
             , left = rect.left
             , bottom = rect.top + rect.height
             , right = rect.left + rect.width
             }
         )
    )
    ( Json.at [ "ownerDocument" ] <|
      Json.at [ "defaultView" ]   <|
      Json.map2
        (\ innerWidth innerHeight ->
          { width = toFloat innerWidth
          , height = toFloat innerHeight
          }
        )
        (Json.at ["innerWidth"] Json.int)
        (Json.at ["innerHeight"] Json.int)
    )


rect : Float -> Float -> Float -> Float -> String
rect x y w h =
    [ x, y, w, h ]
        |> List.map toPx
        |> String.join " "
        |> (\coords -> "rect(" ++ coords ++ ")")


toPx : Float -> String
toPx =
    toString >> flip (++) "px"


onSelect : m -> Property m
onSelect msg =
    Options.onClick msg


themeDark : Property m
themeDark =
    cs "mdc-simple-menu--theme-dark"
