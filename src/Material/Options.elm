module Material.Options exposing
  ( Property 
  , cs, css, many, nop, data
  , when, maybe, disabled
  , styled, styled', stylesheet
  , Style, div, span, img, attribute, center, scrim
  , id
  , input, container
  , onClick, onDoubleClick
  , onMouseDown, onMouseUp
  , onMouseEnter, onMouseLeave
  , onMouseOver, onMouseOut
  , onCheck, onToggle
  , onBlur, onFocus
  , onInput
  , on, on1
  , onWithOptions
  , dispatch, dispatch'
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
applying elm-mdl typography or color to standard elements. 


@docs Property

# Constructors
@docs cs, css, data, many, nop, when, maybe

# Html
@docs Style, styled, styled'

## Elements
@docs div, span, img
@docs stylesheet

## Attributes
@docs attribute, id
@docs center, scrim, disabled

# Events
@docs onClick, onDoubleClick,
      onMouseDown, onMouseUp,
      onMouseEnter, onMouseLeave,
      onMouseOver, onMouseOut
@docs onCheck, onToggle
@docs onBlur, onFocus
@docs onInput

## Custom Event Handlers
@docs on, on1
@docs onWithOptions


## Event internal
@docs dispatch, dispatch'


# Option distribution 
Some components emulate HTML `<input>` elements, usually be nesting an actual
`<input>` element inside additional markup. Options for such components are
distributed between the container and input element. The `input` option
guarantees that its argument options are applied to the `input` element. 

See the `Textfield` documentation and demo for discussion and example.
@docs input, container

-}



import Html exposing (Html, Attribute)
import Html.Attributes
import Html.Events
import Json.Decode as Json 

import Material.Options.Internal as Internal exposing (..)
import Material.Msg as Msg


-- PROPERTIES


{-| Type of elm-mdl properties. (Do not confuse these with Html properties or
`Html.Attributes.property`.) The type variable `c` identifies the component the
property is for. You never have to set it yourself. The type variable `d` by
the type of your `Msg`s; you should set this yourself. 
-}
type alias Property c m = 
  Internal.Property c m 

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


{-| Install arbitrary `Html.Attribute`.

    Options.div
      [ Options.attribute <| Html.Attributes.title "title" ]
      [ ... ]

**NOTE** Do not install event handlers using `Options.attribute`.
Instead use `Options.on` and the variants.
-}
attribute : Html.Attribute m -> Property c m
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


{-| Apply argument options to `input` element in component implementation.
-}
input : List (Style m) -> Property (Input c m) m
input =
  Internal.input


{-| Apply argument options to container element in component implementation. 
-}
container : List (Style m) -> Property (Container c m) m
container =
  Internal.container 



-- EVENTS


{-| Add custom event handlers
 -}
on : String -> (Json.Decoder m) -> Property c m
on event =
  Listener event Nothing


{-| Add a custom event handler that always succeeds.

Equivalent to `Options.on event (Json.Decode.succeed msg)`
 -}
on1 : String -> m -> Property c m
on1 event m =
  on event (Json.succeed m)


{-|-}
onClick : msg -> Property c msg
onClick msg =
  on "click" (Json.succeed msg)


{-|-}
onDoubleClick : msg -> Property c msg
onDoubleClick msg =
  on "dblclick" (Json.succeed msg)


{-|-}
onMouseDown : msg -> Property c msg
onMouseDown msg =
  on "mousedown" (Json.succeed msg)


{-|-}
onMouseUp : msg -> Property c msg
onMouseUp msg =
  on "mouseup" (Json.succeed msg)


{-|-}
onMouseEnter : msg -> Property c msg
onMouseEnter msg =
  on "mouseenter" (Json.succeed msg)


{-|-}
onMouseLeave : msg -> Property c msg
onMouseLeave msg =
  on "mouseleave" (Json.succeed msg)


{-|-}
onMouseOver : msg -> Property c msg
onMouseOver msg =
  on "mouseover" (Json.succeed msg)


{-|-}
onMouseOut : msg -> Property c msg
onMouseOut msg =
  on "mouseout" (Json.succeed msg)


{-| Capture [change](https://developer.mozilla.org/en-US/docs/Web/Events/change)
events on checkboxes. It will grab the boolean value from `event.target.checked`
on any input event.
Check out [targetChecked](#targetChecked) for more details on how this works.
-}
onCheck : (Bool -> msg) -> Property c msg
onCheck tagger =
  on "change" (Json.map tagger Html.Events.targetChecked)


{-|-}
onToggle : msg -> Property c msg
onToggle =
  on1 "change"

-- FOCUS EVENTS


{-|-}
onBlur : msg -> Property c msg
onBlur msg =
  on "blur" (Json.succeed msg)


{-|-}
onFocus : msg -> Property c msg
onFocus msg =
  on "focus" (Json.succeed msg)


{-|-}
onInput : (String -> m) -> Property c m
onInput f = 
  on "input" (Json.map f Html.Events.targetValue)
 

{-| Add custom event handlers with options
 -}
onWithOptions : String -> Html.Events.Options -> (Json.Decoder m) -> Property c m
onWithOptions evt options =
  Listener evt (Just options)



-- DISPATCH

{-| Add a lifting function that is **required** for multi event dispatch.
To enable multi event dispatch with Mdl:

    Chip.button
      [ Options.dispatch Mdl
      , Options.onClick Click
      , Options.onClick AnotherClick
      ]
      [ ... ]
 -}
dispatch : (Msg.Msg a m -> m) -> Property c m
dispatch lift =
  Lift (Msg.Dispatch >> lift)


{-| Add a lifting function that is **required** for multi event dispatch.
To enable multi event dispatch for anything.

Add a message

    type Msg
      = ...
      | Dispatch (Dispatch.Msg Msg)
      ...

Create an element with Options.styled

    Options.styled Html.button
      [ Options.dispatch' Dispatch
      , Options.onClick Click
      , Options.onClick AnotherClick
      ]
      [ ... ]
 -}
dispatch' : (List m -> m) -> Property c m
dispatch' =
  Lift
