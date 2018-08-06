module Internal.Ripple.Model
    exposing
        ( Geometry
        , Model
        , Msg(..)
        , defaultGeometry
        , defaultModel
        )

import DOM exposing (Rectangle)


type alias Model =
    { focus : Bool
    , active : Bool
    , animating : Bool
    , deactivation : Bool
    , geometry : Geometry
    , animation : Int
    }


defaultModel : Model
defaultModel =
    { focus = False
    , active = False
    , animating = False
    , deactivation = False
    , geometry = defaultGeometry
    , animation = 0
    }


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
