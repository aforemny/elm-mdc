module Internal.Dialog.Model
    exposing
        ( Model
        , Msg(..)
        , defaultModel
        )


type alias Model =
    { animating : Bool
    , open : Bool
    }


defaultModel : Model
defaultModel =
    { animating = False
    , open = False
    }


type Msg
    = NoOp
    | SetState Bool
    | SetOpen Bool
    | AnimationEnd
