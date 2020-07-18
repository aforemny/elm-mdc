module Internal.Slider.Model exposing
    ( Geometry
    , Rect
    , Model
    , Msg(..)
    , defaultGeometry
    , defaultModel
    )


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
    }


type Msg m
    = NoOp
    | Init Float Float Float Geometry
    | Resize Float Float Float Geometry
    | InteractionStart { clientX : Float }
    | KeyDown
    | Focus
    | Blur
    | ThumbContainerPointer { clientX : Float }
    | TransitionEnd
    | Drag { clientX : Float }
    | Up
    | ActualUp


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
