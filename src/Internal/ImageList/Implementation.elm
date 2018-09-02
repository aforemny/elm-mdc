module Internal.ImageList.Implementation
    exposing
        ( Property
        , divImage
        , image
        , imageAspectContainer
        , item
        , label
        , masonry
        , src
        , supporting
        , view
        , withTextProtection
        )

import Html exposing (Html, text)
import Html.Attributes as Html
import Internal.ImageList.Model exposing (Config, defaultConfig)
import Internal.Options as Options exposing (cs, css, styled, when)


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
    styled Html.div (cs "mdc-image-list__image-aspect-container" :: options)


supporting : List (Property m) -> List (Html m) -> Html m
supporting options =
    styled Html.div (cs "mdc-image-list__supporting" :: options)


label : List (Property m) -> List (Html m) -> Html m
label options =
    styled Html.span (cs "mdc-image-list__label" :: options)


withTextProtection : Property m
withTextProtection =
    Options.option (\config -> { config | withTextProtection = True })


masonry : Property m
masonry =
    Options.option (\config -> { config | masonry = True })


image : List (Property m) -> List (Html m) -> Html m
image options =
    styled Html.img (cs "mdc-image-list__image" :: options)


divImage : List (Property m) -> List (Html m) -> Html m
divImage options =
    styled Html.div (cs "mdc-image-list__image" :: options)


src : String -> Property m
src url =
    Options.attribute (Html.src url)
