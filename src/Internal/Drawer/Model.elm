module Internal.Drawer.Model
    exposing
        ( Geometry
        , Model
        , Msg(..)
        , defaultGeometry
        , defaultModel
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
    | SetOpen ( Bool, Bool )


type alias Geometry =
    { width : Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { width = 0
    }
