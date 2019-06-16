module Internal.TextField.CharacterCounter.Implementation exposing (characterCounter)

import Html exposing (Html)
import Internal.Options as Options exposing (cs, styled)


characterCounter : List (Options.Property c m) -> List (Html m) -> Html m
characterCounter options text =
    styled Html.div
        (cs "mdc-text-field-character-counter" :: options)
        text
