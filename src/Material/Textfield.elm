module Material.Textfield exposing 
  ( Property, label, floatingLabel, error, value, disabled, password
  , onInput
  , Msg, Model, defaultModel, update, view
  , render
  , text', textarea, rows, cols
  , autofocus
  , maxlength
  , onBlur
  , onFocus
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
 
# Component render
@docs render

# Options
@docs Property, value
  
# Appearance
@docs label, floatingLabel, error, disabled, rows, cols
@docs autofocus, maxlength

# Type 
@docs password, textarea, text', onInput
@docs onBlur, onFocus

# Elm Architecture
@docs Msg, Model, defaultModel, update, view

-}

import Html exposing (div, span, Html, text)
import Html.Attributes exposing (class, type', style)
import Html.Events exposing (targetValue)
import Json.Decode as Decoder
import Platform.Cmd

import Parts exposing (Indexed)

import Material.Options as Options exposing (cs, nop)


-- OPTIONS

type Kind
  = Text
  | Textarea
  | Password


type alias Config m = 
  { labelText : Maybe String
  , labelFloat : Bool
  , error : Maybe String
  , value : Maybe String
  , disabled : Bool
  , onInput : Maybe (Html.Attribute m)
  , kind : Kind
  , rows : Maybe Int
  , cols : Maybe Int
  , autofocus : Bool
  , maxlength : Maybe Int
  , onBlur : Maybe (Html.Attribute m)
  , onFocus : Maybe (Html.Attribute m)
  }


defaultConfig : Config m
defaultConfig = 
  { labelText = Nothing
  , labelFloat = False
  , error = Nothing
  , value = Nothing
  , disabled = False
  , kind = Text
  , onInput = Nothing
  , rows = Nothing
  , cols = Nothing
  , autofocus = False
  , maxlength = Nothing
  , onBlur = Nothing
  , onFocus = Nothing
  }


{-| Type of Textfield options
-}
type alias Property m = 
  Options.Property (Config m) m


{-| Label of the textfield
-}
label : String -> Property m 
label str = 
  Options.set 
    (\config -> { config | labelText = Just str })

{-| Label of textfield animates away from the input area on input
-}
floatingLabel : Property m
floatingLabel =
  Options.set
    (\config -> { config | labelFloat = True })


{-| Error message
-}
error : String -> Property m
error str = 
  Options.set
    (\config -> { config | error = Just str })


{-| Current value of the textfield. 
-}
value : String -> Property m
value str = 
  Options.set
    (\config -> { config | value = Just str })


{-| Specifies that the input should automatically get focus when the page loads
-}
autofocus : Property m
autofocus =
  Options.set
    (\config -> { config | autofocus = True })


{-| Specifies the maximum number of characters allowed in the input
-}
maxlength : Int -> Property m
maxlength v =
  Options.set
    (\config -> { config | maxlength = Just v })


{-| Disable the textfield input
-}
disabled : Property m
disabled = 
  Options.set
    (\config -> { config | disabled = True })


{-| Message to dispatch on input
-}
onInput : (String -> m) -> Property m
onInput f = 
  Options.set
    (\config -> { config | onInput = 
      Just (Html.Events.on "input" (Decoder.map f targetValue)) })


{-| The `blur` event occurs when the input loses focus.
-}
onBlur : m -> Property m
onBlur f =
  Options.set
    (\config -> { config | onBlur =
      Just (Html.Events.on "focusout" (Decoder.succeed f)) })


{-| The `focus` event occurs when the input gets focus.
-}
onFocus : m -> Property m
onFocus f =
  Options.set
    (\config -> { config | onFocus =
      Just (Html.Events.on "focusin" (Decoder.succeed f)) })


{-| Sets the type of input to 'password'.
-}
password : Property m 
password =
  Options.set
    (\config -> { config | kind = Password })


{-| Creates a multiline textarea using 'textarea' element
-}
textarea : Property m
textarea =
  Options.set
    (\config -> { config | kind = Textarea })

{-| Sets the type of input to 'text'. (Name chosen to avoid clashing with Html.text)
-}
text' : Property m
text' =
  Options.set
    (\config -> { config | kind = Text })

{-| Number of rows in a multi-line input
-}
rows : Int -> Property m
rows rows =
  Options.set
    (\config -> { config | rows = Just rows })

{-| Number of columns in a multi-line input
-}
cols : Int -> Property m
cols cols =
  Options.set
    (\config -> { config | cols = Just cols })

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


{-| Component view
-}
view : (Msg -> m) -> Model -> List (Property m) -> Html m
view lift model options =
  let 
    ({ config } as summary) = 
      Options.collect defaultConfig options
    val = 
      config.value |> Maybe.withDefault model.value

    isTextarea = config.kind == Textarea

    elementFunction =
      if isTextarea then
        Html.textarea
      else
        Html.input

    -- Applying the type attribute only if we are not a textarea
    -- However, if we are a textarea and rows and/or cols have been defined, add them instead
    typeAttributes =
      case config.kind of
          Text -> [type' "text"]
          Password -> [type' "password"]
          Textarea ->
            [] ++ (case config.rows of
                       Just r -> [Html.Attributes.rows r]
                       Nothing -> [])
               ++ (case config.cols of
                       Just c -> [Html.Attributes.cols c]
                       Nothing -> [])

    maxlength =
      case config.maxlength of
        Just val -> [Html.Attributes.maxlength val]
        Nothing -> []

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
      ( List.filterMap identity 
          [ config.onInput
          , config.onBlur
          , config.onFocus
          ]
      )
      [ elementFunction
          ([ class "mdl-textfield__input"
          , style [ ("outline", "none") ]
          , Html.Attributes.disabled config.disabled 
          , Html.Events.onBlur (lift Blur)
          , Html.Events.onFocus (lift Focus)
          , case config.value of
              Just str -> 
                Html.Attributes.value str
              Nothing -> 
                Html.Events.on "input" (Decoder.map (Input >> lift) targetValue)
          , Html.Attributes.autofocus config.autofocus
          ] ++ typeAttributes ++ maxlength)
          []
      , Html.label 
          [class "mdl-textfield__label"]  
          (case config.labelText of 
            Just str -> [ text str ]
            Nothing -> [])
      , config.error 
          |> Maybe.map (\e -> span [class "mdl-textfield__error"] [text e])
          |> Maybe.withDefault (div [] [])
      ]



-- PART

type alias Container c =
  { c | textfield : Indexed Model }

{-| Component render. Below is an example, assuming boilerplate setup as indicated 
  in `Material`, and a user message `ChangeAgeMsg Int`.

    Textfield.render Mdl [0] model.mdl
      [ Textfield.label "Your age?"
      , Textfield.floatingLabel
      , Textfield.value model.age
      , Textfield.onInput (String.toInt >> ChangeAgeMsg)
      ]
-}
render 
  : (Parts.Msg (Container c) m -> m)
  -> Parts.Index
  -> (Container c)
  -> List (Property m)
  -> Html m
render =
  Parts.create 
    view (\_ msg model -> Just (update msg model, Cmd.none))
    .textfield (\x c -> { c | textfield = x }) 
    defaultModel

