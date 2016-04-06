module Demo.Elevation where

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


{-| From the [Material Design Lite documentation](https://github.com/google/material-design-lite/blob/master/src/shadow/README.md)

> The Material Design Lite (MDL) shadow is not a component in the same sense as
> an MDL card, menu, or textbox; it is a visual effect that can be assigned to a
> user interface element. The effect simulates a three-dimensional positioning of
> the element, as though it is slightly raised above the surface it rests upon —
> a positive z-axis value, in user interface terms. The shadow starts at the
> edges of the element and gradually fades outward, providing a realistic 3-D
> effect.
> 
> Shadows are a convenient and intuitive means of distinguishing an element from
> its surroundings. A shadow can draw the user's eye to an object and emphasize
> the object's importance, uniqueness, or immediacy.
> 
> Shadows are a well-established feature in user interfaces, and provide users
> with a visual clue to an object's intended use or value. Their design and use
> is an important factor in the overall user experience.)

The [Material Design Specification](https://www.google.com/design/spec/what-is-material/elevation-shadows.html#elevation-shadows-elevation-android-)
pre-defines appropriate elevation for most UI elements; you need to manually
assign shadows only to your own elements. 

You are encouraged to visit the
[Material Design specification](https://www.google.com/design/spec/what-is-material/elevation-shadows.html)
for details about appropriate use of shadows. 

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



