module Material.Internal.Ripple exposing (Msg(..), Geometry, defaultGeometry)


import DOM exposing (Rectangle)


type Msg
    = Focus Geometry
    | Blur
    | Activate Geometry
    | Deactivate


type alias Geometry =
    { isSurfaceDisabled : Bool
    , event : { type_ : String, pageX : Float, pageY : Float }
    , frame : Rectangle
    }


defaultGeometry : Geometry
defaultGeometry =
    { isSurfaceDisabled = False
    , event = { type_ = "", pageX = 0, pageY = 0 }
    , frame = { width = 0, height = 0, left = 0, top = 0 }
    }
