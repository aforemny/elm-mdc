module Material.Internal.List.Implementation exposing
    ( activated
    , avatarList
    , defaultConfig
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

import Html.Attributes as Html
import Html exposing (Html)
import Material.Internal.Icon.Implementation as Icon
import Material.Internal.Options as Options exposing (styled, cs)


type alias Config =
    {}


defaultConfig : Config
defaultConfig =
    {}


type alias Property m =
    Options.Property Config m


ul : List (Property m) -> List (Html m) -> Html m
ul options =
    styled Html.ul (cs "mdc-list" :: options)


nonInteractive : Property m
nonInteractive =
    cs "mdc-list--non-interactive"


dense : Property m
dense =
    cs "mdc-list--dense"


avatarList : Property m
avatarList =
    cs "mdc-list--avatar-list"


twoLine : Property m
twoLine =
    cs "mdc-list--two-line"


li : List (Property m) -> List (Html m) -> Html m
li options =
    styled Html.li (cs "mdc-list-item" :: options)


text : List (Property m) -> List (Html m) -> Html m
text options =
  styled Html.span (cs "mdc-list-item__text" :: options)


secondaryText : List (Property m) -> List (Html m) -> Html m
secondaryText options =
  styled Html.span (cs "mdc-list-item__secondary-text" :: options)


listItem : Property m
listItem =
    cs "mdc-list-item"


selected : Property m
selected =
  cs "mdc-list-item--selected"


activated : Property m
activated =
  cs "mdc-list-item--activated"


graphic : List (Property m) -> List (Html m) -> Html m
graphic options =
    styled Html.span (cs "mdc-list-item__graphic" :: options)


graphicIcon : List (Icon.Property m) -> String -> Html m
graphicIcon options =
    Icon.view (cs "mdc-list-item__graphic" :: options)


graphicImage : List (Property m) -> String -> Html m
graphicImage options url =
    styled Html.img
      ( cs "mdc-list-item__graphic"
      :: Options.attribute (Html.src url)
      :: options
      )
      []


meta : List (Property m) -> List (Html m) -> Html m
meta options =
    styled Html.span (cs "mdc-list-item__meta" :: options)


metaText : List (Property m) -> String -> Html m
metaText options str =
    styled Html.span (cs "mdc-list-item__meta" :: options) [ Html.text str ]


metaIcon : List (Icon.Property m) -> String -> Html m
metaIcon options =
    Icon.view (cs "mdc-list-item__meta" :: options)


metaImage : List (Property m) -> String -> Html m
metaImage options url =
    styled Html.img
      ( cs "mdc-list-item__meta"
      :: Options.attribute (Html.src url)
      :: options
      )
      []


group : List (Property m) -> List (Html m) -> Html m
group options =
    styled Html.div (cs "mdc-list-group"::options)


subheader : List (Property m) -> List (Html m) -> Html m
subheader options =
    styled Html.div (cs "mdc-list-group__subheader"::options)


divider : List (Property m) -> List (Html m) -> Html m
divider options =
    styled Html.li
    ( cs "mdc-list-divider"
    :: Options.attribute (Html.attribute "role" "separator")
    :: options
    )


groupDivider : List (Property m) -> List (Html m) -> Html m
groupDivider options =
    styled Html.hr (cs "mdc-list-divider" :: options)


padded : Property m
padded =
    cs "mdc-list-divier--padded"


inset : Property m
inset =
    cs "mdc-list-divider--inset"
