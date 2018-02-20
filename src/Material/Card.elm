module Material.Card
    exposing
        ( actionButton
        , actionButtons
        , actionIcon
        , actionIcons
        , actions
        , aspect16To9
        , fullBleed
        , media
        , backgroundImage
        , mediaContent
        , primaryAction
        , Property
        , square
        , stroked
        , view
        )

{-| Card is a component that implements the Material Design card component.

## Design & API Documentation

- [Material Design guidelines: Cards](https://material.io/guidelines/components/cards.html)
- [Demo](https://aforemny.github.io/elm-mdc/#cards)

@docs Property
@docs view
@docs stroked
@docs primary
@docs secondary
@docs primaryAction

### Card media
@docs media
@docs backgroundImage
@docs square
@docs aspect16-9
@docs mediaContent

### Card actions
@docs actions
@docs fullBleed
@docs actionButtons
@docs actionIcons
@docs actionButton
@docs actionIcon
-}

import Html exposing (Html)
import Material.Button as Button
import Material.IconToggle as IconToggle
import Material.Options as Options exposing (cs, css, div)


type alias Config =
    {}


defaultConfig : Config
defaultConfig =
    {}


{-| A card's property.
-}
type alias Property m =
    Options.Property Config m


{-| Component view.
-}
view : List (Property m) -> List (Html m) -> Html m
view options =
    Options.div (cs "mdc-card" :: options)


{-| Removes the card's shadow and displays a hairline stroke instead
-}
stroked : Property m
stroked =
    cs "mdc-card--stroked"


{-| The main tappable area of the card. Typically contains all card content,
except `cardActions`. Only applicable to cards that have a primary action that
the main surface should trigger.
-}
primaryAction : List (Property m) -> List (Html m) -> Html m
primaryAction options =
    div (cs "mdc-card__primary-action"::options)


{-| Media area that displays a custom `background-image` with `background-size: cover`
-}
media : List (Property m) -> List (Html m) -> Html m
media options =
    div
    ( cs "mdc-card__media"
    :: options
    )


backgroundImage : String -> Property m
backgroundImage url =
    css "background-image" ("url(" ++ url ++ ")")


{-| Automatically scales the media area's height to equal its width
-}
square : Property m
square =
    cs "mdc-card__media--square"


{-| Automatically scales the media area's height according to its width,
maintaining a 16:9 aspect ratio
-}
aspect16To9 : Property m
aspect16To9 =
    cs "mdc-card__media--16-9"


{-| An absolutely-positioned box the same size as the media area, for
displaying a title or icon on top of the `background-image`
-}
mediaContent : List (Property m) -> List (Html m) -> Html m
mediaContent options =
    div
    ( cs "mdc-card__media-content"
    :: options
    )


{-| Row containing action buttons and/or icons
-}
actions : List (Property m) -> List (Html m) -> Html m
actions options =
    div
    ( cs "mdc-card__actions"
    :: options
    )


{-| Removes the action area's padding and causes its only child (`actions`
element) to consume 100% of the action area's width
-}
fullBleed : Property m
fullBleed =
    cs "mdc-card__actions--full-bleed"


{-| A group of action buttons, displayed on the left side of the card (in LTR),
adjacent to `actionIcons`
-}
actionButtons : List (Property m) -> List (Html m) -> Html m
actionButtons options =
    div
    ( cs "mdc-card__action-buttons"
    :: options
    )


{-| A group of supplemental icons, displayed on the right side of the card (in
LTR), adjacent to `actionButtons`
-}
actionIcons : List (Property m) -> List (Html m) -> Html m
actionIcons options =
    div
    ( cs "mdc-card__action-icons"
    :: options
    )


{-| An action button with text
-}
actionButton : Button.Property m
actionButton =
    cs "mdc-card__action mdc-card__action-button"



{-| An action icon with text
-}
actionIcon : IconToggle.Property m
actionIcon =
    cs "mdc-card__action mdc-card__action-icon"
