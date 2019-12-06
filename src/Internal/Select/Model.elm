module Internal.Select.Model exposing
    ( Model
    , Msg(..)
    , defaultModel
    )

import Internal.Keyboard as Keyboard exposing (Key, KeyCode)
import Internal.Menu.Model as Menu
import Internal.Ripple.Model as Ripple


type alias Model =
    { focused : Bool
    , isDirty : Bool
    , ripple : Ripple.Model
    , menu : Menu.Model
    }


defaultModel : Model
defaultModel =
    { focused = False
    , isDirty = False
    , ripple = Ripple.defaultModel
    , menu = Menu.defaultModel
    }


type Msg m
    = NoOp
    | Blur
    | Focus
    | Change String
    | RippleMsg Ripple.Msg
    | KeyDown String Key KeyCode
    | OpenMenu String
    | ToggleMenu
    | MenuSelection String (String -> m) String
    | MenuMsg (Menu.Msg m)
