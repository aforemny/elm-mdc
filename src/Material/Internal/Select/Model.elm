module Material.Internal.Select.Model exposing
    ( defaultGeometry
    , defaultModel
    , Geometry
    , Model
    , Msg(..)
    )

import DOM
import Material.Internal.Menu.Model as Menu


type alias Model =
    { menu : Menu.Model
    , geometry : Maybe Geometry
    , index : Maybe Int
    }


defaultModel : Model
defaultModel =
    { menu = Menu.defaultModel
    , geometry = Nothing
    , index = Nothing
    }


type Msg m
    = MenuMsg (Maybe Int) (Menu.Msg m)
    | Init Geometry


type alias Geometry =
    { boundingClientRect : DOM.Rectangle
    , windowInnerHeight : Float
    , menuHeight : Float
    , itemOffsetTops : List Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { boundingClientRect = { top = 0, left = 0, width = 0, height = 0 }
    , windowInnerHeight = 0
    , menuHeight = 0
    , itemOffsetTops = []
    }
