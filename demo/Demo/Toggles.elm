module Demo.Toggles where

import Effects exposing (Effects, none)
import Html exposing (..)

import Material.Toggles as Toggles
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
  = MDL (Material.Action Action)


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    MDL action' -> 
      Material.update MDL action' model.mdl
        |> map1st (\m -> { model | mdl = m })


-- VIEW


switch : Toggles.Switch Mdl Action
switch = 
  Toggles.instance 0 MDL 
    Toggles.switch Toggles.model 
    [ ]

checkbox : Toggles.Checkbox Mdl Action
checkbox = 
  Toggles.instance 1 MDL 
    Toggles.checkbox Toggles.model 
    [ ]

radio1 : Toggles.Radio Mdl Action 
radio1 = 
  Toggles.instance 2 MDL
    Toggles.radio Toggles.model
    [ ]


radio2 : Toggles.Radio Mdl Action 
radio2 = 
  Toggles.instance 3 MDL
    Toggles.radio Toggles.model
    [ ]


view : Signal.Address Action -> Model -> Html
view addr model =
  [ div 
      [] 
      [ switch.view addr model.mdl []
      , checkbox.view addr model.mdl [] 
      , radio1.view addr model.mdl [] ("1", "g1") [ text "Option 1" ]
      , radio2.view addr model.mdl [] ("2", "g2") [ text "Option 2" ]
      ]
  ]
  |> Page.body2 "Toggles" srcUrl intro references


intro : Html
intro = 
  Page.fromMDL "http://www.getmdl.io/index.html#toggles-section/checkbox" """
> The Material Design Lite (MDL) checkbox component is an enhanced version of the
> standard HTML `<input type="checkbox">` element. A checkbox consists of a small
> square and, typically, text that clearly communicates a binary condition that
> will be set or unset when the user clicks or touches it. Checkboxes typically,
> but not necessarily, appear in groups, and can be selected and deselected
> individually. The MDL checkbox component allows you to add display and click
>     effects.
> 
> Checkboxes are a common feature of most user interfaces, regardless of a site's
> content or function. Their design and use is therefore an important factor in
> the overall user experience. [...]
> 
> The enhanced checkbox component has a more vivid visual look than a standard
> checkbox, and may be initially or programmatically disabled.
""" 


srcUrl : String 
srcUrl =
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Toggles.elm"


references : List (String, String)
references = 
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Toggles"
  , Page.mds "https://www.google.com/design/spec/components/selection-controls.html"
  , Page.mdl "http://www.getmdl.io/index.html#toggles-section/checkbox"
  ]


