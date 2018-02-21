module Material.Internal.Checkbox exposing (Msg(..), Animation(..), State)


type Msg
    = NoOp
    | Init (Maybe State) State
    | SetFocus Bool
    | AnimationEnd


type alias State =
    { checked : Bool
    , indeterminate : Bool
    }


type Animation
  = UncheckedChecked
  | UncheckedIndeterminate
  | CheckedUnchecked
  | CheckedIndeterminate
  | IndeterminateChecked
  | IndeterminateUnchecked
