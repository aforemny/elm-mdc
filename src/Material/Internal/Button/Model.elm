module Material.Internal.Button.Model exposing (Msg(..))

import Material.Internal.Ripple.Model as Ripple


type Msg =
    RippleMsg Ripple.Msg
