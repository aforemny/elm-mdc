module Internal.Menu.Model
    exposing
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


type alias Model =
    { index : Maybe Int
    , open : Bool
    , animating : Bool
    , geometry : Maybe Geometry
    , quickOpen : Maybe Bool
    , focusedItemAtIndex : Maybe Int
    , keyDownWithinMenu : Bool
    }


defaultModel : Model
defaultModel =
    { index = Nothing
    , open = False
    , animating = False
    , geometry = Nothing
    , quickOpen = Nothing
    , focusedItemAtIndex = Nothing
    , keyDownWithinMenu = False
    }


type Msg m
    = NoOp
    | Init { quickOpen : Bool, index : Maybe Int } Geometry
    | AnimationEnd
    | Open
    | Close
    | Toggle
    | CloseDelayed
    | DocumentClick
    | KeyDown Int Meta Key KeyCode
    | KeyUp Meta Key KeyCode
    | SetFocus Int


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
