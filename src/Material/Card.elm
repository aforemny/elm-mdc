module Material.Card
    exposing
        ( -- VIEW
          view

        , primary
        , title
        , large
        , subtitle

        , supportingText

        , actions
        , vertical

        , media
        , mediaItem
        , x1dot5
        , x2
        , x3

        , horizontalBlock

        , Property
        , darkTheme
        )

{-| Card is a component that implements the Material Design card component.

## Design & API Documentation

- [Material Design guidelines: Cards](https://material.io/guidelines/components/cards.html)
- [Demo](https://aforemny.github.io/elm-mdc/#cards)

@docs view

## Elements
@docs primary, title, large, subtitle
@docs supportingText
@docs actions, vertical
@docs media, mediaItem, x1dot5, x2, x3
@docs horizontalBlock

## Properties
@docs Property
@docs darkTheme
-}

import Html exposing (Html)
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


{-| Use a dark theme for this card.
-}
darkTheme : Property m
darkTheme =
    cs "mdc-card--theme-dark"


{-| Component view.
-}
view : List (Property m) -> List (Html m) -> Html m
view options =
    Options.div (cs "mdc-card" :: options)


{-| Defines the primary text / title content block.
-}
primary : List (Property m) -> List (Html m) -> Html m
primary options =
    div (cs "mdc-card__primary"::options)


{-| A title block, to be contained in the primary section of the card.
-}
title : List (Property m) -> List (Html m) -> Html m
title options =
    div (cs "mdc-card__title"::options)


{-| An option for the title, to make it larger.
-}
large : Property m
large =
    cs "mdc-card__title--large"

{-| A subtitle block, to be contained in the primary section of the card.
-}
subtitle : List (Property m) -> List (Html m) -> Html m
subtitle options =
    div (cs "mdc-card__subtitle"::options)


{-| This area is used for displaying the bulk of the textual content of the card.
-}
supportingText : List (Property m) -> List (Html m) -> Html m
supportingText options =
    div (cs "mdc-card__supporting-text"::options)


{-| Actions to include on a card.
-}
actions : List (Property m) -> List (Html m) -> Html m
actions options =
    div (cs "mdc-card__actions"::options)


{-| Option to lay actions out vertically instead of horizontally.
-}
vertical : Property m
vertical =
    cs "mdc-card__actions--vertical"


{-| Used for showing rich media in cards.
-}
media : List (Property m) -> List (Html m) -> Html m
media options =
    div (cs "mdc-card__media"::options)


{-| Media items are designed to be used in horizontal blocks, taking up a fixed height,
rather than stretching to the width of the card.
-}
mediaItem : List (Property m) -> List (Html m) -> Html m
mediaItem options =
    div (cs "mdc-card__media-item"::options)


{-| Predefined media item size - 120px.
-}
x1dot5 : Property m
x1dot5 =
    cs "mdc-card__media-item--1dot5x"


{-| Predefined media item size - 160px.
-}
x2 : Property m
x2 =
    cs "mdc-card__media-item--2x"


{-| Predefined media item size - 240px.
-}
x3 : Property m
x3 =
    cs "mdc-card__media-item--3x"


{-| Stack multiple card blocks horizontally instead of vertically by placing in a `horizontalBlock`.
-}
horizontalBlock : List (Property m) -> List (Html m) -> Html m
horizontalBlock options =
    Options.div (cs "mdc-card__horizontal-block"::options)
