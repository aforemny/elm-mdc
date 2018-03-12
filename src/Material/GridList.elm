module Material.GridList exposing
    ( gutter1
    , headerCaption
    , icon
    , iconAlignEnd
    , iconAlignStart
    , image
    , Model
    , primary
    , primaryContent
    , Property
    , react
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
import Material.GridList as GridList

GridList.view Mdc [0] model.mdc
    []
    ( List.repeat 6 <|
      GridList.tile []
          [ GridList.primary []
                [ GridList.image [] "images/1-1.jpg"
                ]
          , GridList.secondary []
                [ GridList.title []
                  [ text "Single Very Long Grid Title Line"
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


# Internal

@docs Model
@docs react
-}


import DOM
import Html.Attributes as Html
import Html exposing (Html)
import Json.Decode as Json exposing (Decoder)
import Material.Component as Component exposing (Indexed, Index)
import Material.GlobalEvents as GlobalEvents
import Material.Icon as Icon
import Material.Internal.GridList exposing (Msg(..), Geometry, defaultGeometry)
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)


{-| GridList model.

Internal use only.
-}
type alias Model =
    { configured : Bool
    , geometry : Maybe Geometry
    , resizing : Bool
    , lastResize : Int
    , requestAnimationFrame : Bool
    }


defaultModel : Model
defaultModel =
    { configured = False
    , geometry = Nothing
    , resizing = False
    , lastResize = 0
    , requestAnimationFrame = True
    }


type alias Msg m =
    Material.Internal.GridList.Msg m


update : Msg m -> Model -> ( Model, Cmd (Msg m) )
update msg model =
    case msg of
        Init geometry ->
            ( { model | geometry = Just geometry }, Cmd.none )


gridList : (Msg m -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
gridList lift model options nodes =
    let
        width =
            model.geometry
            |> Maybe.map (\ { width, tileWidth } ->
                  tileWidth * toFloat (floor (width / tileWidth))
               )
            |> Maybe.map (toString >> flip (++) "px")
            |> Maybe.withDefault "auto"
    in
    styled Html.div
    ( cs "mdc-grid-list"
    :: ( when (model.geometry == Nothing) <|
         GlobalEvents.onTick (Json.map (lift << Init) decodeGeometry)
       )
    :: GlobalEvents.onResize (Json.map (lift << Init) decodeGeometry)
    :: options
    )
    [ styled Html.ul
      [ cs "mdc-grid-list__tiles"
      , css "width" width
      ]
      nodes
    ]


{-| Style a GridList so that its tiles have a header caption.

By default GridList tile's have a footer caption.
-}
headerCaption : Property m
headerCaption =
    cs "mdc-grid-list--header-caption"


{-| Style a GridList so that tile's captions have two lines.

By default a tile's caption is single line.
-}
twolineCaption : Property m
twolineCaption =
    cs "mdc-grid-list--twoline-caption"


{-| Configure a GridList tile's icon to be aligned to the start.
-}
iconAlignStart : Property m
iconAlignStart =
    cs "mdc-grid-list--with-icon-align-start"


{-| Configure a GridList tile's icon to be aligned to the end.
-}
iconAlignEnd : Property m
iconAlignEnd =
    cs "mdc-grid-list--with-icon-align-end"


{-| Style a GridList to have a 1px padding.

By default a GridList has a 4px padding.
-}
gutter1 : Property m
gutter1 =
    cs "mdc-grid-list--tile-gutter-1"


{-| Style a GridList so that its tiles `primary` content preserves a 16 to 9
aspect ratio.
-}
tileAspect16x9 : Property m
tileAspect16x9 =
    cs "mdc-grid-list--tile-aspect-16x9"


{-| Style a GridList so that its tiles `primary` content preserves a 4 to 3
aspect ratio.
-}
tileAspect4x3 : Property m
tileAspect4x3 =
    cs "mdc-grid-list--tile-aspect-4x3"


{-| Style a GridList so that its tiles `primary` content preserves a 3 to 4
aspect ratio.
-}
tileAspect3x4 : Property m
tileAspect3x4 =
    cs "mdc-grid-list--tile-aspect-3x4"


{-| Style a GridList so that its tiles `primary` content preserves a 2 to 3
aspect ratio.
-}
tileAspect2x3 : Property m
tileAspect2x3 =
    cs "mdc-grid-list--tile-aspect-2x3"


{-| Style a GridList so that its tiles `primary` content preserves a 3 to 2
aspect ratio.
-}
tileAspect3x2 : Property m
tileAspect3x2 =
    cs "mdc-grid-list--tile-aspect-3x2"


{-| GridList tile.
-}
tile : List (Property m) -> List (Html m) -> Html m
tile options =
    styled Html.div ( cs "mdc-grid-tile" :: options)


{-| GridList tile's primary block.

Contains `primaryContent` or `image`.
-}
primary : List (Property m) -> List (Html m) -> Html m
primary options =
    styled Html.div ( cs "mdc-grid-tile__primary" :: options )


{-| GridList tile's secondary block.

This contains the caption made up of `title`, `icon` and/or `supportText`.
-}
secondary : List (Property m) -> List (Html m) -> Html m
secondary options =
    styled Html.div ( cs "mdc-grid-tile__secondary" :: options )


{-| Specify an image as a GridList tile's primary content.
-}
image : List (Property m) -> String -> Html m
image options src =
    styled Html.img
    ( cs "mdc-grid-tile__primary-content"
    :: Options.attribute (Html.src src)
    :: options
    )
    []


{-| Add a title caption to the tile.

Should be a direct child of `secondary`.
-}
title : List (Property m) -> List (Html m) -> Html m
title options =
    styled Html.div ( cs "mdc-grid-tile__title" :: options )


{-| Add supporting text to a tile's caption.

Should be a direct child of `secondary`.
-}
supportText : List (Property m) -> List (Html m) -> Html m
supportText options =
    styled Html.div ( cs "mdc-grid-tile__support-text" :: options )


{-| Add an icon to a tile's caption.

Should be a direct child of `secondary`.
-}
icon : List (Property m) -> String -> Html m
icon options icon =
    styled Html.div ( cs "mdc-grid-tile__icon" :: options ) [ Icon.view [] icon ]


{-| GridList tile's primary content wrapper.

Should be a d direct child of `primary`.
-}
primaryContent : List (Property m) -> List (Html m) -> Html m
primaryContent options =
    styled Html.div ( cs "mdc-grid-tile__primary-content" :: options )


type alias Store s =
    { s | gridList : Indexed Model }


( get, set ) =
    Component.indexed .gridList (\x y -> { y | gridList = x }) defaultModel


{-| GridList view.
-}
view :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render get gridList Material.Msg.GridListMsg


{-| GridList react.

Internal use only.
-}
react :
    (Material.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.GridListMsg (Component.generalise update)


{-| GridList property.
-}
type alias Property m =
    Options.Property Config m


type alias Config =
    {
    }


defaultConfig : Config
defaultConfig =
    {
    }


decodeGeometry : Decoder Geometry
decodeGeometry =
    DOM.target <|
    Json.map2 Geometry
    ( DOM.offsetWidth
    )
    ( DOM.childNode 0 <|
      DOM.childNode 0 <|
      DOM.offsetWidth
    )
