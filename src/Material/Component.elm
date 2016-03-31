module Material.Component where

import Effects exposing (Effects)
import Html exposing (Html)
import Dict exposing (Dict)

import Material.Button as Button
import Material.Style exposing (Style)
import Material.Textfield as Textfield



map1st : (a -> c) -> (a,b) -> (c,b)
map1st f (x,y) = (f x, y)


map2nd : (b -> c) -> (a,b) -> (a,c)
map2nd f (x,y) = (x, f y)



type alias Updater model action = 
  action -> model -> (model, Effects action)


type Action model = 
  A (model -> (model, Effects (Action model)))
  

update : Updater State (Action State)
update (A f) model = 
  f model


pack : Updater model action -> action -> Action model
pack update action = 
  A ( \m -> map2nd (Effects.map (pack update)) (update action m) )


type alias View model action a = 
  Signal.Address action -> model -> a


type alias Component model action a = 
  { view : View model action a
  , update : Updater model action 
  }


type alias States a = 
  Dict Int a 


type alias State =
  { button : States Button.Model
  , textfield : States Textfield.Model
  }


state0 : State
state0 = 
  { button = Dict.empty
  , textfield = Dict.empty
  }


buttonComponent : Component Button.Model Button.Action (List Style -> List Html -> Html)
buttonComponent = 
  { view = Button.raised
  , update = Button.update
  }

textfieldComponent : Component Textfield.Model Textfield.Action Html
textfieldComponent = 
  { view = Textfield.view
  , update = \action model -> (Textfield.update action model, Effects.none)
  }


embed : 
  Component submodel action a ->            -- Given a "Component submodel ..."
  (model -> States submodel) ->             -- a getter 
  (States submodel -> model -> model) ->    -- a setter
  submodel ->                               -- an initial model for this instance
  Int ->                                    -- an id for this instance
  Component model action a                  -- ... produce a "Component model ..."

embed component get set model0 id = 
  let 
    get' model = 
      Dict.get id (get model) |> Maybe.withDefault model0

    set' submodel model = 
      set (Dict.insert id submodel (get model)) model 

    view addr model = 
      component.view addr (get' model)

    update action model = 
      component.update action (get' model)
        |> map1st (flip set' model)
  in 
    { view = view
    , update = update
    }


type alias Updater' model action action' = 
  action -> model -> (model, Effects action, action')

{-
observe : (action -> action') -> Updater model action -> Updater' model action action'
observe f update action model = 
  let 
    (model', effects) = update action model 
  in 
    (model', effects, f action)
-}


instance : ((Action State) -> action) -> Component State a b -> View State action b
instance f component addr state = 
  component.view 
    (Signal.forwardTo addr (pack component.update >> f))
    state 

{-
f id = 

  embed buttonComponent .button (\x y -> { y | button = x}) id (Button.model True)
-}

type alias Ctor model model' action a = 
  model -> Int -> Component model' action a


type alias ButtonStates a = 
  { a | button : States Button.Model }


mkButton : Ctor (Button.Model) (ButtonStates model') Button.Action (List Style -> List Html -> Html)
  {-
    : Button.Model
    -> Int
    -> Component
           { b | button : States Button.Model }
           Button.Action
           (List Style -> List Html -> Html)
  -}

mkButton model0 = 
  embed buttonComponent .button (\x y -> {y | button = x}) model0



buttonInstance : ((Action State) -> action) -> Int -> View State action (List Style -> List Html -> Html)
buttonInstance f id = 
  instance f (mkButton (Button.model True) id)

mkTextfield model0 = 
  embed textfieldComponent .textfield (\x y -> { y | textfield = x}) model0

textfieldInstance f id = 
  instance f (mkTextfield Textfield.model id)  

