module Material.List exposing
    ( activated
    , avatarList
    , dense
    , divider
    , graphic
    , graphicIcon
    , graphicImage
    , group
    , groupDivider
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
List provides styles which implement Material Design Lists - “A single
continuous column of tessellated subdivisions of equal width.” Both single-line
and two-line lists are supported.

To avoid namespace conflicts with the `List` module, this module should be
imported qualified as `Lists`.


# Resources

- [Material Design guidelines: Lists](https://material.io/guidelines/components/lists.html)
- [Demo](https://aforemny.github.io/elm-mdc/#lists)


# Example


```elm
import Html exposing (text)
import Material.List as Lists


Lists.ul
    [ Lists.twoLine
    , Lists.avatarList
    ]
    [ Lists.li []
          [ Lists.graphicIcon [] "folder"
          , Lists.text []
                [ text "Photos"
                , Lists.secondaryText []
                      [ text "Jan 9, 2014"
                      ]
                ]
          , Lists.metaIcon [] "info"
          ]
    , Lists.li []
          [ Lists.graphicIcon [] "folder"
          , Lists.text []
                [ text "Recipes"
                , Lists.secondaryText []
                      [ text "Jan 17, 2014"
                      ]
                ]
          , Lists.metaIcon [] "info"
          ]
    , Lists.li []
          [ Lists.graphicIcon [] "folder"
          , Lists.text []
                [ text "Work"
                , Lists.secondaryText []
                      [ text "Jan 28, 2014"
                      ]
                ]
          , Lists.metaIcon [] "info"
          ]
    ]
```


# Usage

## Lists

@docs Property
@docs ul
@docs nonInteractive
@docs dense
@docs avatarList
@docs twoLine


## List Items

@docs li
@docs text
@docs secondaryText
@docs selected
@docs activated
@docs graphic, graphicIcon, graphicImage
@docs meta, metaText, metaIcon, metaImage


## List Groups

@docs group
@docs subheader


## Dividers

@docs divider
@docs groupDivider
@docs padded
@docs inset
-}

import Html exposing (Html)
import Material.Internal.Icon.Implementation as Icon
import Material.Internal.List.Implementation as List


{-| List property.
-}
type alias Property m =
    List.Property m


{-| The list element.
-}
ul : List (Property m) -> List (Html m) -> Html m
ul =
    List.ul


{-| Disables interactivity affordances.
-}
nonInteractive : Property m
nonInteractive =
    List.nonInteractive


{-| Make the list appear more compact.
-}
dense : Property m
dense =
    List.dense


{-| Configure the leading tiles of each row to display images instead of icons.
-}
avatarList : Property m
avatarList =
    List.avatarList


{-| List items have primary and secondary lines.
-}
twoLine : Property m
twoLine =
    List.twoLine


{-| List item element.
-}
li : List (Property m) -> List (Html m) -> Html m
li =
    List.li


{-| Class that indicates this is a list item.
-}
listItem : Property m
listItem =
    List.listItem


{-| Primary text for the row.
-}
text : List (Property m) -> List (Html m) -> Html m
text =
    List.text


{-| Secondary text for the row, in case the list is `twoLine`.
-}
secondaryText : List (Property m) -> List (Html m) -> Html m
secondaryText =
    List.secondaryText


{-| Styles a row in selected state.
-}
selected : Property m
selected =
    List.selected


{-| Styles a row in activated state.
-}
activated : Property m
activated =
    List.activated


{-| The first tile in a row, typically an icon or image.
-}
graphic : List (Property m) -> List (Html m) -> Html m
graphic =
    List.graphic


{-| The first tile in a row as an icon.

The second argument is a Material Icon identifier.
-}
graphicIcon : List (Icon.Property m) -> String -> Html m
graphicIcon =
    List.graphicIcon


{-| The first tile in a row as an image.

The second argument is the URL of the image.
-}
graphicImage : List (Property m) -> String -> Html m
graphicImage =
    List.graphicImage


{-| The last tile in a row, typically small text, and icon or image.
-}
meta : List (Property m) -> List (Html m) -> Html m
meta =
    List.meta


{-| The last tile in a row as text.
-}
metaText : List (Property m) -> String -> Html m
metaText =
    List.metaText


{-| The last tile in a row as an icon.

The second argument is a Material Icon identifier.
-}
metaIcon : List (Icon.Property m) -> String -> Html m
metaIcon =
    List.metaIcon


{-| The last tile in a row as an image.

The second argument is the url of the image.
-}
metaImage : List (Property m) -> String -> Html m
metaImage =
    List.metaImage


{-| Wrapper around two or more list elements to be grouped together.
-}
group : List (Property m) -> List (Html m) -> Html m
group =
    List.group


{-| Heading text displayed above each list in a group.
-}
subheader : List (Property m) -> List (Html m) -> Html m
subheader =
    List.subheader


{-| List divider element.
-}
divider : List (Property m) -> List (Html m) -> Html m
divider =
    List.divider


{-| List divider element for groups.
-}
groupDivider : List (Property m) -> List (Html m) -> Html m
groupDivider =
    List.groupDivider


{-| Leaves a gap on each side of the divider to match the padding of `meta`.
-}
padded : Property m
padded =
    List.padded


{-| Increases the leading margin of the divider so that it does not intersect
the avatar column.
-}
inset : Property m
inset =
    List.inset
