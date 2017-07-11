module Material.List
    exposing
        ( ul
        , dense
        , avatar
        , twoLine

        , li
        , startDetail
        , startDetailIcon
        , avatarImage
        , endDetail
        , endDetailIcon

        , text
        , secondary

        , divider
        , inset

        , group
        , subheader
        )

{-| TODO
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


{-| List item's start detail
-}
startDetail options =
    Options.styled Html.span (cs "mdc-list-item__start-detail" :: options)


{-| List item's start detail icon
-}
startDetailIcon icon options =
    Icon.view icon (cs "mdc-list-item__start-detail" :: options)


{-| List item's end detail
-}
endDetail options =
    Options.styled Html.span (cs "mdc-list-item__end-detail" :: options)


{-| List item's end detail icon
-}
endDetailIcon icon options =
    Icon.view icon (cs "mdc-list-item__end-detail" :: options)


{-| Set an avatar image. `src` is a value for `Html.Attributes.src`.
-}
avatarImage : String -> List (Property a m) -> Html m
avatarImage src options =
    Options.styled_ Html.img (cs "mdc-list-item__start-detail"::options) [ Html.Attributes.src src ] []


text options =
    Options.styled Html.span (cs "mdc-list-item__text"::options)


secondary options =
    Options.styled Html.span (cs "mdc-list-item__text__secondary"::options)


divider options =
    Options.styled Html.hr (cs "mdc-list-divider"::options) []


inset =
    cs "mdc-list-divider--inset"


group options =
    Options.styled Html.div (cs "mdc-list-group"::options)


subheader options =
    Options.styled Html.div (cs "mdc-list-group__subheader"::options)
