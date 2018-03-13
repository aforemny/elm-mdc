module Material.Component exposing
    ( Index
    , Indexed
    )

{-|
@docs Indexed, Index
-}

import Material.Internal.Component


{-| -}
type alias Indexed a =
    Material.Internal.Component.Indexed a


{-| -}
type alias Index
    = Material.Internal.Component.Index
