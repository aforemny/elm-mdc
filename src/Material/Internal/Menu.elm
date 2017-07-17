module Material.Internal.Menu exposing
    (
      Msg(..)

    , KeyCode
    , Key
    , Meta
    , defaultMeta

    , Geometry
    , defaultGeometry
    )

import Mouse


{-| TODO
-}
type Msg m
    = Toggle Geometry
    | Open Geometry
    | Close Geometry
    | Tick Float
    | Click Mouse.Position
    | KeyDown Meta Key KeyCode
    | KeyUp Meta Key KeyCode


type alias Meta =
    { altKey : Bool
    , ctrlKey : Bool
    , metaKey : Bool
    , shiftKey : Bool
    }


defaultMeta : Meta
defaultMeta =
    { altKey = False
    , ctrlKey = False
    , metaKey = False
    , shiftKey = False
    }


type alias Key =
    String


type alias KeyCode =
    Int


type alias Geometry =
    { itemsContainer : { width : Float, height : Float }
    , itemGeometries : List ({ top : Float, height : Float })
    , adapter : { isRtl : Bool }
    , anchor : { top : Float, left : Float, bottom : Float, right : Float }
    , window : { width : Float, height : Float }
    }


defaultGeometry : Geometry
defaultGeometry =
    { itemsContainer = { width = 0, height = 0 }
    , itemGeometries = []
    , adapter = { isRtl = False }
    , anchor = { top = 0, left = 0, bottom = 0, right = 0 }
    , window = { width = 800, height = 600 }
    }
