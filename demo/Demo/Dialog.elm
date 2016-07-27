module Demo.Dialog exposing (model, update, view, Model, Msg)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.Attributes exposing (style)

import Material.Dialog as Card exposing (..)
import Material.Options exposing (css)
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


-- ACTION/UPDATE


type Msg
  = Mdl Material.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Mdl action' ->
      Material.update Mdl action' model


-- VIEW

view : Model -> Html Msg
view model =
  [ div [ style [ ("display", "flex") ] ]
      [ dialog
        [ css "margin" "5px"
        ]
        [ Dialog.title []
          [ text "Welcome" ]
        , Dialog.Content []
          [ text """
Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Mauris sagittis pellentesque lacus eleifend lacinia...
"""
          ]
        , Dialog.actions []
          [ Button.render Mdl [0] model.mdl
            [ Button.colored
            , Button.ripple
            ]
            [ text "Cool!" ]
          ]
        ]
      ]
  ]
  |> Page.body2 "Dialog" srcUrl intro references


intro : Html m
intro =
  Page.fromMDL "https://getmdl.io/components/#dialog-section" """
> The Material Design Lite (MDL) dialog component allows for verification of user
> actions, simple data input, and alerts to provide extra information to users.
>
> To use the dialog component, you must be using a browser that supports the
> dialog element. Only Chrome and Opera have native support at the time of
> writing. For other browsers you will need to include the dialog polyfill
> or create your own.
"""


srcUrl : String
srcUrl =
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Dialog.elm"


references : List (String, String)
references =
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Card"
  , Page.mds "https://material.google.com/components/dialog.html"
  , Page.mdl "https://getmdl.io/components/#dialog-section"
  ]
