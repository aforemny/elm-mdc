module Internal.Dialog.Implementation
    exposing
        ( Property
        , accept
        , backdrop
        , body
        , cancel
        , footer
        , header
        , onClose
        , open
        , react
        , scrollable
        , surface
        , title
        , view
        )

import DOM
import Html exposing (Html, text)
import Internal.Button.Implementation as Button
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Dialog.Model exposing (Model, Msg(..), defaultModel)
import Internal.GlobalEvents as GlobalEvents
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Json.Decode as Json exposing (Decoder)


update : (Msg -> m) -> Msg -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    case msg of
        NoOp ->
            ( Nothing, Cmd.none )

        SetState isOpen ->
            if isOpen /= model.open then
                ( Just { model | animating = True, open = isOpen }, Cmd.none )
            else
                ( Nothing, Cmd.none )

        SetOpen isOpen ->
            ( Just { model | open = isOpen }, Cmd.none )

        AnimationEnd ->
            ( Just { model | animating = False }, Cmd.none )


type alias Store s =
    { s | dialog : Indexed Model }


getSet =
    Component.indexed .dialog (\x c -> { c | dialog = x }) defaultModel


react :
    (Internal.Msg.Msg m -> msg)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd msg )
react =
    Component.react getSet.get getSet.set Internal.Msg.DialogMsg update


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render getSet.get dialog Internal.Msg.DialogMsg


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


dialog : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
dialog lift model options nodes =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        stateChanged =
            config.open /= model.open
    in
    Options.apply summary
        Html.aside
        [ cs "mdc-dialog"
        , when stateChanged <|
            GlobalEvents.onTick (Json.succeed (lift (SetState config.open)))
        , when model.open
            << Options.many
          <|
            [ cs "mdc-dialog--open"
            , Options.data "focustrap" ""
            ]
        , when model.animating (cs "mdc-dialog--animating")
        , Options.on "transitionend" (Json.map (\_ -> lift AnimationEnd) transitionend)
        , Options.on "click" <|
            Json.map
                (\doClose ->
                    if doClose then
                        Maybe.withDefault (lift NoOp) config.onClose
                    else
                        lift NoOp
                )
                close
        ]
        []
        nodes


open : Property m
open =
    Options.option (\config -> { config | open = True })


surface : List (Property m) -> List (Html m) -> Html m
surface options =
    styled Html.div (cs "mdc-dialog__surface" :: options)


backdrop : List (Property m) -> List (Html m) -> Html m
backdrop options =
    styled Html.div (cs "mdc-dialog__backdrop" :: options)


body : List (Property m) -> List (Html m) -> Html m
body options =
    styled Html.div (cs "mdc-dialog__body" :: options)


scrollable : Property m
scrollable =
    cs "mdc-dialog__body--scrollable"


header : List (Property m) -> List (Html m) -> Html m
header options =
    styled Html.div (cs "mdc-dialog__header" :: options)


title : Options.Property c m
title =
    cs "mdc-dialog__header__title"


footer : List (Property m) -> List (Html m) -> Html m
footer options =
    styled Html.div (cs "mdc-dialog__footer" :: options)


cancel : Button.Property m
cancel =
    cs "mdc-dialog__footer__button mdc-dialog__footer__button--cancel"


accept : Button.Property m
accept =
    cs "mdc-dialog__footer__button mdc-dialog__footer__button--accept"


onClose : m -> Property m
onClose handler =
    Options.option (\config -> { config | onClose = Just handler })


transitionend : Decoder ()
transitionend =
    let
        hasClass cs className =
            List.member cs (String.split " " className)
    in
    Json.andThen
        (\className ->
            if hasClass "mdc-dialog__surface" className then
                Json.succeed ()
            else
                Json.fail ""
        )
        (DOM.target DOM.className)


close : Decoder Bool
close =
    DOM.target <|
        Json.map
            (\className ->
                let
                    hasClass class =
                        String.contains (" " ++ class ++ " ") (" " ++ className ++ " ")
                in
                if hasClass "mdc-dialog__backdrop" then
                    True
                else
                    False
            )
            (Json.at [ "className" ] Json.string)
