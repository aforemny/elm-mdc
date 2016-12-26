module Material.Snackbar
    exposing
        ( Contents
        , Model
        , add
        , model
        , toast
        , snackbar
        , Msg(Begin, End, Click)
        , update
        , view
        )

{-| From the [Material Design Lite documentation](https://www.getmdl.io/components/index.html#snackbar-section):

> The Material Design Lite (MDL) __snackbar__ component is a container used to
> notify a user of an operation's status. It displays at the bottom of the
> screen. A snackbar may contain an action button to execute a command for the
> user. Actions should undo the committed action or retry it if it failed for
> example. Actions should not be too close the snackbar. By not providing an
> action, the snackbar becomes a __toast__ component.

Refer to [this site](http://debois.github.io/elm-mdl/#snackbar)
for a live demo.

# Generating messages
@docs Contents, toast, snackbar, add

# Elm Architecture

@docs Model, model
@docs Msg, update
@docs view

# Render
Snackbar does not have a `render` value. It must be used as a regular TEA
component.
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Platform.Cmd exposing (Cmd, none)
import Time exposing (Time)
import Maybe exposing (andThen)
import Material.Helpers exposing (map2nd, delay, cmd, aria)


-- MODEL


{-| Defines a single snackbar message. Usually, you would use either `toast`
or `snackbar` to construct `Contents`.

 - `message` defines the (text) message displayed
 - `action` defines a label for the action-button in the snackbar. If
    no action is provided, the snackbar is a message-only toast.
 - `payload` defines the data returned by Snackbar actions for this message.
   You will usually choose this to be a message of yours for later dispatch,
   e.g., if your snackbar has an "Undo" action, you would store the
   corresponding action as the payload.
 - `timeout` is the amount of time the snackbar should be visible
 - `fade` is the duration of the fading animation of the snackbar.

If you are satsified with the default timeout and fade, do not construct
values of this type yourself; use `snackbar` and `toast` below instead.
-}
type alias Contents a =
    { message : String
    , action : Maybe String
    , payload : a
    , timeout : Time
    , fade : Time
    }


{-| Do not construct this yourself; use `model` below.
-}
type alias Model a =
    { queue : List (Contents a)
    , state : State a
    , seq : Int
    }


{-| Default snackbar model.
-}
model : Model a
model =
    { queue = []
    , state = Inert
    , seq = -1
    }


{-| Generate toast with given payload and message. Timeout is 2750ms, fade 250ms.
-}
toast : a -> String -> Contents a
toast payload message =
    { message = message
    , action = Nothing
    , payload = payload
    , timeout = 2750
    , fade = 250
    }


{-| Generate snackbar with given payload, message and label.
Timeout is 2750ms, fade 250ms.
-}
snackbar : a -> String -> String -> Contents a
snackbar payload message label =
    { message = message
    , action = Just label
    , payload = payload
    , timeout = 2750
    , fade = 250
    }



-- SNACKBAR STATE MACHINE


type State a
    = Inert
    | Active (Contents a)
    | Fading (Contents a)


type Transition
    = Timeout
    | Clicked


next : Model a -> Cmd Transition -> Cmd (Msg a)
next model =
    Cmd.map (Move model.seq)


move : Transition -> Model a -> ( Model a, Cmd (Msg a) )
move transition model =
    case ( model.state, transition ) of
        ( Inert, Timeout ) ->
            tryDequeue model

        ( Active contents, Clicked ) ->
            ( { model | state = Fading contents }
            , Cmd.batch
                [ delay contents.fade Timeout |> next model
                , Click contents.payload |> cmd
                ]
            )

        ( Active contents, Timeout ) ->
            ( { model | state = Fading contents }
            , Cmd.batch
                [ delay contents.fade Timeout |> next model
                ]
            )

        ( Fading contents, Timeout ) ->
            ( { model | state = Inert }
            , Cmd.batch
                [ cmd Timeout |> next model
                , End contents.payload |> cmd
                ]
            )

        _ ->
            ( model, none )



-- NOTIFICATION QUEUE


enqueue : Contents a -> Model a -> Model a
enqueue contents model =
    { model
        | queue = List.append model.queue [ contents ]
    }


tryDequeue : Model a -> ( Model a, Cmd (Msg a) )
tryDequeue model =
    case ( model.state, model.queue ) of
        ( Inert, c :: cs ) ->
            ( { model
                | state = Active c
                , queue = cs
                , seq = model.seq + 1
              }
            , Cmd.batch
                [ delay c.timeout Timeout |> Cmd.map (Move (model.seq + 1))
                , cmd (Begin c.payload)
                ]
            )

        _ ->
            ( model, none )



-- ACTIONS, UPDATE


{-| Elm Architecture Msg type.
The following actions are observable to you:
- `Begin a`. The snackbar is now displaying the message with payload `a`.
- `End a`. The snackbar is done displaying the message with payload `a`.
- `Click a`. The user clicked the action on the message with payload `a`.
You can consume these three actions without forwarding them to `Snackbar.update`.
(You still need to forward other Snackbar actions.)
-}
type Msg a
    = Begin a
    | End a
    | Click a
      -- Private
    | Move Int Transition


{-| Elm Architecture update function.
-}
update : Msg a -> Model a -> ( Model a, Cmd (Msg a) )
update action model =
    case action of
        Move seq transition ->
            if seq == model.seq then
                move transition model
            else
                ( model, none )

        _ ->
            -- Begin, End, Click are for external consumption only.
            ( model, none )


{-| Add a message to the snackbar. If another message is currently displayed,
the provided message will be queued. You will be able to observe a `Begin` action
(see `Msg` above) once the action begins displaying.

You must dispatch the returned effect for the Snackbar to begin displaying your
message.
-}
add : Contents a -> Model a -> ( Model a, Cmd (Msg a) )
add contents model =
    enqueue contents model |> tryDequeue



-- VIEW


{-| Elm architecture update function.
-}
view : Model a -> Html (Msg a)
view model =
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
    in
        div
            [ classList
                [ ( "mdl-js-snackbar", True )
                , ( "mdl-snackbar", True )
                , ( "mdl-snackbar--active", isActive )
                ]
            , aria "hidden" (not isActive)
            ]
            [ div
                [ class "mdl-snackbar__text"
                ]
                (contents
                    |> Maybe.map (\c -> [ text c.message ])
                    |> Maybe.withDefault []
                )
            , button
                (class "mdl-snackbar__action"
                    :: type_ "button"
                    :: aria "hidden"
                        (action
                            |> Maybe.map (always (not isActive))
                            |> Maybe.withDefault True
                        )
                    :: (action
                            |> Maybe.map (always [ onClick (Move model.seq Clicked) ])
                            |> Maybe.withDefault []
                       )
                )
                (action
                    |> Maybe.map (\action -> [ text action ])
                    |> Maybe.withDefault []
                )
            ]



-- COMPONENT
{- Component support for Snackbar is currently disabled. The type "Model a" of
   the Snackbar Model escapes into the global Mdl model, polluting users model
   with the type variable "a". This is unacceptable in itself; it makes
   component support too hard to use for non-expert users.

   This problem is compounded by the elm compiler bug
   [#1192](https://github.com/elm-lang/elm-compiler/issues/1192), which causes
   (apparently) unhelpful error messages on errors related to wrong use of type
   constructors.

   Component support for snackbar was implemented earlier. In case a solution
   presents itself, the last commit to contain this support was:

   f0a85912654713238694f48b1a4b7d5a7459965f
-}
