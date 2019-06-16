module Material.TextField.HelperLine exposing (helperLine)

{-| Use Helper line to wrap any helper text. For single line text
fields also put the character counter inside it.


# Resources

  - [Text Field Helper Text - Material Components for the Web](https://material.io/develop/web/components/input-controls/text-field/helper-text/)
  - [Material Design guidelines: Text Fields Layout](https://material.io/guidelines/components/text-fields.html#text-fields-layout)
  - [Demo](https://aforemny.github.io/elm-mc/#text-field)


# Example

    import Html exposing (text)
    import Material.TextField as TextField
    import Material.TextField.HelperLine as TextField
    import Material.TextField.HelperText as TextField


    Html.div []
        [ TextField.view Mdc "my-text-field" model.mdc
              [ TextField.label "Email Adress"
              ]
              []
        , TextField.helperLine []
              [ TextField.helperText []
                  [ text "Help Text" ]
              ]
        ]


# Usage

@docs helperLine

-}

import Html exposing (Html)
import Internal.TextField.HelperLine.Implementation as HelperLine
import Material.Options exposing (Property)


{-| HelperLine view.
-}
helperLine : List (Property c m) -> List (Html m) -> Html m
helperLine =
    HelperLine.helperLine
