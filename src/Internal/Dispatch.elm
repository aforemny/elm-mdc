module Internal.Dispatch
    exposing
        ( Config
        , Custom
        , Lift
        , add
        , clear
        , defaultConfig
        , forward
        , setLift
        , toAttributes
        )

import Dict exposing (Dict)
import Html
import Html.Events
import Json.Decode as Decode exposing (Decoder)
import Task


type Config msg
    = Config
        { decoders : Dict String (List (Decoder (Custom msg)))
        , lift : Maybe (Lift msg)
        }


type alias Lift msg =
    Decoder (Custom (List msg)) -> Decoder (Custom msg)


defaultConfig : Config msg
defaultConfig =
    Config
        { decoders = Dict.empty
        , lift = Nothing
        }


setLift : Lift msg -> Config msg -> Config msg
setLift lift (Config { decoders }) =
    Config
        { decoders = decoders
        , lift = Just lift
        }


type alias Custom msg =
    { message : msg
    , stopPropagation : Bool
    , preventDefault : Bool
    }


{-| TODO: name `inherit`
-}
clear : Config msg -> Config msg
clear (Config config) =
    Config { config | decoders = Dict.empty }


add : String -> Decoder (Custom msg) -> Config msg -> Config msg
add event decoder (Config config) =
    Config
        { config
            | decoders =
                Dict.update event
                    (Maybe.map ((::) decoder) >> Maybe.withDefault [ decoder ] >> Just)
                    config.decoders
        }


toAttributes : Config msg -> List (Html.Attribute msg)
toAttributes (Config config) =
    case config.lift of
        Just lift ->
            config.decoders
                |> Dict.map (\_ -> flatten)
                |> Dict.toList
                |> List.map
                    (\( event, flatDecoder ) ->
                        Html.Events.custom event (lift flatDecoder)
                    )

        Nothing ->
            config.decoders
                |> Dict.toList
                |> List.concatMap
                    (\( event, decoders ) ->
                        List.map (Html.Events.custom event) decoders
                    )


forward : List msg -> Cmd msg
forward msgs =
    Cmd.batch (List.map (Task.perform identity << Task.succeed) msgs)


flatten : List (Decoder (Custom m)) -> Decoder (Custom (List m))
flatten decoders =
    let
        tryMerge value =
            List.foldl (tryMergeStep value)
                { message = []
                , preventDefault = False
                , stopPropagation = False
                }
                decoders

        tryMergeStep value decoder result =
            Decode.decodeValue decoder value
                |> Result.toMaybe
                |> Maybe.map
                    (\{ message, stopPropagation, preventDefault } ->
                        { message = message :: result.message
                        , stopPropagation = stopPropagation || result.stopPropagation
                        , preventDefault = preventDefault || result.preventDefault
                        }
                    )
                |> Maybe.withDefault result
    in
    Decode.map tryMerge Decode.value
