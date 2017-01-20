module Material.Internal.Ripple exposing (Msg(..), DOMState)


import DOM


type Msg
    = Down DOMState
    | Up
    | Tick


type alias DOMState =
    { rect : DOM.Rectangle
    , clientX : Maybe Float
    , clientY : Maybe Float
    , touchX : Maybe Float
    , touchY : Maybe Float
    , type_ : String
    }
