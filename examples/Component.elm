import Html.App as App
import Html exposing (..)
import Html.Attributes exposing (href, class, style)

import Material
import Material.Scheme
import Material.Button as Button
import Material.Options exposing (css)


-- MODEL


type alias Model = 
  { count : Int
  , mdl : Material.Model 
      -- Boilerplate: mdl is the Model store for any and all MDL components you need. 
  }


model : Model 
model = 
  { count = 0
  , mdl = Material.model 
      -- Boilerplate: Always use this initial MDL model store.
  }


-- ACTION, UPDATE


type Msg
  = Increase
  | Reset
  | MDL Material.Msg 
      -- Boilerplate: Msg for MDL actions (ripple animations etc.).


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Increase -> 
      ( { model | count = model.count + 1 } 
      , Cmd.none
      )

    Reset -> 
      ( { model | count = 0 }
      , Cmd.none
      )

    {- Boilerplate: MDL action handler. It should always look like this.
    -}
    MDL action' -> 
      Material.update MDL action' model


-- VIEW


type alias Mdl = 
  Material.Model 


view : Model -> Html Msg
view model =
  div 
    [ style [ ("padding", "2rem") ] ]
    [ text ("Current count: " ++ toString model.count )
    {- We construct the instances of the Button component that we need, one 
    for the increase button, one for the reset button. First, the increase
    button. The arguments are: 

      - An instance id (the `[0]`). Every component that uses the same model
        collection (model.mdl in this file) must have a distinct instance id.
      - A Msg constructor (`MDL`), lifting MDL actions to your Msg type.
      - An initial model (`(Button.model True)`---a button with a ripple animation. 

    Notice that we do not have to add increase and reset separately to model.mdl, 
    and we did not have to add to our update actions to handle their internal events.
    -}
    , Button.render MDL [0] model.mdl 
        [ Button.onClick Increase 
        , css "margin" "0 24px"
        ]
        [ text "Increase" ]
    , Button.render MDL [1] model.mdl 
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
