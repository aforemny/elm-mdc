module Material.Internal.ImageList.Model exposing
    ( Config
    , defaultConfig
    , defaultModel
    , Model
    , Msg(..)
    )


type alias Model =
    { config : Maybe Config
    }


defaultModel : Model
defaultModel =
    { config = Nothing
    }


type Msg
    = Init Config


type alias Config =
    { masonry : Bool
    , overlayLabel : Bool
    }


defaultConfig : Config
defaultConfig =
    { masonry = False
    , overlayLabel = False
    }
