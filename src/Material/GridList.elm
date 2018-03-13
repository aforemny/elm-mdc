module Material.GridList exposing
    ( gutter1
    , headerCaption
    , icon
    , iconAlignEnd
    , iconAlignStart
    , image
    , primary
    , primaryContent
    , Property
    , secondary
    , supportText
    , tile
    , tileAspect16x9
    , tileAspect2x3
    , tileAspect3x2
    , tileAspect3x4
    , tileAspect4x3
    , title
    , twolineCaption
    , view
    )

{-|
Grid List provides a RTL-aware Material Design Grid list component adhering to
the Material Design Grid list spec. Grid Lists are best suited for presenting
homogeneous data, typically images. Each item in a grid list is called a tile.
Tiles maintain consistent width, height, and padding across screen sizes.


# Resources

- [Material Design guidelines: Grid lists](https://material.io/guidelines/components/grid-lists.html)
- [Demo](https://aforemny.github.io/elm-mdc/#grid-list)


# Example

```elm
import Html exposing (text)
import Material.GridList as GridList


GridList.view Mdc [0] model.mdc []
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
```


# Usage


## Grid List

@docs Property
@docs view
@docs headerCaption, twolineCaption
@docs gutter1
@docs iconAlignStart, iconAlignEnd
@docs tileAspect16x9, tileAspect4x3, tileAspect3x4, tileAspect2x3, tileAspect3x2


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
import Material
import Material.Component exposing (Index)
import Material.Internal.GridList.Implementation as GridList


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
tileAspect16x9 : Property m
tileAspect16x9 =
    GridList.tileAspect16x9


{-| Style a GridList so that its tiles `primary` content preserves a 4 to 3
aspect ratio.
-}
tileAspect4x3 : Property m
tileAspect4x3 =
    GridList.tileAspect4x3


{-| Style a GridList so that its tiles `primary` content preserves a 3 to 4
aspect ratio.
-}
tileAspect3x4 : Property m
tileAspect3x4 =
    GridList.tileAspect3x4


{-| Style a GridList so that its tiles `primary` content preserves a 2 to 3
aspect ratio.
-}
tileAspect2x3 : Property m
tileAspect2x3 =
    GridList.tileAspect2x3


{-| Style a GridList so that its tiles `primary` content preserves a 3 to 2
aspect ratio.
-}
tileAspect3x2 : Property m
tileAspect3x2 =
    GridList.tileAspect3x2


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
