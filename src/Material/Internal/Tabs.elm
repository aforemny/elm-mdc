module Material.Internal.Tabs exposing (Msg(..), Geometry, defaultGeometry)

import Material.Internal.Ripple as Ripple


type Msg m
    = Select Int Geometry
    | Dispatch (List m)
    | ScrollForward Geometry
    | ScrollBackward Geometry
    | RippleMsg Int Ripple.Msg
    | Init Geometry
    | Resize
    | AnimationFrame


type alias Geometry =
    { tabs : List { offsetLeft : Float, width : Float }
    , scrollFrame : { width : Float }
    }


defaultGeometry : Geometry
defaultGeometry =
    { tabs = []
    , scrollFrame = { width = 0 }
    }
