module Demo.Tooltip exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.Attributes as Html exposing (..)
import Html.Events as Html exposing (..)

import Material.Tooltip as Tooltip
import Material
import Material.Options as Options exposing(cs, css, when)

import Demo.Page as Page

import Material.Grid as Grid
import Demo.Code as Code
import Markdown

-- import Html.Attributes
-- import Html.App
import Json.Decode as Json exposing ((:=), at)

import Dict
import Parts

-- MODEL


-- type alias MdlAA =
--   Material.Model


type alias Model =
  { mdl : Material.Model
  }


model : Model
model =
  { mdl = Material.model
  }


-- ACTION, UPDATE


type Msg
  = NoOp
  | Mdl Material.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    NoOp ->
        (model, Cmd.none)

    Mdl action' ->
      Material.update Mdl action' model


code : String -> Html a
code str =
  div
    [ style [("overflow", "hidden")] ]
    [ Markdown.toHtml [] <| "```elm\n" ++ Code.trim str ++ "\n```" ]

-- VIEW


demoTooltip : (Html a, String) -> Grid.Cell a
demoTooltip (tooltip, description) =
  Grid.cell
    [Grid.size Grid.All 4]
    [ div [style [("text-align", "center")]]
        [tooltip]
    , code description
    ]

view : Model -> Html Msg
view model  =
  [ div
      []
      [ Html.p [] [text "Example use:"]
      , Grid.grid []
          [Grid.cell [Grid.size Grid.All 12]
             [code """
                    import Material.Tooltip as Tooltip
                    """]
          ]


      , Grid.grid []
          [ demoTooltip
            (div []
               [ p [style [("margin-bottom", "5px")]]
                   [ text "HTML is related to but different from "
                   , span
                       [ Tooltip.onMouseEnter Mdl [16]
                       , Tooltip.onMouseLeave Mdl [16]
                       ]
                       [i [] [text "XML"]]
                   ]
               , Tooltip.render Mdl [16] model.mdl
                   []
                   [div [] [text "BAANANA"]]
               ]
            , """
               experiment
               """
            )

          ]
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
