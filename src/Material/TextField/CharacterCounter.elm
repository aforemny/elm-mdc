module Material.TextField.CharacterCounter exposing (characterCounter)

{-| Character counter is used if there is a character limit. It displays the ratio of characters used and the total character limit.


# Resources

  - [Text Field Character Counter - Material Components for the Web](https://material.io/develop/web/components/input-controls/text-field/character-counter/)
  - [Material Design guidelines: Text Fields Layout](https://material.io/guidelines/components/text-fields.html#text-fields-layout)
  - [Demo](https://aforemny.github.io/elm-mc/#text-field)


# Examples


## Character counter for single-line text

    import Html exposing (text)
    import Material.TextField as TextField
    import Material.TextField.HelperLine as TextField
    import Material.TextField.HelperText as TextField
    import Material.TextField.CharacterCounter as TextField


    Html.div []
        [ TextField.view Mdc "my-text-field" model.mdc
              [ TextField.label "SMS" ]
              []
        , TextField.helperText []
          [ text "Help Text" ]
        , TextField.characterCounter []
          [ text "0 / 140" ]
        ]


# Usage

@docs characterCounter

-}

import Html exposing (Html)
import Internal.TextField.CharacterCounter.Implementation as CharacterCounter
import Material.Options exposing (Property)


{-| CharacterCounter view.
-}
characterCounter : List (Property c m) -> List (Html m) -> Html m
characterCounter =
    CharacterCounter.characterCounter
