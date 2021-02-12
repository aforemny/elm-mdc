module Internal.Slider.Model exposing
    ( Model
    , Msg(..)
    , defaultModel
    )


import Browser.Dom as Dom
import Internal.Ripple.Model as Ripple


type alias Model =
    { ripple : Ripple.Model
    , initialized : Bool
    , dragStarted : Bool
    , showThumbIndicator : Bool
    , min : Float
    , max : Float
    , step : Float
    , left : Float
    , width : Float
    }


defaultModel : Model
defaultModel =
    { ripple = Ripple.defaultModel
    , initialized = False
    , dragStarted = False
    , showThumbIndicator = False
    , min = 0
    , max = 100
    , step = 1
    , left = 0
    , width = 0
    }


type Msg m
    = NoOp
    | RippleMsg Ripple.Msg
    | Init String Float Float Float
    | Resize String Float Float Float
    | DragStart String (Float -> m) Float
    | Focus
    | Blur
    | Up
    | ActualUp
    | GotElement Dom.Element
