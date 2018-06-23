module Internal.Chip.Model exposing (Key, KeyCode, Model, Msg(..), defaultModel)

import Internal.Ripple.Model as Ripple


type alias Model =
    { ripple : Ripple.Model
    }


defaultModel : Model
defaultModel =
    { ripple = Ripple.defaultModel
    }


type alias Key =
    String


type alias KeyCode =
    Int


type Msg m
    = RippleMsg Ripple.Msg
    | Click m
