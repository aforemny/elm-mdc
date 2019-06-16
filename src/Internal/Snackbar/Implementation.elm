module Internal.Snackbar.Implementation exposing
    ( Property
    , add
    , dismissible
    , leading
    , react
    , snack
    , toast
    , view
    )

import Dict
import Html exposing (Html, text)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.GlobalEvents as GlobalEvents
import Internal.Helpers as Helpers
import Internal.Msg
import Internal.Options as Options exposing (aria, cs, role, styled, when)
import Internal.Snackbar.Model exposing (Contents, Model, Msg(..), State(..), Transition(..), defaultModel)
import Json.Decode as Json


toast : Maybe m -> String -> Contents m
toast onDismiss message =
    { message = message
    , action = Nothing
    , timeout = 5000
    , fade = 250
    , stacked = False
    , dismissOnAction = True
    , onDismiss = onDismiss
    }


snack : Maybe m -> String -> String -> Contents m
snack onDismiss message label =
    { message = message
    , action = Just label
    , timeout = 5000
    , fade = 250
    , stacked = True
    , dismissOnAction = True
    , onDismiss = onDismiss
    }


next : Model m -> Cmd Transition -> Cmd (Msg m)
next model =
    Cmd.map (Move model.seq)


move : Transition -> Model m -> ( Model m, Cmd (Msg m) )
move transition model =
    case ( model.state, transition ) of
        ( Inert, Timeout ) ->
            tryDequeue model

        ( Active contents, Clicked ) ->
            ( { model | state = Fading contents }
            , Helpers.delayedCmd contents.fade Timeout |> next model
            )

        ( Active contents, Timeout ) ->
            ( { model | state = Fading contents }
            , Helpers.delayedCmd contents.fade Timeout |> next model
            )

        ( Fading contents, Timeout ) ->
            ( { model | state = Inert }
            , Helpers.cmd Timeout |> next model
            )

        _ ->
            ( model, Cmd.none )


enqueue : Contents m -> Model m -> Model m
enqueue contents model =
    { model
        | queue = List.append model.queue [ contents ]
    }


tryDequeue : Model m -> ( Model m, Cmd (Msg m) )
tryDequeue model =
    case ( model.state, model.queue ) of
        ( Inert, c :: cs ) ->
            ( { model
                | state = Active c
                , queue = cs
                , seq = model.seq + 1
                , open = False
              }
            , Helpers.delayedCmd c.timeout Timeout |> Cmd.map (Move (model.seq + 1))
            )

        _ ->
            ( model, Cmd.none )


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update fwd msg model =
    case msg of
        Move seq transition ->
            if seq == model.seq then
                move transition model
                    |> Tuple.mapSecond (Cmd.map fwd)

            else
                ( model, Cmd.none )

        Dismiss dismissOnAction actionOnDismiss ->
            let
                fwdEffect =
                    case actionOnDismiss of
                        Just msg_ ->
                            Helpers.cmd msg_

                        Nothing ->
                            Cmd.none
            in
            (if dismissOnAction then
                update fwd (Move model.seq Clicked) model

             else
                ( model, Cmd.none )
            )
                |> Tuple.mapSecond (\cmd -> Cmd.batch [ cmd, fwdEffect ])

        SetOpen ->
            ( { model | open = True }, Cmd.none )


add :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Contents m
    -> Store m s
    -> ( Store m s, Cmd m )
add lift idx contents store =
    let
        component_ =
            Dict.get idx store.snackbar
                |> Maybe.withDefault defaultModel

        ( component, effects ) =
            enqueue contents component_
                |> tryDequeue
                |> Tuple.mapSecond (Cmd.map (lift << Internal.Msg.SnackbarMsg idx))

        updatedStore =
            { store | snackbar = Dict.insert idx component store.snackbar }
    in
    ( updatedStore, effects )


type alias Config =
    { dismissible : Bool }


defaultConfig : Config
defaultConfig =
    { dismissible = False }


leading : Property m
leading =
    Options.cs "mdc-snackbar--leading"


dismissible : Property m
dismissible =
    Options.option (\config -> { config | dismissible = True })


snackbar : (Msg m -> m) -> Model m -> List (Property m) -> List (Html m) -> Html m
snackbar lift model options _ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        contents =
            case model.state of
                Inert ->
                    Nothing

                Active c ->
                    Just c

                Fading c ->
                    Just c

        isOpening =
            case model.state of
                Active _ ->
                    not model.open

                _ ->
                    False

        isOpen =
            case model.state of
                Active _ ->
                    model.open

                _ ->
                    False

        isFading =
            case model.state of
                Fading _ ->
                    True

                _ ->
                    False

        action =
            contents |> Maybe.andThen .action

        onDismiss =
            contents |> Maybe.andThen .onDismiss

        stacked =
            Maybe.map .stacked contents == Just True
    in
    Options.apply summary
        Html.div
        [ cs "mdc-snackbar"

        -- Open class should only be added when we have started
        -- animating the opening, and removed immediately when we start closing.
        , cs "mdc-snackbar--open" |> when isOpen

        -- Opening and closing classes need to kick in as soon as
        -- snackbar is opened or closed. They're only used for the
        -- duration of the animation.
        , cs "mdc-snackbar--opening" |> when isOpening
        , cs "mdc-snackbar--closing" |> when isFading
        , when isOpening <| GlobalEvents.onTick (Json.succeed (lift SetOpen))
        , cs "mdc-snackbar--stacked"
            |> when stacked
        ]
        []
        [ styled Html.div
            [ cs "mdc-snackbar__surface"
            ]
            [ styled Html.div
                [ cs "mdc-snackbar__label"
                , role "status"
                , aria "live" "polite"
                ]
                (contents
                    |> Maybe.map (\c -> [ text c.message ])
                    |> Maybe.withDefault []
                )
            , styled Html.div
                [ cs "mdc-snackbar__actions"
                ]
                [ Options.styled Html.button
                    [ cs "mdc-button"
                    , cs "mdc-snackbar__action"
                    , Options.attribute (Html.type_ "button")
                    , Options.on "click" (Json.succeed (lift (Dismiss True onDismiss)))
                    ]
                    (action
                        |> Maybe.map (\actionString -> [ text actionString ])
                        |> Maybe.withDefault []
                    )
                , if config.dismissible then
                    Options.styled Html.button
                        [ cs "mdc-icon-button"
                        , cs "mdc-snackbar__dismiss"
                        , cs "material-icons"
                        , Options.attribute (Html.title "Dismiss")
                        , Options.on "click" (Json.succeed (lift (Dismiss True Nothing)))
                        ]
                        [ text "close" ]

                  else
                    text ""
                ]
            ]
        ]


type alias Property m =
    Options.Property Config m


getSet :
    { get : Index -> { a | snackbar : Indexed (Model m) } -> Model m
    , set :
        Index
        -> { a | snackbar : Indexed (Model m) }
        -> Model m
        -> { a | snackbar : Indexed (Model m) }
    }
getSet =
    Component.indexed .snackbar (\x y -> { y | snackbar = x }) defaultModel


type alias Store m s =
    { s
        | snackbar : Indexed (Model m)
    }


react :
    (Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store m s
    -> ( Maybe (Store m s), Cmd m )
react =
    Component.react getSet.get
        getSet.set
        Internal.Msg.SnackbarMsg
        (\fwd msg model -> Tuple.mapFirst Just (update fwd msg model))


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store m s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render getSet.get snackbar Internal.Msg.SnackbarMsg
