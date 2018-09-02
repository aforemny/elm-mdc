module Material.Textfield.HelperText
    exposing
        ( Property
        , helperText
        , persistent
        , validationMsg
        )

{-| Helper text gives context about a field’s input, such as how the input will be
used. It should be visible either persistently or only on focus.


# Resources

  - [Material Design guidelines: Text Fields Layout](https://material.io/guidelines/components/text-fields.html#text-fields-layout)
  - [Demo](https://aforemny.github.io/elm-mc/#text-field)


# Example

    import Html exposing (text)
    import Material.Textfield as Textfield
    import Material.Textfield.HelperText as Textfield


    Html.div []
        [ Textfield.view Mdc "my-text-field" model.mdc
              [ Textfield.label "Email Adress"
              ]
              []
        , Textfield.helperText
          [ Textfield.persistent
          , Textfield.validationMsg
          ]
          [ text "Help Text (possibly validation message)"
          ]
        ]


# Usage

@docs Property
@docs helperText
@docs persistent
@docs validationMsg

-}

import Html exposing (Html)
import Internal.Textfield.HelperText.Implementation as HelperText


{-| HelperText property.
-}
type alias Property m =
    HelperText.Property m


{-| HelperText view.
-}
helperText : List (Property m) -> List (Html m) -> Html m
helperText =
    HelperText.helperText


{-| Make the helper text permanently visible.
-}
persistent : Property m
persistent =
    HelperText.persistent


{-| Indicates the helper text is a validation message.

It will only show when the text field is marked as invalid or if it is
`persistent`.

-}
validationMsg : Property m
validationMsg =
    HelperText.validationMsg
