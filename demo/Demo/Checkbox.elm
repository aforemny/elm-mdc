module Demo.Checkbox exposing (..)

import Html.Attributes as Html
import Html.Events as Html
import Html exposing (Html, text)
import Material
import Material.Checkbox as Checkbox
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Theme as Theme
import Platform.Cmd exposing (Cmd, none)


-- MODEL


type alias Model =
    { mdl : Material.Model
    , rtl : Bool
    , alignEnd : Bool
    , indeterminate : Bool
    , checked0 : Bool
    , checked1 : Bool
    , disabled0 : Bool
    , disabled1 : Bool
    }


model : Model
model =
    { mdl = Material.model
    , rtl = False
    , alignEnd = False
    , indeterminate = False
    , checked0 = False
    , checked1 = False
    , disabled0 = False
    , disabled1 = False
    }


type Msg
    = Mdl (Material.Msg Msg)
    | ToggleRtl
    | ToggleAlignEnd
    | ToggleIndeterminate
    | ToggleChecked0
    | ToggleChecked1
    | ToggleDisabled0
    | ToggleDisabled1


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model
        ToggleRtl ->
            { model | rtl = not model.rtl } ! []
        ToggleAlignEnd ->
            { model | alignEnd = not model.alignEnd } ! []
        ToggleIndeterminate ->
            { model | indeterminate = not model.indeterminate } ! []
        ToggleChecked0 ->
            { model | checked0 = not model.checked0 } ! []
        ToggleChecked1 ->
            { model | checked1 = not model.checked1 } ! []
        ToggleDisabled0 ->
            { model | disabled0 = not model.disabled0 } ! []
        ToggleDisabled1 ->
            { model | disabled1 = not model.disabled1 } ! []


-- VIEW


view : Model -> Html Msg
view model =
    let
        example options =
            styled Html.div
            ( cs "example"
            :: css "display" "block"
            :: css "margin" "24px"
            :: css "padding" "24px"
            :: options
            )
    in
    Html.div []
    [
      example
      [ Options.attribute (Html.attribute "dir" "rtl") |> when model.rtl
      ]
      [ styled Html.h2
        [ css "margin-left" "0"
        , css "margin-top" "0"
        ]
        [ text "Checkbox" ]
      , styled Html.div
        [ cs "mdc-form-field"
        , cs "mdc-form-field--align-end" |> when model.alignEnd
        ]
        [ Checkbox.render Mdl [0] model.mdl
          [ Checkbox.checked |> when model.checked0
          , Checkbox.indeterminate |> when model.indeterminate
          , Checkbox.disabled |> when model.disabled0
          ]
          [
          ]
        , Html.label [] [ text "This is my checkbox" ]
        ]
      , Html.span [] [ text " " ]
      , Html.button
        [ Html.onClick ToggleIndeterminate
        ]
        [ text "Make indeterminate"
        ]
      , Html.span [] [ text " " ]
      , Html.button
        [ Html.onClick ToggleRtl
        ]
        [ text "Toggle RTL"
        ]
      , Html.span [] [ text " " ]
      , Html.button
        [ Html.onClick ToggleAlignEnd
        ]
        [ text "Toggle Align End"
        ]
      , Html.span [] [ text " " ]
      , Html.button
        [ Html.onClick ToggleDisabled0
        ]
        [ text "Toggle Disabled"
        ]
      ]

    , example
      [ Theme.dark
      , css "background-color" "#333"
      ]
      [ styled Html.h2
        [ css "margin-left" "0"
        , css "margin-top" "0"
        , css "color" "white"
        ]
        [ text "Dark Theme"
        ]
      , styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Checkbox.render Mdl [1] model.mdl
          [ Checkbox.checked |> when model.checked1
          , Checkbox.disabled |> when model.disabled1
          ]
          [
          ]
        , Html.label [] [ text "This is my checkbox" ]
        ]
      , Html.span [] [ text " " ]
      , Html.button
        [ Html.onClick ToggleDisabled1
        ]
        [ text "Toggle Disabled"
        ]
      ]
    ]
