module Material.Options
    exposing
        ( Property
        , aria
        , tabindex
        , attribute
        , cs
        , css
        , data
        , for
        , id
        , many
        , nop
        , on
        , onBlur
        , onChange
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
        , styled
        , when
        )

{-|


# Properties

@docs Property, styled
@docs cs, css
@docs id
@docs many
@docs when
@docs nop
@docs attribute
@docs data
@docs aria
@docs for
@docs tabindex


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

@docs onInput, onChange
@docs onCheck
@docs onSubmit

@docs onBlur
@docs onFocus

-}

import Html exposing (Attribute, Html)
import Html.Events exposing (Options)
import Internal.Options
import Json.Decode exposing (Decoder)


{-| Generic component property.

The `c` stands for a component's configuration type, and each component exports
its own `Property`.

-}
type alias Property c m =
    Internal.Options.Property c m


{-| Make a standard Html element take properties instead of attributes.

    styled Html.div
        [ css "margin" "0 auto"
        ]
        [ text ""
        ]

Note: Most frequently you use styled with a more specialize type on `Html.*`
elements,

    styled :
        (List (Attribute m) -> List (Html m) -> Html m)
        -> List (Property c m)
        -> List (Html m)
        -> Html m

The type annotation for `styled` is more general so that it also works with
`Markdown.toHtml`, etc.

-}
styled :
    (List (Attribute m) -> a)
    -> List (Property c m)
    -> a
styled =
    Internal.Options.styled


{-| Add a HTML class to a component.
-}
cs : String -> Property c m
cs =
    Internal.Options.cs


{-| Add a CSS style to a component.
-}
css : String -> String -> Property c m
css =
    Internal.Options.css


{-| Multiple options.
-}
many : List (Property c m) -> Property c m
many =
    Internal.Options.many


{-| Do nothing. Convenient when the absence or
presence of Options depends dynamically on other values, e.g.,

    Html.div
        [ if isActive then cs "active" else nop ]
        [ … ]

-}
nop : Property c m
nop =
    Internal.Options.nop


{-| Conditional option. When the guard evaluates to `true`, the option is
applied; otherwise it is ignored. Use like this:

    Button.disabled |> when (not model.isRunning)

-}
when : Bool -> Property c m -> Property c m
when =
    Internal.Options.when


{-| HTML data-* attributes. Prefix "data-" is added automatically.
-}
data : String -> String -> Property c m
data =
    Internal.Options.data


{-| HTML aria-* attributes. Prefix "aria-" is added automatically.
-}
aria : String -> String -> Property c m
aria =
    Internal.Options.aria


{-| HTML tabindex attribute.
-}
tabindex : Int -> Property c m
tabindex =
    Internal.Options.tabindex


{-| HTML for attribute.
-}
for : String -> Property c m
for =
    Internal.Options.for


{-| Install arbitrary `Html.Attribute`s.

    styled Html.div
        [ Options.attribute <| Html.title "title" ]
        [ … ]

-}
attribute : Html.Attribute Never -> Property c m
attribute =
    Internal.Options.attribute


{-| -}
on : String -> Decoder m -> Property c m
on =
    Internal.Options.on


{-| -}
onClick : msg -> Property c msg
onClick =
    Internal.Options.onClick


{-| -}
onDoubleClick : msg -> Property c msg
onDoubleClick =
    Internal.Options.onDoubleClick


{-| -}
onMouseDown : msg -> Property c msg
onMouseDown =
    Internal.Options.onMouseDown


{-| -}
onMouseUp : msg -> Property c msg
onMouseUp =
    Internal.Options.onMouseUp


{-| -}
onMouseEnter : msg -> Property c msg
onMouseEnter =
    Internal.Options.onMouseEnter


{-| -}
onMouseLeave : msg -> Property c msg
onMouseLeave =
    Internal.Options.onMouseLeave


{-| -}
onMouseOver : msg -> Property c msg
onMouseOver =
    Internal.Options.onMouseOver


{-| -}
onMouseOut : msg -> Property c msg
onMouseOut =
    Internal.Options.onMouseOut


{-| -}
onCheck : (Bool -> msg) -> Property c msg
onCheck =
    Internal.Options.onCheck


{-| See `onFocus` for additional information.
-}
onBlur : msg -> Property c msg
onBlur =
    Internal.Options.onBlur


{-| Since the `"focus"` (and `"blur"`) event does not bubble, be sure to use
this on `nativeControl` if the component exposes that.

    import Material.Textfield as Textfield

    Textfield.view Mdc "my-text-field" model.mdc
        [ Textfield.nativeControl
            [ Options.onFocus Focus
            ]
        ]
        []

-}
onFocus : msg -> Property c msg
onFocus =
    Internal.Options.onFocus


{-| -}
onInput : (String -> m) -> Property c m
onInput =
    Internal.Options.onInput


{-| -}
onChange : (String -> m) -> Property c m
onChange =
    Internal.Options.onChange


{-| -}
onSubmit : (String -> m) -> Property c m
onSubmit =
    Internal.Options.onSubmit


{-| -}
onWithOptions : String -> Options -> Decoder m -> Property c m
onWithOptions =
    Internal.Options.onWithOptions


{-| Sets the id attribute
-}
id : String -> Property c m
id =
    Internal.Options.id
