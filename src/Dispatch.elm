module Dispatch
  exposing
    ( Msg
    , forward
    , listeners
    , listeners'
    , group
    )

{-| Utility module for dispatching multiple events from a single `Html.Event`

@docs Msg
@docs forward
@docs listeners
@docs listeners'
@docs group
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


type alias Pair m =
  ( Json.Decoder m, Maybe (Html.Events.Options) )


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
onEvt lift event =
  onEvtOptions lift event Html.Events.defaultOptions


{-| Run multiple decoders on a single Html Event with
the given options
-}
onEvtOptions :
  (Msg msg -> msg)
  -> String
  -> Html.Events.Options
  -> List (Json.Decoder msg)
  -> Maybe (Html.Attribute msg)
onEvtOptions lift event options decoders =
  case decoders of
    [] ->
      Nothing

    [ x ] ->
      Html.Events.onWithOptions event options x
        |> Just

    _ ->
      forwardDecoder decoders
        |> Json.map lift
        |> Html.Events.onWithOptions event options
        |> Just


onSingle :
  String
  -> Html.Events.Options
  -> List (Json.Decoder msg)
  -> Maybe (Html.Attribute msg)
onSingle event options decoders =
  case decoders of
    [] ->
      Nothing

    [ x ] ->
      Html.Events.onWithOptions event options x
        |> Just

    -- NOTE: This need to be changed, currently only for debugging
    x :: xs ->
      Debug.crash <| "Multiple decoders for Event '" ++ event ++  "' with no `Options.dispatch Mdl`"
      -- Html.Events.onWithOptions event options x
      --   |> Just


{-| Updates value by given function if found, inserts otherwise
-}
upsert : comparable -> m -> (Maybe m -> Maybe m) -> Dict comparable m -> Dict comparable m
upsert key value func dict =
  if Dict.member key dict then
    Dict.update key func dict
  else
    Dict.insert key value dict


pickOptions : List (Pair a) -> Html.Events.Options
pickOptions decoders =
  List.map snd decoders
    |> List.filterMap identity
    |> List.head
    |> Maybe.withDefault Html.Events.defaultOptions


{-| Combines decoders for events and returns event listeners
-}
listeners :
  (Msg a -> a)
  -> List ( String, List (Pair a) )
  -> List (Html.Attribute a)
listeners lift items =
  items
    |> List.map (\( event, decoders ) -> onEvtOptions lift event (pickOptions decoders) (List.map fst decoders))
    |> List.filterMap identity


{-| Combines decoders for events and returns event listeners
-}
listeners' :
  List ( String, List (Pair a) )
  -> List (Html.Attribute a)
listeners' items =
  items
    |> List.map
        (\( event, decoders ) ->
          onSingle event (pickOptions decoders) (List.map fst decoders)
        )
    |> List.filterMap identity


{-| Group a list of pairs based on the first item
-}
group : List ( a, b ) -> List ( a, List b )
group =
  group' []


split :
  a
  -> List b
  -> List ( a, b )
  -> List ( a, b )
  -> ( List b, List ( a, b ) )
split k0 same differ xs =
  case xs of
    [] ->
      ( same, differ )

    (( k, v ) as x) :: xs ->
      if k == k0 then
        split k0 (v :: same) differ xs
      else
        split k0 same (x :: differ) xs


group' : List ( a, List b ) -> List ( a, b ) -> List ( a, List b )
group' acc items =
  case items of
    [] ->
      acc

    [ ( k, v ) ] ->
      ( k, [ v ] ) :: acc

    [ ( k1, v1 ), ( k2, v2 ) ] ->
      if k1 == k2 then
        ( k1, [ v2, v1 ] ) :: acc
      else
        ( k2, [ v2 ] ) :: ( k1, [ v1 ] ) :: acc

    ( k, v ) :: xs ->
      let
        ( same, different ) =
          split k [ v ] [] xs
      in
        group' (( k, same ) :: acc) different
