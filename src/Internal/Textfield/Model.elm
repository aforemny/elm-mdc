module Internal.Textfield.Model
    exposing
        ( Geometry
        , Model
        , Msg(..)
        , defaultGeometry
        , defaultModel
        )

import Internal.Ripple.Model as Ripple


type alias Model =
    { focused : Bool
    , isDirty : Bool
    , value : Maybe String
    , ripple : Ripple.Model
    , geometry : Maybe Geometry
    }


defaultModel : Model
defaultModel =
    { focused = False
    , isDirty = False
    , value = Nothing
    , ripple = Ripple.defaultModel
    , geometry = Nothing
    }


type Msg
    = Blur
    | Focus Geometry
    | Input String
    | NoOp
    | RippleMsg Ripple.Msg


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
