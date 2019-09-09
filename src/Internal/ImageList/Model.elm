module Internal.ImageList.Model exposing
    ( Config
    , defaultConfig
    )


type alias Config =
    { masonry : Bool
    , withTextProtection : Bool
    , tag : Maybe String
    }


defaultConfig : Config
defaultConfig =
    { masonry = False
    , withTextProtection = False
    , tag = Nothing
    }
