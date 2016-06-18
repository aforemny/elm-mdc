module Demo.Tooltip exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.Attributes as Html exposing (..)
import Html.Events as Html exposing (..)

import Material.Tooltip as Tooltip
import Material

import Demo.Page as Page


-- MODEL


type alias Mdl =
  Material.Model


type alias Model =
  { mdl : Material.Model
  }


model : Model
model =
  { mdl = Material.model
  }


-- ACTION, UPDATE


type Msg
  = TooltipMsg
  | Mdl Material.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    TooltipMsg ->
      (Debug.log "TOLTIP" model, Cmd.none)

    Mdl action' ->
      Material.update Mdl action' model


-- VIEW


view : Model -> Html Msg
view model  =
  [ div
      []
      [ div [] []
      --, div [id "tt1", class "icon material-icons"] [text "add"]
      -- , Tooltip.test []
      , Tooltip.render Mdl [0] model.mdl
           []
           (Tooltip.wrap div [class "icon material-icons"] [text "add"])
      , p [] [text "Simple tooltip"]

      , Tooltip.render Mdl [1] model.mdl
           []
           (Tooltip.wrap div [class "icon material-icons"] [text "print"])


      -- , Tooltip.render Mdl [0] model.mdl
      --      [Tooltip.for "tt1"]
      --      []
      ]
  ]
  |> Page.body2 "TEMPLATE" srcUrl intro references


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
