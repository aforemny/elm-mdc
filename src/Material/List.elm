module Material.List
    exposing
        ( -- View
          ul
        , dense
        , avatar
        , twoLine

        , li
        , startDetail
        , startDetailIcon
        , avatarImage
        , endDetail
        , endDetailIcon
        , listItem

        , text
        , secondary

        , divider
        , inset

        , group
        , subheader
        )

{-|
MDC List provides styles which implement Material Design Lists - “A single
continuous column of tessellated subdivisions of equal width.” Both single-line
and two-line lists are supported (with three-line lists coming soon). MDC Lists
are designed to be accessible and RTL aware.

## Design & API Documentation

- [Material Design guidelines: Lists](https://material.io/guidelines/components/lists.html)
- [Demo](https://aforemny.github.io/elm-mdc/#lists)

## View
@docs ul, dense, avatar, twoLine

## Elements
@docs li, text, secondary
@docs startDetail, startDetailIcon
@docs endDetail, endDetailIcon
@docs avatarImage, listItem

## List dividers
@docs divider, inset

## List groups
@docs group, subheader
-}

import Html exposing (Html, Attribute)
import Html.Attributes
import Material.Options as Options exposing (Property, Style, cs, css, nop)
import Material.Icon as Icon


{-| Container for list items
-}
ul : List (Property c m) -> List (Html m) -> Html m
ul options =
    Options.styled Html.ul (cs "mdc-list" :: options)


{-| Dense lists
-}
dense : Property c m
dense =
    cs "mdc-list--dense"


{-| Avatar lists
-}
avatar : Property c m
avatar =
    cs "mdc-list--avatar-list"


{-| Two-line lists
-}
twoLine : Property c m
twoLine =
    cs "mdc-list--two-line"


{-| List item
-}
li : List (Property c m) -> List (Html m) -> Html m
li options =
    Options.styled Html.li (cs "mdc-list-item" :: options)


{-| List item
-}
listItem : List (Property c m) -> List (Html m) -> Html m
listItem options =
    Options.styled Html.a (cs "mdc-list-item" :: options)


{-| List item's start detail
-}
startDetail : List (Property c m) -> List (Html m) -> Html m
startDetail options =
    Options.styled Html.span (cs "mdc-list-item__start-detail" :: options)


{-| List item's start detail icon
-}
startDetailIcon : String -> List (Property Icon.Config m) -> Html m
startDetailIcon icon options =
    Icon.view icon (cs "mdc-list-item__start-detail" :: options)


{-| List item's end detail
-}
endDetail : List (Property c m) -> List (Html m) -> Html m
endDetail options =
    Options.styled Html.span (cs "mdc-list-item__end-detail" :: options)


{-| List item's end detail icon
-}
endDetailIcon : String -> List (Property Icon.Config m) -> Html m
endDetailIcon icon options =
    Icon.view icon (cs "mdc-list-item__end-detail" :: options)


{-| Set an avatar image. `src` is a value for `Html.Attributes.src`.
-}
avatarImage : String -> List (Property a m) -> Html m
avatarImage src options =
    Options.styled_ Html.img (cs "mdc-list-item__start-detail"::options) [ Html.Attributes.src src ] []


text : List (Property c m) -> List (Html m) -> Html m
text options =
    Options.styled Html.span (cs "mdc-list-item__text"::options)


secondary : List (Property c m) -> List (Html m) -> Html m
secondary options =
    Options.styled Html.span (cs "mdc-list-item__secondary-text"::options)


divider : List (Property c m) -> List (Html m) -> Html m
divider options _ =
    Options.styled Html.hr (cs "mdc-list-divider"::options) []


inset : Property c m
inset =
    cs "mdc-list-divider--inset"


group : List (Property c m) -> List (Html m) -> Html m
group options =
    Options.styled Html.div (cs "mdc-list-group"::options)


subheader : List (Property c m) -> List (Html m) -> Html m
subheader options =
    Options.styled Html.div (cs "mdc-list-group__subheader"::options)
