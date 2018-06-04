module Internal.GridList.Model exposing
    ( defaultGeometry
    , defaultModel
    , Geometry
    , Model
    , Msg(..)
    )


type alias Model =
    { configured : Bool
    , geometry : Maybe Geometry
    , resizing : Bool
    , lastResize : Int
    , requestAnimationFrame : Bool
    }


defaultModel : Model
defaultModel =
    { configured = False
    , geometry = Nothing
    , resizing = False
    , lastResize = 0
    , requestAnimationFrame = True
    }


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
