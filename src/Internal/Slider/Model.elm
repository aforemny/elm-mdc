module Internal.Slider.Model exposing
    ( Geometry
    , Rect
    , Model
    , Msg(..)
    , defaultGeometry
    , defaultModel
    )


import Browser.Dom as Dom


type alias Model =
    { focus : Bool
    , active : Bool
    , geometry : Maybe Geometry
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
    { focus = False
    , active = False
    , geometry = Nothing
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
    | Init String Float Float Float Geometry
    | Resize String Float Float Float Geometry
    | RequestSliderDimensions String (Float -> Msg m) Float
    | GotSliderDimensions Dom.Element (Float -> Msg m) Float
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


type alias Geometry =
    { rect : Rect
    }


type alias Rect =
    { left : Float
    , width : Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { rect = { left = 0, width = 0 }
    }
