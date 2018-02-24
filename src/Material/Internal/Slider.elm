module Material.Internal.Slider exposing (Msg(..), Geometry, defaultGeometry)


type Msg m
    = NoOp
    | Focus
    | Blur
    | Activate Bool Geometry
    | Drag Geometry
    | Up
    | Tick
    | Dispatch (List m)
    | Init Geometry


type alias Geometry =
    { width : Float
    , left : Float
    , x : Float

    , discrete : Bool
    , steps : Maybe Int
    , min : Float
    , max : Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { width = 0
    , left = 0
    , x = 0

    , discrete = False
    , min = 0
    , max = 100
    , steps = Nothing
    }
