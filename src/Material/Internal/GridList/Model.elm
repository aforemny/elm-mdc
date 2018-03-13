module Material.Internal.GridList.Model exposing
    ( Msg(..)
    , Geometry
    , defaultGeometry
    )


type Msg m
    = Init Geometry


type alias Geometry =
    { width : Float
    , tileWidth : Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { width = 0
    , tileWidth = 0
    }
