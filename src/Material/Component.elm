module Material.Component 
  ( Component, setup, addObserver
  , Instance, instance, instance'
  , update
  , Indexed
  , View, Update, Action
  ) where

{-|

# Types

## Elm architecture types
@docs View, Update, Action 

## Component types
@docs Component, Instance

## Helpers
@docs Indexed

# For component consumers
@docs instance, instance'
@docs update

# For component authors
@docs component, addObserver
-}

import Effects exposing (Effects)
import Dict exposing (Dict)


import Material.Helpers exposing (map1, map2, map1st, map2nd)


-- TYPES


{-| Indexed families of things.
-}
type alias Indexed a = 
  Dict Int a 


{- Variant of EA update function type, where effects may be 
lifted to a different type. 
-}
type alias Update' model action action' = 
  action -> model -> (model, Effects action')


{-| Standard EA update function type. 
-}
type alias Update model action = 
  Update' model action action


{-| Standard EA view function type. 
-}
type alias View model action a = 
  Signal.Address action -> model -> a


{-| Generic component action.
-}
type Action model obs = 
  A (model -> (model, Effects (Action model obs), obs))
 

{-| Generic model. 
-}
type alias Model model state  = 
  { model | componentState : state }


-- FOR CONSUMERS


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



-- COMPONENT


{-| Component type. 
-}
type alias Component submodel model action obs a = 
  { view : View model action a
  , update : Update model action 
  , observe : action -> Maybe obs
  , getModel : model -> submodel
  , setModel : submodel -> model -> model
  }
 

{-| Component constructor. You must supply 

1. A view function 
2. An update function 
3. A getter
4. A setter

This will produce a function which needs only

5. An initial model, and
6. an id

to fit with the `instance` function. 
-}
setup : 
  View submodel action a ->                 -- Given a view function, 
  Update submodel action ->                 -- an update function 
  (model -> Indexed submodel) ->            -- a getter 
  (Indexed submodel -> model -> model) ->   -- a setter
  submodel ->                               -- an initial model for this instance
  Int ->                                    -- an instance id (*)
  Component submodel model action obs a     -- ... produce a Component.

setup view update get set model0 id = 
  let 
    get' model = 
      Dict.get id (get model) |> Maybe.withDefault model0

    set' submodel model = 
      set (Dict.insert id submodel (get model)) model 
  in 
    { view = 
        \addr model -> view addr (get' model)
    , update = 
        \action model -> 
          update action (get' model)
            |> map1st (flip set' model)
    , getModel = get'
    , setModel = set'
    , observe = \_ -> Nothing
    }



{- EA update function variant where running the function
produces not just a new model and an effect, but also an 
observation.
-}
type alias Step model action obs =
  action -> model -> (model, Effects action, obs)


{- Convert an update function to a step function by applying a 
function that converts the action input to the update function into
an observation.
-}
observe : (action -> obs) -> Update model action -> Step model action obs 
observe f update action =
  update action >> (\(model', effects) -> (model', effects, f action))


{-| Type of component instances. A component instance contains a view, 
and get/set/map for, well, getting, setting, and mapping the component
model. 
-}
type alias Instance submodel model action a = 
  { view : View model action a
  , get : model -> submodel
  , set : submodel -> model -> model
  , map : (submodel -> submodel) -> model -> model
  }


{- Partially apply a step (update + observation) function to an action, 
producing a generic Action.
-}
pack : (Step model action obs) -> action -> Action model obs
pack update action = 
  A (update action >> map2 (Effects.map (pack update))) 


{-| Instantiate a component. You must supply: 

1. A function embedding `Action` into your actions. 
2. A component
-}
instance : 
  (Action model (Maybe action) -> action) -> 
  Component submodel model subaction action a -> 
  Instance submodel (Model master model) action a
instance lift widget = 
  let 
    get model = 
      widget.getModel model.componentState

    set x model = 
      { model | componentState = widget.setModel x model.componentState }

    fwd = 
      pack (observe widget.observe widget.update) >> lift
  in
    { view = 
        \addr model -> 
          widget.view (Signal.forwardTo addr fwd) model.componentState
    , get = get
    , set = set
    , map = \f model -> set (f (get model)) model
    }


{-| Convenience function for instantiating components whose models
you never need to read or write. (E.g,. Snackbar in Toast form.)
-}
instance' : 
  (Action model (Maybe action) -> action) -> 
  Component submodel model subaction action a -> 
  View (Model m model) action a

instance' lift widget = (instance lift widget).view
      

{-| Add an observer to a component.
-}
addObserver
  :  { c | observe : a -> Maybe b }
  -> (a -> Maybe b)
  -> { c | observe : a -> Maybe b }
addObserver component f = 
  { component 
  | observe = 
      \action -> 
        case f action of 
          Nothing -> component.observe action 
          x -> x
  }
        



{-

type alias TextfieldStates a =
  { a | textfield : Indexed Textfield.Model }



textfieldWidget : Textfield.Model -> Int -> Widget Textfield.Model (TextfieldStates model) Textfield.Action (Maybe obs) Html
textfieldWidget model = 
  widget textfieldComponent .textfield (\x y -> { y | textfield = x}) model

-}

