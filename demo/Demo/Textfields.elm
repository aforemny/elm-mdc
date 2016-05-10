module Demo.Textfields where

import Html exposing (Html)
import Effects exposing (Effects)
import Regex        

import Material.Textfield as Textfield
import Material.Grid as Grid exposing (..)
import Material.Options as Options
import Material

import Demo.Page as Page


-- MODEL


type alias Model = 
  { mdl : Material.Model 
  , str0 : String
  , str3 : String
  , str4 : String
  }


model : Model
model = 
  { mdl = Material.model 
  , str0 = ""
  , str3 = ""
  , str4 = ""
  }


-- ACTION, UPDATE


type Action
  = MDL (Material.Action Action)
  | Upd0 String 
  | Upd3 String
  | Upd4 String


update : Action -> Model -> (Model, Effects Action)
update action model = 
  case let _ = Debug.log "Model" model in  action of 
    MDL action' -> 
      Material.update MDL action' model 

    Upd0 str -> 
      ( { model | str0 = str }, Effects.none )

    Upd3 str -> 
      ( { model | str3 = str }, Effects.none )
  
    Upd4 str -> 
      ( { model | str4 = str }, Effects.none )


-- VIEW


type alias Mdl = 
  Material.Model 


rx : String
rx = 
  "[0-9]*"


rx' : Regex.Regex
rx' = 
  Regex.regex rx


{- Check that rx matches all of str.
-}
match : String -> Regex.Regex -> Bool
match str rx = 
  Regex.find Regex.All rx str
    |> List.any (.match >> (==) str)


view : Signal.Address Action -> Model -> Html
view addr model =
  [ Textfield.render MDL [0] addr model.mdl 
      [ Textfield.onInput (Signal.forwardTo addr Upd0) ]
  , Textfield.render MDL [1] addr model.mdl 
      [ Textfield.label "Labelled" ]
  , Textfield.render MDL [2] addr model.mdl 
      [ Textfield.label "Floating label"
      , Textfield.floatingLabel 
      ]
  , Textfield.render MDL [3] addr model.mdl 
      [ Textfield.label "Disabled"
      , Textfield.disabled 
      , Textfield.value <| 
          model.str0 
            ++ if model.str0 /= "" then " (still disabled, though)" else ""
      ]
  , Textfield.render MDL [4] addr model.mdl 
      [ Textfield.label "w/error checking" 
      , if not <| match model.str4 rx' then 
          Textfield.error <| "Doesn't match " ++ rx
        else
          Options.nop
      , Textfield.onInput (Signal.forwardTo addr Upd4)
      ]
  , Textfield.render MDL [5] addr model.mdl
      [ Textfield.label "Enter password"
      , Textfield.floatingLabel
      , Textfield.password
      ]
  ]
  |> List.map (\c -> 
      cell 
        [size All 4, offset Desktop 1]
        [c]
     )
  |> List.intersperse (cell [size All 1] [])
  |> grid []
  |> flip (::) [] 
  |> (::) (Html.text "Try entering text into some of the textfields below.")
  |> Page.body2 "Textfields" srcUrl intro references


intro : Html
intro = 
  Page.fromMDL "http://www.getmdl.io/components/#textfields-section" """
> The Material Design Lite (MDL) text field component is an enhanced version of
> the standard HTML `<input type="text">` and `<input type="textarea">` elements.
> A text field consists of a horizontal line indicating where keyboard input
> can occur and, typically, text that clearly communicates the intended
> contents of the text field. The MDL text field component provides various
> types of text fields, and allows you to add both display and click effects.
>
> Text fields are a common feature of most user interfaces, regardless of a
> site's content or function. Their design and use is therefore an important
> factor in the overall user experience. See the text field component's
> [Material  Design specifications page](https://www.google.com/design/spec/components/text-fields.html)
> for details.
>
> The enhanced text field component has a more vivid visual look than a standard
> text field, and may be initially or programmatically disabled. There are three
> main types of text fields in the text field component, each with its own basic
> coding requirements. The types are single-line, multi-line, and expandable.

This implementation provides only single-line.

"""

srcUrl : String
srcUrl = 
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Textfields.elm"


references : List (String, String)
references = 
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Textfield"
  , Page.mds "https://www.google.com/design/spec/components/text-fields.html" 
  , Page.mdl "https://www.getmdl.io/components/#textfields-section"
  ]



  
