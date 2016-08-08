module Demo.Textfields exposing (model, Model, update, view, Msg)

import Html exposing (..)
import Platform.Cmd exposing (Cmd)
import Regex

import Material.Textfield as Textfield
import Material.Grid as Grid exposing (..)
import Material.Options as Options exposing (css)
import Material

import Demo.Page as Page
import String

import Material.Slider as Slider
import Material.Typography as Typo
import Demo.Code as Code

import Material.Color as Color
import Json.Decode as Decoder
import Material.Helpers as Helpers

-- MODEL


type alias Model =
  { mdl : Material.Model
  , str0 : String
  , str3 : String
  , str4 : String
  , str6 : String
  , length : Float
  , focus5 : Bool
  , str9 : String
  , sel9 : String
  }


model : Model
model =
  { mdl = Material.model
  , str0 = ""
  , str3 = ""
  , str4 = ""
  , str6 = ""
  , length = 5
  , focus5 = False
  , str9 = ""
  , sel9 = ""
  }


-- ACTION, UPDATE


type Msg
  = MDL (Material.Msg Msg)
  | Upd0 String
  | Upd3 String
  | Upd4 String
  | Upd6 String
  | Upd9 String
  | SetFocus5 Bool 
  | Slider Float
  | KeyUp KeyEvent
  | MouseEvent Selection


{-| Selection range
-}
type alias Selection =
  { start : Int
  , end : Int
  }


{-| KeyEvent
-}
type alias KeyEvent =
  { shift : Bool
  , keyCode : Int
  , selection : Selection
  }


selectionDecoder : Decoder.Decoder Selection
selectionDecoder =
  Decoder.object2 Selection
    (Decoder.at ["target", "selectionStart"] Decoder.int)
    (Decoder.at ["target", "selectionEnd"] Decoder.int)


eventDecoder : Decoder.Decoder KeyEvent
eventDecoder =
  Decoder.object3 KeyEvent
    (Decoder.at ["shiftKey"] Decoder.bool)
    (Decoder.at ["keyCode"] Decoder.int)
    selectionDecoder


getSelectedText : String -> Selection -> String
getSelectedText text { start, end } =
  let
    diff = abs (end - start)
    text' =
      if (end == start) then
        ""
      else
        text
          |> String.dropLeft start
          |> String.left diff
  in
    text'

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    MDL action' ->
      Material.update action' model

    Upd0 str ->
      ( { model | str0 = str }, Cmd.none )

    Upd3 str ->
      ( { model | str3 = str }, Cmd.none )

    Upd4 str ->
      ( { model | str4 = str }, Cmd.none )

    Upd6 str ->
      ( { model | str6 = str }, Cmd.none )

    Upd9 str ->
      ( { model | str9 = str }, Cmd.none )

    Slider value ->
        ( { model | length = value }, Cmd.none)

    SetFocus5 x ->
      { model | focus5 = x } ! [ Cmd.none ]

    KeyUp { shift, keyCode, selection } ->
      let
        selected = getSelectedText model.str9 selection
      in
        ({ model | sel9 = selected }, Cmd.none)

    MouseEvent selection ->
      let
        selected = getSelectedText model.str9 selection
      in
        ({ model | sel9 = selected }, Cmd.none)

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


view : Model -> Html Msg
view model =
  [ ( "Basic textfield"
    , Textfield.render MDL [0] model.mdl
        [ Textfield.onInput Upd0 ]
    , """
        Textfield.render MDL [0] model.mdl
          [ Textfield.onInput Upd0 ]
       """
    )

  , ( "Labelled textfield"
    , Textfield.render MDL [1] model.mdl
        [ Textfield.label "Labelled" ]
    , """
       Textfield.render MDL [1] model.mdl
         [ Textfield.label "Labelled" ]
       """
    )
  , ( "Labelled textfield, floating label"
    , Textfield.render MDL [2] model.mdl
        [ Textfield.label "Floating label"
        , Textfield.floatingLabel
        , Textfield.text'
        ]
    , """
        Textfield.render MDL [2] model.mdl
          [ Textfield.label "Floating label"
          , Textfield.floatingLabel
          , Textfield.text'
          ]
       """
    )
  , ( "Disabled textfield"
    , Textfield.render MDL [3] model.mdl
        [ Textfield.label "Disabled"
        , Textfield.disabled
        , Textfield.value <|
            model.str0
            ++ if model.str0 /= "" then " (still disabled, though)" else ""
        ]
    , """
      Textfield.render MDL [3] model.mdl
        [ Textfield.label "Disabled"
        , Textfield.disabled
        , Textfield.value <|
            model.str0
            ++ if model.str0 /= "" then
                " (still disabled, though)"
               else ""
        ]
       """
    )
  , ( "Textfield with error checking"
    , Textfield.render MDL [4] model.mdl
        [ Textfield.label "w/error checking"
        , if not <| match model.str4 rx' then
            Textfield.error <| "Doesn't match " ++ rx
          else
            Options.nop
        , Textfield.onInput Upd4
        ]
    , """
    Textfield.render MDL [4] model.mdl
      [ Textfield.label "w/error checking"
      , if not <| match model.str4 rx' then
          Textfield.error <| "Doesn't match " ++ rx
        else
          Options.nop
      , Textfield.onInput Upd4
      ]
       """
    )
  , ( "Textfield for passwords"
    , Textfield.render MDL [5] model.mdl
        [ Textfield.label "Enter password"
        , Textfield.floatingLabel
        , Textfield.password
        ]
    , """
      Textfield.render MDL [5] model.mdl
        [ Textfield.label "Enter password"
        , Textfield.floatingLabel
        , Textfield.password
        ]
       """
    )
  , ( "Multi-line textfield"
    , Textfield.render MDL [6] model.mdl
        [ Textfield.label "Default multiline textfield"
        , Textfield.textarea
        ]
    , """
      Textfield.render MDL [6] model.mdl
        [ Textfield.label "Default multiline textfield"
        , Textfield.textarea
        ]
       """
    )

  , ( "Multi-line textfield, 6 rows"
    , Textfield.render MDL [7] model.mdl
        [ Textfield.label "Multiline with 6 rows"
        , Textfield.floatingLabel
        , Textfield.textarea
        , Textfield.rows 6
        ]
    , """
      Textfield.render MDL [7] model.mdl
        [ Textfield.label "Multiline with 6 rows"
        , Textfield.floatingLabel
        , Textfield.textarea
        , Textfield.rows 6
        ]
       """
    )

  , ( "Multi-line textfield with character limit"
    , Html.div []
    [ Textfield.render MDL [8] model.mdl
        [ Textfield.label ("Multiline textfield (" ++
                            (toString (String.length model.str6))
                            ++ " of " ++ (toString (truncate model.length))
                            ++ " char limit)")
        , Textfield.onInput Upd6
        , Textfield.textarea
        , Textfield.maxlength (truncate model.length)
        , Textfield.autofocus
        , Textfield.floatingLabel
        , Textfield.onFocus (SetFocus5 True)
        , Textfield.onBlur (SetFocus5 False)
        ]
    , Options.styled Html.p
        [ Options.css "width" "80%" ]
        [ Options.span
          [ Typo.caption ]
          [ Html.text "Drag to change the maxlength" ]
        , Slider.view
            [ Slider.onChange Slider
            , Slider.value model.length
            , Slider.max 100
            , Slider.min 1
            , Slider.step 1
            ]
        --, Textfield.error <| if model.focus5 then "focused" else "not focused"
        ]
    ]
    , """
       Textfield.render MDL [8] model.mdl
         [ Textfield.label
             ("Multiline textfield (" ++
                (toString (String.length model.str6))
                ++ " of " ++ (toString (truncate model.length))
                ++ " char limit)")
         , Textfield.onInput Upd6
         , Textfield.textarea
         , Textfield.maxlength (truncate model.length)
         , Textfield.autofocus
         , Textfield.floatingLabel
         ]
       """
    )
  , ( "Custom Event Handler(s)"
    , Html.div
        []
        [ Textfield.render MDL [9] model.mdl
            [ Textfield.label "Custom event handlers"
            , Textfield.textarea
            , Textfield.onInput Upd9
            , Textfield.on "keyup" (Decoder.map KeyUp eventDecoder)
            , Textfield.on "mouseup" (Decoder.map MouseEvent selectionDecoder)
            , Textfield.on "mouseout" (Decoder.map MouseEvent selectionDecoder)
              -- Should throttle mousemove
              -- Used because mouseup happens before the selection variables are reset
              -- when unselecting text. 
            , Textfield.on "mousemove" (Decoder.map MouseEvent selectionDecoder)
            ]
        , Options.styled Html.p
            [ css "width" "300px"
            , css "word-wrap" "break-word"
            ]
            [ text <| "Selected text: " ++ model.sel9 ]
        ]
    , """
      Textfield.render MDL [9] model.mdl
        [ Textfield.label "Default multiline textfield"
        , Textfield.textarea
        , Textfield.onInput Upd9
        , Textfield.on "keyup"
            (Decoder.map KeyUp eventDecoder)
        , Textfield.on "mouseup"
            (Decoder.map MouseEvent selectionDecoder)
        , Textfield.on "mouseout"
            (Decoder.map MouseEvent selectionDecoder)
        , Textfield.on "mousemove"
            (Decoder.map MouseEvent selectionDecoder)
        ]
       """
    )

  ]
  |> List.map (\(header, html, code) ->
      cell
        [size Phone 4, size Tablet 6, offset Tablet 1, size Desktop 6, offset Desktop 3]
        [ h4 [] [ text header ] 
        , Options.div
            [ Options.center
            , Color.background Page.background
            ] [html]
        , Code.code [ css "margin" "24px 0" ] code
        ]
     )
  |> grid []
  |> flip (::) []
  |> (::) (Html.text "Try entering text into some of the textfields below.")
  |> Page.body2 "Textfields" srcUrl intro references


intro : Html a
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
