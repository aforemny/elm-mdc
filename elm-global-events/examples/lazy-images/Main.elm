module Main exposing (..)

import Dict exposing (Dict)
import LazyImage


type alias Model =
  { lazyImages : Dict Url LazyImage.Model
  }


type alias URL = String


defaultModel =
  { lazyImages = Dict.empty
  }


type Msg
  = LazyImageMsg Url LazyImage.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    LazyImageMsg url msg_ ->
      let
        ( lazyImage, effects ) =
          LazyImage.update LazyImageMsg msg_
            ( Dict.get url model.lazyImages
              |> Maybe.withDefault LazyImage.defaultModel
            )
      in
      ( { model | lazyImages = Dict.insert url lazyImage model.lazyImages }, effects )


main =
  Html.div
  [ Html.style
    [ ("height", "10000px")
    ]
  ]
  [
  ]
