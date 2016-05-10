module Material.Options
  ( Property, Summary, collect
  , cs, css, many, nop, set, data
  , apply, styled, styled', stylesheet
  , Style, div, span, onHover, key
  ) where


{-| Setting options of Material components.

This module has much same role as `Attribute` of Elm-html. 
TODO
Use this module to (a) add ecustomize components and add your own classes and css to
Material container elements.

(This mechanism is necessary because Elm does not provide a good way to
add to or remove from the contents of an already constructed class Attribute.)

@docs many

# Constructors
@docs cs, css, data, options

# Application
@docs styled, styled', div, span, onHover, key

# Convenience
@docs stylesheet
-}


import String 

import Html exposing (Html, Attribute)
import Html.Attributes
import Html.Events exposing (on)
import Json.Decode as Decoder
import Signal exposing (Address)


-- PROPERTIES


{-| Type of Style information. 
-}
type Property a
  = Class String
  | CSS (String, String)
  | Attribute Attribute
  | Many (List (Property a))
  | Set (a -> a)
  | None


{-| Contents of a Property a.
-}
type alias Summary a = 
  { classes : List String 
  , css : List (String, String)  
  , attrs : List Attribute
  , config : a
  }



collect1 : ((a -> a) -> b -> b) -> Property a -> Summary b -> Summary b
collect1 f option acc = 
  case option of 
    Class x -> { acc | classes = x :: acc.classes }
    CSS x -> { acc | css = x :: acc.css }
    Attribute x -> { acc | attrs = x :: acc.attrs }
    Many options -> List.foldl (collect1 f) acc options
    Set g -> { acc | config = f g acc.config }
    None -> acc


recollect : Summary a -> List (Property a) -> Summary a
recollect = 
  List.foldl (collect1 (<|)) 


{-| Flatten a `Property a` into  a `Summary a`. Operates as `fold`
over options; first two arguments are folding function and initial value. 
-}
collect : a -> List (Property a) -> Summary a
collect config0 =
  recollect { classes=[], css=[], attrs=[], config=config0 }


collect' : List (Property a) -> Summary () 
collect' options = 
  List.foldl 
    (collect1 (\_ _ -> ()))
    { classes=[], css=[], attrs=[], config=() }
    options


id : a -> a
id x = x


addAttributes : Summary a -> List Attribute -> List Attribute
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
apply : Summary b -> (List Attribute -> a) -> List (Property b) 
    -> List (Maybe Attribute) 
    -> a
apply summary ctor options attrs = 
  ctor 
    (addAttributes 
      (recollect summary options) 
      (List.filterMap id attrs))


{-|
-}
styled : (List Attribute -> a) -> List (Property b) -> a
styled ctor props = 
  ctor 
    (addAttributes 
      (collect' props) 
      [])


{-|
-}
styled' : (List Attribute -> a) -> List (Property b) -> List Attribute -> a
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
div : List (Property a) -> List Html -> Html
div = 
  styled Html.div 


{-| Convenience function for the reasonably common case of setting attributes
of a span element. See also `div`. 
-}
span : List (Property a) -> List Html -> Html
span =
  styled Html.span 



{-| Add a HTML class to a component. (Name chosen to avoid clashing with
Html.Attributes.class.)
-}
cs : String -> Property a
cs c = Class c


{-| Add a CSS style to a component.
-}
css : String -> String -> Property a
css key value =
  CSS (key, value)


{-| Add multiple configurations.
-}
many : List (Property a) -> Property a
many =
  Many 


{-| Add a style that does nothing. 
-}
nop : Property a 
nop = None


{-| Set an option 
TODO
-}
set : (a -> a) -> Property a
set = 
  Set


{-| HTML data-* attributes. 
-}
data : String -> String -> Property a
data key val = 
  Attribute (Html.Attributes.attribute ("data-" ++ key) val)


{-| VirtualDOM keys. 
-}
key : String -> Property a
key k = 
  Attribute (Html.Attributes.key k)

-- CONVENIENCE


{-| Construct an Html element contributing to the global stylesheet.
The resulting Html is a `<style>` element.  Remember to insert the resulting Html
somewhere. 
-}
stylesheet : String -> Html
stylesheet css = 
  Html.node "style" [] [Html.text css]


-- STYLE


type alias Style = 
  Property ()


{-|
-}
onHover : Address a -> a -> Style
onHover addr x =
  Attribute (on "mouseover" (Decoder.succeed x) (Signal.message addr))
