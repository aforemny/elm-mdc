module Demo.Switch exposing (..)

import Html exposing (Html, text)
import Material
import Material.Switch as Switch
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Theme as Theme
import Platform.Cmd exposing (Cmd, none)


-- MODEL


type alias Model =
    { mdl : Material.Model
    , on0 : Bool
    , on1 : Bool
    }


model : Model
model =
    { mdl = Material.model
    , on0 = False
    , on1 = False
    }


type Msg
    = Mdl (Material.Msg Msg)
    | ToggleOn0
    | ToggleOn1


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model
        ToggleOn0 ->
            { model | on0 = not model.on0 } ! []
        ToggleOn1 ->
            { model | on1 = not model.on1 } ! []


-- VIEW


view : Model -> Html Msg
view model =
    let
        example options =
            styled Html.div
            ( cs "example"
            :: css "display" "block"
            :: css "margin" "16px"
            :: css "padding" "40px"
            :: options
            )
    in
    Html.div []
    [
      example
      [ css "background-color" "#eee"
      ]
      [ styled Html.h2
        [ css "margin-left" "0"
        , css "margin-top" "0"
        ]
        [ text "Switch on Light Theme" ]
      , styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Switch.render Mdl [0] model.mdl
          [ Options.onClick ToggleOn0
          , Switch.on |> when model.on0
          ]
          [
          ]
        , Html.label [] [ text "off/on" ]
        ]
      ]

    , example
      [ css "background-color" "#eee"
      ]
      [ styled Html.h2
        [ css "margin-left" "0"
        , css "margin-top" "0"
        ]
        [ text "Switch on Light Theme - Disabled" ]
      , styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Switch.render Mdl [2] model.mdl
          [ Switch.disabled
          ]
          [
          ]
        , Html.label [] [ text "off/on" ]
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
        [ text "Switch on Dark Theme" ]
      , styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Switch.render Mdl [1] model.mdl
          [ Options.onClick ToggleOn1
          , Switch.on |> when model.on1
          ]
          [
          ]
        , Html.label [] [ text "off/on" ]
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
        [ text "Switch on Dark Theme - Disabled" ]
      , styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Switch.render Mdl [3] model.mdl
          [ Switch.disabled
          ]
          [
          ]
        , Html.label [] [ text "off/on" ]
        ]
      ]
    ]
