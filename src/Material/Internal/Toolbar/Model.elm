module Material.Internal.Toolbar.Model exposing
    ( Calculations
    , Config
    , Geometry
    , Model
    , Msg(..)
    )


type alias Model =
    { geometry : Maybe Geometry
    , scrollTop : Float
    , calculations : Maybe Calculations
    , config : Maybe Config
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


type alias Config =
    { fixed : Bool
    , fixedLastrow : Bool
    , fixedLastRowOnly : Bool
    , flexible : Bool
    , useFlexibleDefaultBehavior : Bool
    , waterfall : Bool
    , backgroundImage : Maybe String
    }


type alias Geometry =
    { getRowHeight : Float
    , getFirstRowElementOffsetHeight : Float
    , getOffsetHeight : Float
    }


type Msg
    = Init Config Geometry
    | Resize Config Geometry
    | Scroll Config Float
