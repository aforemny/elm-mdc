module Internal.FormField.Implementation exposing
    ( Property
    , alignEnd
    , view
    , noWrap
    )

import Html exposing (Html)
import Internal.Options as Options exposing (cs, styled)


type alias Config =
    {}


type alias Property m =
    Options.Property Config m


view : List (Property m) -> List (Html m) -> Html m
view options =
    styled Html.div (cs "mdc-form-field" :: options)


alignEnd : Property m
alignEnd =
    cs "mdc-form-field--align-end"

noWrap : Property m
noWrap =
    cs "mdc-form-field--nowrap"
