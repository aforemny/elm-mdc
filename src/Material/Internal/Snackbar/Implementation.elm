module Material.Internal.Snackbar.Implementation exposing
    ( add
    , alignEnd
    , alignStart
    , Property
    , react
    , snack
    , toast
    , view
    )

import Dict
import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Material.Internal.Component as Component exposing (Indexed, Index)
import Material.Internal.Helpers as Helpers
import Material.Internal.Msg
import Material.Internal.Options as Options exposing (styled, cs, when)
import Material.Internal.Options.Internal as Internal
import Material.Internal.Snackbar.Model exposing (Model, defaultModel, Contents, Msg(..), Transition(..), State(..))


toast : Maybe m -> String -> Contents m
toast onDismiss message =
    { message = message
    , action = Nothing
    , timeout = 2750
    , fade = 250
    , multiline = False
    , actionOnBottom = False
    , dismissOnAction = True
    , onDismiss = onDismiss
    }


snack : Maybe m -> String -> String -> Contents m
snack onDismiss message label =
    { message = message
    , action = Just label
    , timeout = 2750
    , fade = 250
    , multiline = True
    , actionOnBottom = False
    , dismissOnAction = True
    , onDismiss = onDismiss
    }


next : Model m -> Cmd Transition -> Cmd (Msg m)
next model =
    Cmd.map (Move model.seq)


move : Transition -> Model m -> ( Maybe (Model m), Cmd (Msg m) )
move transition model =
    case ( model.state, transition ) of
        ( Inert, Timeout ) ->
            tryDequeue model

        ( Active contents, Clicked ) ->
            Just
            { model
                | state = Fading contents
            }
                ! [ Helpers.delayedCmd contents.fade Timeout |> next model ]

        ( Active contents, Timeout ) ->
            Just
            { model
                | state = Fading contents
            }
                ! [ Helpers.delayedCmd contents.fade Timeout |> next model ]

        ( Fading contents, Timeout ) ->
            Just
            { model
                | state = Inert
            }
                ! [ Helpers.cmd Timeout |> next model ]

        _ ->
            Nothing ! []


enqueue : Contents m -> Model m -> Model m
enqueue contents model =
    { model
        | queue = List.append model.queue [ contents ]
    }


tryDequeue : Model m -> ( Maybe (Model m), Cmd (Msg m) )
tryDequeue model =
    case ( model.state, model.queue ) of
        ( Inert, c :: cs ) ->
            ( Just
              { model
                | state = Active c
                , queue = cs
                , seq = model.seq + 1
              }
            , Cmd.batch
                [ Helpers.delayedCmd c.timeout Timeout |> Cmd.map (Move (model.seq + 1))
                ]
            )

        _ ->
            Nothing ! []


update : (Msg m -> m) -> Msg m -> Model m -> ( Maybe (Model m), Cmd m )
update fwd msg model =
    case msg of
        Move seq transition ->
            if seq == model.seq then
                move transition model
                |> Tuple.mapSecond (Cmd.map fwd)
            else
                Nothing ! []

        Dismiss dismissOnAction actionOnDismiss ->
            let
                fwdEffect =
                    case actionOnDismiss of
                        Just msg_ ->
                            Helpers.cmd msg_
                        Nothing ->
                            Cmd.none

            in
            ( if dismissOnAction then
                  update fwd (Move model.seq Clicked) model
              else
                  Nothing ! []
            )
                |> Tuple.mapSecond (\cmd -> Cmd.batch [ cmd, fwdEffect ])


add : (Material.Internal.Msg.Msg m -> m)
    -> Index
    -> Contents m
    -> Store m s
    -> ( Store m s, Cmd m )
add lift idx contents store =
    let
        component_ =
            Dict.get idx store.snackbar
            |> Maybe.withDefault defaultModel

        (component, effects ) =
          enqueue contents component_
          |> tryDequeue
          |> Tuple.mapSecond (Cmd.map (lift << Material.Internal.Msg.SnackbarMsg idx))

        updatedStore =
          case component of
              Just component ->
                  { store | snackbar = Dict.insert idx component store.snackbar }

              Nothing ->
                  store
    in
        ( updatedStore, effects )


type alias Config =
    {}


defaultConfig : Config
defaultConfig =
    {}


alignStart : Property m
alignStart =
    Options.cs "mdc-snackbar--align-start"


alignEnd : Property m
alignEnd =
    Options.cs "mdc-snackbar--align-end"


snackbar : (Msg m -> m) -> Model m -> List (Property m) -> List (Html m) -> Html m
snackbar lift model options _ =
    let
        contents =
            case model.state of
                Inert ->
                    Nothing

                Active c ->
                    Just c

                Fading c ->
                    Just c

        isActive =
            case model.state of
                Inert ->
                    False

                Active _ ->
                    True

                Fading _ ->
                    False

        action =
            contents |> Maybe.andThen .action

        onDismiss =
            contents |> Maybe.andThen .onDismiss

        multiline =
            (Maybe.map .multiline contents == Just True)

        actionOnBottom =
            (Maybe.map .actionOnBottom contents == Just True)
            && multiline

        ({ config } as summary) =
            Internal.collect defaultConfig options
    in
    Internal.apply summary Html.div
    [ cs "mdc-snackbar"
    , cs "mdc-snackbar--active"
      |> when isActive
    , cs "mdc-snackbar--multiline"
      |> when multiline
    , cs "mdc-snackbar--action-on-bottom"
      |> when actionOnBottom
    ]
    []
    [ styled Html.div
      [ cs "mdc-snackbar__text"
      ]
      (contents
          |> Maybe.map (\c -> [ text c.message ])
          |> Maybe.withDefault []
      )
    , styled Html.div
      [ cs "mdc-snackbar__action-wrapper"
      ]
      [ Options.styled Html.button
        [ cs "mdc-snackbar__action-button"
        , Options.attribute (Html.type_ "button")
        , case onDismiss of
              Just onDismiss ->
                  Options.on "click" (Json.succeed onDismiss)
              Nothing ->
                  Options.nop
        ]
        (action
            |> Maybe.map (\action -> [ text action ])
            |> Maybe.withDefault []
        )
      ]
    ]


type alias Property m =
    Options.Property Config m


( get, set ) =
    Component.indexed .snackbar (\x y -> { y | snackbar = x }) defaultModel


type alias Store m s =
    { s | snackbar : Indexed (Model m)
    }


react :
    (Material.Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store m s
    -> ( Maybe (Store m s), Cmd m )
react =
    Component.react get set Material.Internal.Msg.SnackbarMsg update


view :
    (Material.Internal.Msg.Msg m -> m)
    -> Index
    -> Store m s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render get snackbar Material.Internal.Msg.SnackbarMsg
