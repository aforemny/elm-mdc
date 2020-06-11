module Internal.Keyboard exposing
    ( Meta
    , Key
    , KeyCode
    , defaultMeta
    , decodeMeta
    , decodeKey
    , decodeKeyCode
    , arrowLeft
    , arrowRight
    , enter
    )


{-| Helper module for keyboard events decoding.
-}


import Json.Decode as Decode exposing (Decoder)
import Html.Events as Html


type alias Meta =
    { altKey : Bool
    , ctrlKey : Bool
    , metaKey : Bool
    , shiftKey : Bool
    }


defaultMeta : Meta
defaultMeta =
    { altKey = False
    , ctrlKey = False
    , metaKey = False
    , shiftKey = False
    }


type alias Key =
    String


type alias KeyCode =
    Int


decodeMeta : Decoder Meta
decodeMeta =
    Decode.map4
        (\altKey ctrlKey metaKey shiftKey ->
            { altKey = altKey
            , ctrlKey = ctrlKey
            , metaKey = metaKey
            , shiftKey = shiftKey
            }
        )
        (Decode.at [ "altKey" ] Decode.bool)
        (Decode.at [ "ctrlKey" ] Decode.bool)
        (Decode.at [ "metaKey" ] Decode.bool)
        (Decode.at [ "shiftKey" ] Decode.bool)


decodeKey : Decoder Key
decodeKey =
    Decode.at [ "key" ] Decode.string


decodeKeyCode : Decoder KeyCode
decodeKeyCode =
    Html.keyCode


{-| List of known keys.

-}
arrowRight =
    ( 39, "ArrowRight" )

arrowLeft =
    ( 37, "ArrowLeft" )

enter =
    ( 13, "Enter" )
