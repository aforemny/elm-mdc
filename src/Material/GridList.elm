module Material.GridList
    exposing
        ( view
        , Property

        , tile

        , primary
        , image

        , secondary
        , icon
        , title
        , supportingText

        , twolineCaption
        , headerCaption
        , gutter1

        , iconAlignStart
        , iconAlignEnd

        , tileAspect16x9
        , tileAspect4x3
        , tileAspect3x4
        , tileAspect2x3
        , tileAspect3x2

        , primaryContent

          -- TEA
        , subscriptions
        , Model
        , defaultModel
        , Msg
        , update

          -- RENDER
        , subs
        , render
        , Store
        , react
        )

{-|
Grid List provides a RTL-aware Material Design Grid list component adhering to
the Material Design Grid list spec. Grid Lists are best suited for presenting
homogeneous data, typically images. Each item in a grid list is called a tile.
Tiles maintain consistent width, height, and padding across screen sizes.
([Material Components for
Web](https://material.io/components/web/catalog/grid-lists/))

@docs view

## Elements
@docs tile, primary, image, secondary, icon, title, supportingText

## Properties
@docs headerCaption, twolineCaption, gutter1
@docs iconAlignStart, iconAlignEnd
@docs tileAspect16x9, tileAspect4x3, tileAspect3x4, tileAspect2x3, tileAspect3x2

## Background images
@docs primaryContent

## TEA architecture
@docs Model, defaultModel, Msg, update

## Featured render
@docs render
@docs Store, react
-}


import AnimationFrame
import DOM
import Html.Attributes as Html
import Html exposing (Html)
import Json.Decode as Json exposing (Decoder)
import Material.Component as Component exposing (Indexed, Index)
import Material.Helpers as Helpers
import Material.Icon as Icon
import Material.Internal.GridList exposing (Msg(..), Geometry, defaultGeometry)
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)
import Window


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
        Configure geometry ->
            ( { model | configured = True, geometry = Just geometry }, Cmd.none )

        Resize ->
            let
                lastResize =
                    model.lastResize + 1
            in
            ( { model
                    | resizing = True
                    , lastResize = lastResize
              }
            , Helpers.delay 0 (ResizeDone lastResize)
            )

        ResizeDone resize ->
            if resize /= model.lastResize then
                ( model, Cmd.none )
            else
                ( { model | requestAnimationFrame = True }, Cmd.none )

        AnimationFrame ->
            ( { model | requestAnimationFrame = False, configured = False } , Cmd.none )

view : (Msg m -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options nodes =
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
    :: when (not model.configured) (cs "elm-mdc-grid-list--uninitialized")
    :: Options.on "elm-mdc-init" (Json.map (lift << Configure) decodeGeometry)
    :: options
    )
    [ styled Html.ul
      [ cs "mdc-grid-list__tiles"
      , css "width" width
      ]
      nodes
    ]


headerCaption : Property m
headerCaption =
    cs "mdc-grid-list--header-caption"


twolineCaption : Property m
twolineCaption =
    cs "mdc-grid-list--twoline-caption"


iconAlignStart : Property m
iconAlignStart =
    cs "mdc-grid-list--with-icon-align-start"


iconAlignEnd : Property m
iconAlignEnd =
    cs "mdc-grid-list--with-icon-align-end"


gutter1 : Property m
gutter1 =
    cs "mdc-grid-list--tile-gutter-1"


tileAspect16x9 : Property m
tileAspect16x9 =
    cs "mdc-grid-list--tile-aspect-16x9"


tileAspect4x3 : Property m
tileAspect4x3 =
    cs "mdc-grid-list--tile-aspect-4x3"


tileAspect3x4 : Property m
tileAspect3x4 =
    cs "mdc-grid-list--tile-aspect-3x4"


tileAspect2x3 : Property m
tileAspect2x3 =
    cs "mdc-grid-list--tile-aspect-2x3"


tileAspect3x2 : Property m
tileAspect3x2 =
    cs "mdc-grid-list--tile-aspect-3x2"


tile : List (Property m) -> List (Html m) -> Html m
tile options =
    styled Html.div ( cs "mdc-grid-tile" :: options)


primary : List (Property m) -> List (Html m) -> Html m
primary options =
    styled Html.div ( cs "mdc-grid-tile__primary" :: options )


secondary : List (Property m) -> List (Html m) -> Html m
secondary options =
    styled Html.div ( cs "mdc-grid-tile__secondary" :: options )


image : List (Property m) -> String -> Html m
image options src =
    styled Html.img
    ( cs "mdc-grid-tile__primary-content"
    :: Options.attribute (Html.src src)
    :: options
    )
    []


title : List (Property m) -> List (Html m) -> Html m
title options =
    styled Html.div ( cs "mdc-grid-tile__title" :: options )


supportingText : List (Property m) -> List (Html m) -> Html m
supportingText options =
    styled Html.div ( cs "mdc-grid-tile__supporting-text" :: options )


icon : List (Property m) -> String -> Html m
icon options icon =
    styled Html.div ( cs "mdc-grid-tile__icon" :: options ) [ Icon.view icon [] ]


primaryContent : List (Property m) -> List (Html m) -> Html m
primaryContent options =
    styled Html.div ( cs "mdc-grid-tile__primary-content" :: options )


type alias Store s =
    { s | gridList : Indexed Model }


( get, set ) =
    Component.indexed .gridList (\x y -> { y | gridList = x }) defaultModel


render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render =
    Component.render get view Material.Msg.GridListMsg


react :
    (Material.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.GridListMsg (Component.generalise update)


subs : (Material.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Component.subs Material.Msg.GridListMsg .gridList subscriptions


subscriptions : Model -> Sub (Msg m)
subscriptions model =
    if model.requestAnimationFrame then
        Sub.batch
        [ AnimationFrame.times (\ _ -> AnimationFrame)
        , Window.resizes (\ _ -> Resize)
        ]
    else
        Window.resizes (\ _ -> Resize)


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
