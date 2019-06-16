module Internal.Dialog.Implementation exposing
    ( Property
    , accept
    , actions
    , cancel
    , content
    , noScrim
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
import Internal.Options as Options exposing (cs, styled, when)
import Json.Decode as Json exposing (Decoder)


update : (Msg -> m) -> Msg -> Model -> ( Maybe Model, Cmd m )
update _ msg model =
    case msg of
        NoOp ->
            ( Nothing, Cmd.none )

        StartAnimation isOpen ->
            if isOpen /= model.open then
                ( Just { model | animating = True, open = isOpen }, Cmd.none )

            else
                ( Nothing, Cmd.none )

        EndAnimation ->
            ( Just { model | animating = False }, Cmd.none )


type alias Store s =
    { s | dialog : Indexed Model }


getSet :
    { get : Index -> { a | dialog : Indexed Model } -> Model
    , set :
        Index
        -> { a | dialog : Indexed Model }
        -> Model
        -> { a | dialog : Indexed Model }
    }
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
    , noScrim : Bool
    }


defaultConfig : Config m
defaultConfig =
    { onClose = Nothing
    , open = False
    , noScrim = False
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
        Html.div
        [ cs "mdc-dialog"
        , Options.role "alertdialog"
        , Options.aria "modal" "true"
        , when stateChanged <|
            GlobalEvents.onTick (Json.succeed (lift (StartAnimation config.open)))

        -- Open class should only be added when we have started
        -- animating the opening, and removed immediately when we start closing.
        , cs "mdc-dialog--open" |> when (model.open && config.open)

        -- Opening and closing classes need to kick in as soon as
        -- dialog is opened or closed. They're only used for the
        -- duration of the animation.
        , cs "mdc-dialog--opening" |> when ((config.open && stateChanged) || (config.open && model.animating))
        , cs "mdc-dialog--closing" |> when ((not config.open && stateChanged) || (not config.open && model.animating))
        , when model.animating (Options.on "transitionend" (Json.succeed (lift EndAnimation)))

        -- Distinguish also between the fake hero dialog one, where we don't want focus trap.
        , when (model.open && config.open && not config.noScrim)
            << Options.many
          <|
            [ Options.data "focustrap" "{}" -- Elm 0.19 has a bug where empty attributes don't work: https://github.com/elm/virtual-dom/issues/132
            , Options.on "keydown" <|
                Json.map2
                    (\key keyCode ->
                        if key == Just "Escape" || keyCode == 27 then
                            Maybe.withDefault (lift NoOp) config.onClose

                        else
                            lift NoOp
                    )
                    (Json.oneOf
                        [ Json.map Just (Json.at [ "key" ] Json.string)
                        , Json.succeed Nothing
                        ]
                    )
                    (Json.at [ "keyCode" ] Json.int)
            ]
        ]
        []
        [ container []
            [ surface [] nodes
            ]
        , if config.noScrim then
            text ""

          else
            scrim
                [ Options.on "click" <|
                    Json.map
                        (\isScrimClick ->
                            if isScrimClick then
                                Maybe.withDefault (lift NoOp) config.onClose

                            else
                                lift NoOp
                        )
                        -- Given the click handler is on the scrim
                        -- element, do we really need to check we
                        -- clicked the scrim?
                        checkScrimClick
                ]
                []
        ]


open : Property m
open =
    Options.option (\config -> { config | open = True })


container : List (Property m) -> List (Html m) -> Html m
container options =
    styled Html.div (cs "mdc-dialog__container" :: options)


surface : List (Property m) -> List (Html m) -> Html m
surface options =
    styled Html.div (cs "mdc-dialog__surface" :: options)


scrim : List (Property m) -> List (Html m) -> Html m
scrim options =
    styled Html.div (cs "mdc-dialog__scrim" :: options)


content : List (Property m) -> List (Html m) -> Html m
content options =
    styled Html.section (cs "mdc-dialog__content" :: options)


scrollable : Property m
scrollable =
    cs "mdc-dialog__body--scrollable"


title : Options.Property c m
title =
    cs "mdc-dialog__title"


actions : List (Property m) -> List (Html m) -> Html m
actions options =
    styled Html.footer (cs "mdc-dialog__actions" :: options)


cancel : Button.Property m
cancel =
    cs "mdc-dialog__footer__button mdc-dialog__footer__button--cancel"


accept : Button.Property m
accept =
    cs "mdc-dialog__footer__button mdc-dialog__footer__button--accept"


onClose : m -> Property m
onClose handler =
    Options.option (\config -> { config | onClose = Just handler })


checkScrimClick : Decoder Bool
checkScrimClick =
    DOM.target <|
        Json.map
            (\className ->
                let
                    hasClass class =
                        String.contains (" " ++ class ++ " ") (" " ++ className ++ " ")
                in
                if hasClass "mdc-dialog__scrim" then
                    True

                else
                    False
            )
            (Json.at [ "className" ] Json.string)


noScrim : Property m
noScrim =
    Options.option (\config -> { config | noScrim = True })
