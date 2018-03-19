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

import Html.Events exposing (Options)
import Html exposing (Html, Attribute)
import Json.Decode exposing (Decoder)
import Material.Internal.Options


{-| Generic component property.

The `c` stands for a component's configuration type, and each component exports
its own `Property`.
-}
type alias Property c m =
    Material.Internal.Options.Property c m


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
styled =
    Material.Internal.Options.styled


{-| Add a HTML class to a component.
-}
cs : String -> Property c m
cs =
    Material.Internal.Options.cs


{-| Add a CSS style to a component.
-}
css : String -> String -> Property c m
css =
    Material.Internal.Options.css


{-| Multiple options.
-}
many : List (Property c m) -> Property c m
many =
    Material.Internal.Options.many


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
    Material.Internal.Options.nop


{-| Conditional option. When the guard evaluates to `true`, the option is
applied; otherwise it is ignored. Use like this:

    Button.disabled |> when (not model.isRunning)
-}
when : Bool -> Property c m -> Property c m
when =
    Material.Internal.Options.when


{-| HTML data-* attributes. Prefix "data-" is added automatically.
-}
data : String -> String -> Property c m
data =
    Material.Internal.Options.data


{-| HTML aria-* attributes. Prefix "aria-" is added automatically.
-}
aria : String -> String -> Property c m
aria =
    Material.Internal.Options.aria


{-| Install arbitrary `Html.Attribute`s.

```elm
styled Html.div
    [ Options.attribute <| Html.title "title" ]
    [ … ]
```
-}
attribute : Html.Attribute Never -> Property c m
attribute =
    Material.Internal.Options.attribute


{-| Apply properties to a component's native control element, ie.  `input`.
-}
nativeControl : List (Property () m)
    -> Property ({ c | nativeControl : List (Property () m) }) m
nativeControl =
    Material.Internal.Options.nativeControl


{-| -}
on : String -> Decoder m -> Property c m
on =
    Material.Internal.Options.on


{-| -}
onClick : msg -> Property c msg
onClick =
    Material.Internal.Options.onClick


{-| -}
onDoubleClick : msg -> Property c msg
onDoubleClick =
    Material.Internal.Options.onDoubleClick


{-| -}
onMouseDown : msg -> Property c msg
onMouseDown =
    Material.Internal.Options.onMouseDown


{-| -}
onMouseUp : msg -> Property c msg
onMouseUp =
    Material.Internal.Options.onMouseUp


{-| -}
onMouseEnter : msg -> Property c msg
onMouseEnter =
    Material.Internal.Options.onMouseEnter


{-| -}
onMouseLeave : msg -> Property c msg
onMouseLeave =
    Material.Internal.Options.onMouseLeave


{-| -}
onMouseOver : msg -> Property c msg
onMouseOver =
    Material.Internal.Options.onMouseOver


{-| -}
onMouseOut : msg -> Property c msg
onMouseOut =
    Material.Internal.Options.onMouseOut


{-| -}
onCheck : (Bool -> msg) -> Property c msg
onCheck =
    Material.Internal.Options.onCheck


{-| -}
onBlur : msg -> Property c msg
onBlur =
    Material.Internal.Options.onBlur


{-| -}
onFocus : msg -> Property c msg
onFocus =
    Material.Internal.Options.onFocus


{-| -}
onInput : (String -> m) -> Property c m
onInput =
    Material.Internal.Options.onInput


{-| -}
onSubmit : (String -> m) -> Property c m
onSubmit =
    Material.Internal.Options.onSubmit


{-| -}
onWithOptions : String -> Options -> Decoder m -> Property c m
onWithOptions =
    Material.Internal.Options.onWithOptions


{-| No-shorthand multiple-event dispatch.

You are very unlikely to need this.
-}
dispatch : (List m -> m) -> Property c m
dispatch =
    Material.Internal.Options.dispatch
