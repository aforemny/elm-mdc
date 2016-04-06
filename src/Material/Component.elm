module Material.Component 
  ( Embedding, Observer
  , Indexed
  , Instance, instance 
  , update
  , Action
  ) where

{-| 

The Elm Architecture is conceptually very nice, but it forces us
to write large amounts of boilerplate whenever we need to use a "component". 
We must:

  1. Retain the state of the component in our Model 
  2. Add the components actions to our Action 
  3. Dispatch those actions in our update

None of these things have anything to do with what we want from the component, 
namely rendering it in our View function, and potentially reacting to some 
(but not all) of its actions---e.g., we want to react to a Click of a button, 
but we don't care when it updates its animation state. 

This module provides an extensible mechanism for collecting arbitrary
(differently-typed) Elm Architecture components into a single component with
a single Action type and update function. The module is used internally to 
produce `instance` functions; if you are using elm-mdl (and are not interested in
optimising for compiled program size), you should ignore this module and look
instead at `Material`.

# Component types
@docs Indexed, Embedding, Observer, Instance

# Instance construction
@docs instance

# Instance consumption
@docs update, Action

-}

import Effects exposing (Effects)
import Dict exposing (Dict)

import Material.Helpers exposing (map1, map2, map1st, map2nd, Update, Update')


-- TYPES


{-| Standard EA view function type. 
-}
type alias View model action a = 
  Signal.Address action -> model -> a


-- EMBEDDING MODELS 


{-| Indexed families of things.
-}
type alias Indexed a = 
  Dict Int a 


{-| An __embedding__ of an Elm Architecture component is a variant in which
view and update functions know how to extract and update their model 
from a larger container model. 
-}
type alias Embedding model container  action a = 
  { view : View container action a
  , update : Update container action 
  , getModel : container -> model
  , setModel : model -> container -> container
  }
 

{-| Embed a component. Third and fourth arguments are a getter (extract the 
local model from the container) and a setter (update local model in the 
container). 
-}
embed : 
  View model action a ->               -- Given a view function, 
  Update model action ->               -- an update function 
  (container -> model) ->              -- a getter 
  (model -> container -> container) -> -- a setter
  Embedding model container action a   -- produce an Embedding. 

embed view update get set = 
  { view = 
      \addr model -> view addr (get model)
  , update = 
      \action model -> 
        update action (get model)
          |> map1st (flip set model)
  , getModel = get
  , setModel = set
  }


{-| We are interested in particular embeddings where components of the same type 
all have their state living inside a shared `Dict`; the individual component
has an id used for looking up its own state. Its the responsibility of the user
to make
sure that ids are unique. 
-}
embedIndexed : 
  View model action a ->                       -- Given a view function, 
  Update model action ->                       -- an update function 
  (container -> Indexed model) ->              -- a getter 
  (Indexed model -> container -> container) -> -- a setter
  model ->                                     -- an initial model for this instance
  Int ->                                       -- an instance id (*)
  Embedding model container action a           -- ... produce a Component.

embedIndexed view update get set model0 id = 
  let 
    get' model = 
      Dict.get id (get model) |> Maybe.withDefault model0

    set' submodel model = 
      set (Dict.insert id submodel (get model)) model 
  in 
      embed view update get' set' 



-- LIFTING ACTIONS


{-| Generic MDL Action. 
-}
type Action model obs = 
  A (model -> (model, Effects (Action model obs), Maybe obs))


{-| Generic update function for Action. 
-}
update : 
  (Action state action -> action) ->      
  Update' state (Action state action) action

update fwd (A f) state = 
  let 
    (state', fx, obs) = 
      f state
        |> map2 (Effects.map fwd)
  in 
    case obs of 
      Nothing -> 
        (state', fx)

      Just x -> 
        (state', Effects.batch [ fx, Effects.tick (always x) ]) 



-- INSTANCES


{- EA update function variant where running the function
produces not just a new model and an effect, but also an 
observation.
-}
type alias Step model action obs =
  action -> model -> (model, Effects action, Maybe obs)
  


{-| Type of component instances. A component instance contains a view, 
and get/set/map for, well, getting, setting, and mapping the component
model. 
-}
type alias Instance submodel model subaction action a = 
  { view : View model action a
  , get : model -> submodel
  , set : submodel -> model -> model
  , map : (submodel -> submodel) -> model -> model
  , fwd : subaction -> action 
  }


{- Partially apply a step function to an action, 
producing a generic Action.
-}
pack : (Step model action obs) -> action -> Action model obs
pack update action = 
  A (update action >> map2 (Effects.map (pack update))) 


{-| Type of observers.
-}
type alias Observer action obs = 
  action -> Maybe obs


{- Convert an update function to a step function by applying a 
function that converts the action input to the update function into
an observation.
-}
observe : Observer action obs -> Update model action -> Step model action obs
observe f update action =
  update action >> (\(model', effects) -> (model', effects, f action))


{- Return the first non-Nothing value in the list, or Nothing if no such
exists.
-}
pick : (a -> Maybe b) -> List a -> Maybe b
pick f xs = 
  case xs of 
    [] -> Nothing 
    x :: xs' -> 
      case f x of 
        Nothing -> pick f xs' 
        x -> x


connect : List (Observer subaction action) -> Observer subaction action
connect observers subaction = 
  pick ((|>) subaction) observers



{-| Given a lifting function, a list of observers and an embedding, construct an 
Instance. Notice that the Instance forgets the type parameter `subaction`.
-}
instance' : 
  (Action model action -> action) -> 
  List (Observer subaction action) -> 
  Embedding submodel model subaction a -> 
  Instance submodel model subaction action a
instance' lift observers embedding = 
  let 
    fwd = 
      pack (observe (connect observers) embedding.update) >> lift
    get = 
      embedding.getModel
    set = 
      embedding.setModel
  in
    { view = 
        \addr -> 
          embedding.view (Signal.forwardTo addr fwd) 
    , get = get
    , set = set
    , map = \f model -> set (f (get model)) model
    , fwd = fwd
    }


{-| It is helpful to see parameter names: 

    instance view update get set id lift model0 observers = 
      ...

Convert a regular Elm Architecture component (view, update) to a component
which knows how to access its state in a generic container model (get, set),
and which dispatches generic Action updates, lifted to the consumers action
type (lift). You can react to actions in custom way by providing observers
(observers). You must also provide an initial model (model0) and an identifier
for the instance (id). The identifier must be unique for all instances of the 
same type stored in the same model (rule of thumb: if they are in the same
file, they need distinct ids.)
-}
instance
    : View model action a
    -> Update model action
    -> (container -> Indexed model)
    -> (Indexed model -> container -> container)
    -> Int
    -> (Action container observation -> observation)
    -> model
    -> List (Observer action observation)
    -> Instance model container action observation a

instance view update get set id lift model0 observers = 
  embedIndexed view update get set model0 id 
    |> instance' lift observers
