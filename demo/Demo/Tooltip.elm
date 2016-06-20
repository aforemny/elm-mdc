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
import Material.Button as Button

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
               [ div [ class "icon material-icons"
                     , Tooltip.onMouseEnter Mdl [0]
                     , Tooltip.onMouseLeave Mdl [0]
                     ] [text "add"]

               , Tooltip.render Mdl [0] model.mdl
                   []
                   [div [] [text "Default tooltip"]]
               ]
            , """
               Default tooltip positioned below
               """
            )

          , demoTooltip
            (div []
               [ p [style [("margin-bottom", "5px")]]
                   [ text "HTML is related to but different from "
                   , span
                       [ Tooltip.onMouseEnter Mdl [1]
                       , Tooltip.onMouseLeave Mdl [1]
                       ]
                       [i [] [text "XML"]]
                   ]
               , Tooltip.render Mdl [1] model.mdl
                   [Tooltip.left]
                   [div [] [text "XML is an acronym for eXtensible Markup Language"]]
               ]
            , """
               Hover over `XML` to see a tooltip
               on the left
               """
            )

          , demoTooltip
            (div []
               [ div [class "icon material-icons"
                     , Tooltip.onMouseEnter Mdl [2]
                     , Tooltip.onMouseLeave Mdl [2]
                     ] [text "share"]

               , Tooltip.render Mdl [2] model.mdl
                   [ Tooltip.large
                   , Tooltip.right]
                   [div [] [text "Large tooltip"]]
               ]
            , """
               A large tooltip positioned on the right
               """
            )

          , demoTooltip
            (div []
               [
                Button.render Mdl [0] model.mdl
                  [ Button.raised
                  , Tooltip.attr <| Tooltip.onMouseEnter Mdl [3]
                  , Tooltip.attr <| Tooltip.onMouseLeave Mdl [3]
                  ]
                  [ text "BUTTON"]

               , Tooltip.render Mdl [3] model.mdl
                   [ Tooltip.top
                   , Tooltip.large]
                   [div [] [text "Tooltips also work with material components"]]
               ]
            , """
               A large tooltip positioned
               above the button
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
