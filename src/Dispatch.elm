module Dispatch exposing
  ( Msg
  , forward
  , listeners
  )

{-| Utility module for dispatching multiple events from a single `Html.Event`

@docs Msg
@docs forward
@docs listeners
-}

import Material.Helpers as Helpers
import Json.Decode as Json
import Html.Events
import Html
import Dict exposing (Dict)

{-| Message type
-}
type Msg m
  = Forward (List m)


{-| Maps messages to commands
-}
forward : Msg m -> Cmd m
forward (Forward messages) =
  List.map Helpers.cmd messages |> Cmd.batch


{-| Applies given decoders to the same initial value
   and return the applied results as a list
-}
applyMultipleDecoders : List (Json.Decoder m) -> Json.Decoder (List m)
applyMultipleDecoders decoders =
  let
    processDecoder initial decoder =
      case (Json.decodeValue decoder initial) of
        Ok smt ->
          Just smt

        Err _ ->
          Nothing
  in
    Json.customDecoder Json.value
      (\initial ->
        List.map (processDecoder initial) decoders
          |> List.filterMap identity
          |> Result.Ok
      )


{-|
-}
forwardDecoder : List (Json.Decoder a) -> Json.Decoder (Msg a)
forwardDecoder =
  applyMultipleDecoders >> (Json.map Forward)


{-| Run multiple decoders on a single Html Event
-}
onEvt :
  (Msg msg -> msg)
  -> String
  -> List (Json.Decoder msg)
  -> Maybe (Html.Attribute msg)
onEvt lift event decoders =
  case decoders of
    [] ->
      Nothing

    [ x ] ->
      Html.Events.on event x
        |> Just

    _ ->
      forwardDecoder decoders
        |> Json.map lift
        |> Html.Events.on event
        |> Just


{-|
-}
combineListeners :
  Dict String (Json.Decoder m)
  -> Dict String (Json.Decoder m)
  -> Dict String (List (Json.Decoder m))
combineListeners first second =
  Dict.merge
    (\key value accum -> Dict.insert key [ value ] accum)
    (\key v1 v2 accum -> Dict.insert key [ v1, v2 ] accum)
    (\key value accum -> Dict.insert key [ value ] accum)
    first
    second
    Dict.empty


{-| Combines decoders for events and returns event listeners
-}
listeners :
  (Msg m -> m)
  -> Dict String (Json.Decoder m)
  -> Dict String (Json.Decoder m)
  -> List (Html.Attribute m)
listeners lift first second =
  let
    items =
      combineListeners first second
  in
    Dict.toList items
      |> List.map (\( event, decoders ) -> onEvt lift event decoders)
      |> List.filterMap identity
