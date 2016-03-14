module Demo.Textfields where

import Array exposing (Array)
import Html exposing (Html)

import Material.Textfield as Textfield
import Material.Grid as Grid exposing (..)


type alias Model = Array Textfield.Model


model : Model
model =
  let t0 = Textfield.model in
  [ t0
  , { t0 | label = Just { text = "Labelled", float = False } }
  , { t0 | label = Just { text = "Floating label", float = True }}
  , { t0
    | label = Just { text = "Disabled", float = False }
    , isDisabled = True
    }
  , { t0
    | label = Just { text = "With error and value", float = False }
    , error = Just "The input is wrong!"
    , value = "Incorrect input"
    }
  ]
  |> Array.fromList


type Action =
  Field Int Textfield.Action


update : Action -> Model -> Model
update (Field k action) fields =
  Array.get k fields
  |> Maybe.map (Textfield.update action)
  |> Maybe.map (\field' -> Array.set k field' fields)
  |> Maybe.withDefault fields


view : Signal.Address Action -> Model -> Html
view addr model =
  model
  |> Array.indexedMap (\k field ->
    Textfield.view (Signal.forwardTo addr (Field k)) field
  )
  |> Array.toList
  |> List.map (\x -> cell [size All 3] [x])
  |> grid
