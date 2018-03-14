module Material.Internal.Dialog.Model exposing
    ( defaultModel
    , Model
    , Msg(..)
    )


type alias Model =
    { open : Bool
    , animating : Bool
    }


defaultModel : Model
defaultModel =
    { open = False
    , animating = False
    }


type Msg
    = NoOp
    | Open
    | Close
    | AnimationEnd
