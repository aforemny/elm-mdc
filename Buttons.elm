module Buttons where

import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Effects

import Material.Button as Button exposing (Appearance(..), Coloring(..))
import Material.Grid as Grid
import Material.Icon as Icon


-- MODEL


type alias Index = (Int, Int)


tabulate' : Int -> List a -> List (Int, a)
tabulate' i ys =
  case ys of
    [] -> []
    y :: ys -> (i, y) :: tabulate' (i+1) ys


tabulate : List a -> List (Int, a)
tabulate = tabulate' 0


row : Appearance -> Bool -> List (Int, (Bool, Button.Config))
row appearance ripple =
  [ Plain, Colored, Primary, Accent ]
  |> List.map (\c -> (ripple, { coloring = c, appearance = appearance }))
  |> tabulate


buttons : List (List (Index, (Bool, Button.Config)))
buttons =
  [Flat, Raised, FAB, MiniFAB, Icon]
  |> List.concatMap (\a -> [row a False, row a True])
  |> tabulate
  |> List.map (\(i, row) -> List.map (\(j, x) -> ((i,j), x)) row)


model : Model
model =
  { clicked = ""
  , buttons =
      buttons
      |> List.concatMap (List.map <| \(idx, (ripple, _)) -> (idx, Button.model ripple))
      |> Dict.fromList
  }


-- ACTION, UPDATE


type Action = Action Index Button.Action


type alias Model =
  { clicked : String
  , buttons : Dict.Dict Index Button.Model
  }


update : Action -> Model -> (Model, Effects.Effects Action)
update (Action idx action) model =
  Dict.get idx model.buttons
  |> Maybe.map (\m0 ->
    let
      (m1, e) = Button.update action m0
    in
      ({ model | buttons = Dict.insert idx  m1 model.buttons }, Effects.map (Action idx) e)
  )
  |> Maybe.withDefault (model, Effects.none)


-- VIEW


describe : Bool -> Button.Config -> String
describe ripple config =
  let
    appearance =
      case config.appearance of
        Flat -> "flat"
        Raised -> "raised"
        FAB -> "FAB"
        MiniFAB -> "mini-FAB"
        Icon -> "icon"
    coloring =
      case config.coloring of
        Plain -> "plain"
        Colored -> "colored"
        Primary -> "primary"
        Accent -> "accent"
  in
    appearance ++ ", " ++ coloring ++ if ripple then " w/ripple" else ""



view : Signal.Address Action -> Model -> Html
view addr model =
  buttons |> List.concatMap (\row ->
    row |> List.map (\(idx, (ripple, config)) ->
      let model' =
        Dict.get idx model.buttons |> Maybe.withDefault (Button.model False)
      in
        Grid.cell
          [ Grid.col Grid.All 3]
          [ div
              [ style
                [ ("text-align", "center")
                , ("margin-top", "1em")
                , ("margin-bottom", "1em")
                ]
              ]
              [ Button.view
                  (Signal.forwardTo addr (Action idx))
                  config
                  model'
                  []
                  [ case config.appearance of
                      Flat -> text <| "Flat Button"
                      Raised -> text <| "Raised Button"
                      FAB -> Icon.i "add"
                      MiniFAB -> Icon.i "zoom_in"
                      Icon -> Icon.i "flight_land"
                  ]
              , div
                  [ style
                    [ ("font-size", "9pt")
                    , ("margin-top", "1em")
                    ]
                  ]
                  [ text <| describe ripple config ]
              ]
          ]
    )
  )
  |> Grid.grid 
