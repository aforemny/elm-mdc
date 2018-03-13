module Material.Internal.Checkbox.Model exposing
    ( Msg(..)
    , Animation(..)
    , State(..)
    )


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
