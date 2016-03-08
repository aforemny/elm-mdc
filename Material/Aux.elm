module Material.Aux where

import Html
import Html.Attributes
import Html.Events
import Json.Decode as Json exposing ((:=))
import Effects exposing (Effects)
import Native.Material

filter : (a -> List b -> c) -> a -> List (Maybe b) -> c
filter elem attr html =
  elem attr (List.filterMap (\x -> x) html)


onClick' : Signal.Address a -> a -> Html.Attribute
onClick' address x =
  Html.Events.onWithOptions
    "click"
    { stopPropagation = True
    , preventDefault = True
    }
    Json.value
    (\_ -> Signal.message address x)


effect : Effects b -> a -> (a, Effects b)
effect e x = (x, e)


pure : a -> (a, Effects b)
pure = effect Effects.none


clip : comparable -> comparable -> comparable -> comparable
clip lower upper k = Basics.max lower (Basics.min k upper)


type alias Rectangle =
  { width : Float
  , height : Float
  , top : Float
  , right : Float
  , bottom : Float
  , left : Float
  }


rectangleDecoder : Json.Decoder Rectangle
rectangleDecoder =
  "boundingClientRect" :=
    Json.object6 Rectangle
      ("width" := Json.float)
      ("height" := Json.float)
      ("top" := Json.float)
      ("right" := Json.float)
      ("bottom" := Json.float)
      ("left" := Json.float)


{-| Options for an event listener. If `stopPropagation` is true, it means the
event stops traveling through the DOM so it will not trigger any other event
listeners. If `preventDefault` is true, any built-in browser behavior related
to the event is prevented. For example, this is used with touch events when you
want to treat them as gestures of your own, not as scrolls. If `withGeometry`
is true, the event object will be augmented with geometry information for the
events target node; use `geometryDecoder` to decode.
-}
type alias Options =
    { stopPropagation : Bool
    , preventDefault : Bool
    , withGeometry : Bool
    }


{-| Everything is `False` by default.
    defaultOptions =
        { stopPropagation = False
        , preventDefault = False
        , withGeometry = False
        }
-}
defaultOptions : Options
defaultOptions =
    { stopPropagation = False
    , preventDefault = False
    , withGeometry = False
    }


on : String -> Options -> Json.Decoder a -> (a -> Signal.Message) -> Html.Attribute
on =
  Native.Material.on


blurOn : String -> Html.Attribute
blurOn evt =
  Html.Attributes.attribute ("on" ++ evt) <| "this.blur()"
