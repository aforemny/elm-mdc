module Material.Internal.Dispatch exposing (Config(..))


import Html.Events
import Json.Decode exposing (Decoder)


type Config msg =
  Config
    { decoders : List (String, (Decoder msg, Maybe Html.Events.Options))
    , lift : Maybe (Decoder (List msg) -> Decoder msg)
    }
