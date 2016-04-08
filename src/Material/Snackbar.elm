module Material.Snackbar
  ( Contents, Model, model, toast, snackbar, isActive, activeAction
  , Action(Add, Action), update
  , view
  , Instance, instance, add
  ) where

{-| TODO

# Model
@ docs Contents, Model, model, toast, snackbar

# Action, Update
@docs Action, update

# View
@docs view
-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects, none)
import Task
import Time exposing (Time)
import Maybe exposing (andThen)

import Material.Component as Component exposing (Indexed)
import Material.Helpers exposing (mapFx, addFx, delay)


-- MODEL


{-| TODO
-}
type alias Contents a =
  { message : String
  , action : Maybe (String, a)
  , timeout : Time
  , fade : Time
  }


{-| TODO
-}
type alias Model a =
  { queue : List (Contents a)
  , state : State' a
  , seq : Int
  }


{-| TODO
-}
model : Model a
model =
  { queue = []
  , state = Inert
  , seq = 0
  }




{-| Generate default toast with given message.
Timeout is 2750ms, fade 250ms.
-}
toast : String -> Contents a
toast message =
  { message = message
  , action = Nothing
  , timeout = 2750
  , fade = 250
  }


{-| Generate default snackbar with given message,
action-label, and action. Timeout is 2750ms, fade 250ms.
-}
snackbar : String -> String -> a -> Contents a
snackbar message actionMessage action =
  { message = message
  , action = Just (actionMessage, action)
  , timeout = 2750
  , fade = 250
  }


{-| TODO
(Bad name)
-}
isActive : Model a -> Maybe (Contents a)
isActive model =
  case model.state of
    Active c ->
      Just c

    _ ->
      Nothing


{-|  TODO
-}
activeAction : Model a -> Maybe a
activeAction model = 
  isActive model 
    |> flip Maybe.andThen .action 
    |> Maybe.map snd


contentsOf : Model a -> Maybe (Contents a)
contentsOf model =
  case model.state of
    Inert -> Nothing
    Active contents -> Just contents
    Fading contents -> Just contents


-- SNACKBAR STATE MACHINE


type State' a
  = Inert
  | Active (Contents a)
  | Fading (Contents a)


type Transition
  = Timeout
  | Click


move : Transition -> Model a -> (Model a, Effects Transition)
move transition model =
  case (model.state, transition) of
    (Inert, Timeout) ->
      tryDequeue model

    (Active contents, _) ->
      ( { model | state = Fading contents }
      , delay contents.fade Timeout
      )

    (Fading contents, Timeout) ->
      ( { model | state = Inert}
      , Effects.tick (\_ -> Timeout)
      )

    _ ->
      (model, none)


-- NOTIFICATION QUEUE


enqueue : Contents a -> Model a -> Model a
enqueue contents model =
  { model
    | queue = List.append model.queue [contents]
  }


tryDequeue : Model a -> (Model a, Effects Transition)
tryDequeue model =
  case (model.state, model.queue) of
    (Inert, c :: cs) ->
      ( { model
          | state = Active c
          , queue = cs
          , seq = model.seq + 1
        }
      , delay c.timeout Timeout
      )

    _ ->
      (model, none)


-- ACTIONS, UPDATE


{-| TODO
-}
type Action a
  = Add (Contents a)
  | Action a
  | Move Int Transition


forwardClick : Transition -> Model a -> (Model a, Effects (Action a)) -> (Model a, Effects (Action a))
forwardClick transition model =
  case (transition, model.state) of
    (Click, Active contents) ->
      contents.action
      |> Maybe.map (snd >> Action >> Task.succeed >> Effects.task >> addFx)
      |> Maybe.withDefault (\x -> x)

    _ ->
      \x -> x


liftTransition : (Model a, Effects Transition) -> (Model a, Effects (Action a))
liftTransition (model, effect) =
  (model, Effects.map (Move model.seq) effect)


{-| TODO
-}
update : Action a -> Model a -> (Model a, Effects (Action a))
update action model =
  case action of
    Action _ ->
      (model, none)

    Add contents ->
      enqueue contents model
      |> tryDequeue
      |> liftTransition

    Move seq transition ->
      if seq == model.seq then
        move transition model
        |> liftTransition
        |> forwardClick transition model
      else
        (model, none)


-- VIEW


view : Signal.Address (Action a) -> Model a -> Html
view addr model =
  let
    active =
      model.queue /= []

    textBody =
      contentsOf model
      |> Maybe.map (\c -> [ text c.message ])
      |> Maybe.withDefault []

    (buttonBody, buttonHandler) =
      contentsOf model
      |> (flip Maybe.andThen .action)
      |> Maybe.map (\(msg, action') ->
        ([ text msg ],
         [ onClick addr (Move model.seq Click) ])
      )
      |> Maybe.withDefault ([], [])

    isActive =
      case model.state of
        Inert -> False
        Active _ -> True
        Fading _ -> False
  in
    div
      [ classList
        [ ("mdl-js-snackbar", True)
        , ("mdl-snackbar", True)
        , ("mdl-snackbar--active", isActive)
        ]
      -- , ariaHidden "true"
      ]
      [ div
          [ class "mdl-snackbar__text"
          ]
          textBody
      , button
          (  class "mdl-snackbar__action"
          :: type' "button"
       -- :: ariaHidden "true"
          :: buttonHandler
          )
          buttonBody
      ]


-- COMPONENT


{-|
-}
type alias State s  obs = 
  { s | snackbar : Maybe (Model obs) }


{-|
-}
type alias Instance state obs =
  Component.Instance (Model obs) state (Action obs) obs Html


{-|
-}
type alias Observer obs = 
  Component.Observer (Action obs) obs


actionObserver : Observer ons 
actionObserver action = 
  case action of 
    Action action' -> 
      Just action' 
  
    _ -> 
      Nothing


{-| Component instance.
-}
instance 
  : (Component.Action (State state obs) obs -> obs)
  -> (Model obs)
  -> Instance (State state obs) obs

instance lift model0 = 
  Component.instance1
    view update .snackbar (\x y -> {y | snackbar = x}) lift model0 [ actionObserver ]

{-|
  TODO
-}
add : 
  Contents obs 
  -> Instance (State state obs) obs 
  -> (State state obs)
  -> (State state obs, Effects obs)
add contents inst model = 
  let
    (sb, fx) = 
      update (Add contents) (inst.get model)
  in
    (inst.set sb model, Effects.map inst.fwd fx)
