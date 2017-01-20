module Material.Internal.Tooltip exposing (Msg(..), DOMState, defaultDOMState)

import DOM


type Msg
    = Enter DOMState
    | Leave


{-| Position and offsets from dom events for the tooltip
-}
type alias DOMState =
    { rect : DOM.Rectangle
    , offsetWidth : Float
    , offsetHeight : Float
    }


{-| Default DOMState constructor
-}
defaultDOMState : DOMState
defaultDOMState =
    { rect = { left = 0, top = 0, width = 0, height = 0 }
    , offsetWidth = 0
    , offsetHeight = 0
    }
