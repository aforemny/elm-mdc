module Demo.Slider exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.Attributes as Html

import Material.Slider as Slider
import Material

import Demo.Page as Page
import Dict exposing (Dict)


-- MODEL


type alias Mdl =
  Material.Model


type alias Model =
  { mdl : Material.Model
  , value : Float
  , values : Dict Int Float
  }


model : Model
model =
  { mdl = Material.model
  , value = 0
  , values = Dict.empty
  }


-- ACTION, UPDATE

type Msg
  = Slider Int Float
  | Mdl Material.Msg


get : Int -> Dict Int Float -> Float
get key dict =
  Dict.get key dict |> Maybe.withDefault 0


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of

    Slider idx value ->
      let
        values = Dict.insert idx value model.values
      in
        ({ model | values = values }, Cmd.none)

    Mdl action' ->
      Material.update Mdl action' model


-- VIEW


view : Model -> Html Msg
view model  =
  [ Html.p
      [ Html.style [("width", "300px")]]
      [ Slider.render Mdl [0] model.mdl
          [ Slider.onChange (Slider 0)
          , Slider.value (get 0 model.values)
          ]
          []
      ]
  , Html.p
      [ Html.style [("width", "300px")]]
      [ Slider.render Mdl [1] model.mdl
          [ Slider.onChange (Slider 1)
          , Slider.value (get 1 model.values)
          ]
          []
      ]
  ]
  |> Page.body2 "Sliders" srcUrl intro references


intro : Html m
intro =
  Page.fromMDL "https://www.getmdl.io/components/index.html#TEMPLATE-section" """
> ...
"""


srcUrl : String
srcUrl =
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/TEMPLATE.elm"


references : List (String, String)
references =
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-TEMPLATE"
  , Page.mds "https://www.google.com/design/spec/components/TEMPLATE.html"
  , Page.mdl "https://www.getmdl.io/components/index.html#TEMPLATE"
  ]
