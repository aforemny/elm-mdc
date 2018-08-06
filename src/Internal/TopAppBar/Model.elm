module Internal.TopAppBar.Model
    exposing
        ( Config
        , Model
        , Msg(..)
        , defaultConfig
        , defaultModel
        )


type alias Model =
    { lastScrollPosition : Maybe Float
    , topAppBarHeight : Maybe Float
    , wasDocked : Bool
    , isDockedShowing : Bool
    , currentAppBarOffsetTop : Float
    , styleTop : Maybe Float

    -- Note: Resize throttling is not implemented.
    -- , isCurrentlyBeingResized : Bool
    -- , resizeThrottleId : Int
    -- , resizeDebounceId : Int
    }


defaultModel : Model
defaultModel =
    { lastScrollPosition = Nothing
    , topAppBarHeight = Nothing
    , wasDocked = True
    , isDockedShowing = True
    , currentAppBarOffsetTop = 0
    , styleTop = Nothing
    }


type Msg
    = Init { scrollPosition : Float, topAppBarHeight : Float }
    | Resize { scrollPosition : Float, topAppBarHeight : Float }
    | Scroll { scrollPosition : Float }


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
