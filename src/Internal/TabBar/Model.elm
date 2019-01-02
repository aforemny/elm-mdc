module Internal.TabBar.Model exposing
    ( Geometry
    , Model
    , Msg(..)
    , defaultGeometry
    , defaultModel
    )

import Dict exposing (Dict)
import Internal.Ripple.Model as Ripple


type alias Model =
    { geometry : Maybe Geometry
    , translateOffset : Float
    , ripples : Dict Int Ripple.Model
    , indicatorShown : Bool
    , forwardIndicator : Bool
    , backIndicator : Bool
    , scrollLeftAmount : Int
    , activeTab : Int
    }


defaultModel : Model
defaultModel =
    { geometry = Nothing
    , translateOffset = 0
    , ripples = Dict.empty
    , indicatorShown = False
    , forwardIndicator = False
    , backIndicator = False
    , scrollLeftAmount = 0
    , activeTab = 0
    }


type Msg m
    = NoOp
    | Dispatch (List m)
    | Select Geometry
    | ScrollForward Geometry
    | ScrollBack Geometry
    | RippleMsg Int Ripple.Msg
    | Init Geometry
    | SetIndicatorShown
    | Focus Int Geometry
    | SetActiveTab Int


type alias Geometry =
    { tabs : List { offsetLeft : Float, offsetWidth : Float }
    , tabBar : { offsetWidth : Float }
    , scrollFrame : { offsetWidth : Float }
    }


defaultGeometry : Geometry
defaultGeometry =
    { tabs = []
    , scrollFrame = { offsetWidth = 0 }
    , tabBar = { offsetWidth = 0 }
    }
