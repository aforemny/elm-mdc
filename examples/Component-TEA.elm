import StartApp
import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Platform.Cmd exposing (Cmd, Never)
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


type Msg
  = IncreaseButtonMsg Button.Msg
  | ResetButtonMsg Button.Msg


increase : Model -> Model
increase model = 
  { model | count = model.count + 1 }


reset : Model -> Model 
reset model = 
   { model | count = 0 }



update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case Debug.log "" action of
    IncreaseButtonMsg action' -> 
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
        , Cmd.map IncreaseButtonMsg fx
        )

    ResetButtonMsg action' -> 
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
        , Cmd.map ResetButtonMsg fx
        )


-- VIEW


view : Signal.Address Msg -> Model -> Html
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
        (Signal.forwardTo addr IncreaseButtonMsg) 
        model.increaseButtonModel 
        [] 
        [ text "Increase" ]
    , Button.flat 
        (Signal.forwardTo addr ResetButtonMsg)
        model.resetButtonModel 
        [] 
        [ text "Reset" ]
    ]
  |> Material.Scheme.top 
  

{- The remainder of this file is Elm/StartApp boilerplate.
-}


-- SETUP


init : (Model, Cmd.Cmd Msg)
init = (model, Cmd.none)


inputs : List (Signal.Signal Msg)
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
