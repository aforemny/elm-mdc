module Material.Internal.Select exposing (Msg(..))

import Material.Internal.Menu as Menu


{-| TODO
-}
type Msg m
    = MenuMsg (Menu.Msg m)
