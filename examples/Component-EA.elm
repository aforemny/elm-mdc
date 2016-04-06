import StartApp
import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Effects exposing (Effects, Never)
import Task exposing (Task)

import Material.Button as Button
import Material.Scheme


-- MODEL


type alias Model = 
  { count : Int
  , increaseButtonModel : Button.Model
  , resetButtonModel : Button.Model
  }


model : Model 
model = 
  { count = 0
  , increaseButtonModel = Button.model True -- With ripple animation
  , resetButtonModel = Button.model False   -- Without ripple animation
  }


-- ACTION, UPDATE


type Action
  = IncreaseButtonAction Button.Action
  | ResetButtonAction Button.Action


increase : Model -> Model
increase model = 
  { model | count = model.count + 1 }


reset : Model -> Model 
reset model = 
   { model | count = 0 }


update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case Debug.log "" action of
    IncreaseButtonAction action' -> 
      let 
        (submodel, fx) =
          Button.update action' model.increaseButtonModel
        model' = 
          case action' of 
            Button.Click -> 
              increase model
            _ -> 
              model
      in 
        ( { model' | increaseButtonModel = submodel }
        , Effects.map IncreaseButtonAction fx
        )

    ResetButtonAction action' -> 
      let 
        (submodel, fx) =
          Button.update action' model.resetButtonModel 
        model' = 
          case action' of 
            Button.Click -> 
              reset model
            _ -> 
              model
      in 
        ( { model' | resetButtonModel = submodel }
        , Effects.map ResetButtonAction fx
        )


-- VIEW


view : Signal.Address Action -> Model -> Html
view addr model =
  div
    [ style
      [ ("margin", "auto")
      , ("padding-left", "5%")
      , ("padding-right", "5%")
      ]
    ]
    [ text ("Current count: " ++ toString model.count )
    , Button.flat 
        (Signal.forwardTo addr IncreaseButtonAction) 
        model.increaseButtonModel 
        [] 
        [ text "Increase" ]
    , Button.flat 
        (Signal.forwardTo addr ResetButtonAction)
        model.resetButtonModel 
        [] 
        [ text "Reset" ]
    ]
  |> Material.Scheme.top 
  

{- The remainder of this file is Elm/StartApp boilerplate.
-}


-- SETUP


init : (Model, Effects.Effects Action)
init = (model, Effects.none)


inputs : List (Signal.Signal Action)
inputs =
  [ 
  ]


app : StartApp.App Model
app =
    StartApp.start
      { init = init
      , view = view
      , update = update
      , inputs = inputs
      }


main : Signal Html
main =
    app.html


-- PORTS


port tasks : Signal (Task Never ())
port tasks =
    app.tasks
