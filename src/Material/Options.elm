module Material.Options exposing
  ( Property, Summary, collect
  , cs, css, many, nop, set, data, key
  , apply, styled, styled', stylesheet
  , Style, div, span, onHover
  )


{-| Setting options of Material components.

This module has much same role as `Attribute` of Elm-html. 
TODO
Use this module to (a) add ecustomize components and add your own classes and css to
Material container elements.

(This mechanism is necessary because Elm does not provide a good way to
add to or remove from the contents of an already constructed class Attribute.)

@docs Property, Style, Summary

@docs many, nop

# Constructors
@docs cs, css, data, key

# Application
@docs styled, styled', div, span, onHover

# Convenience
@docs stylesheet

# Internal
@docs apply, collect, set

-}


import String 

import Html exposing (Html, Attribute)
import Html.Attributes
import Html.Events exposing (on)
import Json.Decode as Decoder
import Json.Encode as Encoder


-- PROPERTIES


{-| Type of Style information. 
-}
type Property c m 
  = Class String
  | CSS (String, String)
  | Attribute (Attribute m)
  | Many (List (Property c m))
  | Set (c -> c)
  | None


{-| Contents of a Property a.
-}
type alias Summary c m = 
  { classes : List String 
  , css : List (String, String)  
  , attrs : List (Attribute m)
  , config : c
  }



collect1 
  : ((c -> c) -> c' -> c') 
  -> Property c m 
  -> Summary c' m 
  -> Summary c' m
collect1 f option acc = 
  case option of 
    Class x -> { acc | classes = x :: acc.classes }
    CSS x -> { acc | css = x :: acc.css }
    Attribute x -> { acc | attrs = x :: acc.attrs }
    Many options -> List.foldl (collect1 f) acc options
    Set g -> { acc | config = f g acc.config }
    None -> acc


recollect : Summary c m  -> List (Property c m) -> Summary c m
recollect = 
  List.foldl (collect1 (<|)) 


{-| Flatten a `Property a` into  a `Summary a`. Operates as `fold`
over options; first two arguments are folding function and initial value. 
-}
collect : c -> List (Property c m) -> Summary c m
collect config0 =
  recollect { classes=[], css=[], attrs=[], config=config0 }


collect' : List (Property c m) -> Summary () m 
collect' options = 
  List.foldl 
    (collect1 (\_ _ -> ()))
    { classes=[], css=[], attrs=[], config=() }
    options


id : a -> a
id x = x


addAttributes : Summary c m -> List (Attribute m) -> List (Attribute m)
addAttributes summary attrs = 
  List.concat
    [ attrs
    , [ Html.Attributes.style summary.css ]
    , [ Html.Attributes.class (String.join " " summary.classes) ]
    , summary.attrs
    ]


{-| 
  TODO
  Handle the common case of setting attributes of a standard Html node
from a List (Property a). Use like this:

    import Material.Property exposing (..)

    myDiv : Html
    myDiv =
      apply () div
        [ css "classA", css "classB" ]
        [ text "This is my div with classes classA and classB!" ]

Ignores `b`.
-}
apply : Summary c m -> (List (Attribute m) -> a) -> List (Property c m) 
    -> List (Maybe (Attribute m)) 
    -> a
apply summary ctor options attrs = 
  ctor 
    (addAttributes 
      (recollect summary options) 
      (List.filterMap id attrs))


{-|
-}
styled : (List (Attribute m) -> a) -> List (Property c m) -> a
styled ctor props = 
  ctor 
    (addAttributes 
      (collect' props) 
      [])


{-|
-}
styled' : (List (Attribute m) -> a) -> List (Property c m) -> List (Attribute m) -> a
styled' ctor props attrs = 
  ctor
    (addAttributes
      (collect' props)
      attrs)


{-| Convenience function for the ultra-common case of setting attributes of a
div element. Use like this: 

    myDiv : Html 
    myDiv = 
      Style.div
        [ Color.background Color.primary
        , Color.text Color.accentContrast
        ]
        [ text "I'm in color!" ]

-}
div : List (Property c m) -> List (Html m) -> Html m
div = 
  styled Html.div 


{-| Convenience function for the reasonably common case of setting attributes
of a span element. See also `div`. 
-}
span : List (Property c m) -> List (Html m) -> Html m
span =
  styled Html.span 



{-| Add a HTML class to a component. (Name chosen to avoid clashing with
Html.Attributes.class.)
-}
cs : String -> Property c m
cs c = Class c


{-| Add a CSS style to a component.
-}
css : String -> String -> Property c m
css key value =
  CSS (key, value)


{-| Add multiple configurations.
-}
many : List (Property c m) -> Property c m
many =
  Many 


{-| Add a style that does nothing. 
-}
nop : Property c m 
nop = None


{-| Set an option 
TODO
-}
set : (c -> c) -> Property c m
set = 
  Set


{-| HTML data-* attributes. 
-}
data : String -> String -> Property c m
data key val = 
  Attribute (Html.Attributes.attribute ("data-" ++ key) val)


{-| VirtualDOM keys. 
-}
key : String -> Property c m
key k = 
  Attribute (Html.Attributes.property "key" (Encoder.string k))

-- CONVENIENCE


{-| Construct an Html element contributing to the global stylesheet.
The resulting Html is a `<style>` element.  Remember to insert the resulting Html
somewhere. 
-}
stylesheet : String -> Html m
stylesheet css = 
  Html.node "style" [] [Html.text css]


-- STYLE


{-| TODO
-}
type alias Style m = 
  Property () m


{-|
-}
onHover : m -> Style m
onHover x =
  Attribute (on "mouseover" (Decoder.succeed x))
