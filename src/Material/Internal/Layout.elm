module Material.Internal.Layout exposing (Msg(..), TabScrollState)

import Material.Internal.Ripple as Ripple


type Msg
    = ToggleDrawer
    | Resize Int
    | ScrollTab TabScrollState
    | ScrollPane Bool Float
      -- True means fixedHeader
    | TransitionHeader { toCompact : Bool, fixedHeader : Bool }
    | TransitionEnd
    | NOP
      -- Subcomponents
    | Ripple Int Ripple.Msg


type alias TabScrollState =
    { canScrollLeft : Bool
    , canScrollRight : Bool
    , width : Maybe Int
    }
