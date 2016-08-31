module Dispatch
  exposing
    ( Msg
    , Decoder
    , forward
    , listeners
    , listeners'
    , group
    , update
    )

{-| Utility module for dispatching multiple events from a single `Html.Event`

## Types
@docs Msg
@docs Decoder

## Event handlers
@docs listeners
@docs listeners'
@docs group

## Dispatch
@docs forward
@docs update
-}

import Json.Decode as Json
import Html.Events
import Html
import Task


{-|
  Lift any value of type `msg` to a `Cmd msg`.
-}
cmd : msg -> Cmd msg
cmd msg =
  Task.perform (always msg) (always msg) (Task.succeed msg)


{-| Message type
-}
type alias Msg m
  = (List m)


{-| A decoder with possible options
-}
type alias Decoder m =
  ( Json.Decoder m, Maybe (Html.Events.Options) )


{-| Maps messages to commands
-}
forward : Msg m -> Cmd m
forward (messages) =
  List.map cmd messages |> Cmd.batch


{-| Map the second element of a tuple

    map2nd ((+) 1) ("bar", 3) == ("bar", 4)
-}
map2nd : (b -> c) -> ( a, b ) -> ( a, c )
map2nd f ( x, y ) =
  ( x, f y )


{-| Runs batch update
-}
update : (a -> b -> ( b, Cmd c )) -> Msg a -> b -> ( b, Cmd c )
update update (msg) model =
  let
    inner cmd ( m, gs ) =
      update cmd m
        |> map2nd (flip (::) gs)
  in
    List.foldl
      inner
      ( model, [] )
      msg
      |> map2nd Cmd.batch


{-| Applies given decoders to the same initial value
   and return the applied results as a list
-}
applyMultipleDecoders : List (Json.Decoder m) -> Json.Decoder (List m)
applyMultipleDecoders decoders =
  let
    processDecoder initial decoder =
      Json.decodeValue decoder initial
        |> Result.toMaybe
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
  applyMultipleDecoders


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


{-| A single event
-}
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
      Debug.crash <| "Multiple decoders for Event '" ++ event ++ "' with no `Options.dispatch Mdl`"


pickOptions : List (Decoder a) -> Html.Events.Options
pickOptions decoders =
  List.map snd decoders
    |> List.filterMap identity
    |> List.head
    |> Maybe.withDefault Html.Events.defaultOptions


{-| This function takes a lifting function and
pair of events and their handlers and returns
a list of `Html.Attribute` containing handlers that
will allow for dispatching of multiple events from a single `Html.Event`
-}
listeners :
  (Msg a -> a)
  -> List ( String, List (Decoder a) )
  -> List (Html.Attribute a)
listeners lift items =
  items
    |> List.map (\( event, decoders ) -> onEvtOptions lift event (pickOptions decoders) (List.map fst decoders))
    |> List.filterMap identity


{-| Take a list of events to a list of decoders and
apply only the first of those decoders. This
is only applicable if no lifting argument is available.
If a lifting argument is available use
`Dispatch.listeners` instead.
-}
listeners' :
  List ( String, List (Decoder a) )
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
