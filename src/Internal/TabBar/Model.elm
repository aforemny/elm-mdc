module Internal.TabBar.Model exposing
    ( Geometry
    , Model
    , Msg(..)
    , Tab
    , defaultGeometry
    , defaultModel
    )

import Dict exposing (Dict)
import Internal.Ripple.Model as Ripple


type alias Model =
    { geometry : Maybe Geometry
    , translateOffset : Float
    , ripples : Dict Int Ripple.Model
    , activeTab : Int
    }


defaultModel : Model
defaultModel =
    { geometry = Nothing
    , translateOffset = 0
    , ripples = Dict.empty
    , activeTab = 0
    }


type Msg m
    = NoOp
    | Dispatch (List m)
    | RippleMsg Int Ripple.Msg
    | Init Geometry
    | SetActiveTab String Int Float


type alias Tab =
    { offsetLeft : Float
    , offsetWidth : Float
    , contentLeft : Float
    , contentRight : Float
    }


type alias Geometry =
    { tabs : List Tab
    , scrollArea : { offsetWidth : Float }
    , tabBar : { offsetWidth : Float }
    }


defaultGeometry : Geometry
defaultGeometry =
    { tabs = []
    , scrollArea = { offsetWidth = 0 }
    , tabBar = { offsetWidth = 0 }
    }
