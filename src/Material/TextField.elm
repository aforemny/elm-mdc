module Material.TextField exposing
    ( Property
    , view
    , label
    , value
    , placeholder
    , disabled
    , leadingIcon
    , trailingIcon
    , onLeadingIconClick
    , onTrailingIconClick
    , required
    , invalid
    , pattern
    , outlined
    , fullwidth
    , prefix
    , suffix
    , textarea
    , internalCounter
    , rows
    , cols
    , email
    , password
    , type_
    , name
    , nativeControl
    , autocomplete
    , autofocus
    , onFocus
    , onBlur
    )

{-| Text fields allow users to input, edit, and select text.


# Resources

  - [Material Design guidelines: Text Fields](https://material.io/guidelines/components/text-fields.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#text-field)


# Example

    import Material.Options as Options
    import Material.TextField as TextField

    TextField.view Mdc "my-text-field" model.mdc
        [ TextField.label "Text field"
        , Options.onChange UpdateTextField
        ]
        []


# Usage

@docs Property
@docs view


## Properties

@docs label
@docs value
@docs placeholder
@docs disabled
@docs prefix
@docs suffix


### Icon properties

@docs leadingIcon
@docs trailingIcon
@docs onLeadingIconClick
@docs onTrailingIconClick


### Validation properties

@docs required
@docs invalid
@docs pattern


## Variants

@docs outlined
@docs fullwidth


### Multiline

@docs textarea
@docs rows
@docs cols
@docs internalCounter


## Type

@docs email
@docs password
@docs type_


## Form submission

@docs name

## Control

@docs autocomplete
@docs autofocus
@docs onFocus
@docs onBlur


## Native control

@docs nativeControl

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Options as Options
import Internal.TextField.Implementation as TextField
import Material


{-| TextField property.
-}
type alias Property m =
    TextField.Property m


{-| TextField view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    TextField.view


{-| Set action for when the leading icon is clicked.
-}
onLeadingIconClick : msg -> Property msg
onLeadingIconClick =
    TextField.onLeadingIconClick


{-| Set action for when the trailing icon is clicked.
-}
onTrailingIconClick : msg -> Property msg
onTrailingIconClick =
    TextField.onTrailingIconClick


{-| Add a leading icon to the textfield.
-}
leadingIcon : String -> Property m
leadingIcon =
    TextField.leadingIcon


{-| Add a trailing icon to the textfield.
-}
trailingIcon : String -> Property m
trailingIcon =
    TextField.trailingIcon


{-| Style a single line textfield as an outlined textfield. Do not use for multine textfields.
-}
outlined : Property m
outlined =
    TextField.outlined


{-| Set a label for the textfield.
-}
label : String -> Property m
label =
    TextField.label


{-| Set the textfield's value.
-}
value : String -> Property m
value =
    TextField.value


{-| Disable the textfield.
-}
disabled : Property m
disabled =
    TextField.disabled


{-| Prefix and suffix text can add context to a text field, such as a
currency symbol prefix or a unit of mass suffix.
-}
prefix : String -> Property m
prefix =
    TextField.prefix


{-| Prefix and suffix text can add context to a text field, such as a
currency symbol prefix or a unit of mass suffix.
-}
suffix : String -> Property m
suffix =
    TextField.suffix


{-| Set the textfield's `type` to `password`.
-}
password : Property m
password =
    TextField.password


{-| Set the textfield's `type` to `email`.
-}
email : Property m
email =
    TextField.email


{-| Set a pattern to validate the textfield's input against.

The text field is automatically marked invalid if the pattern does not match
its input.

-}
pattern : String -> Property m
pattern =
    TextField.pattern


{-| Set the number of rows in a `textarea` textfield.
-}
rows : Int -> Property m
rows =
    TextField.rows


{-| Set the number of columns in a `textarea` textfield.
-}
cols : Int -> Property m
cols =
    TextField.cols


{-| Set this property if a character counter is placed inside the textarea's body.
-}
internalCounter : Property m
internalCounter =
    TextField.internalCounter


{-| Mark the textfield as required.
-}
required : Property m
required =
    TextField.required


{-| Set the textfield's type.
-}
type_ : String -> Property m
type_ =
    TextField.type_


{-| Set the textfield's name.
-}
name : String -> Property m
name =
    TextField.name


{-| Make the textfield take up all the available horizontal space.

Full width textfields cannot not have a label. Use a placeholder instead.
-}
fullwidth : Property m
fullwidth =
    TextField.fullwidth


{-| Mark the textfield as invalid.
-}
invalid : Property m
invalid =
    TextField.invalid


{-| Make the textfield a `textarea` element instead of `input`.
-}
textarea : Property m
textarea =
    TextField.textarea


{-| Sets the placeholder of the textfield.
-}
placeholder : String -> Property m
placeholder =
    TextField.placeholder


{-| Apply properties to underlying native control element.
-}
nativeControl : List (Options.Property () m) -> Property m
nativeControl =
    TextField.nativeControl


{-| Set a text field's HTML `autocomplete` attribute.
-}
autocomplete : String -> Property m
autocomplete =
    nativeControl << List.singleton << Options.autocomplete


{-| Set a text field's HTML `autofocus` attribute.
-}
autofocus : Property m
autofocus =
    nativeControl [ Options.autofocus True ]


{-| Sets a text field's onFocus handler.

This is here for convenience, because the onFocus handler has to be set on the
`nativeControl`. For other events, see `Material.Options`.

-}
onFocus : m -> Property m
onFocus handler =
    nativeControl [ Options.onFocus handler ]


{-| Sets a text field's onBlur handler.

This is here for convenience, because the onBlur handler has to be set on the
`nativeControl`. For other events, see `Material.Options`.

-}
onBlur : m -> Property m
onBlur handler =
    nativeControl [ Options.onBlur handler ]
