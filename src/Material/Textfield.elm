module Material.Textfield
    exposing
        ( Property
        , label
--        , floatingLabel
--        , value
--        , defaultValue
        , disabled
        , render
        , react
--        , autofocus
--        , maxlength
        , dense
        , required
        , type_
        , password
        , email
        , textfield
        , rows
        , cols
        , maxRows
        , pattern
        , multiline
        , fullWidth
        , placeholder
        , Model
        , defaultModel
        , Msg
        , update
        , view
        , Config
        , defaultConfig
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
@docs Property, Config, defaultConfig, value, defaultValue

## Appearance

@docs label, floatingLabel

## Html attributes
@docs disabled, rows, cols
@docs autofocus, maxlength, maxRows

@docs password, email, textarea, text_

# Elm Architecture
@docs Msg, Model, defaultModel, update, view

# Internal use
@docs react

-}

import Html.Attributes as Html exposing (class, type_, style)
import Html.Events as Html exposing (defaultOptions)
import Html exposing (div, span, Html, text)
import Json.Decode as Decode
import Json.Encode as Json
import Material.Component as Component exposing (Indexed)
import Material.Internal.Options as Internal
import Material.Internal.Textfield exposing (Msg(..))
import Material.Msg exposing (Index) 
import Material.Options as Options exposing (cs, css, nop, Style, when)
import Regex


-- OPTIONS


{-| TODO
-}
type alias Config m =
    { labelText : Maybe String
    , labelFloat : Bool
    , value : Maybe String
    , defaultValue : Maybe String
    , disabled : Bool
    , input : List (Options.Style m)
    , container : List (Options.Style m)
    , maxRows : Maybe Int
    , dense : Bool
    , required : Bool
    , type_ : Maybe String
    , textfieldBox : Bool
    , pattern : Maybe String
    , multiline : Bool
    , fullWidth : Bool
    , invalid : Bool
    }


{-| TODO
-}
defaultConfig : Config m
defaultConfig =
    { labelText = Nothing
    , labelFloat = False
    , value = Nothing
    , defaultValue = Nothing
    , disabled = False
    , input = []
    , container = []
    , maxRows = Nothing
    , dense = False
    , required = False
    , type_ = Just "text"
    , textfieldBox = False
    , pattern = Nothing
    , multiline = False
    , fullWidth = False
    , invalid = False
    }


{-| Type of Textfield options
-}
type alias Property m =
    Options.Property (Config m) m


{-| Label of the textfield
-}
label : String -> Property m
label =
    Internal.option
        << (\str config -> { config | labelText = Just str })


{-| Label of textfield animates away from the input area on input
-}
floatingLabel : Property m
floatingLabel =
    Internal.option
        (\config -> { config | labelFloat = True })


{-| Current value of the textfield.
-}
value : String -> Property m
value =
    Internal.option
        << (\str config -> { config | value = Just str })


{-| Set the default value of the textfield
-}
defaultValue : String -> Property m
defaultValue =
    Internal.option
        << (\str config -> { config | defaultValue = Just str })


{-| Specifies that the input should automatically get focus when the page loads
-}
autofocus : Property m
autofocus =
    Options.attribute <| Html.autofocus True


{-| Specifies the maximum number of characters allowed in the input
-}
maxlength : Int -> Property m
maxlength k =
    Options.attribute <| Html.maxlength k


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
    Internal.option (\config -> { config | type_ = Just "password" })


{-| Sets the type of input to 'email'.
-}
email : Property m
email =
    Internal.option (\config -> { config | type_ = Just "email" })


{-| TODO
-}
textfield : Property m
textfield =
    Internal.option (\config -> { config | textfieldBox = True })


{-| TODO
-}
pattern : String -> Property m
pattern =
    Internal.option << (\value config -> { config | pattern = Just value })


{-| Number of rows in a multi-line input
-}
rows : Int -> Property m
rows k =
    Internal.input [ Options.attribute <| Html.rows k ]


{-| Number of columns in a multi-line input
-}
cols : Int -> Property m
cols k =
    Internal.input [ Options.attribute <| Html.cols k ]


{-| Maximum number of rows (only Textrea).
-}
maxRows : Int -> Property m
maxRows k =
    Internal.option (\config -> { config | maxRows = Just k })


{-| TODO
-}
dense : Property m
dense =
    Internal.option (\config -> { config | dense = True })


{-| TODO
-}
required : Property m
required =
    Internal.option (\config -> { config | required = True })


type_ : String -> Property m
type_ =
    Internal.option << (\value config -> { config | type_ = Just value })


fullWidth : Property m
fullWidth =
    Internal.option (\config -> { config | fullWidth = True })


invalid : Property m
invalid =
    Internal.option (\config -> { config | invalid = True })


multiline : Property m
multiline =
    Internal.option (\config -> { config | multiline = True })


placeholder : String -> Property m
placeholder value =
    Internal.input [ Options.attribute <| Html.attribute "placeholder" value ]


-- MODEL


{-|
-}
type alias Model =
    { isFocused : Bool
    , isDirty : Bool
    , value : Maybe String
    }


{-| Default model. 
-}
defaultModel : Model
defaultModel =
    { isFocused = False
    , isDirty = False
    , value = Nothing
    }



-- ACTIONS, UPDATE


{-| Component actions. 
-}
type alias Msg
    = Material.Internal.Textfield.Msg


{-| Component update.
-}
update : x -> Msg -> Model -> ( Maybe Model, Cmd msg )
update _ msg model =
    (case msg of
        Input str ->
            let
                dirty =
                    str /= ""
            in
                Just { model | value = Just str, isDirty = dirty }

        Blur ->
            Just { model | isFocused = False }

        Focus ->
            Just { model | isFocused = True }

        NoOp ->
            Just model
    )
      |> flip (!) []



-- VIEW


{-| Component view

Be aware that styling (third argument) is applied to the outermost element
of the textfield's implementation, and so is mostly useful for positioning
(e.g., `margin: 0 auto;` or `align-self: flex-end`). See `Options.input`
if you need to apply styling to the underlying `<input>` element.
-}
view : (Msg -> m) -> Model -> List (Property m) -> x -> Html m
view lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        isDirty =
            model.isDirty

        preventEnterWhenMaxRowsExceeded =
            Options.onWithOptions "keydown"
                { defaultOptions
                  | preventDefault = True
                }
                ( Decode.map2 (,) Html.keyCode Html.targetValue
                  |> Decode.andThen (\ (keyCode, value) ->
                      let
                          rows =
                              value
                              |> String.split "\n"
                              |> List.length
                      in
                      if (rows >= Maybe.withDefault 0 config.maxRows) && (keyCode == 13) then
                            Decode.succeed (lift NoOp)
                          else
                            Decode.fail ""
                    )
                )
            |> when (config.multiline && (config.maxRows /= Nothing))

        isFocused =
            model.isFocused && not config.disabled

        isInvalid =
            case config.pattern of
                Just pattern ->
                    model.value
                    |> Maybe.map (not << Regex.contains (Regex.regex ("^" ++ pattern ++ "$")))
                    |> Maybe.withDefault False
                Nothing -> False
    in
        Internal.applyContainer summary
            div
            [ cs "mdc-textfield"
            , cs "mdc-textfield--upgraded"
            , Internal.on1 "focus" lift Focus
            , Internal.on1 "blur" lift Blur
            , cs "mdc-textfield--focused" |> when isFocused 
            , cs "mdc-textfield--disabled" |> when config.disabled
            , cs "mdc-textfield--dense" |> when config.dense
            , cs "mdc-textfield--fullwidth" |> when config.fullWidth
            , cs "mdc-textfield--invalid" |> when isInvalid
            , cs "mdc-textfield--multiline" |> when config.multiline
            , preventEnterWhenMaxRowsExceeded
            ]
            [ Internal.applyInput summary
                (if config.multiline then Html.textarea else Html.input)
                [
                  cs "mdc-textfield__input"
                , css "outline" "none"
                , cs "mdc-textfield--box" |> when config.textfieldBox
                , Internal.on1 "focus" lift Focus
                , Internal.on1 "blur" lift Blur
                , Options.onInput (Input >> lift)
                , Options.many << List.map Internal.attribute << List.filterMap identity <|
                  [ Html.type_ (Maybe.withDefault "text" config.type_)
                    |> if not config.multiline then Just else always Nothing
                    -- TODO: ^^^^ can crash Elm runtime
                  , Html.disabled True
                    |> if config.disabled then Just else always Nothing
                  , Html.property "required" (Json.bool True)
                    |> if config.required then Just else always Nothing
                  , Html.property "pattern" (Json.string (Maybe.withDefault "" config.pattern))
                    |> if config.pattern /= Nothing then Just else always Nothing
                  , Html.attribute "outline" "medium none"
                    |> Just
                  ]
                ]
                []
            , Options.styled Html.label
                [ cs "mdc-textfield__label"
                , cs "mdc-textfield__label--float-above" |> when (isFocused || isDirty)
                ]
                ( case config.labelText of
                    Just str ->
                        [ text str ]

                    Nothing ->
                        []
                )
            , Options.styled div
              [ cs "mdc-textfield__bottom-line"
              ]
              [
              ]
            ]


-- COMPONENT


type alias Store s =
    { s | textfield : Indexed Model }


( get, set ) =
    Component.indexed .textfield (\x c -> { c | textfield = x }) defaultModel


{-| Component react function.
-}
react
    : (Material.Msg.Msg m -> msg)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd msg )
react =
    Component.react get
        set
        Material.Msg.TextfieldMsg update


{-| Component render. Below is an example, assuming boilerplate setup as indicated
  in `Material`, and a user message `ChangeAgeMsg Int`.

    Textfield.render Mdl [0] model.mdl
      [ Textfield.label "Age"
      , Textfield.floatingLabel
      , Textfield.value model.age
      , Options.onInput (String.toInt >> ChangeAgeMsg)
      ]
      []

Be aware that styling (third argument) is applied to the outermost element
of the textfield's implementation, and so is mostly useful for positioning
(e.g., `margin: 0 auto;` or `align-self: flex-end`). See `Textfield.style`
if you need to apply styling to the underlying `<input>` element.
-}
render
    : (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> x
    -> Html m       
render lift index store options =
    Component.render get view Material.Msg.TextfieldMsg lift index store
        (Internal.dispatch lift :: options)

-- TODO: use inject ^^^^^
