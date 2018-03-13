module Material.Internal.Snackbar.Model exposing
    ( Msg(..)
    , Transition(..)
    )


type Msg m
    = Move Int Transition
    | Dismiss Bool (Maybe m)


type Transition
    = Timeout
    | Clicked
