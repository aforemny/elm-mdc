module Material.Internal.Fab exposing (Msg(..))

import Material.Internal.Ripple as Ripple

type Msg
    = RippleMsg Ripple.Msg
    | NoOp
