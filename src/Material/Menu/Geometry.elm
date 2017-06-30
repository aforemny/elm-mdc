module Material.Menu.Geometry
    exposing
        ( Geometry
        , Element
        , decode
        )

import DOM
import Json.Decode exposing (..)


{-| An Geometry stores relevant information from DOM during Open and Close
events. (This computes more than it needs to.)
-}
type alias Geometry =
    { button : Element
    , menu : Element
    , container : Element
    , offsetTops : List Float
    , offsetHeights : List Float
    }


type alias Element =
    { offsetTop : Float
    , offsetLeft : Float
    , offsetHeight : Float
    , bounds : DOM.Rectangle
    }


{-| Decode Geometry from the button's reference
-}
decode : Decoder Geometry
decode =
    map5 Geometry
        (DOM.target element)
        (DOM.target (DOM.nextSibling (DOM.childNode 1 element)))
        (DOM.target (DOM.nextSibling element))
        (DOM.target (DOM.nextSibling (DOM.childNode 1 (DOM.childNodes DOM.offsetTop))))
        (DOM.target (DOM.nextSibling (DOM.childNode 1 (DOM.childNodes DOM.offsetHeight))))


{-| Decode an Element
-}
element : Decoder Element
element =
    map4 Element
        DOM.offsetTop
        DOM.offsetLeft
        DOM.offsetHeight
        DOM.boundingClientRect
