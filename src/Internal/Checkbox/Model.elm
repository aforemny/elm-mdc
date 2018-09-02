module Internal.Checkbox.Model
    exposing
        ( Animation(..)
        , Model
        , Msg(..)
        , State(..)
        , defaultModel
        )


type alias Model =
    { isFocused : Bool
    , lastKnownState : Maybe (Maybe State)
    , animation : Maybe Animation
    }


defaultModel : Model
defaultModel =
    { isFocused = False
    , lastKnownState = Nothing
    , animation = Nothing
    }


type Msg
    = NoOp
    | Init (Maybe (Maybe State)) (Maybe State)
    | SetFocus Bool
    | AnimationEnd


type State
    = Checked
    | Unchecked


type Animation
    = UncheckedChecked
    | UncheckedIndeterminate
    | CheckedUnchecked
    | CheckedIndeterminate
    | IndeterminateChecked
    | IndeterminateUnchecked
