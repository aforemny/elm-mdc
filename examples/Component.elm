import StartApp
import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Effects exposing (Effects, Never)
import Task exposing (Task)

import Material
import Material.Scheme
import Material.Button as Button


-- MODEL


type alias Model = 
  { count : Int
  , mdl : Material.Model Action
      -- Boilerplate: Model store for any and all MDL components you need. 
  }



model : Model 
model = 
  { count = 0
  , mdl = Material.model 
      -- Always use this initial MDL component model store.
  }


-- ACTION, UPDATE


type Action
  = Increase
  | Reset
  | MDL (Material.Action Action)   
      -- Boilerplate: Action for MDL actions (ripple animations etc.).
      -- It should always look like this. 


update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case Debug.log "" action of
    Increase -> 
      ( { model | count = model.count + 1 } 
      , Effects.none
      )

    Reset -> 
      ( { model | count = 0 }
      , Effects.none
      )

    {- Boilerplate: MDL action handler. It should always look like this, except
       you can of course choose to put its saved model someplace other than 
       model.mdl.
    -}
    MDL action' -> 
      let (mdl', fx) = 
        Material.update MDL action' model.mdl 
      in 
        ( { model | mdl = mdl' } , fx )


-- VIEW


type alias Mdl = Material.Model Action

{- We construct the instances of the Button component that we need, one 
for the increase button, one for the reset button. First, the increase
button. The arguments are: 

  - An instance id (the `0`). Every component that uses the same model collection
    (model.mdl in this file) must have a distinct instance id. 
  - An Action creator (`MDL`), lifting MDL actions to your Action type. 
  - A button view (`flat`). 
  - An initial model (`(Button.model True)`---a button with a ripple animation. 
  - A list of observations you want to make of the button (final argument). 
    In this case, we hook up Click events of the button to the `Increase` action
    defined above. 
-}
increase : Button.Instance Mdl Action
increase =
  Button.instance 0 MDL 
    Button.flat (Button.model True) 
    [ Button.fwdClick Increase ]


{- Next, the reset button. This one has id 1, does not ripple, and forwards its
click event to our Reset action.
-}
reset : Button.Instance Mdl Action
reset = 
  Button.instance 1 MDL 
    Button.flat (Button.model False)
    [ Button.fwdClick Reset ]


{- Notice that we did not have to add increase and reset separately to model.mdl, 
and we did not have to add to our update actions to handle their internal events.
-}


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
    , increase.view addr model.mdl [] [ text "Increase" ]
    , reset.view    addr model.mdl [] [ text "Reset" ]
    -- Note that we use the .view function of our component instances to
    -- actually render the component. 
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
