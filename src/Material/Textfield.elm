module Material.Textfield exposing 
  ( Property, label, floatingLabel, error, value, disabled, password
  , onInput
  , Msg, Model, defaultModel, update, view
  , render
  )

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
@docs Property, value, label, floatingLabel, error, disabled, onInput, password

# Part
@docs render

# Elm Architecture
@docs Msg, Model, defaultModel, update, view



-}

import Html exposing (div, span, Html, text)
import Html.Attributes exposing (class, type', style)
import Html.Events exposing (onFocus, onBlur, targetValue)
import Json.Decode as Decoder
import Platform.Cmd

import Parts exposing (Indexed)

import Material.Options as Options exposing (cs, nop)


-- OPTIONS



type alias Config m = 
  { labelText : Maybe String
  , labelFloat : Bool
  , error : Maybe String
  , value : Maybe String
  , disabled : Bool
  , onInput : Maybe (Html.Attribute m)
  , type' : Html.Attribute m
  }


defaultConfig : Config m
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
type alias Property m = 
  Options.Property (Config m) m


{-|
  TODO
-}
label : String -> Property m 
label str = 
  Options.set 
    (\config -> { config | labelText = Just str })

{-| 
  TODO
-}
floatingLabel : Property m
floatingLabel =
  Options.set
    (\config -> { config | labelFloat = True })


{-|
  TODO
-}
error : String -> Property m
error str = 
  Options.set
    (\config -> { config | error = Just str })


{-| 
  TODO
-}
value : String -> Property m
value str = 
  Options.set
    (\config -> { config | value = Just str })


{-| 
  TODO
-}
disabled : Property m
disabled = 
  Options.set
    (\config -> { config | disabled = True })


{-|
  TODO
-}
onInput : (String -> m) -> Property m
onInput f = 
  Options.set
    (\config -> { config | onInput = 
      Just (Html.Events.on "input" (Decoder.map f targetValue)) })

{-|
-}
password : Property m 
password =
  Options.set
    (\config -> { config | type' = type' "password" })


-- MODEL



{- Kind of textfield. Currently supports only single-line input or password
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
type Msg
  = Blur
  | Focus
  | Input String


{-| Component update.
-}
update : Msg -> Model -> Model
update action model =
  case action of
    Input str -> 
      { model | value = str }
      
    Blur ->
      { model | isFocused = False }

    Focus ->
      { model | isFocused = True }


-- VIEW


{-|
-}
view : Model -> List (Property Msg) -> Html Msg
view = view' (\x -> x)


view' : (Msg -> m) -> Model -> List (Property m) -> Html m
view' lift model options =
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
          , onBlur (lift Blur)
          , onFocus (lift Focus)
          , case config.value of
              Just str -> 
                Html.Attributes.value str
              Nothing -> 
                Html.Events.on "input" (Decoder.map (Input >> lift) targetValue)
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
  : (Parts.Msg (Container c) -> m)
  -> Parts.Index
  -> (Container c)
  -> List (Property m)
  -> Html m
render =
  Parts.create 
    view' (\action model -> (update action model, Cmd.none))
    .textfield (\c x -> { c | textfield = x }) 
    defaultModel

