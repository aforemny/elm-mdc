module Material.View exposing
  ( Property, Summary, collect
  , cs, css, many, nop, set
  , apply, stylesheet
  )


{-| TODO
Styling Material components.

Use these to customize components and add your own classes and css to
Material container elements.

(This mechanism is necessary because Elm does not provide a good way to
add to or remove from the contents of an already constructed class Attribute.)

@docs Many

# Constructors
@docs cs, cs', css, css', attribute, options

# Application
@docs styled, div, span

# Convenience
@docs stylesheet
-}


import String 

import Html exposing (Html, Attribute)
import Html.Attributes


-- CONFIG


{-| Type of Style information. 
-}
type Property a
  = Class String
  | CSS (String, String)
  | Many (List (Property a))
  | Set (a -> a)
  | NOP


{-| Contents of a Property a.
-}
type alias Summary a = 
  { classes : List String 
  , css : List (String, String)  
  , options : a
  }



collect1 : Property a -> Summary a -> Summary a
collect1 cfg acc = 
  case cfg of 
    Class x -> { acc | classes = x :: acc.classes }
    CSS x -> { acc | css = x :: acc.css }
    Many cfgs -> recollect acc cfgs
    Set f -> { acc | options = f acc.options }
    NOP -> acc


recollect : Summary a -> List (Property a) -> Summary a
recollect = 
  List.foldl collect1 



{-| Flatten a `Property a` into  a `Summary a`. Operates as `fold`
over options; first two arguments are folding function and initial value. 
-}
collect : a -> List (Property a) -> Summary a
collect opt0 =
  recollect { classes=[], css=[], options=opt0 }



id : a -> a
id x = x


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
apply summary ctor config attrs = 
  let
    summary' = recollect summary config
  in
    ctor 
      (  Html.Attributes.style summary.css
      :: Html.Attributes.class (String.join " " summary.classes)
      :: List.filterMap id attrs
      )


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
{-
div : a -> List (Property a) -> List Html -> Html
div opt0 configs = 
  apply opt0 Html.div configs [] 


{-| Convenience function for the reasonably common case of setting attributes
of a span element. See also `div`. 
-}
span : a -> List (Property a) -> List Html -> Html
span opt0 configs elems = 
  apply Html.span configs [] elems

-}


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
nop = NOP


{-| Set an option 
TODO
-}
set : (a -> a) -> Property a
set = 
  Set


-- CONVENIENCE


{-| Construct an Html element contributing to the global stylesheet.
The resulting Html is a `<style>` element.  Remember to insert the resulting Html
somewhere. 
-}
stylesheet : String -> Html
stylesheet css = 
  Html.node "style" [] [Html.text css]
