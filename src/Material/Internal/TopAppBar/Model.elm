module Material.Internal.TopAppBar.Model exposing
    ( Config
    , defaultConfig
    , defaultModel
    , Model
    , Msg(..)
    )


type alias Model =
    { scrollTop : Float
    , config : Maybe Config
    }


defaultModel : Model
defaultModel =
    { scrollTop = 0
    , config = Nothing
    }


type Msg
    = Init Config
    | Scroll Config Float


type alias Config =
    { dense : Bool
    , fixed : Bool
    , prominent : Bool
    , short : Bool
    , collapsed : Bool
    }


defaultConfig : Config
defaultConfig =
    { dense = False
    , fixed = False
    , prominent = False
    , short = False
    , collapsed = False
    }
