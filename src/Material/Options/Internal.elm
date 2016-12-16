module Material.Options.Internal exposing (..)

import Html


{-| Internal type of properties. Do not use directly; use constructor functions
   in the Options module or `attribute` instead.
-}
type Property c m
    = Class String
    | CSS ( String, String )
    | Attribute (Html.Attribute m)
    | Internal (Html.Attribute m)
    | Many (List (Property c m))
    | Set (c -> c)
    | None


{-| We've seen examples of users inadverdently overriding event handlers / html
classes / css styling with this function, causing malfunctions in the library.
So we hide it away here.
-}
attribute : Html.Attribute m -> Property c m
attribute =
    Internal
