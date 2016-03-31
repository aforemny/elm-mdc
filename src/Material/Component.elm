module Material.Component where

import Effects exposing (Effects)
import Html exposing (Html)
import Dict exposing (Dict)

import Material.Button as Button
import Material.Style exposing (Style)
import Material.Textfield as Textfield


map1 : (a -> a') -> (a, b, c) -> (a', b, c)
map1 f (x,y,z) = (f x, y, z)


map2 : (b -> b') -> (a, b, c) -> (a, b', c)
map2 f (x,y,z) = (x, f y, z)


map1st : (a -> c) -> (a,b) -> (c,b)
map1st f (x,y) = (f x, y)


map2nd : (b -> c) -> (a,b) -> (a,c)
map2nd f (x,y) = (x, f y)


type alias Update' model action action' = 
  action -> model -> (model, Effects action')


type alias Update model action = 
  Update' model action action


type alias Step model action action' = 
  action -> model -> (model, Effects action, action')


type alias State =
  { button : Indexed Button.Model
  , textfield : Indexed Textfield.Model
  }


state0 : State
state0 = 
  { button = Dict.empty
  , textfield = Dict.empty
  }


type Action model obs = 
  A (model -> (model, Effects (Action model obs), obs))
 

type alias Model model state  = 
  { model | componentState : state }


update : 
  (Action state (Maybe action) -> action) ->      
  Update (Model model state) action ->                    
  Update' (Model model state) (Action state (Maybe action)) action

update fwd update' (A f) model = 
  let 
    (model', fx, obs) = 
      f model.componentState
        |> map1 (\state' -> { model | componentState = state' })
        |> map2 (Effects.map fwd)
  in 
    case obs of 
      Nothing -> 
        (model', fx)

      Just x -> 
        update' x model'
          |> map2nd (\fx' -> Effects.batch [ fx, fx' ]) 


pack : (Step model action obs) -> action -> Action model obs
pack update action = 
  A (update action >> map2 (Effects.map (pack update))) 
-- CAUTION. Potential crash from update/update name clash. 


type alias View model action a = 
  Signal.Address action -> model -> a


type alias Component model action a = 
  { view : View model action a
  , update : Update model action 
  }


type alias Indexed a = 
  Dict Int a 

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


type alias Widget submodel model action obs a = 
  { view : View model action a
  , update : Update model action 
  , observe : action -> Maybe obs
  , getModel : model -> submodel
  , setModel : submodel -> model -> model
  }
 

widget : 
  Component submodel action a ->            -- Given a "Component submodel ..."
  (model -> Indexed submodel) ->            -- a getter 
  (Indexed submodel -> model -> model) ->   -- a setter
  submodel ->                               -- an initial model for this instance
  Int ->                                    -- an id for this instance
  Widget submodel model action obs a        -- ... produce a "Widget ..."

widget component get set model0 id = 
  let 
    get' model = 
      Dict.get id (get model) |> Maybe.withDefault model0

    set' submodel model = 
      set (Dict.insert id submodel (get model)) model 
  in 
    { view = 
        \addr model -> component.view addr (get' model)

    , update = 
        \action model -> 
          component.update action (get' model)
            |> map1st (flip set' model)

    , getModel = get'
    , setModel = set'
    , observe = \_ -> Nothing
    }



observe : (action -> obs) -> Update model action -> Step model action obs 
observe f update action =
  update action >> (\(model', effects) -> (model', effects, f action))


type alias Instance submodel model action a = 
  { view : View model action a
  , getModel : model -> submodel
  , setModel : submodel -> model -> model
  }


instance : 
  (Action model (Maybe action) -> action) -> 
  Widget submodel model subaction action a -> 
  Instance submodel model action a
instance lift widget = 
  { view = 
      \addr -> 
        widget.view (Signal.forwardTo addr (pack (observe widget.observe widget.update) >> lift))
  , getModel = 
      widget.getModel
  , setModel = 
      widget.setModel
  }

instance' : 
  (Action model (Maybe action) -> action) -> 
  Widget submodel model subaction action a -> 
  View model action a

instance' lift widget = (instance lift widget).view
      

type alias ButtonStates a = 
  { a | button : Indexed Button.Model }

--buttonWidget : Button.Model -> Int -> Widget Button.Model (ButtonStates m) Button.Action (Maybe obs) (List Style -> List Html -> Html)
buttonWidget model = 
  widget buttonComponent .button (\x y -> {y | button = x}) model

type Test = State' (Action State (Maybe Test))


addObserver widget f = 
  { widget 
  | observe = 
      \action -> 
        case f action of 
          Nothing -> widget.observe action 
          x -> x
  }
        


onClick f widget  = 
  (\action -> 
    case action of 
      Button.Click -> 
        Just f
      _ -> 
        Nothing)
  |> addObserver widget 





type alias TextfieldStates a =
  { a | textfield : Indexed Textfield.Model }



--textfieldWidget : Textfield.Model -> Int -> Widget Textfield.Model (TextfieldStates model) Textfield.Action (Maybe obs) Html
textfieldWidget model = 
  widget textfieldComponent .textfield (\x y -> { y | textfield = x}) model

