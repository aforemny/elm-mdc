module Material.Options exposing
    ( aria
    , attribute
    , cs
    , css
    , data
    , dispatch
    , many
    , nativeControl
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
    , onSubmit
    , onWithOptions
    , Property
    , styled
    , when
    )

{-|

# Properties

@docs Property, styled
@docs cs, css
@docs many
@docs when
@docs nop
@docs attribute
@docs data, aria

@docs nativeControl


# Events

@docs on
@docs onWithOptions

@docs onClick
@docs onDoubleClick
@docs onMouseDown
@docs onMouseUp
@docs onMouseEnter
@docs onMouseLeave
@docs onMouseOver
@docs onMouseOut

@docs onInput
@docs onCheck
@docs onSubmit

@docs onBlur
@docs onFocus


# Dispatch

@docs dispatch
-}

import Html.Attributes
import Html.Events
import Html exposing (Html, Attribute)
import Json.Decode as Json
import Material.Internal.Options as Internal exposing (..)


{-| Generic component property.

The `c` stands for a component's configuration type, and each component exports
its own `Property`.
-}
type alias Property c m =
    Internal.Property c m


{-| Make a standard Html element take properties instead of attributes.

```
styled Html.div
    [ css "margin" "0 auto"
    ]
    [ text ""
    ]
```
-}
styled : (List (Attribute m) -> List (Html m) -> Html m)
    -> List (Property c m)
    -> List (Html m)
    -> Html m
styled ctor props =
    ctor (addAttributes (collect_ props) [])


{-| Add a HTML class to a component.
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

```elm
Html.div
    [ if isActive then cs "active" else nop ]
    [ … ]
```
-}
nop : Property c m
nop =
    None


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


{-| Install arbitrary `Html.Attribute`s.

```elm
styled Html.div
    [ Options.attribute <| Html.title "title" ]
    [ … ]
```
-}
attribute : Html.Attribute Never -> Property c m
attribute =
    Attribute << Html.Attributes.map never


{-| Apply properties to a component's native control element, ie.  `input`.
-}
nativeControl : List (Property c m)
    -> Property ({ c | nativeControl : List (Property c m) }) m
nativeControl =
    Internal.nativeControl


{-| -}
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


{-| -}
onCheck : (Bool -> msg) -> Property c msg
onCheck =
    (flip Json.map Html.Events.targetChecked) >> on "change"


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


{-| -}
onSubmit : (String -> m) -> Property c m
onSubmit f =
    onWithOptions "submit"
        { preventDefault = True
        , stopPropagation = False
        }
        (Json.map f Html.Events.targetValue)


{-| -}
onWithOptions : String -> Html.Events.Options -> Json.Decoder m -> Property c m
onWithOptions evt options =
    Listener evt (Just options)


{-| No-shorthand multiple-event dispatch.

You are *extremely* unlikely to need this.
-}
dispatch : (List m -> m) -> Property c m
dispatch =
    Lift << Json.map
