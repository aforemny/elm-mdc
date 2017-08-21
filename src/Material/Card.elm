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


type alias Property m =
    Options.Property Config m


darkTheme : Property m
darkTheme =
    cs "mdc-card--theme-dark"


view : List (Property m) -> List (Html m) -> Html m
view options =
    Options.div (cs "mdc-card" :: options)


primary : List (Property m) -> List (Html m) -> Html m
primary options =
    div (cs "mdc-card__primary"::options)


title : List (Property m) -> List (Html m) -> Html m
title options =
    div (cs "mdc-card__title"::options)


large : Property m
large =
    cs "mdc-card__title--large"

subtitle : List (Property m) -> List (Html m) -> Html m
subtitle options =
    div (cs "mdc-card__subtitle"::options)


supportingText : List (Property m) -> List (Html m) -> Html m
supportingText options =
    div (cs "mdc-card__supporting-text"::options)


actions : List (Property m) -> List (Html m) -> Html m
actions options =
    div (cs "mdc-card__actions"::options)


vertical : Property m
vertical =
    cs "mdc-card__actions--vertical"


media : List (Property m) -> List (Html m) -> Html m
media options =
    div (cs "mdc-card__media"::options)


mediaItem : List (Property m) -> List (Html m) -> Html m
mediaItem options =
    div (cs "mdc-card__media-item"::options)


x1dot5 : Property m
x1dot5 =
    cs "mdc-card__media-item--1dot5x"


x2 : Property m
x2 =
    cs "mdc-card__media-item--2x"


x3 : Property m
x3 =
    cs "mdc-card__media-item--3x"


horizontalBlock : List (Property m) -> List (Html m) -> Html m
horizontalBlock options =
    Options.div (cs "mdc-card__horizontal-block"::options)
