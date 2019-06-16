module Internal.List.Model exposing
    ( Model
    , Msg(..)
    , defaultModel
    )

import Dict exposing (Dict)
import Internal.Ripple.Model as Ripple


type alias Model =
    { ripples : Dict String Ripple.Model

    -- The focused item is initially equal to the active item if any,
    -- but keyboard navigation can change this. If there's no active
    -- item, the focused item is 0.
    , focused : Maybe Int
    }


defaultModel : Model
defaultModel =
    { ripples = Dict.empty
    , focused = Nothing
    }


type Msg m
    = NoOp
    | RippleMsg String Ripple.Msg
    | FocusItem Int String
    | ResetFocusedItem
    | SelectItem Int (Int -> m)
