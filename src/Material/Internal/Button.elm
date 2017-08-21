module Material.Internal.Button exposing (Msg(..))

import Material.Internal.Ripple as Ripple


type Msg =
    RippleMsg Ripple.Msg
