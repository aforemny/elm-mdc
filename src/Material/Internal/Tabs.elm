module Material.Internal.Tabs exposing (Msg(..))

import Material.Internal.Ripple as Ripple


type Msg
    = Ripple Int Ripple.Msg
