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
    }


defaultModel : Model
defaultModel =
    { open = False
    , state = Nothing
    , animating = False
    }


type Msg
    = NoOp
    | Tick
    | SetOpen ( Bool )
    | SetClose


type alias Geometry =
    { width : Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { width = 0
    }
