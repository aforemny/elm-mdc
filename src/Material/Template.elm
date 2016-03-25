module Material.Template
  ( Model, model
  , Action, update
  , view
  ) where

-- TEMPLATE. Copy this to a file for your component, then update.

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#TEMPLATE-section):

> ...

See also the
[Material Design Specification]([https://www.google.com/design/spec/components/TEMPLATE.html).

# Component
@docs Model, model, Action, update

# View
@docs view

-}


import Effects exposing (Effects, none)
import Html exposing (..)


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
view : Signal.Address Action -> Model -> Html
view addr model =
  div [] [ h1 [] [ text "TEMPLATE" ] ]
