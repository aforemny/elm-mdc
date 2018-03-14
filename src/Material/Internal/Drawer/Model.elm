module Material.Internal.Drawer.Model exposing
    ( defaultGeometry
    , defaultModel
    , Geometry
    , Model
    , Msg(..)
    )


type alias Model =
    { open : Bool
    , state : Maybe Bool
    , animating : Bool
    , persistent : Bool
    }


defaultModel : Model
defaultModel =
    { open = False
    , state = Nothing
    , animating = False
    , persistent = False
    }


type Msg
    = NoOp
    | Tick
    | Click

    | Open Bool
    | Close
    | Toggle Bool


type alias Geometry =
    { width : Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { width = 0
    }
