module Material.Internal.Tabs exposing (Msg(..), Geometry, defaultGeometry)


type Msg m
    = Select Int Geometry
    | Dispatch (List m)
    | ScrollForward Geometry
    | ScrollBackward Geometry
    | Init Geometry


type alias Geometry =
    { tabs : List { offsetLeft : Float, width : Float }
    , scrollFrame : { width : Float }
    }


defaultGeometry : Geometry
defaultGeometry =
    { tabs = []
    , scrollFrame = { width = 0 }
    }
