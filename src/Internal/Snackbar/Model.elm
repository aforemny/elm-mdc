module Internal.Snackbar.Model exposing
    ( Contents
    , Model
    , Msg(..)
    , State(..)
    , Transition(..)
    , defaultModel
    )


type alias Model m =
    { queue : List (Contents m)
    , state : State m
    , seq : Int
    , open : Bool
    }


type alias Contents m =
    { message : String
    , action : Maybe String
    , timeout : Float
    , fade : Float
    , stacked : Bool
    , dismissOnAction : Bool
    , onDismiss : Maybe m
    }


type State m
    = Inert
    | Active (Contents m)
    | Fading (Contents m)


defaultModel : Model m
defaultModel =
    { queue = []
    , state = Inert
    , seq = -1
    , open = False
    }


type Msg m
    = Move Int Transition
    | Dismiss Bool (Maybe m)
    | SetOpen


type Transition
    = Timeout
    | Clicked
