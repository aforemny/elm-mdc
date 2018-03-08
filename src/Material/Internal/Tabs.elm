module Material.Internal.Tabs exposing (Msg(..), Geometry, defaultGeometry)

import Material.Internal.Ripple as Ripple


type Msg m
    = NoOp
    | Dispatch (List m)
    | Select Int Geometry
    | ScrollForward Geometry
    | ScrollBack Geometry
    | RippleMsg Int Ripple.Msg
    | Init Geometry
    | SetIndicatorShown
    | Focus Int Geometry


type alias Geometry =
    { tabs : List { offsetLeft : Float, offsetWidth : Float }
    , tabBar : { offsetWidth : Float }
    , scrollFrame : { offsetWidth : Float }
    }


defaultGeometry : Geometry
defaultGeometry =
    { tabs = []
    , tabBar = { offsetWidth = 0 }
    , scrollFrame = { offsetWidth = 0 }
    }
