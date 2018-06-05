module Material.Internal.Select.Model exposing
    ( defaultGeometry
    , defaultModel
    , Geometry
    , Model
    , Msg(..)
    )

import DOM
import Material.Internal.Ripple.Model as Ripple


type alias Model =
    { geometry : Maybe Geometry
    , focused : Bool
    , isDirty : Bool
    , value : Maybe String
    , ripple : Ripple.Model
    }


defaultModel : Model
defaultModel =
    { geometry = Nothing
    , focused = False
    , isDirty = False
    , value = Nothing
    , ripple = Ripple.defaultModel
    }


type Msg m
    = Blur
    | Focus Geometry
    | Input String
    | NoOp
    | RippleMsg Ripple.Msg


type alias Geometry =
    { boundingClientRect : DOM.Rectangle
    , windowInnerHeight : Float
    , itemOffsetTops : List Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { boundingClientRect = { top = 0, left = 0, width = 0, height = 0 }
    , windowInnerHeight = 0
    , itemOffsetTops = []
    }
