module Internal.Toolbar.Model
    exposing
        ( Calculations
        , Config
        , Geometry
        , Model
        , Msg(..)
        , defaultCalculations
        , defaultConfig
        , defaultGeometry
        , defaultModel
        )


type alias Model =
    { geometry : Maybe Geometry
    , scrollTop : Float
    , calculations : Maybe Calculations
    , config : Maybe Config
    }


defaultModel : Model
defaultModel =
    { geometry = Nothing
    , scrollTop = 0
    , calculations = Nothing
    , config = Nothing
    }


type alias Calculations =
    { toolbarRowHeight : Float
    , toolbarRatio : Float
    , flexibleExpansionRatio : Float
    , maxTranslateYRatio : Float
    , scrollThresholdRatio : Float
    , toolbarHeight : Float
    , flexibleExpansionHeight : Float
    , maxTranslateYDistance : Float
    , scrollThreshold : Float
    }


defaultCalculations : Calculations
defaultCalculations =
    { toolbarRowHeight = 0
    , toolbarRatio = 0
    , flexibleExpansionRatio = 0
    , maxTranslateYRatio = 0
    , scrollThresholdRatio = 0
    , toolbarHeight = 0
    , flexibleExpansionHeight = 0
    , maxTranslateYDistance = 0
    , scrollThreshold = 0
    }


type Msg
    = Init Config Geometry
    | Resize Config Geometry
    | Scroll Config Float


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
