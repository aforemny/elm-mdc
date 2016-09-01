module Dispatch
  exposing
    ( Msg
    , Decoder
    , Config
    , on
    , onWithOptions
    , forward
    , listeners
    , group
    , update
    , add
    , lift
    , lift'
    , empty
    )

{-| Utility module for dispatching multiple events from a single `Html.Event`

To add support for Dispatch

Add a message to your `Msg`

    type Msg
      = ...
      | Dispatch (List Msg)
      ...

Add call to `Dispatch.update` in update

    update : Msg -> Model -> (Model, Cmd Msg)
    update msg model =
      case msg of
        ...

      Dispatch messages ->
        Dispatch.update update messages model

        ...

Add a call to `Dispatch.on` on an element

    view : Model -> Html Msg
    view model =
      let
        decoders =
          [ Json.Decode.succeed ClickOne
          , Json.Decode.succeed ClickTwo
          , Json.Decode.map SomeMessage
              (Json.at ["target", "offsetWidth"] Json.float) ]
      in
        Html.button
          ([] ++ (case Dispatch.on "click" Dispatch decoders of
                    Just attr -> [ attr ]
                    Nothing -> []))
          [ text "Button" ]


## Types
@docs Msg

## Events
@docs on
@docs onWithOptions
@docs update

## Advanced

These are used for `elm-mdl`. They are likely
not generic enough for common use

@docs Decoder
@docs Config
@docs empty, add, lift, lift'
@docs listeners

@docs group
@docs forward
-}

import Json.Decode as Json
import Html.Events
import Html
import Task


{-| Dispatch configuration type.
 -}
type Config m =
  Config
    { decoders : List (String, (Json.Decoder m, Maybe Html.Events.Options))
    , lift : Maybe (List m -> m)
    }


{-| Empty configuration
 -}
empty : Config m
empty =
  Config
    { decoders = []
    , lift = Nothing
    }

{-| Set the lifting function
 -}
lift : (List m -> m) -> Config m -> Config m
lift fn (Config config) =
  Config
    { config | lift = Just fn }


{-| Get the lifting function
 -}
lift' : (Config m) -> Maybe (List m -> m)
lift' (Config config) = config.lift


{-| Add a decoder for event
 -}
add : String -> Maybe Html.Events.Options -> Json.Decoder msg -> Config msg -> Config msg
add event options decoder (Config config) =
  Config
    { config | decoders = (event, (decoder, options)) :: config.decoders }


{-| Listeners
 -}
listeners : Config msg -> List (Html.Attribute msg)
listeners (Config config) =
  let
    grouped =
      group config.decoders

  in
    case config.lift of
      Just fn ->
        listeners' fn grouped
      Nothing ->
        listeners'' grouped


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
forward : List m -> Cmd m
forward (messages) =
  List.map cmd messages |> Cmd.batch


{-| Map the second element of a tuple

    map2nd ((+) 1) ("bar", 3) == ("bar", 4)
-}
map2nd : (b -> c) -> ( a, b ) -> ( a, c )
map2nd f ( x, y ) =
  ( x, f y )


{-|
-}
inner : (a -> b -> ( c, d )) -> a -> ( b, List d ) -> ( c, List d )
inner update cmd ( m, gs ) =
  update cmd m
    |> map2nd (flip (::) gs)


{-| Runs the given `update` on all the messages and
returns the updated model including batching of
any commands returned by running the `update`.
-}
update : (msg -> model -> ( model, Cmd any )) -> List msg -> model -> ( model, Cmd any )
update update (msg) model =
  List.foldl
    (inner update)
    ( model, [] )
    msg
    |> map2nd Cmd.batch


{-| Decode value using a decoder
 -}
processDecoder : Json.Value -> Json.Decoder a -> Maybe a
processDecoder initial decoder =
  Json.decodeValue decoder initial
    |> Result.toMaybe


{-| Applies given decoders to the same initial value
   and return the applied results as a list
 -}
applyMultipleDecoders : List (Json.Decoder m) -> Json.Decoder (List m)
applyMultipleDecoders decoders =
  Json.customDecoder Json.value
    (\initial ->
       List.filterMap (processDecoder initial) decoders
       |> Result.Ok
    )


{-| Dispatch multiple decoders for a single event.

Returns `Nothing` if an empty list of decoders is provided.
Otherwise returns `Just Html.Attribute` with a listener
that will attempt to run multiple decoders on the event.
 -}
on
  : String
  -> (List msg -> msg)
  -> List (Json.Decoder msg)
  -> Maybe (Html.Attribute msg)
on event lift =
  onWithOptions event lift Html.Events.defaultOptions

{-| Dispatch multiple decoders for a single event.
Options apply to the whole event.

Returns `Nothing` if an empty list of decoders is provided.
Otherwise returns `Just Html.Attribute` with a listener
that will attempt to run multiple decoders on the event.
 -}
onWithOptions
  : String
  -> (List msg -> msg)
  -> Html.Events.Options
  -> List (Json.Decoder msg)
  -> Maybe (Html.Attribute msg)
onWithOptions event lift options decoders =
  case decoders of
    [] ->
      Nothing

    [ x ] ->
      Html.Events.onWithOptions event options x
        |> Just

    _ ->
      applyMultipleDecoders decoders
        |> Json.map lift
        |> Html.Events.onWithOptions event options
        |> Just


{-| Run multiple decoders on a single Html Event with
the given options
-}
onEvtOptions :
  (List msg -> msg)
  -> (String, List (Decoder msg))
  -> Maybe (Html.Attribute msg)
onEvtOptions lift (event, pairs) =
  let
    options =
      pickOptions pairs

    decoders =
      List.map fst pairs
  in
    case decoders of
      [] ->
        Nothing

      [ x ] ->
        Html.Events.onWithOptions event options x
          |> Just

      _ ->
        applyMultipleDecoders decoders
          |> Json.map lift
          |> Html.Events.onWithOptions event options
          |> Just


{-| A single event
-}
onSingle :
  (String, List (Decoder msg))
  -> Maybe (Html.Attribute msg)
onSingle (event, pairs) =
  let
    options =
      pickOptions pairs

    decoders =
      List.map fst pairs

  in
    case decoders of
      [] ->
        Nothing

      [ x ] ->
        Html.Events.onWithOptions event options x
          |> Just

      x :: xs ->
        let
          -- NOTE: This probably needs to be changed, currently only for debugging
          _ = Debug.log "WARNING" ("Multiple decoders for Event '" ++ event ++ "' with no `Options.dispatch Mdl`")
        in
          Html.Events.onWithOptions event options x
            |> Just


{-| Picks a set of options or Html.Events.defaultOptions -}
pickOptions : List (Decoder a) -> Html.Events.Options
pickOptions =
  List.filterMap snd
    >> List.head
    >> Maybe.withDefault Html.Events.defaultOptions


{-| This function takes a lifting function and
pair of events and their handlers and returns
a list of `Html.Attribute` containing handlers that
will allow for dispatching of multiple events from a single `Html.Event`
-}
listeners' :
  (List a -> a)
  -> List ( String, List (Decoder a) )
  -> List (Html.Attribute a)
listeners' lift items =
  List.filterMap (onEvtOptions lift) items


{-| Take a list of events to a list of decoders and
apply only the first of those decoders. This
is only applicable if no lifting argument is available.
If a lifting argument is available use
`Dispatch.listeners` instead.
-}
listeners'' :
  List ( String, List (Decoder a) )
  -> List (Html.Attribute a)
listeners'' items =
  List.filterMap onSingle items


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
