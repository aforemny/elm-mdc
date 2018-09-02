module Internal.GridList.Model
    exposing
        ( Geometry
        , Model
        , Msg(..)
        , defaultGeometry
        , defaultModel
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
