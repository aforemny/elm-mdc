module Material.Options exposing
  ( Property, Summary, collect
  , cs, css, many, nop, set, data
  , when, maybe, disabled
  , apply, styled, styled', stylesheet
  , Style, div, span, img, attribute, center, scrim
  , id
  , inner
  )


{-| Setting options for Material components. 

Here is a standard use of an elm-mdl Textfield: 

    Textfield.render MDL [0] model.mdl
      [ Textfield.floatingLabel
      , Textfield.label "name"
      , css "width" "96px"
      , cs "my-name-textfield"
      ]

The above code renders a textfield, setting the optional properties
`floatingLabel` and `label "name"` on the textfield; as well as adding
additional (CSS) styling `width: 96px;` and the HTML class `my-name-textfield`. 

This module defines the type `Property c m` of such optional properties, the
elements of the last argument in the above call to `Textfield.render`.
Individual components, such as Textfield usually instantiate the `c` to avoid
inadvertently applying, say, a Textfield property to a Button. 

Some optional properties apply to all components, see the `Typography`,
`Elevation`, `Badge`, and `Color` modules. Such universally applicable
optional properties can _also_ be applied to standard `Html` elements 
such as `Html.div`; see `style` et. al. below. This is convenient, e.g., for
applying MDL typography or color to standard elements. 


@docs Property

# Constructors
@docs cs, css, data, many, nop, when, maybe

# Html
@docs Style, styled, styled'

## Elements
@docs div, span, img
@docs stylesheet

## Attributes
@docs attribute, id, inner
@docs center, scrim, disabled

# Internal
The following types and values are used internally in the library. 
@docs Summary, apply, collect, set

-}


import String 

import Html exposing (Html, Attribute)
import Html.Attributes

import Material.Options.Internal exposing (..)

-- PROPERTIES


{-| Type of elm-mdl properties. (Do not confuse these with Html properties or
`Html.Attributes.property`.) The type variable `c` identifies the component the
property is for. You never have to set it yourself. The type variable `d` by
the type of your `Msg`s; you should set this yourself. 
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


{- `collect` and variants are called multiple times by nearly every use of
  any elm-mdl component. Carefully consider performance implications before
  modifying. In particular: 

  - Avoid closures. They are slow to create and cause subsequent GC.
  - Pre-compute where possible. 

  Earlier versions of `collect`, violating these rules, consumed ~20% of
  execution time for `Cards.view` and `Textfield.view`.
-}


collect1 
  :  Property c m 
  -> Summary c m 
  -> Summary c m
collect1 option acc = 
  case option of 
    Class x -> { acc | classes = x :: acc.classes }
    CSS x -> { acc | css = x :: acc.css }
    Attribute x -> { acc | attrs = x :: acc.attrs }
    Many options -> List.foldl collect1 acc options
    Set g -> { acc | config = g acc.config }
    None -> acc


recollect : Summary c m  -> List (Property c m) -> Summary c m
recollect = 
  List.foldl collect1 


{-| Flatten a `Property a` into  a `Summary a`. Operates as `fold`
over options; first two arguments are folding function and initial value. 
-}
collect : c -> List (Property c m) -> Summary c m
collect =
  Summary [] [] [] >> recollect 


{-| Special-casing of collect for `Property c ()`. 
-}
collect1' : Property c m -> Summary () m -> Summary () m
collect1' options acc = 
  case options of 
    Class x -> { acc | classes = x :: acc.classes }
    CSS x -> { acc | css = x :: acc.css }
    Attribute x -> { acc | attrs = x :: acc.attrs }
    Many options -> List.foldl collect1' acc options
    Set _ -> acc 
    None -> acc


collect' : List (Property c m) -> Summary () m 
collect' = 
  List.foldl collect1' (Summary [] [] [] ())


addAttributes : Summary c m -> List (Attribute m) -> List (Attribute m)
addAttributes summary attrs = 
  List.append
    attrs
    (  Html.Attributes.style summary.css 
    :: Html.Attributes.class (String.join " " summary.classes) 
    :: summary.attrs
    )


{-| Apply a `Summary m`, extra properties, and optional attributes 
to a standard Html node. 
-}
apply : Summary c m -> (List (Attribute m) -> a) 
    -> List (Property c m) -> List (Attribute m) -> a
apply summary ctor options attrs = 
  ctor 
    (addAttributes 
      (recollect summary options) 
      attrs)
    


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


{-| Convenience function for the not unreasonably uncommon case of setting
attributes of an img element. Use like this: 

    img
      [ Options.css "height" "200px" ]
      [ Html.Attributes.src "assets/image.jpg" ] 
-}
img : List (Property a b) -> List (Attribute b) -> Html b
img options attrs =
  styled' Html.img options attrs [] 


{-| Set HTML disabled attribute. -}
disabled : Bool -> Property c m 
disabled v = 
  Attribute (Html.Attributes.disabled v)


{-| Add an HTML class to a component. (Name chosen to avoid clashing with
Html.Attributes.class.)
-}
cs : String -> Property c m
cs c = Class c


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

    Options.div 
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


{-| Apply a Maybe option when defined
-}
maybe : Maybe (Property c m) -> Property c m
maybe prop = 
  prop |> Maybe.withDefault nop 


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


{-| Install arbitrary `Html.Attribute`. Applicable only to `Style m`, not 
general Properties. Use like this:

    Options.div 
      [ Options.attribute <| Html.onClick MyClickEvent ]
      [ ... ]
-}
attribute : Html.Attribute m -> Style m 
attribute =
  Attribute 

{-| Options installing css for element to be a flex-box container centering its
elements. 
-}
center : Property c m
center =
  many
    [ css "display" "flex"
    , css "align-items" "center"
    , css "justify-content" "center"
    ]


{-| Scrim. Argument value indicates terminal opacity, the value of which should
depend on the underlying image. `0.6` works well often. 
-}
scrim : Float -> Property c m
scrim opacity = 
  css "background" <| "linear-gradient(rgba(0, 0, 0, 0), rgba(0, 0, 0, " ++ toString opacity ++ "))" 


{-| Sets the id attribute
-}
id : String -> Property c m
id =
  Attribute << Html.Attributes.id


{-| Sets attributes on the inner element for components that support it.
For example `Textfield`:

    Textfield.render ...
      [ ...
      , Options.inner
          [ Options.id "id-of-the-input"
          ]
      ]

-}
inner : List (Property c m) -> Property { a | inner : List (Property c m) } m
inner options =
  set (\c -> { c | inner = options ++ c.inner })
