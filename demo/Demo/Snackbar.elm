module Demo.Snackbar exposing (Model, defaultModel, Msg, update, view)

import Html.Attributes as Html
import Html.Events as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.Options as Options exposing (styled, cs, css, nop, when)
import Material.Snackbar as Snackbar
import Material.Textfield as Textfield
import Material.Theme as Theme
import Material.Checkbox as Checkbox
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model =
    { mdl : Material.Model
    , multiline : Bool
    , actionOnBottom : Bool
    , dismissOnAction : Bool
    , darkTheme : Bool
    , messageText : String
    , actionText : String
    }


defaultModel : Model
defaultModel =
    { mdl = Material.model
    , multiline = False
    , actionOnBottom = False
    , dismissOnAction = True
    , darkTheme = False
    , messageText = "Message deleted"
    , actionText = "Undo"
    }


type Msg
    = Mdl (Material.Msg Msg)
    | ToggleMultiline
    | ToggleActionOnBottom
    | ToggleDismissOnAction
    | ToggleDarkTheme
    | SetMessageText String
    | SetActionText String
    | Show (List Int)
    | Dismiss


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model
        ToggleMultiline ->
            { model | multiline = not model.multiline } ! []
        ToggleActionOnBottom ->
            { model | actionOnBottom = not model.actionOnBottom } ! []
        ToggleDismissOnAction ->
            { model | dismissOnAction = not model.dismissOnAction } ! []
        ToggleDarkTheme ->
            { model | darkTheme = not model.darkTheme } ! []
        SetMessageText messageText  ->
            { model | messageText = messageText } ! []
        SetActionText actionText  ->
            { model | actionText = actionText } ! []
        Show idx ->
            let
                contents =
                    if model.multiline then
                        let
                            snack =
                                Snackbar.snack model.messageText model.actionText
                        in
                        { snack
                            | dismissOnAction = model.dismissOnAction
                        }
                    else
                        let
                            toast =
                                Snackbar.toast model.messageText
                        in
                        { toast
                            | dismissOnAction = model.dismissOnAction
                            , action = Just "Hide"
                        }
            in
            Snackbar.add Mdl idx contents model
        Dismiss ->
            let
                _ = Debug.log "msg" Dismiss
            in
            model ! []


view : Model -> Html Msg
view model =
    let
        example options =
            styled Html.div
            ( css "display" "block"
            :: css "margin" "24px"
            :: css "padding" "24px"
            :: options
            )
    in
    styled Html.div
    [ when model.darkTheme << Options.many <|
      [ Theme.dark
      , css "background-color" "#333"
      ]
    ]
    [ example []
      [
        styled Html.h2 [ Typography.title ] [ text "Basic Example" ]

      , styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Checkbox.render Mdl [0] model.mdl
          [ Options.on "change" (Json.succeed ToggleMultiline)
          , Checkbox.checked |> when model.multiline
          ]
          []
        , Html.label [] [ text "Multiline" ]
        ]
      , Html.br [] []

      , styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Checkbox.render Mdl [1] model.mdl
          [ Options.on "change" (Json.succeed ToggleActionOnBottom)
          , Checkbox.checked |> when model.actionOnBottom
          , when (not model.multiline) <|
            Checkbox.disabled
          ]
          []
        , Html.label [] [ text "Action on Bottom" ]
        ]
      , Html.br [] []

      , styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Checkbox.render Mdl [2] model.mdl
          [ Options.on "change" (Json.succeed ToggleDismissOnAction)
          , Checkbox.checked |> when model.dismissOnAction
          ]
          []
        , Html.label [] [ text "Dismiss On Action" ]
        ]
      , Html.br [] []

      , Button.render Mdl [3] model.mdl
        [ Options.on "click" (Json.succeed ToggleDarkTheme)
        , Button.primary
        , Button.raised
        ]
        [ text "Toggle Dark Theme"
        ]
      , Html.br [] []

      , Textfield.render Mdl [4] model.mdl
        [ -- Textfield.defaultValue model.messageText
          -- ^^ TODO
          Textfield.label "Message Text"
        , Options.on "input" (Json.map SetMessageText Html.targetValue)
        ]
        [
        ]
      , Html.br [] []

      , Textfield.render Mdl [5] model.mdl
        [ -- Textfield.defaultValue model.actionText
          -- ^^ TODO
          Textfield.label "Action Text"
        , Options.on "input" (Json.map SetActionText Html.targetValue)
        ]
        [
        ]
      , Html.br [] []

      , Button.render Mdl [6] model.mdl
        [ Button.raised
        , css "margin-top" "14px"
        , Options.on "click" (Json.succeed (Show [10]))
        ]
        [ text "Show"
        ]

      , Button.render Mdl [7] model.mdl
        [ Button.raised
        , css "margin-top" "14px"
        , Options.on "click" (Json.succeed (Show [11]))
        ]
        [ text "Show Rtl"
        ]

      , Button.render Mdl [8] model.mdl
        [ Button.raised
        , css "margin-top" "14px"
        , Options.on "click" (Json.succeed (Show [12]))
        ]
        [ text "Show Start Aligned"
        ]

      , Button.render Mdl [9] model.mdl
        [ Button.raised
        , css "margin-top" "14px"
        , Options.on "click" (Json.succeed (Show [13]))
        ]
        [ text "Show Start Aligned (Rtl)"
        ]

      , Snackbar.render Mdl [10] model.mdl
        [ Snackbar.onDismiss Dismiss
        ]
        []

      , Html.div
        [ Html.attribute "dir" "rtl"
        ]
        [ Snackbar.render Mdl [11] model.mdl
          [ Snackbar.onDismiss Dismiss
          ]
          []
        ]

      , Snackbar.render Mdl [12] model.mdl
        [ Snackbar.onDismiss Dismiss
        , Snackbar.alignStart
        ]
        []

      , Html.div
        [ Html.attribute "dir" "rtl"
        ]
        [ Snackbar.render Mdl [13] model.mdl
          [ Snackbar.onDismiss Dismiss
          , Snackbar.alignStart
          ]
          []
        ]

      ]
    ]
