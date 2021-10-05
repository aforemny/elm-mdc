module Internal.Card.Implementation exposing
    ( Property
    , actionButton
    , actionButtons
    , actionIcon
    , actionIcons
    , actions
    , aspect16To9
    , backgroundImage
    , fullBleed
    , media
    , mediaContent
    , primaryAction
    , square
    , stroked
    , view
    )

import Html exposing (Html)
import Internal.Button.Implementation as Button
import Internal.IconButton.Implementation as IconButton
import Internal.Options as Options exposing (cs, css, styled, tabindex)


type alias Config =
    {}


type alias Property m =
    Options.Property Config m


view : List (Property m) -> List (Html m) -> Html m
view options =
    styled Html.div (cs "mdc-card" :: options)


stroked : Property m
stroked =
    cs "mdc-card--stroked"


primaryAction : List (Property m) -> List (Html m) -> Html m
primaryAction options inner =
    styled Html.div
        ( cs "mdc-card__primary-action"
        :: tabindex 0
        :: options
        )
        ( [ styled Html.div [ cs "mdc-card__ripple" ] [] ]
        ++ inner )


media : List (Property m) -> List (Html m) -> Html m
media options =
    styled Html.div (cs "mdc-card__media" :: options)


backgroundImage : String -> Property m
backgroundImage url =
    css "background-image" ("url(" ++ url ++ ")")


square : Property m
square =
    cs "mdc-card__media--square"


aspect16To9 : Property m
aspect16To9 =
    cs "mdc-card__media--16-9"


mediaContent : List (Property m) -> List (Html m) -> Html m
mediaContent options =
    styled Html.div (cs "mdc-card__media-content" :: options)


actions : List (Property m) -> List (Html m) -> Html m
actions options =
    styled Html.div (cs "mdc-card__actions" :: options)


fullBleed : Property m
fullBleed =
    cs "mdc-card__actions--full-bleed"


actionButtons : List (Property m) -> List (Html m) -> Html m
actionButtons options =
    styled Html.div (cs "mdc-card__action-buttons" :: options)


actionIcons : List (Property m) -> List (Html m) -> Html m
actionIcons options =
    styled Html.div (cs "mdc-card__action-icons" :: options)


actionButton : Button.Property m
actionButton =
    cs "mdc-card__action mdc-card__action-button"


actionIcon : IconButton.Property m
actionIcon =
    cs "mdc-card__action mdc-card__action-icon"
