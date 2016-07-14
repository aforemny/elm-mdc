module Material.Options exposing
  ( Property, Summary, collect
  , cs, css, many, nop, set, data
  , when, disabled
  , apply, styled, styled', stylesheet
  , Style, div, span, onHover
  )


{-| Setting options for Material components. Refer to the `Material` module
for intended use. 

@docs Property

# Constructors
@docs cs, css, data, many, nop, when

# Html
@docs Style, styled, styled', div, span, onHover, disabled

# Convenience
@docs stylesheet

# Internal
The following types and values are used internally in the library. 
@docs Summary, apply, collect, set

-}


import String 

import Html exposing (Html, Attribute)
import Html.Attributes
import Html.Events exposing (on)
import Json.Decode as Decoder

import Material.Options.Internal exposing (..)

-- PROPERTIES


{-| Type of elm-mdl properties. (Do not confuse these with Html properties or
`Html.Attributes.property`.)
The type variable `c` identifies the component the property is for. You never have to set it yourself. The type variable `d` by the type of your `Msg`s; you should 
set this yourself. 
-}
type alias Property c m = 
  Material.Options.Internal.Property c m 


{-| Contents of a `Property c m`.
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


addAttributes : Summary c m -> List (Attribute m) -> List (Attribute m)
addAttributes summary attrs = 
  List.concat
    [ attrs
    , [ Html.Attributes.style summary.css ]
    , [ Html.Attributes.class (String.join " " summary.classes) ]
    , summary.attrs
    ]


{-| Apply a `Summary m`, extra properties, and optional attributes 
to a standard Html node. 
-}
apply : Summary c m -> (List (Attribute m) -> a) -> List (Property c m) 
    -> List (Maybe (Attribute m)) 
    -> a
apply summary ctor options attrs = 
  ctor 
    (addAttributes 
      (recollect summary options) 
      (List.filterMap identity attrs))


{-| Apply properties to a standard Html element. 
-}
styled : (List (Attribute m) -> a) -> List (Property c m) -> a
styled ctor props = 
  ctor 
    (addAttributes 
      (collect' props) 
      [])


{-| Apply properties and attributes to a standard Html element.
-}
styled' : (List (Attribute m) -> a) -> List (Property c m) -> List (Attribute m) -> a
styled' ctor props attrs = 
  ctor
    (addAttributes
      (collect' props)
      attrs)


{-| Convenience function for the ultra-common case of apply elm-mdl styling to a
`div` element. Use like this: 

    myDiv : Html m
    myDiv = 
      Options.div
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


{-| Set HTML disabled attribute. -}
disabled : Bool -> Property c m 
disabled v = 
  Attribute (Html.Attributes.disabled v)


{-| Add an HTML class to a component. (Name chosen to avoid clashing with
Html.Attributes.class.)
-}
cs : String -> Property c m
cs c = Class c


{-| Conditionally add an HTML class to a component. (Name chosen to avoid
clashing with Html.Attributes.class.)
-}
cs' : String -> Bool -> Property c m 
cs' c b = 
  if b then Class c else None


{-| Add a CSS style to a component. 
-}
css : String -> String -> Property c m
css key value =
  CSS (key, value)


{-| Multiple options.
-}
many : List (Property c m) -> Property c m
many =
  Many 


{-| Do nothing. Convenient when the absence or 
presence of Options depends dynamically on other values, e.g., 

    div 
      [ if model.isActive then css "active" else nop ]
      [ ... ]
-}
nop : Property c m 
nop = None


{-| Set a configuration value. 
-}
set : (c -> c) -> Property c m
set = 
  Set


{-| HTML data-* attributes. 
-}
data : String -> String -> Property c m
data key val = 
  Attribute (Html.Attributes.attribute ("data-" ++ key) val)


{-| Conditional option. When the guard evaluates to `true`, the option is
applied; otherwise it is ignored. Use like this: 

    Button.disabled `when` not model.isRunning
-}
when : Property c m -> Bool -> Property c m
when prop guard = 
  if guard then prop else nop


-- CONVENIENCE


{-| Construct an Html element contributing to the global stylesheet.
The resulting Html is a `<style>` element.  Remember to insert the resulting Html
somewhere. 
-}
stylesheet : String -> Html m
stylesheet css = 
  Html.node "style" [] [Html.text css]


-- STYLE


{-| Options for situations where there is no configuration, i.e., 
styling a `div`.
-}
type alias Style m = 
  Property () m


{-| Option adding an `on "mouseover"` event handler to an element. 
Applicable only to `Style m`, not general Properties. 
-}
onHover : m -> Style m
onHover x =
  Attribute (on "mouseover" (Decoder.succeed x))
