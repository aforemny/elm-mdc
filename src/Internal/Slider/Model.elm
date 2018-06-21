module Internal.Slider.Model exposing
    ( defaultGeometry
    , defaultModel
    , Geometry
    , Model
    , Msg(..)
    , XY
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


type alias XY = { pageX : Float, pageY : Float }

type Msg m
    = NoOp
    | Init Geometry
    | Resize Geometry
    | InteractionStart String { pageX : Float }
    | KeyDown
    | Focus
    | Blur
    | ThumbContainerPointer String { pageX : Float }
    | TransitionEnd
    | Drag XY
    | Up


type alias Geometry =
    { rect : Rect
    , discrete : Bool
    , step : Maybe Float
    , min : Float
    , max : Float
    }


type alias Rect =
    { left : Float
    , top : Float
    , width : Float
    , height : Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { rect = { left = 0, top = 0, width = 0, height = 0 }
    , discrete = False
    , min = 0
    , max = 100
    , step = Nothing
    }
