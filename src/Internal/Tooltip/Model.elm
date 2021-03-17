module Internal.Tooltip.Model exposing
    ( ClientRect
    , Model
    , Msg(..)
    , ParentRect
    , Tooltip
    , TooltipState(..)
    , XTransformOrigin(..)
    , YTransformOrigin(..)
    , defaultModel
    )


import Browser.Dom as Dom
import Internal.Keyboard as Keyboard exposing (Key, KeyCode)
import Material.Tooltip.XPosition as XPosition exposing (XPosition)
import Material.Tooltip.YPosition as YPosition exposing (YPosition)


type alias ParentRect =
    { left : Float
    , top : Float
    }

type alias ClientRect =
    { left : Float
    , right : Float
    , top : Float
    , bottom : Float
    , width : Float
    , height : Float
    }

type alias Tooltip =
    { width : Float
    , height : Float
    , viewportWidth : Float
    , viewportHeight : Float
    , isRich : Bool
    }

type XTransformOrigin
    = Left
    | Right
    | Center

type YTransformOrigin
    = Bottom
    | Top

-- States are getting complex, we need TLA+ to check our code
type TooltipState
    = Hidden
    | DelayShowing
    | Showing
    | Shown
    | Hide

type alias Model =
    { parentRect : Maybe ParentRect
    , anchorRect : Maybe ClientRect
    , tooltip : Maybe Tooltip
    , isRich : Bool
    , isMultiline : Bool
    , xTooltipPos : XPosition
    , yTooltipPos : YPosition
    , state : TooltipState
    , inTransition : Bool
    , xTransformOrigin : XTransformOrigin
    , yTransformOrigin : YTransformOrigin
    , left : Float
    , top : Float
    }

defaultModel : Model
defaultModel =
    { parentRect = Nothing
    , anchorRect = Nothing
    , tooltip = Nothing
    , isRich = False
    , isMultiline = False
    , xTooltipPos = XPosition.Detected
    , yTooltipPos = YPosition.Detected
    , state = Hidden
    , inTransition = False
    , xTransformOrigin = Left
    , yTransformOrigin = Top
    , left = 0
    , top = 0
    }


type Msg m
    = NoOp
    | ShowPlainTooltip String String XPosition YPosition
    | DoShowPlainTooltip String String XPosition YPosition
    | ShowRichTooltip String String String XPosition YPosition
    | DoShowRichTooltip String String String XPosition YPosition
    | Show
    | GotParentElement Dom.Element
    | GotAnchorElement Dom.Element
    | GotTooltipElement Dom.Element
    | StartHide
    | DoStartHide
    | TransitionEnd
    | KeyDown Key KeyCode
