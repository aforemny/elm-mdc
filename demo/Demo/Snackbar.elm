module Demo.Snackbar exposing (Model, Msg(Mdc), defaultModel, update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Html.Attributes as Html
import Html.Events as Html
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.Checkbox as Checkbox
import Material.FormField as FormField
import Material.Options as Options exposing (cs, css, nop, styled, when)
import Material.Snackbar as Snackbar
import Material.Textfield as Textfield
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , multiline : Bool
    , actionOnBottom : Bool
    , dismissOnAction : Bool
    , messageText : String
    , actionText : String
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , multiline = False
    , actionOnBottom = False
    , dismissOnAction = True
    , messageText = "Message deleted"
    , actionText = "Undo"
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleMultiline
    | ToggleActionOnBottom
    | ToggleDismissOnAction
    | SetMessageText String
    | SetActionText String
    | Show Material.Index
    | Dismiss String
    | NoOp


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        NoOp ->
            ( model, Cmd.none )

        ToggleMultiline ->
            ( { model | multiline = not model.multiline }, Cmd.none )

        ToggleActionOnBottom ->
            ( { model | actionOnBottom = not model.actionOnBottom }, Cmd.none )

        ToggleDismissOnAction ->
            ( { model | dismissOnAction = not model.dismissOnAction }, Cmd.none )

        SetMessageText messageText ->
            ( { model | messageText = messageText }, Cmd.none )

        SetActionText actionText ->
            ( { model | actionText = actionText }, Cmd.none )

        Show idx ->
            let
                contents =
                    if model.multiline then
                        let
                            snack =
                                Snackbar.snack
                                    (Just (lift (Dismiss model.messageText)))
                                    model.messageText
                                    model.actionText
                        in
                        { snack
                            | dismissOnAction = model.dismissOnAction
                            , actionOnBottom = model.actionOnBottom
                        }
                    else
                        let
                            toast =
                                Snackbar.toast
                                    (Just (lift (Dismiss model.messageText)))
                                    model.messageText
                        in
                        { toast
                            | dismissOnAction = model.dismissOnAction
                            , action = Just "Hide"
                        }

                ( mdc, effects ) =
                    Snackbar.add (lift << Mdc) idx contents model.mdc
            in
            ( { model | mdc = mdc }, effects )

        Dismiss str ->
            let
                _ =
                    Debug.log "Dismiss" str
            in
            ( model, Cmd.none )


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    let
        example options =
            styled Html.div
                (css "display" "block"
                    :: css "margin" "24px"
                    :: css "padding" "24px"
                    :: options
                )
    in
    page.body "Snackbar"
        [ Page.hero []
            [ styled Html.div
                [ css "position" "relative"
                , css "left" "0"
                , css "transform" "none"
                , cs "mdc-snackbar mdc-snackbar--active"
                ]
                [ styled Html.div [ cs "mdc-snackbar__text" ] [ text "Message sent" ]
                , styled Html.div
                    [ cs "mdc-snackbar__action-wrapper" ]
                    [ styled Html.button
                        [ Options.attribute (Html.type_ "button")
                        , cs "mdc-snackbar__action-button"
                        ]
                        [ text "Undo"
                        ]
                    ]
                ]
            ]
        , styled Html.div
            []
            [ example []
                [ styled Html.h2 [ Typography.title ] [ text "Basic Example" ]
                , FormField.view []
                    [ Checkbox.view (lift << Mdc)
                        "snackbar-multiline-checkbox"
                        model.mdc
                        [ Options.onClick (lift ToggleMultiline)
                        , Checkbox.checked model.multiline
                        ]
                        []
                    , Html.label [] [ text "Multiline" ]
                    ]
                , Html.br [] []
                , FormField.view []
                    [ Checkbox.view (lift << Mdc)
                        "snackbar-toggle-action-on-bottom-checkbox"
                        model.mdc
                        [ Options.onClick (lift ToggleActionOnBottom)
                        , when (not model.multiline)
                            << Options.many
                          <|
                            [ Checkbox.checked model.actionOnBottom
                            , Checkbox.disabled
                            ]
                        ]
                        []
                    , Html.label [] [ text "Action on Bottom" ]
                    ]
                , Html.br [] []
                , FormField.view []
                    [ Checkbox.view (lift << Mdc)
                        "snackbar-dismiss-on-action-button"
                        model.mdc
                        [ Options.onClick (lift ToggleDismissOnAction)
                        , Checkbox.checked model.dismissOnAction
                        ]
                        []
                    , Html.label [] [ text "Dismiss On Action" ]
                    ]
                , Html.br [] []
                , Textfield.view (lift << Mdc)
                    "snackbar-message-text-field"
                    model.mdc
                    [ Textfield.value model.messageText
                    , Textfield.label "Message Text"
                    , Options.on "input" (Json.map (lift << SetMessageText) Html.targetValue)
                    ]
                    []
                , Html.br [] []
                , Textfield.view (lift << Mdc)
                    "snackbar-action-text-field"
                    model.mdc
                    [ Textfield.value model.actionText
                    , Textfield.label "Action Text"
                    , Options.on "input" (Json.map (lift << SetActionText) Html.targetValue)
                    ]
                    []
                , Html.br [] []
                , Button.view (lift << Mdc)
                    "snackbar-show-button"
                    model.mdc
                    [ Button.raised
                    , css "margin-top" "14px"
                    , Options.on "click" (Json.succeed (lift (Show "snackbar-default-snackbar")))
                    ]
                    [ text "Show"
                    ]
                , text " "
                , Button.view (lift << Mdc)
                    "snackbar-show-button-rtl"
                    model.mdc
                    [ Button.raised
                    , css "margin-top" "14px"
                    , Options.on "click" (Json.succeed (lift (Show "snackbar-default-snackbar-rtl")))
                    ]
                    [ text "Show Rtl"
                    ]
                , text " "
                , Button.view (lift << Mdc)
                    "snackbar-show-start-aligned-button"
                    model.mdc
                    [ Button.raised
                    , css "margin-top" "14px"
                    , Options.on "click" (Json.succeed (lift (Show "snackbar-align-start-snackbar")))
                    ]
                    [ text "Show Start Aligned"
                    ]
                , text " "
                , Button.view (lift << Mdc)
                    "snackbar-show-start-aligned-button-rtl"
                    model.mdc
                    [ Button.raised
                    , css "margin-top" "14px"
                    , Options.on "click" (Json.succeed (lift (Show "snackbar-align-start-snackbar-rtl")))
                    ]
                    [ text "Show Start Aligned (Rtl)"
                    ]
                , Snackbar.view (lift << Mdc) "snackbar-default-snackbar" model.mdc [] []
                , Html.div
                    [ Html.attribute "dir" "rtl"
                    ]
                    [ Snackbar.view (lift << Mdc) "snackbar-default-snackbar-rtl" model.mdc [] []
                    ]
                , Snackbar.view (lift << Mdc)
                    "snackbar-align-start-snackbar"
                    model.mdc
                    [ Snackbar.alignStart
                    ]
                    []
                , Html.div
                    [ Html.attribute "dir" "rtl"
                    ]
                    [ Snackbar.view (lift << Mdc)
                        "snackbar-align-start-snackbar-rtl"
                        model.mdc
                        [ Snackbar.alignStart
                        ]
                        []
                    ]
                ]
            ]
        ]
