module Demo.Template where

import Effects exposing (Effects, none)
import Html exposing (..)

import Material.Template as Template
import Material.Helpers exposing (map1st)
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


type Action 
  = TemplateAction 
  | MDL (Material.Action Action)


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    TemplateAction -> 
      (model, Effects.none)

    MDL action' -> 
      Material.update MDL action' model.mdl
        |> map1st (\m -> { model | mdl = m })


-- VIEW


template = 
  Template.instance 0 MDL Template.model 
    [ Template.fwdTemplate TemplateAction ]


view : Signal.Address Action -> Model -> Html
view addr model =
  [ div 
      [] 
      [ template.view addr model.mdl []
      ]
  ]
  |> Page.body2 "TEMPLATE" srcUrl intro references


intro : Html
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


