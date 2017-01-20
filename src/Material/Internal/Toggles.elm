module Material.Internal.Toggles exposing (Msg(..))

import Material.Internal.Ripple as Ripple


type Msg
    = Ripple Ripple.Msg
    | SetFocus Bool
