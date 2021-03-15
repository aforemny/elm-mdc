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
import Internal.Tooltip.XPosition as XPosition exposing (XPosition)
import Internal.Tooltip.YPosition as YPosition exposing (YPosition)


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
    , viewportHeight : Float
    , viewportWidth : Float
    , isRich : Bool
    }

type XTransformOrigin
    = Left
    | Right
    | Center

type YTransformOrigin
    = Bottom
    | Top

type TooltipState
    = Hidden
    | Showing
    | Shown
    | Hide

type alias Model =
    { parentRect : Maybe ParentRect
    , anchorRect : Maybe ClientRect
    , tooltip : Maybe Tooltip
    , isRich : Bool
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
    , xTooltipPos = XPosition.Detected -- TODO: we currently have no way to set this
    , yTooltipPos = YPosition.Detected -- TODO: we currently have no way to set this
    , state = Hidden
    , inTransition = False
    , xTransformOrigin = Left
    , yTransformOrigin = Top
    , left = 0
    , top = 0
    }


type Msg m
    = NoOp
    | ShowPlainTooltip String String
    | DoShowPlainTooltip String String
    | ShowRichTooltip String String String
    | DoShowRichTooltip String String String
    | Show
    | GotParentElement Dom.Element
    | GotAnchorElement Dom.Element
    | GotTooltipElement Dom.Element
    | StartHide
    | DoStartHide
    | TransitionEnd
