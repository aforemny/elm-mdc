{- This file shows how to use elm-mdl components as vanilla TEA components. You
are unlikely to want this; consider looking at Counter.elm instead. 
-}

import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Platform.Cmd exposing (Cmd)

import Material.Button as Button
import Material.Scheme
import Material.Options exposing (css)


-- MODEL


type alias Model = 
  { count : Int
  , increaseButtonModel : Button.Model
  , resetButtonModel : Button.Model
  }


model : Model 
model = 
  { count = 0
  , increaseButtonModel = Button.defaultModel 
  , resetButtonModel = Button.defaultModel 
  }


-- ACTION, UPDATE


type Msg
  = IncreaseButtonMsg Button.Msg
  | ResetButtonMsg Button.Msg
  | Increase
  | Reset


increase : Model -> Model
increase model = 
  { model | count = model.count + 1 }


reset : Model -> Model 
reset model = 
   { model | count = 0 }



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Increase -> 
       ( { model | count = model.count + 1 } 
       , Cmd.none
       )
 
    Reset -> 
       ( { model | count = 0 }
       , Cmd.none
       )
 
    IncreaseButtonMsg msg' -> 
      let 
        (submodel, fx) =
          Button.update msg' model.increaseButtonModel
      in 
        ( { model | increaseButtonModel = submodel }
        , Cmd.map IncreaseButtonMsg fx
        )

    ResetButtonMsg msg' -> 
      let 
        (submodel, fx) =
          Button.update msg' model.resetButtonModel 
      in 
        ( { model | resetButtonModel = submodel }
        , Cmd.map ResetButtonMsg fx
        )


-- VIEW


view : Model -> Html Msg
view model =
  div
    [ style [ ("padding", "2rem") ] ]
    [ text ("Current count: " ++ toString model.count )
    , Button.view IncreaseButtonMsg model.increaseButtonModel
        [ Button.onClick Increase 
        , css "margin" "0 24px"
        ]
        [ text "Increase" ]
    , Button.view ResetButtonMsg model.resetButtonModel 
        [ Button.onClick Reset ] 
        [ text "Reset" ]
    ]
  |> Material.Scheme.top 


main : Program Never
main =
  App.program 
    { init = ( model, Cmd.none ) 
    , view = view
    , subscriptions = always Sub.none 
    , update = update
    }
