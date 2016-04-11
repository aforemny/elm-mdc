module Demo.Template where

import Effects exposing (Effects, none)
import Html exposing (..)

import Markdown

import Material.Template as Template
import Material exposing (lift, lift')


-- MODEL


type alias Model =
  { template : Template.Model
  }


model : Model
model =
  { template = Template.model
  }


-- ACTION, UPDATE


type Action 
  = TemplateAction Template.Action


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    TemplateAction action' -> lift .template (\m x -> {m|template=x}) TemplateAction Template.update action' model


-- VIEW



view : Signal.Address Action -> Model -> Html
view addr model =
  div []
    [ intro
    , Template.view (Signal.forwardTo addr TemplateAction) model.template
    ]



intro : Html
intro = """
# TEMPLATE

From the
[Material Design Lite documentation](https://www.getmdl.io/components/index.html#TEMPLATE-section).

> ...

#### See also

 - [Demo source code](https://github.com/debois/elm-mdl/blob/master/examples/Demo/TEMPLATE.elm)
 - [elm-mdl package documentation](http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-TEMPLATE)
 - [Material Design Specification](https://www.google.com/design/spec/components/TEMPLATE.html)
 - [Material Design Lite documentation](https://www.getmdl.io/components/index.html#TEMPLATE)

#### Demo

""" |> Markdown.toHtml



