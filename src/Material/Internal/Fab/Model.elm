module Material.Internal.Fab.Model exposing
    ( Msg(..)
    )

import Material.Internal.Ripple.Model as Ripple


type Msg
    = RippleMsg Ripple.Msg
    | NoOp
