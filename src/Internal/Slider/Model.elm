module Internal.Slider.Model exposing
    ( Model
    , Msg(..)
    , defaultModel
    )


import Browser.Dom as Dom


type alias Model =
    { initialized : Bool
    , focus : Bool
    , active : Bool
    , activeValue : Maybe Float
    , inTransit : Bool
    , preventFocus : Bool
    , min : Float
    , max : Float
    , step : Float
    , left : Float
    , width : Float
    }


defaultModel : Model
defaultModel =
    { initialized = False
    , focus = False
    , active = False
    , activeValue = Nothing
    , inTransit = False
    , preventFocus = False
    , min = 0
    , max = 100
    , step = 1
    , left = 0
    , width = 0
    }


type Msg m
    = NoOp
    | Init String Float Float Float
    | Resize String Float Float Float
    | RequestSliderDimensions String (Float -> Msg m) Float
    | GotSliderDimensions (Float -> Msg m) Float Dom.Element
    | InteractionStart Float
    | KeyDown
    | Focus
    | Blur
    | ThumbContainerPointer Float
    | TransitionEnd
    | Drag Float
    | Up
    | ActualUp
    | GotElement Dom.Element
