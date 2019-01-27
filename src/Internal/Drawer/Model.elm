module Internal.Drawer.Model exposing
    ( Geometry
    , Model
    , Msg(..)
    , defaultGeometry
    , defaultModel
    )


type alias Model =
    { open : Bool
    , animating : Bool
    , closeOnAnimationEnd : Bool
    }


defaultModel : Model
defaultModel =
    { open = False
    , animating = False
    , closeOnAnimationEnd = False
    }


type Msg
    = NoOp
    | StartAnimation Bool
    | EndAnimation


type alias Geometry =
    { width : Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { width = 0
    }
