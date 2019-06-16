module Internal.Menu.Model exposing
    ( Geometry
    , Key
    , KeyCode
    , Meta
    , Model
    , Msg(..)
    , Viewport
    , defaultGeometry
    , defaultMeta
    , defaultModel
    )

import Internal.List.Model as Lists


type alias Model =
    { index : Maybe Int
    , open : Bool
    , animating : Bool
    , geometry : Maybe Geometry
    , quickOpen : Maybe Bool
    , list : Lists.Model
    , keyDownWithinMenu : Bool
    }


defaultModel : Model
defaultModel =
    { index = Nothing
    , open = False
    , animating = False
    , geometry = Nothing
    , quickOpen = Nothing
    , list = Lists.defaultModel
    , keyDownWithinMenu = False
    }


type Msg m
    = NoOp
    | Init { quickOpen : Bool, index : Maybe Int, focusedItemId : String } Geometry
    | AnimationEnd
    | Open
    | Close
    | Toggle
    | CloseDelayed
    | DocumentClick
    | KeyDown Meta Key KeyCode
    | KeyUp Meta Key KeyCode
    | ListMsg (Lists.Msg m)


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
    { viewport : Viewport
    , viewportDistance : ViewportDistance
    , anchor : { width : Float, height : Float }
    , menu : { width : Float, height : Float }
    }


type alias Viewport =
    { width : Float
    , height : Float
    }


type alias ViewportDistance =
    { top : Float
    , right : Float
    , left : Float
    , bottom : Float
    }


defaultGeometry : Geometry
defaultGeometry =
    { viewport = { width = 0, height = 0 }
    , viewportDistance = { top = 0, right = 0, left = 0, bottom = 0 }
    , anchor = { width = 0, height = 0 }
    , menu = { width = 0, height = 0 }
    }
