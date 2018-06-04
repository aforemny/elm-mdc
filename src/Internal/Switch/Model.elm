module Internal.Switch.Model exposing
    ( defaultModel
    , Model
    , Msg(..)
    )


type alias Model =
    { isFocused : Bool
    }


defaultModel : Model
defaultModel =
    { isFocused = False
    }


type Msg
    = SetFocus Bool
    | NoOp
