module Material.Options exposing
    ( aria
    , attribute
    , cs
    , css
    , data
    , dispatch
    , input
    , many
    , nop
    , on
    , onBlur
    , onCheck
    , onClick
    , onDoubleClick
    , onFocus
    , onInput
    , onMouseDown
    , onMouseEnter
    , onMouseLeave
    , onMouseOut
    , onMouseOver
    , onMouseUp
    , onToggle
    , onWithOptions
    , Property
    , styled
    , when
    )

{-| Properties, styles, and event definitions.

@docs Property, styled
@docs cs, css
@docs many
@docs when
@docs nop
@docs attribute
@docs data, aria
@docs input

@docs on
@docs onBlur
@docs onCheck
@docs onClick
@docs onDoubleClick
@docs onFocus
@docs onInput
@docs onMouseDown
@docs onMouseEnter
@docs onMouseLeave
@docs onMouseOut
@docs onMouseOver
@docs onMouseUp
@docs onToggle
@docs onWithOptions
@docs dispatch
-}

import Html.Attributes
import Html.Events
import Html exposing (Html, Attribute)
import Json.Decode as Json
import Material.Internal.Options as Internal exposing (..)



-- PROPERTIES


{-| Generic component property.
-}
type alias Property c m =
    Internal.Property c m


{-| Apply properties to a standard Html element.
-}
styled : (List (Attribute m) -> a) -> List (Property c m) -> a
styled ctor props =
    ctor
        (addAttributes
            (collect_ props)
            []
        )


{-| Add an HTML class to a component. (Name chosen to avoid clashing with
Html.Attributes.class.)
-}
cs : String -> Property c m
cs c =
    Class c


{-| Add a CSS style to a component.
-}
css : String -> String -> Property c m
css key value =
    CSS ( key, value )


{-| Multiple options.
-}
many : List (Property c m) -> Property c m
many =
    Many


{-| Do nothing. Convenient when the absence or
presence of Options depends dynamically on other values, e.g.,

    Options.div
      [ if model.isActive then cs "active" else nop ]
      [ ... ]
-}
nop : Property c m
nop =
    None


{-| HTML data-* attributes. Prefix "data-" is added automatically.
-}
data : String -> String -> Property c m
data key val =
    Attribute (Html.Attributes.attribute ("data-" ++ key) val)


{-| HTML aria-* attributes. Prefix "aria-" is added automatically.
-}
aria : String -> String -> Property c m
aria key val =
    Attribute (Html.Attributes.attribute ("aria-" ++ key) val)


{-| Conditional option. When the guard evaluates to `true`, the option is
applied; otherwise it is ignored. Use like this:

    Button.disabled |> when (not model.isRunning)
-}
when : Bool -> Property c m -> Property c m
when guard prop  =
    if guard then
        prop
    else
        nop


{-| Install arbitrary `Html.Attribute`.

```elm
import Html
import Html.Attributes as Html
import Material.Options as Options exposing (styled)

styled Html.div
    [ Options.attribute <| Html.title "title"
    ]
    [ …
    ]
```
-}
attribute : Html.Attribute Never -> Property c m
attribute =
    Attribute << Html.Attributes.map never


{-| Apply argument options to `input` element in component implementation.

TODO: re-implement
-}
input : List (Property c m) -> Property ({ c | input : List (Property c m) }) m
input =
    Internal.input


{-| Add custom event handlers
-}
on : String -> Json.Decoder m -> Property c m
on event =
    Listener event Nothing


{-| -}
onClick : msg -> Property c msg
onClick msg =
    on "click" (Json.succeed msg)


{-| -}
onDoubleClick : msg -> Property c msg
onDoubleClick msg =
    on "dblclick" (Json.succeed msg)


{-| -}
onMouseDown : msg -> Property c msg
onMouseDown msg =
    on "mousedown" (Json.succeed msg)


{-| -}
onMouseUp : msg -> Property c msg
onMouseUp msg =
    on "mouseup" (Json.succeed msg)


{-| -}
onMouseEnter : msg -> Property c msg
onMouseEnter msg =
    on "mouseenter" (Json.succeed msg)


{-| -}
onMouseLeave : msg -> Property c msg
onMouseLeave msg =
    on "mouseleave" (Json.succeed msg)


{-| -}
onMouseOver : msg -> Property c msg
onMouseOver msg =
    on "mouseover" (Json.succeed msg)


{-| -}
onMouseOut : msg -> Property c msg
onMouseOut msg =
    on "mouseout" (Json.succeed msg)


{-| Capture [change](https://developer.mozilla.org/en-US/docs/Web/Events/change)
events on checkboxes. It will grab the boolean value from `event.target.checked`
on any input event.
Check out [targetChecked](#targetChecked) for more details on how this works.
-}
onCheck : (Bool -> msg) -> Property c msg
onCheck =
    (flip Json.map Html.Events.targetChecked) >> on "change"


{-| -}
onToggle : msg -> Property c msg
onToggle msg =
    on "change" (Json.succeed msg)


{-| -}
onBlur : msg -> Property c msg
onBlur msg =
    on "blur" (Json.succeed msg)


{-| -}
onFocus : msg -> Property c msg
onFocus msg =
    on "focus" (Json.succeed msg)


{-| -}
onInput : (String -> m) -> Property c m
onInput f =
    on "input" (Json.map f Html.Events.targetValue)


{-| Add custom event handlers with options
-}
onWithOptions : String -> Html.Events.Options -> Json.Decoder m -> Property c m
onWithOptions evt options =
    Listener evt (Just options)


{-| No-shorthand multiple-event dispatch.

You are *extremely* unlikely to need this.
-}
dispatch : (List m -> m) -> Property c m
dispatch =
    Lift << Json.map
