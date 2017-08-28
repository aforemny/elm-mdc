module Material.Internal.Textfield exposing (Msg(..))

import Material.Internal.Ripple as Ripple


type Msg
    = Blur
    | Focus
    | Input String
    | NoOp
    | RippleMsg Ripple.Msg
