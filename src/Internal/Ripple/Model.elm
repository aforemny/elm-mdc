module Internal.Ripple.Model
    exposing
        ( ActivateData
        , ActivatedData
        , AnimateDeactivationData
        , AnimationState(..)
        , ClientRect
        , Event
        , Geometry
        , Model
        , Msg(..)
        , Point
        , activationEventTypes
        , cssClasses
        , defaultGeometry
        , defaultModel
        , numbers
        , pointerDeactivationEvents
        , strings
        )

import Browser.Dom
import DOM exposing (Rectangle)


-- CONSTANTS


cssClasses :
    { root : String
    , unbounded : String
    , bgFocused : String
    , fgActivation : String
    , fgDeactivation : String
    }
cssClasses =
    { root = "mdc-ripple-upgraded"
    , unbounded = "mdc-rippe-upgraded--unbounded"
    , bgFocused = "mdc-ripple-upgraded--background-focused"
    , fgActivation = "mdc-ripple-upgraded--foreground-activation"
    , fgDeactivation = "mdc-ripple-upgraded--foreground-deactivation"
    }


strings :
    { varLeft : String
    , varTop : String
    , varFgSize : String
    , varFgScale : String
    , varFgTranslateStart : String
    , varFgTranslateEnd : String
    }
strings =
    { varLeft = "--mdc-ripple-left"
    , varTop = "--mdc-ripple-top"
    , varFgSize = "--mdc-ripple-fg-size"
    , varFgScale = "--mdc-ripple-fg-scale"
    , varFgTranslateStart = "--mdc-ripple-fg-translate-start"
    , varFgTranslateEnd = "--mdc-ripple-fg-translate-end"
    }


numbers :
    { padding : Float
    , initialOriginScale : Float
    , deactivationTimeoutMs : Float
    , fgDeactivationMs : Float
    , tapDelayMs : Float
    }
numbers =
    { padding = 10
    , initialOriginScale = 0.6
    , deactivationTimeoutMs = 225
    , fgDeactivationMs = 150
    , tapDelayMs = 300
    }



-- FOUNDATION


type alias Event
    = { eventType : String
      , pagePoint : { pageX : Float, pageY : Float }
      }


type alias Point =
    { x : Float
    , y : Float
    }


activationEventTypes : List String
activationEventTypes =
    [ "touchstart", "pointerdown", "mousedown" ]


pointerDeactivationEvents : List String
pointerDeactivationEvents =
    [ "touchend", "pointerup", "mouseup" ]


type alias ClientRect =
    { top : Float
    , left : Float
    , width : Float
    , height : Float
    }


type alias Model =
    { focused : Bool
    , animationState : AnimationState
    , animationCounter : Int
    }


type AnimationState
    = Idle
    | Activated ActivatedData
    | Deactivated ActivatedData


type alias ActivatedData =
    { frame : ClientRect
    , wasElementMadeActive : Bool
    , activationEvent : Maybe Event
    , fgScale : Float
    , initialSize : Float
    , translateStart : String
    , translateEnd : String
    , activationHasEnded : Bool
    , deactivated : Bool
    }


defaultModel : Model
defaultModel =
    { focused = False
    , animationState = Idle
    , animationCounter = 0
    }


type Msg
    = Focus
    | Blur
    | Activate0 String ActivateData
    | Activate ActivateData (Result Browser.Dom.Error Browser.Dom.Element)
    | Reactivate ActivateData (Result Browser.Dom.Error Browser.Dom.Element)
    | ActivationEnded Int
    | Deactivate
    | DeactivationEnded Int


type alias ActivateData =
    { event : Event
    , isSurfaceDisabled : Bool
    , wasElementMadeActive : Bool
    , isUnbounded : Bool
    }


type alias AnimateDeactivationData =
    { wasActivatedByPointer : Bool
    , wasElementMadeActive : Bool
    }


type alias Geometry =
    { isSurfaceDisabled : Bool
    , event : { type_ : String, pageX : Float, pageY : Float }
    , frame : Rectangle
    }


defaultGeometry : Geometry
defaultGeometry =
    { isSurfaceDisabled = False
    , event = { type_ = "", pageX = 0, pageY = 0 }
    , frame = { width = 0, height = 0, left = 0, top = 0 }
    }
