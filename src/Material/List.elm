module Material.List
    exposing
    ( activated
    , avatarList
    , defaultConfig
    , dense
    , divider
    , graphic
    , graphicIcon
    , graphicImage
    , group
    , inset
    , li
    , listItem
    , meta
    , metaIcon
    , metaImage
    , metaText
    , nonInteractive
    , padded
    , Property
    , secondaryText
    , selected
    , subheader
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
@docs ul, nonInteractive, dense, avatarList, twoLine, Property, defaultConfig

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
import Material.Options as Options exposing (styled, cs)


type alias Config =
    {}


{-| List default config.

Internal use only.
-}
defaultConfig : Config
defaultConfig =
    {}


{-| List property.
-}
type alias Property m =
    Options.Property Config m


{-| The list element
-}
ul : List (Property m) -> List (Html m) -> Html m
ul options =
    styled Html.ul (cs "mdc-list" :: options)


{-| Disables interactivity affordances
-}
nonInteractive : Property m
nonInteractive =
    cs "mdc-list--non-interactive"


{-| Make the list appear more compact
-}
dense : Property m
dense =
    cs "mdc-list--dense"


{-| Configure the leading tiles of each row to display images instead of icons
-}
avatarList : Property m
avatarList =
    cs "mdc-list--avatar-list"


{-| List items have primary and secondary lines
-}
twoLine : Property m
twoLine =
    cs "mdc-list--two-line"


{-| List item element
-}
li : List (Property m) -> List (Html m) -> Html m
li options =
    styled Html.li (cs "mdc-list-item" :: options)


{-| List item element, a instead of li
-}
listItem : List (Property m) -> List (Html m) -> Html m
listItem options =
    styled Html.a (cs "mdc-list-item" :: options)


{-| Primary text for the row
-}
text : List (Property m) -> List (Html m) -> Html m
text options =
  styled Html.span (cs "mdc-list-item__text" :: options)


{-| Secondary text for the row
-}
secondaryText : List (Property m) -> List (Html m) -> Html m
secondaryText options =
  styled Html.span (cs "mdc-list-item__secondary-text" :: options)


{-| Styles a row in selected state
-}
selected : Property m
selected =
  cs "mdc-list-item--selected"


{-| Styles a row in activated state
-}
activated : Property m
activated =
  cs "mdc-list-item--activated"


{-| The first tile in a row, typically an icon or image
-}
graphic : List (Property m) -> List (Html m) -> Html m
graphic options =
    styled Html.span (cs "mdc-list-item__graphic" :: options)


{-| The first tile in a row as an icon
-}
graphicIcon : List (Icon.Property m) -> String -> Html m
graphicIcon options =
    Icon.view (cs "mdc-list-item__graphic" :: options)


{-| The first tile in a row as an image
-}
graphicImage : List (Property m) -> String -> Html m
graphicImage options url =
    styled Html.img
      ( cs "mdc-list-item__graphic"
      :: Options.attribute (Html.src url)
      :: options
      )
      []


{-| The last tile in a row, typically small text, and icon or image.
-}
meta : List (Property m) -> List (Html m) -> Html m
meta options =
    styled Html.span (cs "mdc-list-item__meta" :: options)


{-| The last tile in a row as text
-}
metaText : List (Property m) -> String -> Html m
metaText options str =
    styled Html.span (cs "mdc-list-item__meta" :: options) [ Html.text str ]


{-| The last tile in a row as an icon
-}
metaIcon : List (Icon.Property m) -> String -> Html m
metaIcon options =
    Icon.view (cs "mdc-list-item__meta" :: options)


{-| The last tile in a row as an image
-}
metaImage : List (Property m) -> String -> Html m
metaImage options url =
    styled Html.img
      ( cs "mdc-list-item__meta"
      :: Options.attribute (Html.src url)
      :: options
      )
      []


{-| Wrapper around two or more list elements to be grouped together
-}
group : List (Property m) -> List (Html m) -> Html m
group options =
    styled Html.div (cs "mdc-list-group"::options)


{-| Heading text displayed above each list in a group
-}
subheader : List (Property m) -> List (Html m) -> Html m
subheader options =
    styled Html.div (cs "mdc-list-group__subheader"::options)


{-| List divider element
-}
divider : List (Property m) -> List (Html m) -> Html m
divider options _ =
    styled Html.hr (cs "mdc-list-divider"::options) []


{-| Leaves a gap on each side of the divider to match the padding of `meta`
-}
padded : Property m
padded =
    cs "mdc-list-divier--padded"


{-| Increases the leading margin of the divider so that it does not intersect
the avatar column
-}
inset : Property m
inset =
    cs "mdc-list-divider--inset"
