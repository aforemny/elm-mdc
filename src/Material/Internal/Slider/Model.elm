module Material.Internal.Slider.Model exposing
    ( Msg(..)
    , Geometry
    , defaultGeometry
    )


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
    | Drag { pageX : Float }
    | Up



type alias Geometry =
    { rect : Rect
    , discrete : Bool
    , steps : Maybe Int
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
    , steps = Nothing
    }
