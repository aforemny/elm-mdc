module Material.Internal.GridList.Implementation exposing
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

import DOM
import Html.Attributes as Html
import Html exposing (Html)
import Json.Decode as Json exposing (Decoder)
import Material.Internal.Component as Component exposing (Indexed, Index)
import Material.Internal.GlobalEvents as GlobalEvents
import Material.Internal.GridList.Model exposing (Msg(..), Geometry, defaultGeometry)
import Material.Internal.Icon.Implementation as Icon
import Material.Internal.Msg
import Material.Internal.Options as Options exposing (styled, cs, css, when)


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
    Material.Internal.GridList.Model.Msg m


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


supportText : List (Property m) -> List (Html m) -> Html m
supportText options =
    styled Html.div ( cs "mdc-grid-tile__support-text" :: options )


icon : List (Property m) -> String -> Html m
icon options icon =
    styled Html.div ( cs "mdc-grid-tile__icon" :: options ) [ Icon.view [] icon ]


primaryContent : List (Property m) -> List (Html m) -> Html m
primaryContent options =
    styled Html.div ( cs "mdc-grid-tile__primary-content" :: options )


type alias Store s =
    { s | gridList : Indexed Model }


( get, set ) =
    Component.indexed .gridList (\x y -> { y | gridList = x }) defaultModel


view :
    (Material.Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render get gridList Material.Internal.Msg.GridListMsg


react :
    (Material.Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Internal.Msg.GridListMsg (Component.generalise update)


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
