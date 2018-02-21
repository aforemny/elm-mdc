module LazyImage exposing (..)

import DOM
import GlobalEvents
import Html.Attributes as Html
import Html.Events as Html
import Html exposing (Html)
import Json.Decode as Json
import Material.Options as Options exposing (styled, cs, css)
import Material.Spinner as Spinner exposing (spinner)
import Svg
import Svg.Attributes as Svg


type alias Model =
  { geometry : Maybe Geometry
  , image : Maybe Image
  , scrollTop : Float
  }


defaultModel =
  { geometry = Nothing
  , image = Nothing
  , scrollTop = 0
  }


type alias Geometry =
  { boundingClientRect : DOM.Rectangle
  , window : Window
  }


type alias Window =
  { innerHeight : Float
  }


defaultGeometry =
  { boundingClientRect =
      { top = 0
      , left = 0
      , width = 0
      , height = 0
      }
  , window =
      { innerHeight = 0
      }
  }


decodeGeometry =
  Json.map2 Geometry (DOM.target DOM.boundingClientRect) decodeWindow


decodeWindow =
  DOM.target <|
  Json.map Window (Json.at ["ownerDocument", "defaultView", "innerHeight"] Json.float)


decodeScrollTop =
  Json.at ["pageY"] Json.float


type alias Image =
  { naturalWidth : Float
  , naturalHeight : Float
  }


decodeImage =
  DOM.target <|
  Json.map2 Image
    (Json.at ["naturalWidth"] Json.float)
    (Json.at ["naturalHeight"] Json.float)


type Msg
  = Init Geometry
  | Resize Geometry
  | Load Image
  | Scroll Float


update lift msg model =
  case Debug.log "Msg" msg of
    Init geometry ->
      ( { model | geometry = Just geometry }, Cmd.none )

    Resize geometry ->
      ( { model | geometry = Just geometry }, Cmd.none )

    Scroll scrollTop ->
      ( { model | scrollTop = scrollTop }, Cmd.none )

    Load image ->
      ( { model | image = Just image }, Cmd.none )


type alias Config =
  { width : Float
  , height : Float
  }


defaultConfig =
  { width = 240
  , height = 180
  }


view : (Msg -> m) -> Config -> Model -> String -> Html m
view lift { width, height } model url =
  let
    geometry =
      Maybe.withDefault defaultGeometry model.geometry

    visible =
      geometry.boundingClientRect.top < model.scrollTop + geometry.window.innerHeight
  in
  styled Html.div
  [ cs "lazy-image"
  , css "width" (toString width ++ "px")
  , css "height" (toString height ++ "px")
  ,
    [ GlobalEvents.onLoad (Json.map (lift << Init) decodeGeometry)
    , GlobalEvents.onResize (Json.map (lift << Resize) decodeGeometry)
    , GlobalEvents.onScroll (Json.map (lift << Scroll) decodeScrollTop)
    ]
    |> List.concat
    |> List.map Options.attribute
    |> Options.many
  ]
  <|
  if not visible then
    []
  else
    case model.image of
      Nothing ->
        [ styled Html.div
          [ cs "lazy-image__preload"
          ]
          [ Html.img
            [ Html.src url
            , Html.on "load" (Json.map (lift << Load) decodeImage)
            ]
            []
          ]
        , styled Html.div
          [ cs "lazy-image__status-indicator"
          ]
          [
            Svg.svg
            [ Svg.class "mdc-circular-progress"
            , Svg.viewBox "25 25 50 50"
            ]
            [
              Svg.circle
              [ Svg.class "mdc-circular-progress__path"
              , Svg.cx "50"
              , Svg.cy "50"
              , Svg.r "20"
              , Svg.fill "none"
              , Svg.strokeWidth "2"
              , Svg.strokeMiterlimit "10"
              ]
              []
            ]
          ]
        ]

      Just image ->
        [ styled Html.div
          [ cs "lazy-image__image"
          , css "background-image" ("url(" ++ url ++ ")")
          ]
          [
          ]
        ]
