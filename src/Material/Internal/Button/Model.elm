module Material.Internal.Button.Model exposing (Model, defaultModel, Msg(..))

import Material.Internal.Ripple.Model as Ripple


type alias Model =
    { ripple : Ripple.Model
    }


defaultModel : Model
defaultModel =
    { ripple = Ripple.defaultModel
    }


type Msg =
    RippleMsg Ripple.Msg
