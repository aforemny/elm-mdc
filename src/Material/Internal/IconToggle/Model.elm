module Material.Internal.IconToggle.Model exposing
    ( defaultModel
    , Model
    , Msg(..)
    )

import Material.Internal.Ripple.Model as Ripple


type alias Model =
    { on : Bool
    , ripple : Ripple.Model
    }


defaultModel : Model
defaultModel =
    { on = False
    , ripple = Ripple.defaultModel
    }


type Msg
    = RippleMsg Ripple.Msg
