module Internal.Dispatch
    exposing
        ( Config
        , add
        , clear
        , defaultConfig
        , forward
        , getDecoder
        , on
        , onWithOptions
        , setDecoder
        , setMsg
        , toAttributes
        , update
        )

import Html
import Html.Events
import Internal.Dispatch.Internal exposing (Config(..))
import Json.Decode as Json exposing (Decoder)
import Task


type alias Config msg =
    Internal.Dispatch.Internal.Config msg


defaultConfig : Config msg
defaultConfig =
    Config
        { decoders = []
        , lift = Nothing
        }


setDecoder : (Decoder (List msg) -> Decoder msg) -> Config msg -> Config msg
setDecoder f (Config config) =
    Config { config | lift = Just f }


setMsg : (List msg -> msg) -> Config msg -> Config msg
setMsg =
    Json.map >> setDecoder


getDecoder : Config msg -> Maybe (Decoder (List msg) -> Decoder msg)
getDecoder (Config config) =
    config.lift


add : String -> Maybe Html.Events.Options -> Decoder msg -> Config msg -> Config msg
add event options decoder (Config config) =
    Config
        { config | decoders = ( event, ( decoder, options ) ) :: config.decoders }


clear : Config msg -> Config msg
clear (Config config) =
    Config
        { config | decoders = [] }


toAttributes : Config msg -> List (Html.Attribute msg)
toAttributes (Config config) =
    case config.lift of
        Just f ->
            List.map (onMany f) (group config.decoders)

        Nothing ->
            List.map onSingle config.decoders


cmd : msg -> Cmd msg
cmd msg =
    Task.perform (always msg) (Task.succeed msg)


forward : List msg -> Cmd msg
forward messages =
    List.map cmd messages |> Cmd.batch


map2nd : (b -> c) -> ( a, b ) -> ( a, c )
map2nd f ( x, y ) =
    ( x, f y )


update1 : (m -> model -> ( model, d )) -> m -> ( model, List d ) -> ( model, List d )
update1 update cmd ( m, gs ) =
    update cmd m
        |> map2nd (flip (::) gs)


update : (msg -> model -> ( model, Cmd obs )) -> List msg -> model -> ( model, Cmd obs )
update update msg model =
    List.foldl (update1 update) ( model, [] ) msg
        |> map2nd Cmd.batch



-- VIEW


flatten : List (Decoder m) -> Decoder (List m)
flatten decoders =
    Json.value
        |> Json.map
            (\value ->
                List.filterMap
                    (\decoder ->
                        Json.decodeValue decoder value |> Result.toMaybe
                    )
                    decoders
            )


on :
    String
    -> (List msg -> msg)
    -> List (Decoder msg)
    -> Html.Attribute msg
on event lift =
    onWithOptions event lift Html.Events.defaultOptions


onWithOptions :
    String
    -> (List msg -> msg)
    -> Html.Events.Options
    -> List (Decoder msg)
    -> Html.Attribute msg
onWithOptions event lift options decoders =
    flatten decoders
        |> Json.map lift
        |> Html.Events.onWithOptions event options


onMany :
    (Decoder (List m) -> Decoder m)
    -> ( String, List ( Decoder m, Maybe Html.Events.Options ) )
    -> Html.Attribute m
onMany lift decoders =
    case decoders of
        -- Install direct handler for singleton case
        ( event, [ decoder ] ) ->
            onSingle ( event, decoder )

        ( event, decoders ) ->
            flatten (List.map Tuple.first decoders)
                |> lift
                |> Html.Events.onWithOptions event (pickOptions decoders)


pickOptions : List ( a, Maybe Html.Events.Options ) -> Html.Events.Options
pickOptions decoders =
    let
        pick ( _, options ) pickedOptions =
            Maybe.withDefault pickedOptions <|
                Maybe.map
                    (\options ->
                        { preventDefault =
                            pickedOptions.preventDefault || options.preventDefault
                        , stopPropagation =
                            pickedOptions.stopPropagation || options.stopPropagation
                        }
                    )
                    options
    in
    List.foldl pick Html.Events.defaultOptions decoders


onSingle :
    ( String, ( Decoder m, Maybe Html.Events.Options ) )
    -> Html.Attribute m
onSingle ( event, ( decoder, option ) ) =
    Html.Events.onWithOptions
        event
        (Maybe.withDefault Html.Events.defaultOptions option)
        decoder


group : List ( a, b ) -> List ( a, List b )
group =
    group_ []


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


group_ : List ( a, List b ) -> List ( a, b ) -> List ( a, List b )
group_ acc items =
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
            group_ (( k, same ) :: acc) different
