module Demo.Toggles exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Array

import Material.Toggles as Toggles
import Material 


import Demo.Page as Page


-- MODEL


type alias Mdl = 
  Material.Model 


type alias Model =
  { mdl : Material.Model
  , toggles : Array.Array Bool
  , radios : Int
  }


model : Model
model =
  { mdl = Material.model
  , toggles = Array.fromList [ True, False ] 
  , radios = 2
  }


-- ACTION, UPDATE


type Msg 
  = MDL Material.Msg 
  | Switch Int
  | Radio Int


get : Int -> Model -> Bool
get k model = 
  Array.get k model.toggles |> Maybe.withDefault False


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Switch k -> 
      ( { model 
        | toggles = Array.set k (get k model |> not) model.toggles
        } 
      , none
      )

    Radio k -> 
      ( { model | radios = k }, none )

    MDL action' -> 
      Material.update MDL action' model



-- VIEW


view : Model -> Html Msg
view model =
  [ div 
      [] 
      [ Toggles.switch MDL [0] model.mdl 
          [ Toggles.onChange (Switch 0) 
          , Toggles.value (get 0 model)
          ]
      , Toggles.checkbox MDL [1] model.mdl 
          [ Toggles.onChange (Switch 1) 
          , Toggles.value (get 1 model)
          ]
      , Toggles.radio MDL [2] model.mdl 
          [ Toggles.value (2 == model.radios) 
          , Toggles.name "MyRadioGroup"
          , Toggles.onChange (Radio 2)
          ]
          [ text "Foo" ]
      , Toggles.radio MDL [3] model.mdl
          [ Toggles.value (3 == model.radios)
          , Toggles.name "MyRadioGroup"
          , Toggles.onChange (Radio 3)
          ]
          [ text "Bar" ]
      ] 
  ]
  |> Page.body2 "Toggles" srcUrl intro references


intro : Html Msg
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


