module Demo.Lists exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)

import Material.Lists as Lists
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
  = ListsMsg 
  | Mdl Material.Msg 


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    ListsMsg -> 
      (model, Cmd.none)

    Mdl action' -> 
      Material.update Mdl action' model


-- VIEW


view : Model -> Html Msg
view model  =
  [ div 
      [] 
      [ Lists.ul [] []
      ]
  ]
  |> Page.body2 "Lists" srcUrl intro references


intro : Html m
intro = 
  Page.fromMDL "https://www.getmdl.io/components/index.html#Lists-section" """
> ...
""" 


srcUrl : String 
srcUrl =
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Lists.elm"


references : List (String, String)
references = 
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Lists"
  , Page.mds "https://www.google.com/design/spec/components/Lists.html"
  , Page.mdl "https://www.getmdl.io/components/index.html#Lists"
  ]


