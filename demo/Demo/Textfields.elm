module Demo.Textfields exposing (model, Model, update, view, Msg)

import Html.Attributes as Html
import Html exposing (Html)
import Material
import Material.Options as Options
import Material.Options exposing (when, styled, cs, css, div)
import Material.Textfield as Textfield
import Material.Textfield.HelperText as Textfield
import Material.Toggles as Toggles


-- MODEL


type alias Model =
    { mdl : Material.Model
    , example0 : Example
    , example1 : Example
    , example2 : Example
    , example3 : Example
    , example4 : Example
    }


type alias Example =
    { disabled : Bool
    , rtl : Bool
    , darkTheme : Bool
    , dense : Bool
    , required : Bool
    , helperText : Bool
    , persistent : Bool
    , validationMsg : Bool
    }


defaultExample : Example
defaultExample =
    { disabled = False
    , rtl = False
    , darkTheme = False
    , dense = False
    , required = False
    , helperText = False
    , persistent = False
    , validationMsg = False
    }


model : Model
model =
    { mdl = Material.model
    , example0 = defaultExample
    , example1 = defaultExample
    , example2 = defaultExample
    , example3 = defaultExample
    , example4 = defaultExample
    }


type Msg
    = Mdl (Material.Msg Msg)
    | Example0Msg ExampleMsg
    | Example1Msg ExampleMsg
    | Example2Msg ExampleMsg
    | Example3Msg ExampleMsg
    | Example4Msg ExampleMsg


type ExampleMsg
    = ToggleDisabled
    | ToggleRtl
    | ToggleDarkTheme
    | ToggleDense
    | ToggleRequired
    | ToggleHelperText
    | TogglePersistent
    | ToggleValidationMsg


update : Msg -> Model -> Maybe ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model |> Just

        Example0Msg msg_ ->
            { model | example0 = updateExample msg_ model.example0 } ! []
            |> Just

        Example1Msg msg_ ->
            { model | example1 = updateExample msg_ model.example1 } ! []
            |> Just

        Example2Msg msg_ ->
            { model | example2 = updateExample msg_ model.example2 } ! []
            |> Just

        Example3Msg msg_ ->
            { model | example3 = updateExample msg_ model.example3 } ! []
            |> Just

        Example4Msg msg_ ->
            { model | example4 = updateExample msg_ model.example4 } ! []
            |> Just


updateExample : ExampleMsg -> Example -> Example
updateExample msg model =
    case msg of
        ToggleDisabled ->
            { model | disabled = not model.disabled }

        ToggleRtl ->
            { model | rtl = not model.rtl }

        ToggleDarkTheme ->
            { model | darkTheme = not model.darkTheme }

        ToggleDense ->
            { model | dense = not model.dense }

        ToggleRequired ->
            { model | required = not model.required }

        ToggleHelperText ->
            { model | helperText = not model.helperText }

        TogglePersistent ->
            { model | persistent = not model.persistent }

        ToggleValidationMsg ->
            { model | validationMsg = not model.validationMsg }


-- VIEW


view : Model -> Html Msg
view model =
    div []
    [ styled Html.section
      [ cs "example"
      ]
      [ example0 model.mdl 0 Example0Msg model.example0
      , example1 model.mdl 1 Example1Msg model.example1
      , example2 model.mdl 2 Example2Msg model.example2
      , example3 model.mdl 3 Example3Msg model.example3
      , example4 model.mdl 4 Example4Msg model.example4
      ]
    ]


example0 : Material.Model -> Int -> (ExampleMsg -> Msg) -> Example -> Html Msg
example0 mdl idx lift model =
    div []
    [
      Html.h2 []
      [ Html.text
        "Full Functionality Component (Floating Label, Validation, Autocomplete)"
      ]

    , styled Html.section
      [ cs "mdc-theme--dark" |> when model.darkTheme
      , Options.attribute (Html.dir "rtl") |> when model.rtl
      ]
      [ Html.div
        ( if model.darkTheme then
              [ Html.class "mdc-theme--dark" ]
          else
              []
        )
        [ Textfield.render Mdl [idx] mdl
          [ Textfield.label "Email Address"
          , Textfield.disabled |> when model.disabled
          , Textfield.dense |> when model.dense
          , Textfield.required |> when model.required
          ]
          []
        , Textfield.helperText
          [ Textfield.persistent |> when model.persistent
          , Textfield.validationMsg |> when model.validationMsg
          , css "display" "none" |> when (not model.helperText)
          ]
          [ Html.text "Help Text (possibly validation message)"
          ]
        ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,0] mdl
        [ Options.onClick (lift ToggleDisabled)
        ]
        []
      , Html.label [] [ Html.text "Disabled" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,1] mdl
        [ Options.onClick (lift ToggleRtl)
        ]
        []
      , Html.label [] [ Html.text "RTL" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,2] mdl
        [ Options.onClick (lift ToggleDarkTheme)
        ]
        []
      , Html.label [] [ Html.text "Dark Theme" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,3] mdl
        [ Options.onClick (lift ToggleDense)
        ]
        []
      , Html.label [] [ Html.text "Dense" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,4] mdl
        [ Options.onClick (lift ToggleRequired)
        ]
        []
      , Html.label [] [ Html.text "Required" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,5] mdl
        [ Options.onClick (lift ToggleHelperText)
        ]
        []
      , Html.label [] [ Html.text "Use Helper Text" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,6] mdl
        [ Options.onClick (lift TogglePersistent)
        , Toggles.disabled |> when (not model.helperText)
        ]
        []
      , Html.label [] [ Html.text "Make helper text persistent" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,7] mdl
        [ Options.onClick (lift ToggleValidationMsg)
        , Toggles.disabled |> when (not model.helperText)
        ]
        []
      , Html.label [] [ Html.text "Use helper text as validation message" ]
      ]
    ]


example1 : Material.Model -> Int -> (ExampleMsg -> Msg) -> Example -> Html Msg
example1 mdl idx lift model =
    div []
    [ Html.h2 []
      [ Html.text "Password field with validation"
      ]

    , styled Html.section
      [ cs "mdc-theme--dark" |> when model.darkTheme
      , Options.attribute (Html.dir "rtl") |> when model.rtl
      ]
      [ Html.div
        ( if model.darkTheme then
              [ Html.class "mdc-theme--dark" ]
          else
              []
        )
        [ Textfield.render Mdl [idx] mdl
          [ Textfield.label "Choose password"
          , Textfield.password
          , Textfield.pattern ".{8,}"
          , Textfield.required
          ]
          []
        , Textfield.helperText
          [ Textfield.persistent
          , Textfield.validationMsg
          ]
          [ Html.text "Must be at least 8 characters long"
          ]
        ]
      ]
    ]


example2 : Material.Model -> Int -> (ExampleMsg -> Msg) -> Example -> Html Msg
example2 mdl idx lift model =
    div []
    [ Html.h2 []
      [ Html.text "Textfield box"
      ]

    , styled Html.section
      [ cs "mdc-theme--dark" |> when model.darkTheme
      , Options.attribute (Html.dir "rtl") |> when model.rtl
      ]
      [ Html.div
        ( if model.darkTheme then
              [ Html.class "mdc-theme--dark" ]
          else
              []
        )
        [ Textfield.render Mdl [idx] mdl
          [ Textfield.label "Your Name"
          , Textfield.textfield
          ]
          []
        , Textfield.helperText
          [ Textfield.persistent |> when model.persistent
          , Textfield.validationMsg |> when model.validationMsg
          ]
          [ Html.text "Must provide a name"
          ]
        ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,0] mdl
        [ Options.onClick (lift ToggleDisabled)
        ]
        []
      , Html.label [] [ Html.text "Disabled" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,1] mdl
        [ Options.onClick (lift ToggleRtl)
        ]
        []
      , Html.label [] [ Html.text "RTL" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,2] mdl
        [ Options.onClick (lift ToggleDarkTheme)
        ]
        []
      , Html.label [] [ Html.text "Dark Theme" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,3] mdl
        [ Options.onClick (lift ToggleDense)
        ]
        []
      , Html.label [] [ Html.text "Dense" ]
      ]
    ]


example3 : Material.Model -> Int -> (ExampleMsg -> Msg) -> Example -> Html Msg
example3 mdl idx lift model =
    div []
    [ Html.h2 []
      [ Html.text "Multi-line Textfields"
      ]

    , styled Html.section
      [ cs "mdc-theme--dark" |> when model.darkTheme
      , Options.attribute (Html.dir "rtl") |> when model.rtl
      ]
      [ Html.div
        ( if model.darkTheme then
              [ Html.class "mdc-theme--dark" ]
          else
              []
        )
        [ Textfield.render Mdl [idx] mdl
          [ Textfield.label "Multi-line Label"
          , Textfield.multiline
          , Textfield.rows 8
          , Textfield.cols 40
          ]
          []
        ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,0] mdl
        [ Options.onClick (lift ToggleDisabled)
        ]
        []
      , Html.label [] [ Html.text "Disabled" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,1] mdl
        [ Options.onClick (lift ToggleRtl)
        ]
        []
      , Html.label [] [ Html.text "RTL" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,2] mdl
        [ Options.onClick (lift ToggleDarkTheme)
        ]
        []
      , Html.label [] [ Html.text "Dark Theme" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,3] mdl
        [ Options.onClick (lift ToggleDense)
        ]
        []
      , Html.label [] [ Html.text "Dense" ]
      ]
    ]


example4 : Material.Model -> Int -> (ExampleMsg -> Msg) -> Example -> Html Msg
example4 mdl idx lift model =
    div []
    [ Html.h2 []
      [ Html.text "Full-Width Textfields"
      ]

    , styled Html.section
      [ cs "mdc-theme--dark" |> when model.darkTheme
      , Options.attribute (Html.dir "rtl") |> when model.rtl
      ]
      [ Html.div
        ( if model.darkTheme then
              [ Html.class "mdc-theme--dark" ]
          else
              []
        )
        [ Textfield.render Mdl [idx,0] mdl
          [ Textfield.placeholder "Subject"
          , Textfield.fullWidth
          ]
          []
        , Textfield.render Mdl [idx,1] mdl
          [ Textfield.placeholder "Message"
          , Textfield.multiline
          , Textfield.fullWidth
          , Textfield.rows 8
          , Textfield.cols 40
          ]
          []
        ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,2] mdl
        [ Options.onClick (lift ToggleDisabled)
        ]
        []
      , Html.label [] [ Html.text "Disabled" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,3] mdl
        [ Options.onClick (lift ToggleRtl)
        ]
        []
      , Html.label [] [ Html.text "RTL" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,4] mdl
        [ Options.onClick (lift ToggleDarkTheme)
        ]
        []
      , Html.label [] [ Html.text "Dark Theme" ]
      ]
    , div []
      [ Toggles.checkbox Mdl [idx,5] mdl
        [ Options.onClick (lift ToggleDense)
        ]
        []
      , Html.label [] [ Html.text "Dense" ]
      ]
    ]
