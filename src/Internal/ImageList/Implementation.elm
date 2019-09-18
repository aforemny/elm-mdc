module Internal.ImageList.Implementation exposing
    ( Property
    , image
    , imageAspectContainer
    , item
    , label
    , masonry
    , node
    , src
    , supporting
    , view
    , withTextProtection
    )

import Html exposing (Html)
import Html.Attributes as Html
import Internal.ImageList.Model exposing (Config, defaultConfig)
import Internal.Options as Options exposing (cs, styled, when)


cssClasses :
    { masonry : String
    , withTextProtection : String
    }
cssClasses =
    { masonry = "mdc-image-list--masonry"
    , withTextProtection = "mdc-image-list--with-text-protection"
    }



-- VIEW


imageList : List (Property m) -> List (Html m) -> Html m
imageList options =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        Html.ul
        [ cs "mdc-image-list"
        , when config.masonry (cs cssClasses.masonry)
        , when config.withTextProtection (cs cssClasses.withTextProtection)
        ]
        []



-- API


type alias Property m =
    Options.Property Config m


view : List (Property m) -> List (Html m) -> Html m
view =
    imageList


item : List (Property m) -> List (Html m) -> Html m
item options =
    styled Html.li (cs "mdc-image-list__item" :: options)


imageAspectContainer : List (Property m) -> List (Html m) -> Html m
imageAspectContainer options =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
        tag = Maybe.withDefault "div" config.tag
    in
    styled ( Html.node tag ) (cs "mdc-image-list__image-aspect-container" :: options)


supporting : List (Property m) -> List (Html m) -> Html m
supporting options =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        tag = Maybe.withDefault "div" config.tag
    in
    styled ( Html.node tag ) (cs "mdc-image-list__supporting" :: options)


label : List (Property m) -> List (Html m) -> Html m
label options =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        tag = Maybe.withDefault "span" config.tag
    in
    styled ( Html.node tag ) (cs "mdc-image-list__label" :: options)


withTextProtection : Property m
withTextProtection =
    Options.option (\config -> { config | withTextProtection = True })


masonry : Property m
masonry =
    Options.option (\config -> { config | masonry = True })


node : String -> Property m
node tag =
    Options.option (\config -> { config | tag = Just tag })


image : List (Property m) -> List (Html m) -> Html m
image options =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
        tag = Maybe.withDefault "img" config.tag
    in
        styled ( Html.node tag ) (cs "mdc-image-list__image" :: options)


src : String -> Property m
src url =
    Options.attribute (Html.src url)
