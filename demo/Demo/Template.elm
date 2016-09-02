module Demo.Template exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)

import Material.Template as Template
import Material 

import Demo.Page as Page


-- MODEL


type alias Model =
  { mdl : Material.Model
  }


model : Model
model =
  { mdl = Material.model
  }


-- ACTION, UPDATE


type Msg 
  = TemplateMsg 
  | Mdl Material.Msg 


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    TemplateMsg -> 
      (model, Cmd.none)

    Mdl action' -> 
      Material.update Mdl action' model


-- VIEW


view : Model -> Html Msg
view model  =
  [ div 
      [] 
      [ Template.render Mdl [0] model.mdl [] []
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


