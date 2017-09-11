module Material.Internal.GridList exposing (Msg(..), Geometry, defaultGeometry)

type Msg m
    = Resize
    | ResizeDone Int
    | Configure Geometry
    | AnimationFrame


type alias Geometry =
    { width : Float
    , tileWidth : Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { width = 0
    , tileWidth = 0
    }
