module Parts exposing (..)
  {-
  ( embed, embedIndexed, Embedding 
  , View, Update, Index, Indexed
  , Msg
  , lift
  , update
  )
  -}

{-| 

# Elm Architecture types
@docs Update, View

# Embeddings 
@docs Indexed, Embedding, embed, embedIndexed

# Part construction
@docs Msg, Instance, Observer, create, create1

# Part consumption
@docs update

-}

import Platform.Cmd exposing (Cmd)
import Dict exposing (Dict)



-- TYPES



{-| Standard TEA update function type. 
-}
type alias Update model action = 
  action -> model -> (model, Cmd action)


{-| Variant of TEA update function type, where effects may be 
lifted to a different type. 
-}
type alias Update' model action action' = 
  action -> model -> (model, Cmd action')



{-| Standard TEA view function type. 
-}
type alias View model a = 
  model -> a



-- EMBEDDING MODELS 


type alias Index 
  = List Int


type alias Get c m =
  c -> m

type alias Set c m = 
  c -> m -> c


embedView : Get container model -> View model a -> View container a
embedView get view = 
  get >> view 


embedUpdate : 
    Get container model 
 -> Set container model 
 -> Update model msg
 -> Update container msg
embedUpdate get set update = 
  \msg container -> 
     update msg (get container) |> map1st (set container)

  

{-| Indexed families of things.
-}
type alias Indexed a = 
  Dict Index a 



indexed : 
    Get container (Indexed model)
 -> Set container (Indexed model)
 -> model
 -> Index
 -> (Get container model, Set container model)
indexed get set model0 idx =  
  ( \container -> Dict.get idx (get container) |> Maybe.withDefault model0
  , \container model -> set container (Dict.insert idx model (get container)) 
  )
  


-- LIFTING ACTIONS



{-| Similarly to how embeddings enable collecting models of different type
in a single model container, we need to collect actions in a single "master
action" type.  Obviously, actions need to be eventually executed by running
the corresponding update function. To avoid this master action type explicitly
representing the Msg/update pairs of elm-mdl components, we represent an
action of an individual component as a partially applied update function; that
is, a function `container -> container`. E.g., the `Click` action of Button is
conceptually represented as:

    embeddedButton : Embedding Button.Model container action ...
    embeddedButton = 
      embedIndexed 
        Button.view Button.update .button {\m x -> {m|button=x} Button.model 0

    clickMsg : container -> container 
    clickMsg = embeddedButton.update Button.click 

When all components are embedded in the same `container` model, we 
then have a uniform update mechanism. 

TODO
-}
type Msg container = 
  Msg (container -> (container, Cmd (Msg container)))


{-| Generic update function for Msg. 
-}
update : 
  (Msg container -> obs) ->      
  Update' container (Msg container) obs

update fwd (Msg f) container = 
  f container
    |> map2nd (Cmd.map fwd)
  


-- PARTS


{- Partially apply a step function to an action, producing a generic Msg.
-}
pack : 
 (Update model msg) 
 -> msg 
 -> Msg model 
pack update msg = 
  Msg (update msg >> map2nd (Cmd.map (pack update)))


lift
  : (Msg container -> obs) 
  -> Update container msg
  -> msg -> obs
lift f update = 
  pack update >> f


create 
  : ((msg -> obs) -> View model a)
 -> Update model msg
 -> Get container (Indexed model)
 -> Set container (Indexed model)
 -> model 
 -> (Msg container -> obs)
 -> Index
 -> View container a
create view update get0 set0 model0 f idx  = 
  let
    (get, set) = 
      indexed get0 set0 model0 idx

    embeddedUpdate = 
      embedUpdate get set update

    embeddedView = 
      embedView get <| view (pack embeddedUpdate >> f) 
  in
    embeddedView




{-


{-| It is helpful to see parameter names: 

    create view update get set id lift model0 observers = 
      ...

Convert a regular Elm Architecture component (`view`, `update`) to a part, 
i.e., a component which knows how to access its model inside a generic
container model (`get`, `set`), and which dispatches generic `Msg` updates,
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
  -> (Msg container obs -> obs)
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
  -> (Msg container obs -> obs)
  -> View container obs a

create1 view update get set model0 lift = 
  embed view update (get >> Maybe.withDefault model0) (Just >> set)
    |> create' lift 

-}

-- HELPERS


map1st : (a -> c) -> (a,b) -> (c,b)
map1st f (x,y) = (f x, y)


map2nd : (b -> c) -> (a,b) -> (a,c)
map2nd f (x,y) = (x, f y)


