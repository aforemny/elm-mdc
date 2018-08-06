module Material.GridList
    exposing
        ( Property
        , gutter1
        , headerCaption
        , icon
        , iconAlignEnd
        , iconAlignStart
        , image
        , primary
        , primaryContent
        , secondary
        , supportText
        , tile
        , tileAspect16To9
        , tileAspect2To3
        , tileAspect3To2
        , tileAspect3To4
        , tileAspect4To3
        , title
        , twolineCaption
        , view
        )

{-| Grid List provides a RTL-aware Material Design Grid list component adhering to
the Material Design Grid list spec. Grid Lists are best suited for presenting
homogeneous data, typically images. Each item in a grid list is called a tile.
Tiles maintain consistent width, height, and padding across screen sizes.


# Resources

  - [Material Design guidelines: Grid lists](https://material.io/guidelines/components/grid-lists.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#grid-list)


# Example

    import Html exposing (text)
    import Material.GridList as GridList


    GridList.view Mdc "my-grid-list" model.mdc []
        ( List.repeat 6 <|
          GridList.tile []
              [ GridList.primary []
                    [ GridList.image [] "images/1-1.jpg"
                    ]
              , GridList.secondary []
                    [ GridList.title []
                          [ text "Tile Title"
                          ]
                    ]
              ]
        )


# Usage


## Grid List

@docs Property
@docs view
@docs headerCaption, twolineCaption
@docs gutter1
@docs iconAlignStart, iconAlignEnd
@docs tileAspect16To9, tileAspect4To3, tileAspect3To4, tileAspect2To3, tileAspect3To2


## Tiles

@docs tile
@docs primary
@docs secondary
@docs image
@docs icon
@docs title
@docs supportText
@docs primaryContent

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.GridList.Implementation as GridList
import Material


{-| GridList property.
-}
type alias Property m =
    GridList.Property m


{-| GridList view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    GridList.view


{-| Style a GridList so that its tiles have a header caption.

By default GridList tile's have a footer caption.

-}
headerCaption : Property m
headerCaption =
    GridList.headerCaption


{-| Style a GridList so that tile's captions have two lines.

By default a tile's caption is single line.

-}
twolineCaption : Property m
twolineCaption =
    GridList.twolineCaption


{-| Configure a GridList tile's icon to be aligned to the start.
-}
iconAlignStart : Property m
iconAlignStart =
    GridList.iconAlignStart


{-| Configure a GridList tile's icon to be aligned to the end.
-}
iconAlignEnd : Property m
iconAlignEnd =
    GridList.iconAlignEnd


{-| Style a GridList to have a 1px padding.

By default a GridList has a 4px padding.

-}
gutter1 : Property m
gutter1 =
    GridList.gutter1


{-| Style a GridList so that its tiles `primary` content preserves a 16 to 9
aspect ratio.
-}
tileAspect16To9 : Property m
tileAspect16To9 =
    GridList.tileAspect16To9


{-| Style a GridList so that its tiles `primary` content preserves a 4 to 3
aspect ratio.
-}
tileAspect4To3 : Property m
tileAspect4To3 =
    GridList.tileAspect4To3


{-| Style a GridList so that its tiles `primary` content preserves a 3 to 4
aspect ratio.
-}
tileAspect3To4 : Property m
tileAspect3To4 =
    GridList.tileAspect3To4


{-| Style a GridList so that its tiles `primary` content preserves a 2 to 3
aspect ratio.
-}
tileAspect2To3 : Property m
tileAspect2To3 =
    GridList.tileAspect2To3


{-| Style a GridList so that its tiles `primary` content preserves a 3 to 2
aspect ratio.
-}
tileAspect3To2 : Property m
tileAspect3To2 =
    GridList.tileAspect3To2


{-| GridList tile.
-}
tile : List (Property m) -> List (Html m) -> Html m
tile =
    GridList.tile


{-| GridList tile's primary block.

Contains `primaryContent` or `image`.

-}
primary : List (Property m) -> List (Html m) -> Html m
primary =
    GridList.primary


{-| GridList tile's secondary block.

This contains the caption made up of `title`, `icon` and/or `supportText`.

-}
secondary : List (Property m) -> List (Html m) -> Html m
secondary =
    GridList.secondary


{-| Specify an image as a GridList tile's primary content.
-}
image : List (Property m) -> String -> Html m
image =
    GridList.image


{-| Add a title caption to the tile.

Should be a direct child of `secondary`.

-}
title : List (Property m) -> List (Html m) -> Html m
title =
    GridList.title


{-| Add supporting text to a tile's caption.

Should be a direct child of `secondary`.

-}
supportText : List (Property m) -> List (Html m) -> Html m
supportText =
    GridList.supportText


{-| Add an icon to a tile's caption.

Should be a direct child of `secondary`.

-}
icon : List (Property m) -> String -> Html m
icon =
    GridList.icon


{-| GridList tile's primary content wrapper.

Should be a d direct child of `primary`.

-}
primaryContent : List (Property m) -> List (Html m) -> Html m
primaryContent =
    GridList.primaryContent
