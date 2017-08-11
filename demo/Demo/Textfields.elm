module Demo.Textfields exposing (Model, defaultModel, Msg(Mdl), update, view)

import Html.Attributes as Html
import Html exposing (Html)
import Html as Html_
import Material
import Material.Options as Options
import Material.Options exposing (when, styled, cs, css)
import Material.Textfield as Textfield
import Material.Textfield.HelperText as Textfield
import Material.Checkbox as Checkbox
import Demo.Page exposing (Page)


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


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , example0 = defaultExample
    , example1 = defaultExample
    , example2 = defaultExample
    , example3 = defaultExample
    , example4 = defaultExample
    }


type Msg m
    = Mdl (Material.Msg m)
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


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model

        Example0Msg msg_ ->
            { model | example0 = updateExample msg_ model.example0 } ! []

        Example1Msg msg_ ->
            { model | example1 = updateExample msg_ model.example1 } ! []

        Example2Msg msg_ ->
            { model | example2 = updateExample msg_ model.example2 } ! []

        Example3Msg msg_ ->
            { model | example3 = updateExample msg_ model.example3 } ! []

        Example4Msg msg_ ->
            { model | example4 = updateExample msg_ model.example4 } ! []


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


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    page.body "Text fields"
    [ styled Html.section
      [ cs "example"
      ]
      [ example0 lift model.mdl 0 (Example0Msg >> lift) model.example0
      , example1 lift model.mdl 1 (Example1Msg >> lift) model.example1
      , example2 lift model.mdl 2 (Example2Msg >> lift) model.example2
      , example3 lift model.mdl 3 (Example3Msg >> lift) model.example3
      , example4 lift model.mdl 4 (Example4Msg >> lift) model.example4
      ]
    ]


example0 : (Msg m -> m) -> Material.Model -> Int -> (ExampleMsg -> m) -> Example -> Html m
example0 fwd mdl idx lift model =
    styled Html.div []
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
        [ Textfield.render (Mdl >> fwd) [idx] mdl
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
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,0] mdl
        [ Options.onClick (lift ToggleDisabled)
        ]
        []
      , Html.label [] [ Html.text "Disabled" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,1] mdl
        [ Options.onClick (lift ToggleRtl)
        ]
        []
      , Html.label [] [ Html.text "RTL" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,2] mdl
        [ Options.onClick (lift ToggleDarkTheme)
        ]
        []
      , Html.label [] [ Html.text "Dark Theme" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,3] mdl
        [ Options.onClick (lift ToggleDense)
        ]
        []
      , Html.label [] [ Html.text "Dense" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,4] mdl
        [ Options.onClick (lift ToggleRequired)
        ]
        []
      , Html.label [] [ Html.text "Required" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,5] mdl
        [ Options.onClick (lift ToggleHelperText)
        ]
        []
      , Html.label [] [ Html.text "Use Helper Text" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,6] mdl
        [ Options.onClick (lift TogglePersistent)
        , Checkbox.disabled |> when (not model.helperText)
        ]
        []
      , Html.label [] [ Html.text "Make helper text persistent" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,7] mdl
        [ Options.onClick (lift ToggleValidationMsg)
        , Checkbox.disabled |> when (not model.helperText)
        ]
        []
      , Html.label [] [ Html.text "Use helper text as validation message" ]
      ]
    ]


example1 : (Msg m -> m) -> Material.Model -> Int -> (ExampleMsg -> m) -> Example -> Html m
example1 fwd mdl idx lift model =
    styled Html.div []
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
        [ Textfield.render (Mdl >> fwd) [idx] mdl
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


example2 : (Msg m -> m) -> Material.Model -> Int -> (ExampleMsg -> m) -> Example -> Html m
example2 fwd mdl idx lift model =
    styled Html.div []
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
        [ Textfield.render (Mdl >> fwd) [idx] mdl
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
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,0] mdl
        [ Options.onClick (lift ToggleDisabled)
        ]
        []
      , Html.label [] [ Html.text "Disabled" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,1] mdl
        [ Options.onClick (lift ToggleRtl)
        ]
        []
      , Html.label [] [ Html.text "RTL" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,2] mdl
        [ Options.onClick (lift ToggleDarkTheme)
        ]
        []
      , Html.label [] [ Html.text "Dark Theme" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,3] mdl
        [ Options.onClick (lift ToggleDense)
        ]
        []
      , Html.label [] [ Html.text "Dense" ]
      ]
    ]


example3 : (Msg m -> m) -> Material.Model -> Int -> (ExampleMsg -> m) -> Example -> Html m
example3 fwd mdl idx lift model =
    styled Html.div []
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
        [ Textfield.render (Mdl >> fwd) [idx] mdl
          [ Textfield.label "Multi-line Label"
          , Textfield.multiline
          , Textfield.rows 8
          , Textfield.cols 40
          ]
          []
        ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,0] mdl
        [ Options.onClick (lift ToggleDisabled)
        ]
        []
      , Html.label [] [ Html.text "Disabled" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,1] mdl
        [ Options.onClick (lift ToggleRtl)
        ]
        []
      , Html.label [] [ Html.text "RTL" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,2] mdl
        [ Options.onClick (lift ToggleDarkTheme)
        ]
        []
      , Html.label [] [ Html.text "Dark Theme" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,3] mdl
        [ Options.onClick (lift ToggleDense)
        ]
        []
      , Html.label [] [ Html.text "Dense" ]
      ]
    ]


example4 : (Msg m -> m) -> Material.Model -> Int -> (ExampleMsg -> m) -> Example -> Html m
example4 fwd mdl idx lift model =
    styled Html.div []
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
        [ Textfield.render (Mdl >> fwd) [idx,0] mdl
          [ Textfield.placeholder "Subject"
          , Textfield.fullWidth
          ]
          []
        , Textfield.render (Mdl >> fwd) [idx,1] mdl
          [ Textfield.placeholder "Message"
          , Textfield.multiline
          , Textfield.fullWidth
          , Textfield.rows 8
          , Textfield.cols 40
          ]
          []
        ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,2] mdl
        [ Options.onClick (lift ToggleDisabled)
        ]
        []
      , Html.label [] [ Html.text "Disabled" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,3] mdl
        [ Options.onClick (lift ToggleRtl)
        ]
        []
      , Html.label [] [ Html.text "RTL" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,4] mdl
        [ Options.onClick (lift ToggleDarkTheme)
        ]
        []
      , Html.label [] [ Html.text "Dark Theme" ]
      ]
    , styled Html.div []
      [ Checkbox.render (Mdl >> fwd) [idx,5] mdl
        [ Options.onClick (lift ToggleDense)
        ]
        []
      , Html.label [] [ Html.text "Dense" ]
      ]
    ]
