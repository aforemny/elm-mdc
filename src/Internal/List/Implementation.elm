module Internal.List.Implementation
    exposing
        ( Property
        , a
        , activated
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
        , meta
        , metaIcon
        , metaImage
        , metaText
        , nav
        , node
        , nonInteractive
        , ol
        , padded
        , secondaryText
        , selected
        , subheader
        , text
        , twoLine
        , ul
        )

import Html exposing (Html)
import Html.Attributes as Html
import Internal.Icon.Implementation as Icon
import Internal.Options as Options exposing (cs, styled)


type alias Config m =
    { node : Maybe (List (Html.Attribute m) -> List (Html m) -> Html m)
    }


defaultConfig : Config m
defaultConfig =
    { node = Nothing
    }


type alias Property m =
    Options.Property (Config m) m


ul : List (Property m) -> List (Html m) -> Html m
ul options =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        (Maybe.withDefault Html.ul config.node)
        [ cs "mdc-list" ]
        []


ol : List (Property m) -> List (Html m) -> Html m
ol options =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        (Maybe.withDefault Html.ol config.node)
        [ cs "mdc-list" ]
        []


nav : List (Property m) -> List (Html m) -> Html m
nav options =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        (Maybe.withDefault Html.nav config.node)
        [ cs "mdc-list" ]
        []


node : (List (Html.Attribute m) -> List (Html m) -> Html m) -> Property m
node nodeFunc =
    Options.option (\config -> { config | node = Just nodeFunc })


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
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        (Maybe.withDefault Html.li config.node)
        [ cs "mdc-list-item" ]
        []


a : List (Property m) -> List (Html m) -> Html m
a options =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        (Maybe.withDefault Html.a config.node)
        [ cs "mdc-list-item" ]
        []


text : List (Property m) -> List (Html m) -> Html m
text options =
    styled Html.span (cs "mdc-list-item__text" :: options)


secondaryText : List (Property m) -> List (Html m) -> Html m
secondaryText options =
    styled Html.span (cs "mdc-list-item__secondary-text" :: options)


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
        (cs "mdc-list-item__graphic"
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
        (cs "mdc-list-item__meta"
            :: Options.attribute (Html.src url)
            :: options
        )
        []


group : List (Property m) -> List (Html m) -> Html m
group options =
    styled Html.div (cs "mdc-list-group" :: options)


subheader : List (Property m) -> List (Html m) -> Html m
subheader options =
    styled Html.div (cs "mdc-list-group__subheader" :: options)


divider : List (Property m) -> List (Html m) -> Html m
divider options =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        (Maybe.withDefault Html.li config.node)
        [ cs "mdc-list-divider"
        , Options.role "separator"
        ]
        []


groupDivider : List (Property m) -> List (Html m) -> Html m
groupDivider options =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        (Maybe.withDefault Html.hr config.node)
        [ cs "mdc-list-divider"
        ]
        []


padded : Property m
padded =
    cs "mdc-list-divier--padded"


inset : Property m
inset =
    cs "mdc-list-divider--inset"
