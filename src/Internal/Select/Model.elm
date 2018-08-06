module Internal.Select.Model
    exposing
        ( Model
        , Msg(..)
        , defaultModel
        )

import Internal.Ripple.Model as Ripple


type alias Model =
    { focused : Bool
    , isDirty : Bool
    , ripple : Ripple.Model
    }


defaultModel : Model
defaultModel =
    { focused = False
    , isDirty = False
    , ripple = Ripple.defaultModel
    }


type Msg m
    = Blur
    | Focus
    | Change String
    | RippleMsg Ripple.Msg
