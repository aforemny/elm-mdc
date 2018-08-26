module Internal.GridList.Implementation
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
        , react
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

import DOM
import Html exposing (Html)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.GlobalEvents as GlobalEvents
import Internal.GridList.Model exposing (Geometry, Model, Msg(..), defaultGeometry, defaultModel)
import Internal.Icon.Implementation as Icon
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Json.Decode as Json exposing (Decoder)


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
                |> Maybe.map
                    (\geometry ->
                        geometry.tileWidth
                            * toFloat (floor (geometry.width / geometry.tileWidth))
                    )
                |> Maybe.map (\floatWidth -> String.fromFloat floatWidth ++ "px")
                |> Maybe.withDefault "auto"
    in
    styled Html.div
        (cs "mdc-grid-list"
            :: (when (model.geometry == Nothing) <|
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


tileAspect16To9 : Property m
tileAspect16To9 =
    cs "mdc-grid-list--tile-aspect-16To9"


tileAspect4To3 : Property m
tileAspect4To3 =
    cs "mdc-grid-list--tile-aspect-4To3"


tileAspect3To4 : Property m
tileAspect3To4 =
    cs "mdc-grid-list--tile-aspect-3To4"


tileAspect2To3 : Property m
tileAspect2To3 =
    cs "mdc-grid-list--tile-aspect-2To3"


tileAspect3To2 : Property m
tileAspect3To2 =
    cs "mdc-grid-list--tile-aspect-3To2"


tile : List (Property m) -> List (Html m) -> Html m
tile options =
    styled Html.div (cs "mdc-grid-tile" :: options)


primary : List (Property m) -> List (Html m) -> Html m
primary options =
    styled Html.div (cs "mdc-grid-tile__primary" :: options)


secondary : List (Property m) -> List (Html m) -> Html m
secondary options =
    styled Html.div (cs "mdc-grid-tile__secondary" :: options)


image : List (Property m) -> String -> Html m
image options src =
    styled Html.img
        (cs "mdc-grid-tile__primary-content"
            :: Options.attribute (Html.src src)
            :: options
        )
        []


title : List (Property m) -> List (Html m) -> Html m
title options =
    styled Html.div (cs "mdc-grid-tile__title" :: options)


supportText : List (Property m) -> List (Html m) -> Html m
supportText options =
    styled Html.div (cs "mdc-grid-tile__support-text" :: options)


icon : List (Property m) -> String -> Html m
icon options value =
    styled Html.div (cs "mdc-grid-tile__icon" :: options) [ Icon.view [] value ]


primaryContent : List (Property m) -> List (Html m) -> Html m
primaryContent options =
    styled Html.div (cs "mdc-grid-tile__primary-content" :: options)


type alias Store s =
    { s | gridList : Indexed Model }


getSet =
    Component.indexed .gridList (\x y -> { y | gridList = x }) defaultModel


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render getSet.get gridList Internal.Msg.GridListMsg


react :
    (Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.GridListMsg (Component.generalise update)


type alias Property m =
    Options.Property Config m


type alias Config =
    {}


defaultConfig : Config
defaultConfig =
    {}


decodeGeometry : Decoder Geometry
decodeGeometry =
    DOM.target <|
        Json.map2 Geometry
            DOM.offsetWidth
            (DOM.childNode 0 <|
                DOM.childNode 0 <|
                    DOM.offsetWidth
            )
