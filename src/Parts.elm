module Parts
  ( embed, embedIndexed, Embedding 
  , View, Update, Index, Indexed
  , create, create1
  , update
  , Action
  ) where

{-| 

# Elm Architecture types
@docs Update, View

# Embeddings 
@docs Indexed, Embedding, embed, embedIndexed

# Part construction
@docs Action, Instance, Observer, create, create1

# Part consumption
@docs update

-}

import Effects exposing (Effects)
import Dict exposing (Dict)



-- TYPES



{-| Standard TEA update function type. 
-}
type alias Update model action = 
  action -> model -> (model, Effects action)


{-| Variant of TEA update function type, where effects may be 
lifted to a different type. 
-}
type alias Update' model action action' = 
  action -> model -> (model, Effects action')



{-| Standard TEA view function type. 
-}
type alias View model action a = 
  Signal.Address action -> model -> a



-- EMBEDDING MODELS 


type alias Index 
  = List Int


{-| Indexed families of things.
-}
type alias Indexed a = 
  Dict Index a 


{-| An __embedding__ of an Elm Architecture component is a variant in which
view and update functions know how to extract and update their model 
from a larger master model. 
-}
type alias Embedding container action a = 
  { view : View container action a
  , update : Update container action 
  }
 

{-| Embed a component. Third and fourth arguments are a getter (extract the 
local model from the container) and a setter (update local model in the 
container). 

It is instructive to compare the types of the view and update function in 
the input and output:

     {- Input -}                    {- Output -}
     View model action a            View container action a
     Update model action            Update container action 

-}
embed : 
  View model action a ->               -- Given a view function, 
  Update model action ->               -- an update function 
  (container -> model) ->              -- a getter 
  (model -> container -> container) -> -- a setter
  Embedding container action a         -- produce an Embedding. 

embed view update get set = 
  { view = 
      \addr model -> view addr (get model)
  , update = 
      \action model -> 
        update action (get model)
          |> map1st (flip set model)
  }


{-| We are interested in particular embeddings where components of the same
type all have their state living inside a shared `Dict`; the individual
component has a key used to look up its own state. 
-}
embedIndexed : 
  View model action a ->                       -- Given a view function, 
  Update model action ->                       -- an update function 
  (container -> Indexed model) ->              -- a getter 
  (Indexed model -> container -> container) -> -- a setter
  model ->                                     -- an initial model for this part
  Index ->                                     -- a part id (*)
  Embedding container action a                 -- ... produce a Part.

embedIndexed view update get set model0 id = 
  let 
    get' model = 
      Dict.get id (get model) |> Maybe.withDefault model0

    set' submodel model = 
      set (Dict.insert id submodel (get model)) model 
  in 
    embed view update get' set' 



-- LIFTING ACTIONS



{-| Similarly to how embeddings enable collecting models of different type
in a single model container, we need to collect actions in a single "master
action" type.  Obviously, actions need to be eventually executed by running
the corresponding update function. To avoid this master action type explicitly
representing the Action/update pairs of elm-mdl components, we represent an
action of an individual component as a partially applied update function; that
is, a function `container -> container`. E.g., the `Click` action of Button is
conceptually represented as:

    embeddedButton : Embedding Button.Model container action ...
    embeddedButton = 
      embedIndexed 
        Button.view Button.update .button {\m x -> {m|button=x} Button.model 0

    clickAction : container -> container 
    clickAction = embeddedButton.update Button.click 

When all components are embedded in the same `container` model, we 
then have a uniform update mechanism. 

TODO
-}
type Action container obs = 
  A (container -> (container, Effects (Action container obs)))


{-| Generic update function for Action. 
-}
update : 
  (Action container obs -> obs) ->      
  Update' container (Action container obs) obs

update fwd (A f) container = 
  f container
    |> map2nd (Effects.map fwd)
  


-- PARTS


{- Partially apply a step function to an action, producing a generic Action.
-}
pack : (Update model action) -> action -> Action model obs
pack update action = 
  A (update action >> map2nd (Effects.map (pack update))) 


{-| Given a lifting function, a list of observers and an embedding, construct an
Instance. 
-}
create'
  : (Action container obs -> obs) 
  -> Embedding container action a 
  -> View container obs a
create' lift embedding = 
  \addr -> embedding.view (Signal.forwardTo addr (pack embedding.update >> lift))



{-| It is helpful to see parameter names: 

    create view update get set id lift model0 observers = 
      ...

Convert a regular Elm Architecture component (`view`, `update`) to a part, 
i.e., a component which knows how to access its model inside a generic
container model (`get`, `set`), and which dispatches generic `Action` updates,
lifted to the consumers action type `obs` (`lift`). You can react to actions in
custom way by providing observers (`observers`). You must also provide an
initial model (`model0`) and an identifier for the part (`id`). The
identifier must be unique for all parts of the same type stored in the
same model (overapproximating rule of thumb: if they are in the same file,
they need distinct ids.)

Its instructive to compare the types of the input and output views:

    {- Input -}                 {- Output -}
    View model action a         View container obs a

That is, this function fully converts a view from its own `model` and `action`
to the master `container` model and `observation` action. 
-}
create
  : View model action a
  -> Update model action
  -> (container -> Indexed model)
  -> (Indexed model -> container -> container)
  -> model
  -> (Action container obs -> obs)
  -> Index
  -> View container obs a

create view update get set model0 lift id = 
  embedIndexed view update get set model0 id
    |> create' lift 


{-| Variant of `create` for parts that will be used only once in any 
TEA component. 
-}
create1
 : View model action a
  -> Update model action
  -> (container -> Maybe model)
  -> (Maybe model -> container -> container)
  -> model
  -> (Action container obs -> obs)
  -> View container obs a

create1 view update get set model0 lift = 
  embed view update (get >> Maybe.withDefault model0) (Just >> set)
    |> create' lift 


-- HELPERS


map1st : (a -> c) -> (a,b) -> (c,b)
map1st f (x,y) = (f x, y)


map2nd : (b -> c) -> (a,b) -> (a,c)
map2nd f (x,y) = (x, f y)


