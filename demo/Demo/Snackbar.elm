module Demo.Snackbar exposing (Model, defaultModel, Msg(Mdl), update, view)

import Demo.Page as Page exposing (Page)
import Html.Attributes as Html
import Html.Events as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.Checkbox as Checkbox
import Material.Options as Options exposing (styled, cs, css, nop, when)
import Material.Snackbar as Snackbar
import Material.Textfield as Textfield
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model =
    { mdl : Material.Model
    , multiline : Bool
    , actionOnBottom : Bool
    , dismissOnAction : Bool
    , messageText : String
    , actionText : String
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , multiline = False
    , actionOnBottom = False
    , dismissOnAction = True
    , messageText = "Message deleted"
    , actionText = "Undo"
    }


type Msg m
    = Mdl (Material.Msg m)
    | ToggleMultiline
    | ToggleActionOnBottom
    | ToggleDismissOnAction
    | SetMessageText String
    | SetActionText String
    | Show (List Int)
    | Dismiss
    | NoOp


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model
        NoOp ->
            ( model, Cmd.none )
        ToggleMultiline ->
            ( { model | multiline = not model.multiline }, Cmd.none )
        ToggleActionOnBottom ->
            ( { model | actionOnBottom = not model.actionOnBottom }, Cmd.none )
        ToggleDismissOnAction ->
            ( { model | dismissOnAction = not model.dismissOnAction }, Cmd.none )
        SetMessageText messageText  ->
            ( { model | messageText = messageText }, Cmd.none )
        SetActionText actionText  ->
            ( { model | actionText = actionText }, Cmd.none )
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
                            , actionOnBottom = model.actionOnBottom
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
            ( model, Cmd.none )


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

      Page.hero []
      [
        let
            demoSnackbar =
                let
                    def =
                        Snackbar.defaultModel

                    snack =
                        Snackbar.snack "Message sent" "Undo"

                    contents =
                        { snack
                            | multiline = False
                        }
                in
                { def
                    | queue = []
                    , state = Snackbar.Active contents
                    , seq = 0
                }
        in
        Snackbar.view (always (lift NoOp)) demoSnackbar
        [ css "position" "relative"
        , css "left" "0"
        , css "transform" "none"
        ]
        []
      ]

    ,
      styled Html.div []
      [
        example []
        [
          styled Html.h2 [ Typography.title ] [ text "Basic Example" ]
        ,
          styled Html.div
          [ cs "mdc-form-field"
          ]
          [ Checkbox.render (Mdl >> lift) [0] model.mdl
            [ Options.onClick (lift ToggleMultiline)
            , Checkbox.checked |> when model.multiline
            ]
            []
          , Html.label [] [ text "Multiline" ]
          ]
        ,
          Html.br [] []
        ,
          styled Html.div
          [ cs "mdc-form-field"
          ]
          [ Checkbox.render (Mdl >> lift) [1] model.mdl
            [ Options.onClick (lift ToggleActionOnBottom)
            , Checkbox.checked |> when model.actionOnBottom
            , Checkbox.disabled |> when (not model.multiline)
            ]
            []
          , Html.label [] [ text "Action on Bottom" ]
          ]
        ,
          Html.br [] []
        ,
          styled Html.div
          [ cs "mdc-form-field"
          ]
          [ Checkbox.render (Mdl >> lift) [2] model.mdl
            [ Options.onClick (lift ToggleDismissOnAction)
            , Checkbox.checked |> when model.dismissOnAction
            ]
            []
          , Html.label [] [ text "Dismiss On Action" ]
          ]
        ,
          Html.br [] []
        ,
          Textfield.render (Mdl >> lift) [3] model.mdl
          [ Textfield.value model.messageText
          , Textfield.label "Message Text"
          , Options.on "input" (Json.map (SetMessageText >> lift) Html.targetValue)
          ]
          [
          ]
        ,
          Html.br [] []
        ,
          Textfield.render (Mdl >> lift) [4] model.mdl
          [ Textfield.value model.actionText
          , Textfield.label "Action Text"
          , Options.on "input" (Json.map (SetActionText >> lift) Html.targetValue)
          ]
          [
          ]
        ,
          Html.br [] []
        ,
          Button.render (Mdl >> lift) [5] model.mdl
          [ Button.raised
          , css "margin-top" "14px"
          , Options.on "click" (Json.succeed (lift (Show [9])))
          ]
          [ text "Show"
          ]
        ,
          text " "
        ,
          Button.render (Mdl >> lift) [6] model.mdl
          [ Button.raised
          , css "margin-top" "14px"
          , Options.on "click" (Json.succeed (lift (Show [10])))
          ]
          [ text "Show Rtl"
          ]
        ,
          text " "
        ,
          Button.render (Mdl >> lift) [7] model.mdl
          [ Button.raised
          , css "margin-top" "14px"
          , Options.on "click" (Json.succeed (lift (Show [11])))
          ]
          [ text "Show Start Aligned"
          ]
        ,
          text " "
        ,
          Button.render (Mdl >> lift) [8] model.mdl
          [ Button.raised
          , css "margin-top" "14px"
          , Options.on "click" (Json.succeed (lift (Show [12])))
          ]
          [ text "Show Start Aligned (Rtl)"
          ]
        ,
          Snackbar.render (Mdl >> lift) [9] model.mdl
          [ Snackbar.onDismiss (lift Dismiss)
          ]
          []
        ,
          Html.div
          [ Html.attribute "dir" "rtl"
          ]
          [ Snackbar.render (Mdl >> lift) [10] model.mdl
            [ Snackbar.onDismiss (lift Dismiss)
            ]
            []
          ]

        , Snackbar.render (Mdl >> lift) [11] model.mdl
          [ Snackbar.onDismiss (lift Dismiss)
          , Snackbar.alignStart
          ]
          []

        , Html.div
          [ Html.attribute "dir" "rtl"
          ]
          [ Snackbar.render (Mdl >> lift) [12] model.mdl
            [ Snackbar.onDismiss (lift Dismiss)
            , Snackbar.alignStart
            ]
            []
          ]
        ]
      ]
    ]
