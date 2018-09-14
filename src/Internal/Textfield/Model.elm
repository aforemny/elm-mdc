module Internal.Textfield.Model
    exposing
        ( Geometry
        , Model
        , Msg(..)
        , defaultGeometry
        , defaultModel
        )


type alias Model =
    { focused : Bool
    , isDirty : Bool
    , value : Maybe String
    , geometry : Maybe Geometry
    }


defaultModel : Model
defaultModel =
    { focused = False
    , isDirty = False
    , value = Nothing
    , geometry = Nothing
    }


type Msg
    = Blur
    | Focus Geometry
    | Input String
    | NoOp


type alias Geometry =
    { width : Float
    , height : Float
    , labelWidth : Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { width = 0
    , height = 0
    , labelWidth = 0
    }
