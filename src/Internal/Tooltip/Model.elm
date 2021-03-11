module Internal.Tooltip.Model exposing
    ( ClientRect
    , Model
    , Msg(..)
    , Tooltip
    , TooltipState(..)
    , XTransformOrigin(..)
    , YTransformOrigin(..)
    , defaultModel
    )


import Browser.Dom as Dom
import Internal.Tooltip.XPosition as XPosition exposing (XPosition)
import Internal.Tooltip.YPosition as YPosition exposing (YPosition)


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
    { anchorRect : Maybe ClientRect
    , tooltip : Maybe Tooltip
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
    { anchorRect = Nothing
    , tooltip = Nothing
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
    | StartShow String String
    | Show
    | GotAnchorElement Dom.Element
    | GotTooltipElement Dom.Element
    | StartHide
    | TransitionEnd
