module Material.Internal.Toolbar exposing (Msg(..), Geometry, defaultGeometry, Config, defaultConfig)

type Msg
    = Init Config Geometry
    | Resize Config Geometry
    | Scroll Config Float


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


type alias Config =
    { fixed : Bool
    , fixedLastrow : Bool
    , fixedLastRowOnly : Bool
    , flexible : Bool
    , useFlexibleDefaultBehavior : Bool
    , waterfall : Bool
    , backgroundImage : Maybe String
    }


defaultConfig : Config
defaultConfig =
    { fixed = False
    , fixedLastrow = False
    , fixedLastRowOnly = False
    , flexible = False
    , useFlexibleDefaultBehavior = False
    , waterfall = False
    , backgroundImage = Nothing
    }
