module Demo.Checkbox exposing (Model,defaultModel,Msg(Mdl),update,view)

import Demo.Page as Page exposing (Page)
import Html.Attributes as Html
import Html.Events as Html
import Html exposing (Html, text)
import Material
import Material.Checkbox as Checkbox
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Theme as Theme
import Platform.Cmd exposing (Cmd, none)


type alias Model =
    { mdl : Material.Model
    , rtl : Bool
    , alignEnd : Bool
    , indeterminate : Bool
    , checked0 : Bool
    , checked1 : Bool
    , checked2 : Bool
    , disabled1 : Bool
    , disabled2 : Bool
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , rtl = False
    , alignEnd = False
    , indeterminate = False
    , checked0 = False
    , checked1 = False
    , checked2 = False
    , disabled1 = False
    , disabled2 = False
    }


type Msg m
    = Mdl (Material.Msg m)
    | ToggleRtl
    | ToggleAlignEnd
    | ToggleIndeterminate
    | ToggleChecked0
    | ToggleChecked1
    | ToggleChecked2
    | ToggleDisabled1
    | ToggleDisabled2


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model
        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )
        ToggleAlignEnd ->
            ( { model | alignEnd = not model.alignEnd }, Cmd.none )
        ToggleIndeterminate ->
            ( { model | indeterminate = not model.indeterminate }, Cmd.none )
        ToggleChecked0 ->
            ( { model | checked0 = not model.checked0 }, Cmd.none )
        ToggleChecked1 ->
            ( { model | checked1 = not model.checked1, indeterminate = False }, Cmd.none )
        ToggleChecked2 ->
            ( { model | checked2 = not model.checked2 }, Cmd.none )
        ToggleDisabled1 ->
            ( { model | disabled1 = not model.disabled1 }, Cmd.none )
        ToggleDisabled2 ->
            ( { model | disabled2 = not model.disabled2 }, Cmd.none )


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
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
    page.body "Checkbox"
    [
      Page.hero []
      [
        styled Html.div
        [ cs "mdc-form-field"
        , cs "mdc-form-field--align-end" |> when model.alignEnd
        ]
        [ Checkbox.render (Mdl >> lift) [0] model.mdl
          [ Options.onClick (lift ToggleChecked0)
          , Checkbox.checked |> when model.checked0
          ]
          [
          ]
        , Html.label [] [ text "Checkbox" ]
        ]
      ]

    ,
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
        [ Checkbox.render (Mdl >> lift) [1] model.mdl
          [ Options.onClick (lift ToggleChecked1)
          , Checkbox.checked |> when model.checked1
          , Checkbox.indeterminate |> when model.indeterminate
          , Checkbox.disabled |> when model.disabled1
          ]
          [
          ]
        , Html.label [] [ text "This is my checkbox" ]
        ]
      , Html.span [] [ text " " ]
      , Html.button
        [ Html.onClick (lift ToggleIndeterminate)
        ]
        [ text "Make indeterminate"
        ]
      , Html.span [] [ text " " ]
      , Html.button
        [ Html.onClick (lift ToggleRtl)
        ]
        [ text "Toggle RTL"
        ]
      , Html.span [] [ text " " ]
      , Html.button
        [ Html.onClick (lift ToggleAlignEnd)
        ]
        [ text "Toggle Align End"
        ]
      , Html.span [] [ text " " ]
      , Html.button
        [ Html.onClick (lift ToggleDisabled1)
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
        [ Checkbox.render (Mdl >> lift) [2] model.mdl
          [ Options.onClick (lift ToggleChecked2)
          , Checkbox.checked |> when model.checked2
          , Checkbox.disabled |> when model.disabled2
          ]
          [
          ]
        , Html.label [] [ text "This is my checkbox" ]
        ]
      , Html.span [] [ text " " ]
      , Html.button
        [ Html.onClick (lift ToggleDisabled2)
        ]
        [ text "Toggle Disabled"
        ]
      ]
    ]
