{- This file re-implements the Elm Counter example (1 counter) with elm-mdl
buttons. Use this as a starting point for using elm-mdl components in your own
app. 
-}

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
      -- Boilerplate: model store for any and all MDL components you use. 
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
      -- Boilerplate: Msg clause for internal MDL messages.


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

    -- Boilerplate: MDL action handler. 
    MDL msg' -> 
      Material.update MDL msg' model


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
    button. The first three arguments are: 

      - A Msg constructor (`MDL`), lifting MDL messages to the Msg type.
      - An instance id (the `[0]`). Every component that uses the same model
        collection (model.mdl in this file) must have a distinct instance id.
      - A reference to the elm-mdl model collection (`model.mdl`). 

    Notice that we do not have to add fields for the increase and reset buttons
    separately to our model; and we did not have to add to our update messages
    to handle their internal events.

    MDL components are configured with `Options`, similar to `Html.Attributes`.
    The `Button.onClick Increase` option instructs the button to send the `Increase`
    message when clicked. The `css ...` option adds CSS styling to the button. 
    See `Material.Options` for details on options. 
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
      -- Load Google MDL CSS. You'll likely want to do that not in code as we
      -- do here, but rather in your master .html file. See the documentation
      -- for the `Material` module for details.
  

main : Program Never
main =
  App.program 
    { init = ( model, Cmd.none ) 
    , view = view
    , subscriptions = always Sub.none 
    , update = update
    }
