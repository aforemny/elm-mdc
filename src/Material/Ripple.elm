module Material.Ripple where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events
import Json.Decode as Json exposing ((:=), at)
import Effects exposing (Effects, tick, none)

import Material.Helpers exposing (effect)
import DOM


-- MODEL


type alias Metrics =
  { rect : DOM.Rectangle
  , x : Float
  , y : Float
  }


type Animation
  = Frame Int -- There is only 0 and 1.
  | Inert


type alias Model =
  { animation : Animation
  , metrics : Maybe Metrics
  }


model : Model
model =
  { animation = Inert
  , metrics = Nothing
  }


-- ACTION, UPDATE


type alias Geometry =
  { rect : DOM.Rectangle
  , clientX : Maybe Float
  , clientY : Maybe Float
  , touchX : Maybe Float
  , touchY : Maybe Float
  }


geometryDecoder : Json.Decoder Geometry
geometryDecoder =
  Json.object5 Geometry
    (DOM.target DOM.boundingClientRect)
    (Json.maybe ("clientX" := Json.float))
    (Json.maybe ("clientY" := Json.float))
    (Json.maybe (at ["touches", "0", "clientX"] Json.float))
    (Json.maybe (at ["touches", "0", "clientY"] Json.float))


computeMetrics : Geometry -> Maybe Metrics
computeMetrics g =
  let
    rect = g.rect
    set x y = (x - rect.left, y - rect.top) |> Just
  in
    (case (g.clientX, g.clientY, g.touchX, g.touchY) of
      (Just 0.0, Just 0.0, _, _) ->
        (rect.width / 2.0, rect.height / 2.0) |> Just

      (Just x, Just y, _, _) ->
        set x y

      (_, _, Just x, Just y) ->
        set x y

      _ ->
        Nothing

    ) |> Maybe.map (\(x,y) -> Metrics rect x y)


type Action
  = Down Geometry
  | Up
  | Tick


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Down geometry ->
      { model
      | animation = Frame 0
      , metrics = computeMetrics geometry
      }
      |> effect (tick <| \_ -> Tick)

    Up ->
      { model
      | animation = Inert
      }
      |> effect none

    Tick ->
      { model
      | animation = Frame 1
      }
      |> effect none



-- VIEW


downOn : String -> Signal.Address Action -> Attribute
downOn name addr =
  Html.Events.on
    name
    geometryDecoder
    (Down >> Signal.message addr)


upOn : String -> Signal.Address Action -> Attribute
upOn name addr =
  Html.Events.on
    name
    (Json.succeed ())
    ((\_ -> Up) >> Signal.message addr)


styles : Metrics -> Int -> List (String, String)
styles m frame =
  let
    scale = if frame == 0 then "scale(0.0001, 0.0001)" else ""
    toPx k = (toString (round k))  ++ "px"
    offset = "translate(" ++ toPx m.x ++ ", " ++ toPx m.y ++ ")"
    transformString = "translate(-50%, -50%) " ++ offset ++ scale
    r = m.rect
    rippleSize =
      sqrt (r.width * r.width + r.height * r.height) * 2.0 + 2.0 |> toPx
  in
    [ ("width", rippleSize)
    , ("height", rippleSize)
    , ("-webkit-transform", transformString)
    , ("-ms-transform", transformString)
    , ("transform", transformString)
    ]


view : Signal.Address Action -> List Attribute -> Model -> Html
view addr attrs model =
  let
    styling =
      case (model.metrics, model.animation) of
        (Just metrics, Frame frame) -> styles metrics frame
        (Just metrics, Inert) -> styles metrics 1 -- Hack.
        _ -> []
  in
    span
      (  downOn "mousedown" addr
      :: downOn "touchstart" addr
      :: upOn "mouseup" addr
      :: upOn "mouseleave" addr
      :: upOn "touchend" addr
      :: upOn "blur" addr
      :: attrs
      )
      [ span
        [ classList
          [ ("mdl-ripple", True)
          , ("is-animating", model.animation /= Frame 0)
          , ("is-visible", model.animation /= Inert)
          ]
        , style styling
        ]
        []
      ]
