module Demo.Footer exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)

import Material.Footer as Footer
import Material
import Material.Options as Options
import Material.Icon as Icon

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
  = FooterMsg
  | Mdl Material.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    FooterMsg ->
      (Debug.log "FOOTER" model, Cmd.none)

    Mdl action' ->
      Material.update Mdl action' model


-- VIEW


view : Model -> Html Msg
view model  =
  [ div
      []
      [
       Footer.mini [ Options.cs "demo-mini-footer" ]
         [ Footer.left []
             [ Footer.logo [ Options.cs "demo-mini-footer-logo" ]
                 [ text "Mini footer example" ]
             , Footer.links [ Options.cs "demo-mini-footer-links" ]
                 [ li []
                     [ Footer.link [Footer.href "#", Footer.onClick FooterMsg]
                         [text "Link 1"] ]
                 , li []
                     [ Footer.link [Footer.href "#", Footer.onClick FooterMsg]
                         [text "Link 2"] ]
                 ]
             ]
         , Footer.right []
             [Footer.logo [] [text "Mini footer example"]]
         ]
      ]
  ]
  |> Page.body2 "Footers" srcUrl intro references


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
