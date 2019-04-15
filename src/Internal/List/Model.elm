module Internal.List.Model exposing
    ( Model
    , Msg(..)
    , defaultModel
    )

import Dict exposing (Dict)
import Internal.Ripple.Model as Ripple


type alias Model =
    { ripples : Dict Int Ripple.Model
    }


defaultModel : Model
defaultModel =
    { ripples = Dict.empty
    }


type Msg m
    = NoOp
    | RippleMsg Int Ripple.Msg
