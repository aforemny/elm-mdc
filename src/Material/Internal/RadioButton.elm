module Material.Internal.RadioButton exposing (Msg(..))

import Material.Internal.Ripple as Ripple


type Msg
    = RippleMsg Ripple.Msg
    | NoOp
    | SetFocus Bool
