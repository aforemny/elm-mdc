module Material.Card
    exposing
        ( view
        , darkTheme
        , primary
        , title
        , large
        , subtitle
        , media
        , mediaItem
        , x1dot5
        , x2
        , x3
        , supportingText
        , actions
        , vertical
        , horizontalBlock
        )

{-| From the [Material Design Lite documentation](https://getmdl.io/components/#cards-section):

> The Material Design Lite (MDL) card component is a user interface element
> representing a virtual piece of paper that contains related data — such as a
> photo, some text, and a link — that are all about a single subject.
>
> Cards are a convenient means of coherently displaying related block that is
> composed of different types of objects. They are also well-suited for presenting
> similar objects whose size or supported actions can vary considerably, like
> photos with captions of variable length. Cards have a constant width and a
> variable height, depending on their block.
>
> Cards are a fairly new feature in user interfaces, and allow users an access
> point to more complex and detailed information. Their design and use is an
> important factor in the overall user experience. See the card component's
> Material Design specifications page for details.

Refer to [this site](http://debois.github.io/elm-mdl/#cards)
for a live demo.

# Render
@docs view
@docs primary, title, subtitle

# Content blocks
@docs title, media, text, actions

## Title block
@docs subhead, head

# Misc
@docs expand, border, menu
-}

import Html exposing (Html)
import Material.Options as Options exposing (Style, cs, css, div)


{-| Generate a primary block
-}
primary : List (Style a) -> List (Html a) -> Html a
primary options =
    div (cs "mdc-card__primary"::options)


{-| Generate a title block
-}
title : List (Style a) -> List (Html a) -> Html a
title options =
    div (cs "mdc-card__title"::options)


{-| Large title
-}
large : Style a
large =
    cs "mdc-card__title--large"

{-| Generate a subtitle block
-}
subtitle : List (Style a) -> List (Html a) -> Html a
subtitle options =
    div (cs "mdc-card__subtitle"::options)


{-| Generate a media block
-}
media : List (Style a) -> List (Html a) -> Html a
media options =
    div (cs "mdc-card__media"::options)


mediaItem : List (Style a) -> List (Html a) -> Html a
mediaItem options =
    div (cs "mdc-card__media-item"::options)


x1dot5 : Style a
x1dot5 =
    cs "mdc-card__media-item--1dot5x"


x2 : Style a
x2 =
    cs "mdc-card__media-item--2x"


x3 : Style a
x3 =
    cs "mdc-card__media-item--3x"


{-| Generate a supporting text block
-}
supportingText : List (Style a) -> List (Html a) -> Html a
supportingText options =
    div (cs "mdc-card__supporting-text"::options)


{-| Generate an actions block
-}
actions : List (Style a) -> List (Html a) -> Html a
actions options =
    div (cs "mdc-card__actions"::options)


{-| Make actions block elements stack vertically.
-}
vertical : Style a
vertical =
    cs "mdc-card__actions--vertical"


{-| Horizontal block
-}
horizontalBlock : List (Style a) -> List (Html a) -> Html a
horizontalBlock options =
    Options.div (cs "mdc-card__horizontal-block"::options)


{-| Construct a card.
-}
view : List (Style a) -> List (Html a) -> Html a
view options =
    Options.div (cs "mdc-card" :: options)


{-| Dark-themed card
-}
darkTheme : Style a
darkTheme =
    cs "mdc-card--theme-dark"
