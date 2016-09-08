module Material.Textfield exposing 
  ( Property, label, floatingLabel, error, value, disabled, password
  , Msg, Model, defaultModel, update, view
  , render
  , text', textarea, rows, cols
  , autofocus
  , maxlength
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
[this site](https://debois.github.io/elm-mdl/#textfields)
for a live demo.
 
# Component render
@docs render

# Options
@docs Property, value
  
## Appearance

@docs label, floatingLabel, error

## Html attributes
@docs disabled, rows, cols
@docs autofocus, maxlength

# Type 
@docs password, textarea, text'

# Elm Architecture
@docs Msg, Model, defaultModel, update, view


-}


import Html exposing (div, span, Html, text)
import Html.Attributes exposing (class, type', style)
import Html.Events 
import Platform.Cmd
import Json.Decode as Decode

import Parts exposing (Indexed)

import Material.Options as Options exposing (cs, css, nop, Style, when)
import Material.Options.Internal as Internal exposing (attribute)
import Material.Msg as Material


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
  , kind : Kind
  , rows : Maybe Int
  , cols : Maybe Int
  , input : List (Options.Style m)  
  , container : List (Options.Style m)
  }


defaultConfig : Config m
defaultConfig = 
  { labelText = Nothing
  , labelFloat = False
  , error = Nothing
  , value = Nothing
  , disabled = False
  , kind = Text
  , rows = Nothing
  , cols = Nothing
  , input = [] 
  , container = [] 
  }


{-| Type of Textfield options
-}
type alias Property m = 
  Options.Property (Config m) m


{-| Label of the textfield
-}
label : String -> Property m 
label = 
  Internal.option <<
    (\str config -> { config | labelText = Just str })


{-| Label of textfield animates away from the input area on input
-}
floatingLabel : Property m
floatingLabel =
  Internal.option 
    (\config -> { config | labelFloat = True })


{-| Error message
-}
error : String -> Property m
error = 
  Internal.option <<
    (\str config -> { config | error = Just str })


{-| Current value of the textfield. 
-}
value : String -> Property m
value =
  Internal.option <<
    (\str config -> { config | value = Just str })


{-| Specifies that the input should automatically get focus when the page loads
-}
autofocus : Property m
autofocus =
  Options.attribute <| Html.Attributes.autofocus True


{-| Specifies the maximum number of characters allowed in the input
-}
maxlength : Int -> Property m
maxlength k =
  Options.attribute <| Html.Attributes.maxlength k


{-| Disable the textfield input
-}
disabled : Property m
disabled = 
  Internal.option
    (\config -> { config | disabled = True })


{-| Set properties on the actual `input` element in the Textfield.
-}
input : List (Options.Style m) -> Property m
input =
  Options.input


{-| Sets the type of input to 'password'.
-}
password : Property m 
password =
  Internal.option
    (\config -> { config | kind = Password })


{-| Creates a multiline textarea using 'textarea' element
-}
textarea : Property m
textarea =
  Internal.option
    (\config -> { config | kind = Textarea })


{-| Sets the type of input to 'text'. (Name chosen to avoid clashing with Html.text)
-}
text' : Property m
text' =
  Internal.option
    (\config -> { config | kind = Text })


{-| Number of rows in a multi-line input
-}
rows : Int -> Property m
rows k =
  Internal.input [ Options.attribute <| Html.Attributes.rows k ]


{-| Number of columns in a multi-line input
-}
cols : Int -> Property m
cols k =
  Internal.input [ Options.attribute <| Html.Attributes.cols k ] 


-- MODEL


{-| 
-}
type alias Model =
  { isFocused : Bool
  , isDirty : Bool 
  }


{-| Default model. No label, error, or value.
-}
defaultModel : Model
defaultModel =
  { isFocused = False
  , isDirty = False
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
update : x -> Msg -> Model -> Maybe (Model, Cmd msg)
update _ action model =
  case action of
    Input str ->
      let
        dirty = str /= ""
      in
        if dirty == model.isDirty then 
          Nothing
        else
          Just ({ model | isDirty = dirty }, Cmd.none)

    Blur ->
      Just ({ model | isFocused = False }, Cmd.none)

    Focus ->
      Just ({ model | isFocused = True }, Cmd.none)


-- VIEW

{-| Component view

Be aware that styling (third argument) is applied to the outermost element
of the textfield's implementation, and so is mostly useful for positioning
(e.g., `margin: 0 auto;` or `align-self: flex-end`). See `Textfield.input`
if you need to apply styling to the underlying `<input>` element. 
-}
view : (Msg -> m) -> Model -> List (Property m) -> x -> Html m
view lift model options _ =
  let
    ({ config } as summary) = 
      Internal.collect defaultConfig options

    inner = 
      case config.kind of 
        Textarea -> Html.textarea
        _ -> Html.input
  in
    Internal.applyContainer summary div
      [ cs "mdl-textfield"
      , cs "mdl-js-textfield"
      , cs "is-upgraded"
      , cs "mdl-textfield--floating-label" `when` config.labelFloat 
      , cs "is-invalid" `when` (config.error /= Nothing)
      , cs "is-dirty" `when` (config.value /= Nothing || model.isDirty)
      , cs "is-focused" `when` (model.isFocused && not config.disabled)
      , cs "is-disabled" `when` config.disabled 
      ]
      [ Internal.applyInput summary inner 
          [ cs "mdl-textfield__input"
          , css "outline" "none"
          , Internal.on1 "focus" lift Focus
          , Internal.on1 "blur" lift Blur
          , case config.kind of
              Text -> attribute <| type' "text"
              Password -> attribute <| type' "password"
              _ -> nop 
          , attribute (Html.Attributes.disabled True) `when` config.disabled
          , case config.value of
              Nothing -> 
                -- If user is not setting value, is we need the default input
                -- decoder to maintain is-dirty
                Options.on "input" 
                  (Decode.map (Input >> lift) Html.Events.targetValue)
              Just v -> 
                Html.Attributes.defaultValue v |> attribute
          ]
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


set : Indexed Model -> Container c -> Container c
set x c = 
   { c | textfield = x }


{-| Component render. Below is an example, assuming boilerplate setup as indicated 
  in `Material`, and a user message `ChangeAgeMsg Int`.

    Textfield.render Mdl [0] model.mdl
      [ Textfield.label "Age"
      , Textfield.floatingLabel
      , Textfield.value model.age
      , Textfield.onInput (String.toInt >> ChangeAgeMsg)
      ]

Be aware that styling (third argument) is applied to the outermost element
of the textfield's implementation, and so is mostly useful for positioning
(e.g., `margin: 0 auto;` or `align-self: flex-end`). See `Textfield.input`
if you need to apply styling to the underlying `<input>` element. 
-}
render 
  : (Material.Msg (Container c) m -> m)
  -> Parts.Index
  -> (Container c)
  -> List (Property m)
  -> x
  -> Html m
render lift =
  Parts.create 
    (Internal.inject view lift) update
    .textfield set
    defaultModel
    (Material.Internal >> lift)
