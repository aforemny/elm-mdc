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
    }


defaultModel : Model
defaultModel =
    { menu = Menu.defaultModel
    , geometry = Nothing
    }


type Msg m
    = MenuMsg (Menu.Msg m)
    | Init Geometry


type alias Geometry =
    { windowInnerHeight : Float
    , boundingClientRect : DOM.Rectangle
    , menuHeight : Float
    , itemOffsetTops : List Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { windowInnerHeight = 0
    , boundingClientRect = { top = 0, left = 0, width = 0, height = 0 }
    , menuHeight = 0
    , itemOffsetTops = []
    }
