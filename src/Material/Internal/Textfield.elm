module Material.Internal.Textfield exposing (Msg(..), Geometry, defaultGeometry)

import Material.Internal.Ripple as Ripple


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
