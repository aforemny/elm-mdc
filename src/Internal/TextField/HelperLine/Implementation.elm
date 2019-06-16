module Internal.TextField.HelperLine.Implementation exposing (helperLine)

import Html exposing (Html)
import Internal.Options as Options exposing (cs, styled)


helperLine : List (Options.Property c m) -> List (Html m) -> Html m
helperLine options list =
    styled Html.div
        (cs "mdc-text-field-helper-line" :: options)
        list
