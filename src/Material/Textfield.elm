module Material.Textfield exposing
    ( box
    , cols
    , dense
    , disabled
    , email
    , fullwidth
    , iconUnclickable
    , invalid
    , label
    , leadingIcon
    , outlined
    , password
    , pattern
    , placeholder
    , Property
    , required
    , rows
    , textarea
    , trailingIcon
    , type_
    , value
    , view
    )
{-|
Text fields allow users to input, edit, and select text.


# Resources

- [Material Design guidelines: Text Fields](https://material.io/guidelines/components/text-fields.html)
- [Demo](https://aforemny.github.io/elm-mdc/#text-field)


# Example

```elm
import Material.Textfield as Textfield

Textfield.view Mdc [0] model.mdc
    [ Textfield.label "Text field"
    ]
    []
```


# Usage

@docs Property
@docs view
@docs label
@docs value
@docs placeholder
@docs box
@docs outlined
@docs fullwidth
@docs disabled
@docs dense
@docs email
@docs password
@docs type_
@docs textarea
@docs rows
@docs cols
@docs leadingIcon
@docs trailingIcon
@docs iconUnclickable
@docs required
@docs invalid
@docs pattern
-}

import Html exposing (Html)
import Material.Component exposing (Indexed, Index)
import Material.Internal.Textfield.Implementation as Textfield
import Material.Msg


{-| Textfield property.
-}
type alias Property m =
    Textfield.Property m


type alias Store s =
    { s | textfield : Indexed Textfield.Model }


{-| Textfield view.
-}
view
    : (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
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
