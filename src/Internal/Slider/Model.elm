module Internal.Slider.Model exposing
    ( Geometry
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
    }


defaultModel : Model
defaultModel =
    { focus = False
    , active = False
    , geometry = Nothing
    , activeValue = Nothing
    , inTransit = False
    , preventFocus = False
    }


type Msg m
    = NoOp
    | Init Geometry
    | Resize Geometry
    | InteractionStart String { clientX : Float }
    | KeyDown
    | Focus
    | Blur
    | ThumbContainerPointer String { clientX : Float }
    | TransitionEnd
    | Drag { clientX : Float }
    | Up
    | ActualUp


type alias Geometry =
    { rect : Rect
    , discrete : Bool
    , step : Maybe Float
    , min : Float
    , max : Float
    }


type alias Rect =
    { left : Float
    , width : Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { rect = { left = 0, width = 0 }
    , discrete = False
    , min = 0
    , max = 100
    , step = Nothing
    }
