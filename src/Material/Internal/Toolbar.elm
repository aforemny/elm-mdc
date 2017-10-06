module Material.Internal.Toolbar exposing (Msg(..), Geometry, defaultGeometry)

type Msg
    = NoOp
    | Init Geometry


type alias Geometry =
    { getRowHeight : Float
    , getFirstRowElementOffsetHeight : Float
    , getOffsetHeight : Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { getRowHeight = 0
    , getFirstRowElementOffsetHeight = 0
    , getOffsetHeight = 0
    }
