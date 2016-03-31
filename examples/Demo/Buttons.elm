module Demo.Buttons where

import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Effects

import Material.Button as Button exposing (..)
import Material.Grid as Grid
import Material.Icon as Icon
import Material.Style exposing (Style)

import Material.Textfield as Textfield
import Material.Component as Component 
import Material.Component.All as Setup


-- MODEL


type alias Index = (Int, Int)


type alias View =
  Signal.Address Button.Action -> Button.Model -> List Style -> List Html -> Html


type alias View' =
  Signal.Address Button.Action -> Button.Model -> Html


view' : View -> List Style -> Html -> Signal.Address Button.Action -> Button.Model -> Html
view' view coloring elem addr model =
  view addr model coloring [elem]


describe : String -> Bool -> String -> String
describe kind ripple c =
    kind ++ ", " ++ c ++ if ripple then " w/ripple" else ""


row : (String, Html, View) -> Bool -> List (Int, (Bool, String, View'))
row (kind, elem, v) ripple =
  [ ("plain", [])
  , ("colored", [Button.colored])
  , ("primary", [Button.primary])
  , ("accent", [Button.accent]) 
  ]
  |> List.map (\(d,c) -> (ripple, describe kind ripple d, view' v c elem))
  |> List.indexedMap (,)


buttons : List (List (Index, (Bool, String, View')))
buttons =
  [ ("flat", text "Flat Button", Button.flat)
  , ("raised", text "Raised Button", Button.raised)
  , ("FAB", Icon.i "add", Button.fab)
  , ("mini-FAB", Icon.i "zoom_in", Button.minifab)
  , ("icon", Icon.i "flight_land", Button.icon)
  ]
  |> List.concatMap (\a -> [row a False, row a True])
  |> List.indexedMap (\i r -> List.map (\(j, x) -> ((i,j), x)) r)


model : Model
model =
  { clicked = ""
  , buttons =
      buttons
      |> List.concatMap (List.map <| \(idx, (ripple, _, _)) -> (idx, Button.model ripple))
      |> Dict.fromList
  , componentState = Setup.state
  }


-- ACTION, UPDATE


type Action 
  = Action Index Button.Action
  | State (Setup.Action Action)
  | Click 
  | Input String


type alias Model =
  { clicked : String
  , buttons : Dict.Dict Index Button.Model
  , componentState : Setup.State
  }


update : Action -> Model -> (Model, Effects.Effects Action)
update action model = 
  case action of 
    Action idx action -> 
      Dict.get idx model.buttons
      |> Maybe.map (\m0 ->
        let
          (m1, e) = Button.update action m0
        in
          ({ model | buttons = Dict.insert idx  m1 model.buttons }, Effects.map (Action idx) e)
      )
      |> Maybe.withDefault (model, Effects.none)

    State action' -> 
      Component.update State update action' model

    Click -> 
      ( tf.map (\m -> { m | value = "You clicked!" }) model, Effects.none ) 

    Input str -> 
      ( tf.map (\m -> { m | value = "You wrote '" ++ str ++ "' in the other guy."}) model 
      , Effects.none
      )


instance = Component.instance State
instance' = Component.instance' State


tf = instance <| Textfield.component Textfield.model 4



-- VIEW



view : Signal.Address Action -> Model -> Html
view addr model =
  buttons |> List.concatMap (\row ->
    row |> List.concatMap (\(idx, (ripple, description, view)) ->
      let model' =
        Dict.get idx model.buttons |> Maybe.withDefault (Button.model False)
      in
        [ Grid.cell
          [ Grid.size Grid.All 3]
          [ div
              [ style
                [ ("text-align", "center")
                , ("margin-top", "1em")
                , ("margin-bottom", "1em")
                ]
              ]
              [ view
                  (Signal.forwardTo addr (Action idx))
                  model'
              , div
                  [ style
                    [ ("font-size", "9pt")
                    , ("margin-top", "1em")
                    ]
                  ]
                  [ text description
                  ]
              ]
          ]
        ]
    )
  )
  |> (\contents -> 
    div []
      [ instance' (Button.component Button.flat (Button.model True) 1 |> onClick Click) addr model [] [ text "Click me (1)" ]
      , instance' (Button.component Button.raised (Button.model False) 2) addr model [] [ text "Click me (2)" ]
      , instance' (Textfield.component Textfield.model 3 |> Textfield.onInput Input) addr model
      , tf.view addr model
      , Grid.grid [] contents
      ]
      )

--i = instance' State (buttonWidget (Button.model True) 1) -- addr model.componentState [] [ text "Click me (1)" ]
