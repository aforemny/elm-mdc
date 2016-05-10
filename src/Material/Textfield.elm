module Material.Textfield 
  ( Property, label, floatingLabel, error, value, disabled, password
  , onInput
  , Action, Model, defaultModel, update, view
  , render
  )
  where

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#textfields-section):

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


Refer to 
[this site](https://debois.github.io/elm-mdl/#/textfields)
for a live demo.
 
This implementation provides only single-line.

# Options
@docs Property, value, label, floatingLabel, error, disabled, onInput

# Part
@docs render

# Elm Architecture
@docs Action, Model, defaultModel, update, view



-}

import Html exposing (div, span, Html, text)
import Html.Attributes exposing (class, type', style)
import Html.Events exposing (onFocus, onBlur, targetValue)
import Effects
import Signal exposing (Address)

import Parts exposing (Indexed)

import Material.Options as Options exposing (cs, nop)


-- OPTIONS



type alias Config = 
  { labelText : Maybe String
  , labelFloat : Bool
  , error : Maybe String
  , value : Maybe String
  , disabled : Bool
  , onInput : Maybe Html.Attribute
  , type' : Html.Attribute
  }


defaultConfig : Config
defaultConfig = 
  { labelText = Nothing
  , labelFloat = False
  , error = Nothing
  , value = Nothing
  , disabled = False
  , type' = type' "text"
  , onInput = Nothing
  }


{-|
  TODO
-}
type alias Property = 
  Options.Property Config


{-|
  TODO
-}
label : String -> Property 
label str = 
  Options.set 
    (\config -> { config | labelText = Just str })

{-| 
  TODO
-}
floatingLabel : Property
floatingLabel =
  Options.set
    (\config -> { config | labelFloat = True })


{-|
  TODO
-}
error : String -> Property
error str = 
  Options.set
    (\config -> { config | error = Just str })


{-| 
  TODO
-}
value : String -> Property
value str = 
  Options.set
    (\config -> { config | value = Just str })


{-| 
  TODO
-}
disabled : Property
disabled = 
  Options.set
    (\config -> { config | disabled = True })


{-|
  TODO
-}
onInput : Address String -> Property
onInput addr = 
  Options.set
    (\config -> { config | onInput = 
      Just (Html.Events.on "input" targetValue (Signal.message addr)) })

{-|
-}
password : Property 
password =
  Options.set
    (\config -> { config | type' = type' "password" })


-- MODEL



{-| Kind of textfield. Currently supports only single-line input or password
inputs.
  | MultiLine (Maybe Int) -- Max no. of rows or no limit
  -- TODO. Should prevent key event for ENTER
  -- when number of rows exceeds maxrows argument to constructor:

  MaterialTextfield.prototype.onKeyDown_ = function(event) {
    var currentRowCount = event.target.value.split('\n').length;
    if (event.keyCode === 13) {
      if (currentRowCount >= this.maxRows) {
        event.preventDefault();
      }
    }
  };
  -}


{-| Model. The textfield is in its error-container if `error` is not `Nothing`.
The contents of the field is `value`.
-}
type alias Model =
  { isFocused : Bool
  , value : String
  }


{-| Default model. No label, error, or value.
-}
defaultModel : Model
defaultModel =
  { isFocused = False
  , value = ""
  }


-- ACTIONS, UPDATE


{-| Component actions. `Input` carries the new value of the field.
-}
type Action
  = Blur
  | Focus
  | Input String


{-| Component update.
-}
update : Action -> Model -> Model
update action model =
  case action of
    Input str -> 
      { model | value = str }
      
    Blur ->
      { model | isFocused = False }

    Focus ->
      { model | isFocused = True }


-- VIEW


{-| Component view.
-}
view : Signal.Address Action -> Model -> List Property -> Html
view addr model options =
  let 
    ({ config } as summary) = 
      Options.collect defaultConfig options
    val = 
      config.value |> Maybe.withDefault model.value
  in
    Options.apply summary div
      [ cs "mdl-textfield"
      , cs "mdl-js-textfield"
      , cs "is-upgraded"
      , if config.labelFloat then cs "mdl-textfield--floating-label" else nop
      , if config.error /= Nothing then cs "is-invalid" else nop 
      , if val /= "" then cs "is-dirty" else nop
      , if model.isFocused && not config.disabled then cs "is-focused" else nop
      , if config.disabled then cs "is-disabled" else nop
      ]
      [ config.onInput
      ]
      ([ Just <| Html.input
          [ class "mdl-textfield__input"
          , style [ ("outline", "none") ]
          , config.type'
          , Html.Attributes.disabled config.disabled 
          , onBlur addr Blur
          , onFocus addr Focus
          , case config.value of
              Just str -> 
                Html.Attributes.value str
              Nothing -> 
                Html.Events.on "input" targetValue (Input >> Signal.message addr)
          ]
          []
      , Just <| Html.label 
          [class "mdl-textfield__label"]  
          (case config.labelText of 
            Just str -> [ text str ]
            Nothing -> [])
      , config.error |> Maybe.map (\e ->
          span [class "mdl-textfield__error"] [text e])
      ]
        |> List.filterMap (\x -> x)
      )



-- PART


{-|
-}
type alias Container c =
  { c | textfield : Indexed Model }


{-|
  TODO
-}
render 
  : (Parts.Action (Container c) obs -> obs)
  -> Parts.Index
  -> Address obs
  -> (Container c)
  -> List Property 
  -> Html
render lift = 
  let
    update' action model = 
      (update action model, Effects.none)
  in
    Parts.create
      view update' .textfield (\x y -> {y | textfield=x}) defaultModel lift
    
  
