module Material.Template exposing
  ( Model, model
  , Msg, update
  , view
  , instance, fwdTemplate
  , Container, Observer, Instance
  )

-- TEMPLATE. Copy this to a file for your component, then update.

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#TEMPLATE-section):

> ...

See also the
[Material Design Specification]([https://www.google.com/design/spec/components/TEMPLATE.html).

Refer to [this site](http://debois.github.io/elm-mdl#/template)
for a live demo.

@docs Model, model, Msg, update
@docs view

# Component support

@docs Container, Observer, Instance, instance, fwdTemplate
-}


import Platform.Cmd exposing (Cmd, none)
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
type Msg
  = MyMsg


{-| Component update.
-}
update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  (model, none)


-- VIEW


{-| Component view.
-}
view : Signal.Address Msg -> Model -> List Style -> Html
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
  Component.Observer Msg obs


{-|
-}
type alias Instance container obs =
  Component.Instance 
    Model container Msg obs (List Style -> Html)


{-| Create a component instance. Example usage, assuming you have a type
`Msg` with a constructor ...
-}
instance : 
  Int
  -> (Component.Msg (Container c) obs -> obs)
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
    MyMsg -> Just obs


