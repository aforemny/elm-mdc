module Demo.Snackbar exposing (Model, defaultModel, Msg(Mdl), update, view)

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
import Demo.Page exposing (Page)


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
    { mdl = Material.defaultModel
    , multiline = False
    , actionOnBottom = False
    , dismissOnAction = True
    , darkTheme = False
    , messageText = "Message deleted"
    , actionText = "Undo"
    }


type Msg m
    = Mdl (Material.Msg m)
    | ToggleMultiline
    | ToggleActionOnBottom
    | ToggleDismissOnAction
    | ToggleDarkTheme
    | SetMessageText String
    | SetActionText String
    | Show (List Int)
    | Dismiss


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model
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
            Snackbar.add (Mdl >> lift) idx contents model
        Dismiss ->
            let
                _ = Debug.log "msg" Dismiss
            in
            model ! []


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    let
        example options =
            styled Html.div
            ( css "display" "block"
            :: css "margin" "24px"
            :: css "padding" "24px"
            :: options
            )
    in
    page.body "Snackbar"
    [
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
          [ Checkbox.render (Mdl >> lift) [0] model.mdl
            [ Options.on "change" (Json.succeed (lift ToggleMultiline))
            , Checkbox.checked |> when model.multiline
            ]
            []
          , Html.label [] [ text "Multiline" ]
          ]
        , Html.br [] []

        , styled Html.div
          [ cs "mdc-form-field"
          ]
          [ Checkbox.render (Mdl >> lift) [1] model.mdl
            [ Options.on "change" (Json.succeed (lift ToggleActionOnBottom))
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
          [ Checkbox.render (Mdl >> lift) [2] model.mdl
            [ Options.on "change" (Json.succeed (lift ToggleDismissOnAction))
            , Checkbox.checked |> when model.dismissOnAction
            ]
            []
          , Html.label [] [ text "Dismiss On Action" ]
          ]
        , Html.br [] []

        , Button.render (Mdl >> lift) [3] model.mdl
          [ Options.on "click" (Json.succeed (lift ToggleDarkTheme))
          , Button.primary
          , Button.raised
          ]
          [ text "Toggle Dark Theme"
          ]
        , Html.br [] []

        , Textfield.render (Mdl >> lift) [4] model.mdl
          [ -- Textfield.defaultValue model.messageText
            -- ^^ TODO
            Textfield.label "Message Text"
          , Options.on "input" (Json.map (SetMessageText >> lift) Html.targetValue)
          ]
          [
          ]
        , Html.br [] []

        , Textfield.render (Mdl >> lift) [5] model.mdl
          [ -- Textfield.defaultValue model.actionText
            -- ^^ TODO
            Textfield.label "Action Text"
          , Options.on "input" (Json.map (SetActionText >> lift) Html.targetValue)
          ]
          [
          ]
        , Html.br [] []

        , Button.render (Mdl >> lift) [6] model.mdl
          [ Button.raised
          , css "margin-top" "14px"
          , Options.on "click" (Json.succeed (lift (Show [10])))
          ]
          [ text "Show"
          ]

        , Button.render (Mdl >> lift) [7] model.mdl
          [ Button.raised
          , css "margin-top" "14px"
          , Options.on "click" (Json.succeed (lift (Show [11])))
          ]
          [ text "Show Rtl"
          ]

        , Button.render (Mdl >> lift) [8] model.mdl
          [ Button.raised
          , css "margin-top" "14px"
          , Options.on "click" (Json.succeed (lift (Show [12])))
          ]
          [ text "Show Start Aligned"
          ]

        , Button.render (Mdl >> lift) [9] model.mdl
          [ Button.raised
          , css "margin-top" "14px"
          , Options.on "click" (Json.succeed (lift (Show [13])))
          ]
          [ text "Show Start Aligned (Rtl)"
          ]

        , Snackbar.render (Mdl >> lift) [10] model.mdl
          [ Snackbar.onDismiss (lift Dismiss)
          ]
          []

        , Html.div
          [ Html.attribute "dir" "rtl"
          ]
          [ Snackbar.render (Mdl >> lift) [11] model.mdl
            [ Snackbar.onDismiss (lift Dismiss)
            ]
            []
          ]

        , Snackbar.render (Mdl >> lift) [12] model.mdl
          [ Snackbar.onDismiss (lift Dismiss)
          , Snackbar.alignStart
          ]
          []

        , Html.div
          [ Html.attribute "dir" "rtl"
          ]
          [ Snackbar.render (Mdl >> lift) [13] model.mdl
            [ Snackbar.onDismiss (lift Dismiss)
            , Snackbar.alignStart
            ]
            []
          ]

        ]
      ]
    ]
