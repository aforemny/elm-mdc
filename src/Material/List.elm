module Material.List
    exposing
    ( activated
    , avatarList
    , dense
    , divider
    , graphic
    , graphicIcon
    , graphicImage
    , group
    , subheader
    , inset
    , li
    , listItem
    , meta
    , metaIcon
    , metaImage
    , metaText
    , nonInteractive
    , padded
    , secondaryText
    , selected
    , text
    , twoLine
    , ul
    )

{-|
MDC List provides styles which implement Material Design Lists - “A single
continuous column of tessellated subdivisions of equal width.” Both single-line
and two-line lists are supported (with three-line lists coming soon). MDC Lists
are designed to be accessible and RTL aware.

## Design & API Documentation

- [Material Design guidelines: Lists](https://material.io/guidelines/components/lists.html)
- [Demo](https://aforemny.github.io/elm-mdc/#lists)

### List element
@docs ul, nonInteractive, dense, avatarList, twoLine

### List items
@docs li, listItem, text, secondaryText, selected, activated, graphic, graphicIcon, graphicImage, meta, metaText, metaIcon, metaImage

### List groups
@docs group, subheader

### List dividers
@docs divider, padded, inset
-}

import Html.Attributes as Html
import Html exposing (Html)
import Material.Icon as Icon
import Material.Options as Options exposing (Property, styled, cs)


{-| The list element
-}
ul : List (Property c m) -> List (Html m) -> Html m
ul options =
    styled Html.ul (cs "mdc-list" :: options)


{-| Disables interactivity affordances
-}
nonInteractive : Property c m
nonInteractive =
    cs "mdc-list--non-interactive"


{-| Make the list appear more compact
-}
dense : Property c m
dense =
    cs "mdc-list--dense"


{-| Configure the leading tiles of each row to display images instead of icons
-}
avatarList : Property c m
avatarList =
    cs "mdc-list--avatar-list"


{-| List items have primary and secondary lines
-}
twoLine : Property c m
twoLine =
    cs "mdc-list--two-line"


{-| List item element
-}
li : List (Property c m) -> List (Html m) -> Html m
li options =
    styled Html.li (cs "mdc-list-item" :: options)


{-| List item element, a instead of li
-}
listItem : List (Property c m) -> List (Html m) -> Html m
listItem options =
    styled Html.a (cs "mdc-list-item" :: options)


{-| Primary text for the row
-}
text : List (Property c m) -> List (Html m) -> Html m
text options =
  styled Html.span (cs "mdc-list-item__text" :: options)


{-| Secondary text for the row
-}
secondaryText : List (Property c m) -> List (Html m) -> Html m
secondaryText options =
  styled Html.span (cs "mdc-list-item__secondary-text" :: options)


{-| Styles a row in selected state
-}
selected : Property c m
selected =
  cs "mdc-list-item--selected"


{-| Styles a row in activated state
-}
activated : Property c m
activated =
  cs "mdc-list-item--activated"


{-| The first tile in a row, typically an icon or image
-}
graphic : List (Property c m) -> List (Html m) -> Html m
graphic options =
    styled Html.span (cs "mdc-list-item__graphic" :: options)


{-| The first tile in a row as an icon
-}
graphicIcon : List (Icon.Property m) -> String -> Html m
graphicIcon options =
    Icon.view (cs "mdc-list-item__graphic" :: options)


{-| The first tile in a row as an image
-}
graphicImage : List (Property c m) -> String -> Html m
graphicImage options url =
    styled Html.img
      ( cs "mdc-list-item__graphic"
      :: Options.attribute (Html.src url)
      :: options
      )
      []


{-| The last tile in a row, typically small text, and icon or image.
-}
meta : List (Property c m) -> List (Html m) -> Html m
meta options =
    styled Html.span (cs "mdc-list-item__meta" :: options)


{-| The last tile in a row as text
-}
metaText : List (Property c m) -> String -> Html m
metaText options str =
    styled Html.span (cs "mdc-list-item__meta" :: options) [ Html.text str ]


{-| The last tile in a row as an icon
-}
metaIcon : List (Icon.Property m) -> String -> Html m
metaIcon options =
    Icon.view (cs "mdc-list-item__meta" :: options)


{-| The last tile in a row as an image
-}
metaImage : List (Property c m) -> String -> Html m
metaImage options url =
    styled Html.img
      ( cs "mdc-list-item__meta"
      :: Options.attribute (Html.src url)
      :: options
      )
      []


{-| Wrapper around two or more list elements to be grouped together
-}
group : List (Property c m) -> List (Html m) -> Html m
group options =
    styled Html.div (cs "mdc-list-group"::options)


{-| Heading text displayed above each list in a group
-}
subheader : List (Property c m) -> List (Html m) -> Html m
subheader options =
    styled Html.div (cs "mdc-list-group__subheader"::options)


{-| List divider element
-}
divider : List (Property c m) -> List (Html m) -> Html m
divider options _ =
    styled Html.hr (cs "mdc-list-divider"::options) []


{-| Leaves a gap on each side of the divider to match the padding of `meta`
-}
padded : Property c m
padded =
    cs "mdc-list-divier--padded"


{-| Increases the leading margin of the divider so that it does not intersect
the avatar column
-}
inset : Property c m
inset =
    cs "mdc-list-divider--inset"
