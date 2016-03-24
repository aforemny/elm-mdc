module Material.Style
  ( Style
  , styled
  , cs, cs', css, css', attrib, multiple
  , stylesheet
  ) where


{-| Styling Material components.

Use these to customize components and add your own classes and css to
Material container elements.

(This mechanism is necessary because Elm does not provide a good way to
add to or remove from the contents of an already constructed class Attribute.)

@docs Style

# Constructors
@docs cs, cs', css, css', attrib, multiple

# Application
@docs styled

# Convenience
@docs stylesheet
-}


import String 

import Html exposing (Html, Attribute)
import Html.Attributes


-- STYLING


{-| Type of Style information. 
-}
type Style
  = Class String
  | CSS (String, String)
  | Attr (String, String)
  | Multiple (List Style)
  | NOP

multipleOf : Style -> Maybe (List Style)
multipleOf style =
  case style of
    Multiple multiple -> Just multiple
    _ -> Nothing


attrOf : Style -> Maybe (String, String)
attrOf style =
  case style of
    Attr attrib -> Just attrib
    _ -> Nothing
    
cssOf : Style -> Maybe (String, String)
cssOf style =
  case style of
    CSS css -> Just css
    _ -> Nothing


classOf : Style -> Maybe String
classOf style =
  case style of
    Class c -> Just c
    _ -> Nothing


flatten : Style -> List Style -> List Style
flatten style styles = 
  case style of
    Multiple styles' ->
      List.foldl flatten styles' styles
    style ->
      style :: styles

{-| Handle the common case of setting attributes of a standard Html node
from a List Style. Use like this:

    import Material.Style exposing (..)

    myDiv : Html
    myDiv =
      styled div
        [ css "classA", css "classB" ]
        [ {- onClick ... (*) -} ]
        [ text "This is my div with classes classA and classB!" ]

Note that if you do specify `style`, `class`, or `classList` attributes in
(*), they will be discarded.
-}
styled : (List Attribute -> a) -> List Style -> List Attribute -> a
styled ctor styles attrs = 
  let
    flatStyles = List.foldl flatten [] styles      
    styleAttrs = (List.filterMap attrOf flatStyles) 
      |> List.map (\attrib -> Html.Attributes.attribute (fst attrib) ( snd attrib))
  in
  ctor
    (  Html.Attributes.style (List.filterMap cssOf flatStyles)
    :: Html.Attributes.class (String.join " " (List.filterMap classOf flatStyles))
    :: List.append attrs styleAttrs
    )



{-| Add a HTML class to a component. (Name chosen to avoid clashing with
Html.Attributes.class.)
-}
cs : String -> Style
cs c = Class c


{-| Conditionally add a HTML class to a component.
-}
cs' : String -> Bool -> Style
cs' c b =
  if b then Class c else NOP


{-| Add a CSS style to a component.
-}
css : String -> String -> Style
css key value =
  CSS (key, value)

{-| Add a custom attribute
-}
attrib : String -> String -> Style
attrib key value =
  Attr (key, value)

{-| Add a custom attribute
-}
multiple : List Style -> Style
multiple styles =
  Multiple (styles)

{-| Conditionally add a CSS style to a component
-}
css' : String -> String -> Bool -> Style
css' key value b =
  if b then CSS (key, value) else NOP


{-| Add a style that does nothing. 
-}
nop : Style 
nop = NOP


-- CONVENIENCE


{-| Construct an Html element contributing to the global stylesheet.
The resulting Html is a <style> element.  Remember to insert the resulting Html
somewhere. 
-}
stylesheet : String -> Html
stylesheet css = 
  Html.node "style" [] [Html.text css]
