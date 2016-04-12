module Material.Template
  ( Model, model
  , Action, update
  , view
  , instance, fwdTemplate
  , Container, Observer, Instance
  ) where

-- TEMPLATE. Copy this to a file for your component, then update.

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#TEMPLATE-section):

> ...

See also the
[Material Design Specification]([https://www.google.com/design/spec/components/TEMPLATE.html).

Refer to [this site](http://debois.github.io/elm-mdl#/template)
for a live demo.

@docs Model, model, Action, update
@docs view

# Component support

@docs Container, Observer, Instance, instance, fwdTemplate
-}


import Effects exposing (Effects, none)
import Html exposing (..)

import Material.Component as Component exposing (Indexed)
import Material.Style as Style exposing (Style, cs, css')


-- MODEL


{-| Component model.
-}
type alias Model =
  {
  }


{-| Default component model constructor.
-}
model : Model
model =
  {
  }


-- ACTION, UPDATE


{-| Component action.
-}
type Action
  = MyAction


{-| Component update.
-}
update : Action -> Model -> (Model, Effects Action)
update action model =
  (model, none)


-- VIEW


{-| Component view.
-}
view : Signal.Address Action -> Model -> List Style -> Html
view addr model styles =
  Style.div 
    ( cs "TEMPLATE"
    :: styles
    ) 
    [ h1 [] [ text "TEMPLATE" ] ]


-- COMPONENT


{-|
-}
type alias Container c =
  { c | template : Indexed Model }


{-|
-}
type alias Observer obs = 
  Component.Observer Action obs


{-|
-}
type alias Instance container obs =
  Component.Instance 
    Model container Action obs (List Style -> Html)


{-| Create a component instance. Example usage, assuming you have a type
`Action` with a constructor ...
-}
instance : 
  Int
  -> (Component.Action (Container c) obs -> obs)
  -> Model
  -> List (Observer obs)
  -> Instance (Container c) obs

instance id lift model0 observers = 
  Component.instance 
    view update .template (\x y -> {y | template = x}) id lift model0 observers


{-| 
-}
fwdTemplate : obs -> (Observer obs)
fwdTemplate obs action = 
  case action of 
    MyAction -> Just obs


