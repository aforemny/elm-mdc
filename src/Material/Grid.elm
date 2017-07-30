module Material.Grid
    exposing
        ( view
        , headerCaption
        , twolineCaption
        , iconAlignStart
        , iconAlignEnd
        , gutter1
        , tileAspect16x9
        , tileAspect4x3
        , tileAspect3x4
        , tileAspect2x3
        , tileAspect3x2
        , tile
        , primary
        , secondary
        , image
        , title
        , supportingText
        , icon
        , primaryContent
        )


import Html.Attributes as Html
import Html exposing (Html)
import Material.Icon as Icon
import Material.Options as Options exposing (Style, styled, cs)


view : List (Style m) -> List (Html m) -> Html m
view options nodes =
    styled Html.div
    ( cs "mdc-grid-list"
    :: options
    )
    [ styled Html.ul
      [ cs "mdc-grid-list__tiles"
      ]
      nodes
    ]


headerCaption : Style m
headerCaption =
    cs "mdc-grid-list--header-caption"


twolineCaption : Style m
twolineCaption =
    cs "mdc-grid-list--twoline-caption"


iconAlignStart : Style m
iconAlignStart =
    cs "mdc-grid-list--with-icon-align-start"


iconAlignEnd : Style m
iconAlignEnd =
    cs "mdc-grid-list--with-icon-align-end"


gutter1 : Style m
gutter1 =
    cs "mdc-grid-list--tile-gutter-1"


tileAspect16x9 : Style m
tileAspect16x9 =
    cs "mdc-grid-list--tile-aspect-16x9"


tileAspect4x3 : Style m
tileAspect4x3 =
    cs "mdc-grid-list--tile-aspect-4x3"


tileAspect3x4 : Style m
tileAspect3x4 =
    cs "mdc-grid-list--tile-aspect-3x4"


tileAspect2x3 : Style m
tileAspect2x3 =
    cs "mdc-grid-list--tile-aspect-2x3"


tileAspect3x2 : Style m
tileAspect3x2 =
    cs "mdc-grid-list--tile-aspect-3x2"


tile : List (Style m) -> List (Html m) -> Html m
tile options =
    styled Html.div ( cs "mdc-grid-tile" :: options)


primary : List (Style m) -> List (Html m) -> Html m
primary options =
    styled Html.div ( cs "mdc-grid-tile__primary" :: options )


secondary : List (Style m) -> List (Html m) -> Html m
secondary options =
    styled Html.div ( cs "mdc-grid-tile__secondary" :: options )


image : List (Style m) -> String -> Html m
image options src =
    styled Html.img
    ( cs "mdc-grid-tile__primary-content"
    :: Options.attribute (Html.src src)
    :: options
    )
    []


title : List (Style m) -> List (Html m) -> Html m
title options =
    styled Html.div ( cs "mdc-grid-tile__title" :: options )


supportingText : List (Style m) -> List (Html m) -> Html m
supportingText options =
    styled Html.div ( cs "mdc-grid-tile__supporting-text" :: options )


icon : List (Style m) -> String -> Html m
icon options icon =
    styled Html.div ( cs "mdc-grid-tile__icon" :: options ) [ Icon.view icon [] ]


primaryContent : List (Style m) -> List (Html m) -> Html m
primaryContent options =
    styled Html.div ( cs "mdc-grid-tile__primary-content" :: options )
