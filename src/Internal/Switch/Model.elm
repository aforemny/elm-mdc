module Internal.Switch.Model
    exposing
        ( Model
        , Msg(..)
        , defaultModel
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
