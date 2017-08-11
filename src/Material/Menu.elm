module Material.Menu exposing (..)

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#menus-section):

> The Material Design Lite (MDL) dropdown component is a user interface element
> that allows users to select one of a number of options. The selection
> typically results in an action initiation, a setting change, or other
> observable effect. Menu options are always presented in sets of two or
> more, and options may be programmatically enabled or disabled as required.
> The dropdown appears when the user is asked to choose among a series of
> options, and is usually dismissed after the choice is made.

> Menus are an established but non-standardized feature in user interfaces,
> and allow users to make choices that direct the activity, progress, or
> characteristics of software. Their design and use is an important factor in
> the overall user experience. See the dropdown component's Material Design
> specifications page for details.

See also the
[Material Design Specification]([https://www.google.com/design/spec/components/menus.html).

Refer to [this site](https://debois.github.io/elm-mdl/#menus)
for a live demo.

# Subscriptions

The Menu component requires subscriptions to arbitrary mouse clicks to be set
up. Example initialisation of containing app:

    import Material.Menu as Menu
    import Material

    type Model =
      { …
      , mdl : Material.Model
      }

    type Msg =
      …
      | Mdl (Material.Msg Msg)

    App.program
      { init = init
      , view = view
      , subscriptions = Menu.subs Mdl model
      , update = update
      }

# Import

Along with this module you will want to to import Material.Dropdown.Item.

# Render
@docs render, subs

# Item
@docs Item, item

# Options
@docs Property

## Alignment
@docs bottomLeft, bottomRight, topLeft, topRight

## Appearance
@docs icon, index

# Elm architecture
@docs Model, defaultModel, Msg, update, view, subscriptions

# Internal use
@docs react

-}

-- import AnimationFrame
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


-- SETUP


{-| Component subscriptions.
-}
subscriptions : Model -> Sub (Msg m)
subscriptions model =
    let
        transitionDurationMs =
            300 -- TODO: refactor `view'
    in
    Sub.batch
    [ if model.open then
        Mouse.clicks Click
      else
        Sub.none
    , if model.animating then
        Sub.none -- TODO:
        -- AnimationFrame.diffs (\dt -> Tick (dt / transitionDurationMs))
      else
        Sub.none
    ]



-- MODEL


{-| Component model
-}
type alias Model =
    { index : Maybe Int
    , open : Bool
    , geometry : Maybe Geometry

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


{-| Default component model
-}
defaultModel : Model
defaultModel =
    { index = Nothing
    , open = False
    , geometry = Nothing

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
    [ Options.on "click" (Json.map (Toggle >> Material.Msg.MenuMsg idx >> lift) decodeGeometryOnButton)
    ]


connect : (Material.Internal.Menu.Msg m -> m) -> Options.Property c m
connect lift =
    Options.many
    [ Options.on "click" (Json.map (Toggle >> lift) decodeGeometryOnButton)
    ]


-- ACTION, UPDATE


-- TODO (select can't have this):
--{-| Component action.
---}
--type alias Msg m
--    = Material.Internal.Menu.Msg m


{-| Component update.
-}
update : (Msg msg -> msg) -> Msg msg -> Model -> ( Model, Cmd msg )
update fwd msg model =
    case msg of

        Toggle geometry ->
            update fwd ((if model.open then Close else Open) geometry) model

        Open geometry ->
            { model
                | open = True
                , geometry = Just geometry

                -- animation:
                , animating = True
                , time = 0
                , startScaleX = model.scaleX
                , startScaleY = model.scaleY
            }
                ! []

        Close geometry ->
            { model
                | open = False
                , geometry = Just geometry

                -- animation:
                , animating = True
                , time = 0
                , startScaleX = model.scaleX
                , startScaleY = model.scaleY
            }
                ! []

        Click { x, y } ->
            let
                geometry =
                    Maybe.withDefault defaultGeometry model.geometry
            in
            if model.open then
                update fwd (Close geometry) model
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
                    if model.open then
                        time + transitionScaleAdjustmentX
                        |> clamp 0 1
                    else
                        (time - transitionScaleAdjustmentX) / (1 - transitionScaleAdjustmentX)
                        |> clamp 0 1

                timeY =
                    if model.open then
                        (time - transitionScaleAdjustmentY) / (1 - transitionScaleAdjustmentY)
                        |> clamp 0 1
                    else
                        time
                        |> clamp 0 1

                easeX =
                    timeX -- TODO: bezierProgress

                easeY =
                    timeY -- TODO: bezierProgress

                targetScale =
                    if model.open then 1 else 0

                startScaleX =
                    model.startScaleX

                startScaleY =
                    let
                        geometry =
                            Maybe.withDefault defaultGeometry model.geometry

                        height =
                            geometry.itemsContainer.height

                        itemHeight =
                            geometry.itemGeometries
                            |> List.head
                            |> Maybe.map .height
                            |> Maybe.withDefault 0
                    in
                    if model.open then
                        max (if height == 0 then 0 else itemHeight / height)
                            (model.startScaleY)
                    else
                        model.startScaleY

                scaleX =
                    startScaleX + (targetScale - startScaleX) * easeX

                scaleY =
                    startScaleY + (targetScale - startScaleY) * easeY

                invScaleX =
                    1 / (if scaleX == 0 then 1 else scaleX)

                invScaleY =
                    1 / (if scaleY == 0 then 1 else scaleY)
            in
            { model
                | time = time
                , animating = time < 1
                , scaleX = scaleX
                , scaleY = scaleX
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

                geometry =
                    Maybe.withDefault defaultGeometry model.geometry
            in
            if altKey || ctrlKey || metaKey then
                model ! []
            else
                if isEnter || isSpace then
                    -- TODO: trigger selected
                    update fwd (Close geometry) model
                else
                    if isEscape then
                        update fwd (Close geometry) model
                    else
                        model ! []


-- PROPERTIES


type alias Config =
    { index : Maybe Int
    , alignment : Maybe Alignment
    }


type Alignment
    = OpenFromTopLeft
    | OpenFromTopRight
    | OpenFromBottomLeft
    | OpenFromBottomRight


defaultConfig : Config
defaultConfig =
    { index = Nothing
    , alignment = Nothing
    }


{-| Type of Menu options
-}
type alias Property m =
    Options.Property Config m


{-| TODO
-}
open : Property m
open =
    cs "mdc-simple-menu--open"


{-| TODO
-}
openFromTopLeft : Property m
openFromTopLeft =
    Internal.option (\config -> { config | alignment = Just OpenFromTopLeft })


{-| TODO
-}
openFromTopRight : Property m
openFromTopRight =
    Internal.option (\config -> { config | alignment = Just OpenFromTopRight })


{-| TODO
-}
openFromBottomLeft : Property m
openFromBottomLeft =
    Internal.option (\config -> { config | alignment = Just OpenFromBottomLeft })


{-| TODO
-}
openFromBottomRight : Property m
openFromBottomRight =
    Internal.option (\config -> { config | alignment = Just OpenFromBottomRight })


{-| Set the default value of a menu.
-}
index : Int -> Property m
index =
    Internal.option << (\index config -> { config | index = Just index })



-- VIEW


{-| Component view.
-}
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
                        if (config.alignment == Just OpenFromBottomLeft)
                           || (config.alignment == Just OpenFromBottomRight) then
                            (height - itemTop - itemHeight) / height
                        else
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
                    anchor.top + height + windowHeight

                bottomOverflow =
                    height - anchor.bottom

                extendsBeyondTopBounds =
                    topOverflow > 0

                vertical =
                    if extendsBeyondTopBounds && (bottomOverflow < topOverflow) then
                        "bottom"
                    else
                        "top"

                leftOverflow =
                    anchor.left + width + windowWidth

                rightOverflow =
                    width - anchor.right

                extendsBeyondLeftBounds =
                    leftOverflow > 0

                extendsBeyondRightBounds =
                    rightOverflow > 0

                horizontal =
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
    in
    Internal.apply summary
    div
    [ cs "mdc-simple-menu"
    , cs "mdc-simple-menu--open" |> when model.open
    , cs "mdc-simple-menu--animating" |> when model.animating

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

    , css "transform"
          ("scale(" ++ toString model.scaleX ++ "," ++ toString model.scaleY ++ ")")

    , css "position" "absolute"
    , css position.horizontal "0"
    , css position.vertical "0"
    , css "transform-origin" transformOrigin
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


-- COMPONENT


type alias Store s =
    { s | menu : Indexed Model }


( get, set ) =
    Component.indexed .menu (\x y -> { y | menu = x }) defaultModel


{-| Component react function. Internal use only.
-}
react :
    (Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react lift msg idx store =
    update lift msg (get idx store)
        |> map1st (set idx store >> Just)


{-|  TODO
-}
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


{-| TODO
-}
subs : (Material.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Component.subs Material.Msg.MenuMsg .menu subscriptions


-- HELPERS


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

decodeGeometryOnButton : Decoder Geometry
decodeGeometryOnButton =
    DOM.target      <| -- "button"
    DOM.nextSibling <| -- ".mdc-simple-menu"
    decodeGeometry


decodeGeometry : Decoder Geometry
decodeGeometry =
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
    ( -- Note: The original implementation reads window.{innerWidth,innerHeight}.
      -- To my knowledge this is the best we can do:
      let
        traverseToRoot : Decoder a -> Decoder a
        traverseToRoot decoder =
            Json.oneOf
            [ DOM.parentElement (Json.lazy (\_ -> traverseToRoot decoder))
            , decoder
            ]
      in
        traverseToRoot <|
        Json.map2
          (\clientWidth clientHeight -> { width = clientWidth, height = clientHeight })
          DOM.offsetWidth
          DOM.offsetHeight
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


onSelect : Decoder m -> Property m
onSelect =
    Options.on "click"
