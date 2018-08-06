module Internal.Tabs.Model
    exposing
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
    , index : Int
    , translateOffset : Float
    , scale : Float
    , ripples : Dict Int Ripple.Model
    , indicatorShown : Bool
    , forwardIndicator : Bool
    , backIndicator : Bool
    , scrollLeftAmount : Int
    }


defaultModel : Model
defaultModel =
    { geometry = Nothing
    , index = 0
    , translateOffset = 0
    , scale = 0
    , ripples = Dict.empty
    , indicatorShown = False
    , forwardIndicator = False
    , backIndicator = False
    , scrollLeftAmount = 0
    }


type Msg m
    = NoOp
    | Dispatch (List m)
    | Select Int Geometry
    | ScrollForward Geometry
    | ScrollBack Geometry
    | RippleMsg Int Ripple.Msg
    | Init Geometry
    | SetIndicatorShown
    | Focus Int Geometry


type alias Geometry =
    { tabs : List { offsetLeft : Float, offsetWidth : Float }
    , tabBar : { offsetWidth : Float }
    , scrollFrame : { offsetWidth : Float }
    }


defaultGeometry : Geometry
defaultGeometry =
    { tabs = []
    , tabBar = { offsetWidth = 0 }
    , scrollFrame = { offsetWidth = 0 }
    }
