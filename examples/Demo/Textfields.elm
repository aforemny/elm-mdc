module Demo.Textfields where

import Html exposing (Html)
import Effects exposing (Effects)
import Regex        

import Material.Textfield as Textfield
import Material.Grid as Grid exposing (..)
import Material.Helpers exposing (map1st)
import Material

import Demo.Page as Page


-- MODEL



type alias Model = 
  { mdl : Material.Model Action 
  , rx : (String, Regex.Regex)
  }


rx0 : String
rx0 = 
  "[0-9]*"


setRegex : String -> (String, Regex.Regex)
setRegex str = 
  (str, Regex.regex str)


model : Model
model = 
  { mdl = Material.model 
  , rx = setRegex rx0
  }



-- ACTION, UPDATE



type Action
  = MDL (Material.Action Action)
  | Upd0 String 
  | Upd4 String


transferToDisabled : String -> Mdl -> Mdl 
transferToDisabled str = 
  field3.map (\m -> 
    { m 
    | value = 
        if str == "" then
          "" 
        else 
          "\"" ++ str ++ "\" (still disabled, though)" 
    }) 


match : String -> Regex.Regex -> Bool
match str rx = 
  Regex.find Regex.All rx str
    |> List.any (.match >> (==) str)


checkRegex : String -> (String, Regex.Regex) -> Mdl -> Mdl 
checkRegex str (rx', rx) mdl =
  let
    value4 = field4.get mdl |> .value
  in
    mdl |> field4.map (\m -> { m | error = 
      if match value4 rx then 
        Nothing
      else
        "Doesn't match regex ' " ++ rx' ++ "'" |> Just
      })



update : Action -> Model -> (Model, Effects Action)
update action model = 
  case action of 
    MDL action' -> 
      Material.update MDL action' model.mdl 
        |> map1st (\mdl' -> { model | mdl = mdl' })

    Upd0 str -> 
      ( { model | mdl = transferToDisabled str model.mdl }
      , Effects.none
      )

    Upd4 str -> 
      ( { model | mdl = checkRegex str model.rx model.mdl }
      , Effects.none
      )


-- VIEW


m0 : Textfield.Model
m0 = 
  Textfield.model


type alias Mdl = 
  Material.Model Action


field0 : Textfield.Instance Mdl Action
field0 = 
  Textfield.instance 0 MDL m0 
    [ Textfield.fwdInput Upd0
    ]


field1 : Textfield.Instance Mdl Action
field1 = 
  Textfield.instance 1 MDL 
    { m0 | label = Just { text = "Labelled", float = False } }
    []


field2 : Textfield.Instance Mdl Action
field2 = 
  Textfield.instance 2 MDL 
    { m0 
    | label = Just { text = "Floating label", float = True }
    }
    []


field3 : Textfield.Instance Mdl Action
field3 = 
  Textfield.instance 3 MDL 
    { m0
    | label = Just { text = "Disabled", float = False }
    , isDisabled = True
    }
    []


field4 : Textfield.Instance Mdl Action
field4 = 
  Textfield.instance 4 MDL 
    { m0
    | label = Just { text = "With error checking", float = False }
    }
    [ Textfield.fwdInput Upd4 ]


view : Signal.Address Action -> Model -> Html
view addr model =
  [ field0
  , field1
  , field2
  , field3
  , field4
  ]
  |> List.map (\c -> 
      cell 
        [size All 4, offset Desktop 1]
        [c.view addr model.mdl]
     )
  |> List.intersperse (cell [size All 1] [])
  |> grid []
  |> flip (::) []
  |> Page.body "Textfields" srcUrl intro references


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
  "https://github.com/debois/elm-mdl/blob/master/examples/Demo/Textfields.elm"


references : List (String, String)
references = 
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Textfield"
  , Page.mds "https://www.google.com/design/spec/components/text-fields.html" 
  , Page.mdl "https://www.getmdl.io/components/#textfields-section"
  ]



  
