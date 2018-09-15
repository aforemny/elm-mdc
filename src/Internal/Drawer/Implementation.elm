module Internal.Drawer.Implementation
    exposing
        ( Config
        , Property
        , Store
        , content
        , defaultConfig
        , emit
        , header
        , headerContent
        , onClose
        , open
        , react
        , render
        , subs
        , subscriptions
        , update
        , view
        )

import Html exposing (Html, text)
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Drawer.Model exposing (Model, Msg(..), defaultModel)
import Internal.GlobalEvents as GlobalEvents
import Internal.Helpers as Helpers
import Internal.List.Implementation as Lists
import Internal.Msg
import Internal.Options as Options exposing (cs, css, many, styled, when)
import Json.Decode as Json exposing (Decoder)


update : (Msg -> m) -> Msg -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    case msg of
        NoOp ->
            ( Nothing, Cmd.none )

        Tick ->
            ( Just
                { model
                    | state = Just model.open
                    , animating = False
                }
            , Cmd.none
            )

        SetOpen ( open ) ->
            ( Just
                { model
                    | open = open
                    , state = Nothing
                    , animating = True
                }
            , Cmd.none
            )

        SetClose ->
            ( Just { model | open = False, state = Nothing, animating = False }
            , Cmd.none
            )


type alias Config m =
    { onClose : Maybe m
    , open : Bool
    }


defaultConfig : Config m
defaultConfig =
    { onClose = Nothing
    , open = False
    }


type alias Property m =
    Options.Property (Config m) m


view : String -> (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view className lift model options nodes =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        stateChanged =
            config.open /= model.open

    in
    styled Html.aside
        [ cs "mdc-drawer"
        , cs className |> when (not ( String.isEmpty className ))
        , when stateChanged <|
            GlobalEvents.onTick (Json.succeed (lift (SetOpen ( config.open ))))
        , cs "mdc-drawer--open" |> when model.open
        , Options.data "focustrap" "" |> when model.open
        , cs "mdc-drawer--opening" |> when model.animating
        , Options.onClick (Maybe.withDefault (lift NoOp) config.onClose)
        , Options.on "keydown" <|
            Json.map lift <|
                Json.map2
                    (\key keyCode ->
                         if key == Just "Escape" || keyCode == 27 then
                             SetClose
                         else
                             NoOp
                    )
                (Json.oneOf
                     [ Json.map Just (Json.at [ "key" ] Json.string)
                     , Json.succeed Nothing
                     ]
                )
            (Json.at [ "keyCode" ] Json.int)
        ]
        nodes


header : List (Property m) -> List (Html m) -> Html m
header options =
    styled Html.header (cs "mdc-drawer__header" :: options)


headerContent : List (Property m) -> List (Html m) -> Html m
headerContent options =
    styled Html.div (cs "mdc-drawer__header-content" :: options)


content : Lists.Property m
content =
    cs "mdc-drawer__content"


type alias Store s =
    { s | drawer : Indexed Model }


( get, set ) =
    Component.indexed .drawer (\x y -> { y | drawer = x }) defaultModel


render :
    String
    -> (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render className =
    Component.render get (view className) Internal.Msg.DrawerMsg


react :
    (Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Internal.Msg.DrawerMsg update


subs : (Internal.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Component.subs Internal.Msg.DrawerMsg .drawer subscriptions


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


onClose : m -> Property m
onClose onClose =
    Options.option (\config -> { config | onClose = Just onClose })


open : Property m
open =
    Options.option (\config -> { config | open = True })


emit : (Internal.Msg.Msg m -> m) -> Index -> Msg -> Cmd m
emit lift idx msg =
    Helpers.cmd (lift (Internal.Msg.DrawerMsg idx msg))
