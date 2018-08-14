module Material.Textfield
    exposing
        ( Property
        , autocomplete
        , autofocus
        , box
        , cols
        , dense
        , disabled
        , email
        , fullwidth
        , iconUnclickable
        , invalid
        , label
        , leadingIcon
        , nativeControl
        , onBlur
        , onFocus
        , outlined
        , password
        , pattern
        , placeholder
        , required
        , rows
        , textarea
        , trailingIcon
        , type_
        , value
        , view
        )

{-| Text fields allow users to input, edit, and select text.


# Resources

  - [Material Design guidelines: Text Fields](https://material.io/guidelines/components/text-fields.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#text-field)


# Example

    import Material.Options as Options
    import Material.Textfield as Textfield

    Textfield.view Mdc "my-text-field" model.mdc
        [ Textfield.label "Text field"
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
@docs dense
@docs disabled


### Icon properties

@docs leadingIcon
@docs trailingIcon
@docs iconUnclickable


### Validation properties

@docs required
@docs invalid
@docs pattern


## Variants

@docs box
@docs outlined
@docs fullwidth


### Multiline

@docs textarea
@docs rows
@docs cols


## Type

@docs email
@docs password
@docs type_


## Autocomplete

@docs nativeControl


## Native control

@docs autocomplete
@docs autofocus
@docs onFocus
@docs onBlur
-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Options as Options
import Internal.Textfield.Implementation as Textfield
import Material


{-| Textfield property.
-}
type alias Property m =
    Textfield.Property m


{-| Textfield view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Textfield.view


{-| Make textfield icons unclickable.
-}
iconUnclickable : Property m
iconUnclickable =
    Textfield.iconUnclickable


{-| Add a leading icon to the textfield.
-}
leadingIcon : String -> Property m
leadingIcon =
    Textfield.leadingIcon


{-| Add a trailing icon to the textfield.
-}
trailingIcon : String -> Property m
trailingIcon =
    Textfield.trailingIcon


{-| Style the textfield as an outlined textfield.
-}
outlined : Property m
outlined =
    Textfield.outlined


{-| Set a label for the textfield.
-}
label : String -> Property m
label =
    Textfield.label


{-| Set the textfield's value.
-}
value : String -> Property m
value =
    Textfield.value


{-| Disable the textfield.
-}
disabled : Property m
disabled =
    Textfield.disabled


{-| Set the textfield's `type` to `password`.
-}
password : Property m
password =
    Textfield.password


{-| Set the textfield's `type` to `email`.
-}
email : Property m
email =
    Textfield.email


{-| Style the textfield as a box textfield.
-}
box : Property m
box =
    Textfield.box


{-| Set a pattern to validate the textfield's input against.

The text field is automatically marked invalid if the pattern does not match
its input.

-}
pattern : String -> Property m
pattern =
    Textfield.pattern


{-| Set the number of rows in a `textarea` textfield.
-}
rows : Int -> Property m
rows =
    Textfield.rows


{-| Set the number of columns in a `textarea` textfield.
-}
cols : Int -> Property m
cols =
    Textfield.cols


{-| Style the textfield as a dense textfield.
-}
dense : Property m
dense =
    Textfield.dense


{-| Mark the textfield as required.
-}
required : Property m
required =
    Textfield.required


{-| Set the textfield's type.
-}
type_ : String -> Property m
type_ =
    Textfield.type_


{-| Make the textfield take up all the available horizontal space.
-}
fullwidth : Property m
fullwidth =
    Textfield.fullwidth


{-| Mark the textfield as invalid.
-}
invalid : Property m
invalid =
    Textfield.invalid


{-| Make the textfield a `textarea` element instead of `input`.
-}
textarea : Property m
textarea =
    Textfield.textarea


{-| Sets the placeholder of the textfield.
-}
placeholder : String -> Property m
placeholder =
    Textfield.placeholder


{-| Apply properties to underlying native control element.
-}
nativeControl : List (Options.Property () m) -> Property m
nativeControl =
    Textfield.nativeControl


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
