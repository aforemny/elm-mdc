module Internal.ImageList.Model
    exposing
        ( Config
        , defaultConfig
        )


type alias Config =
    { masonry : Bool
    , withTextProtection : Bool
    }


defaultConfig : Config
defaultConfig =
    { masonry = False
    , withTextProtection = False
    }
