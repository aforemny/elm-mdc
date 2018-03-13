module Material.Internal.Ripple.Model exposing
    ( Msg(..)
    , Geometry
    , defaultGeometry
    )

import DOM exposing (Rectangle)


type Msg
    = Focus
    | Blur
    | Activate String (Maybe Bool) Geometry
    | Deactivate String
    | AnimationEnd String Int


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
