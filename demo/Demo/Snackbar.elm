module Demo.Snackbar exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Html.Attributes as Html
import Html.Events as Html
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.Checkbox as Checkbox
import Material.FormField as FormField
import Material.Options as Options exposing (aria, cs, css, nop, role, styled, when)
import Material.Snackbar as Snackbar
import Material.TextField as TextField
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , stacked : Bool
    , dismissOnAction : Bool
    , messageText : String
    , actionText : String
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , stacked = False
    , dismissOnAction = True
    , messageText = "Message deleted"
    , actionText = "Undo"
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleStacked
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

        ToggleStacked ->
            ( { model | stacked = not model.stacked }, Cmd.none )

        ToggleDismissOnAction ->
            ( { model | dismissOnAction = not model.dismissOnAction }, Cmd.none )

        SetMessageText messageText ->
            ( { model | messageText = messageText }, Cmd.none )

        SetActionText actionText ->
            ( { model | actionText = actionText }, Cmd.none )

        Show idx ->
            let
                contents =
                    if model.stacked then
                        let
                            snack =
                                Snackbar.snack
                                    (Just (lift (Dismiss model.messageText)))
                                    model.messageText
                                    model.actionText
                        in
                        { snack
                            | dismissOnAction = model.dismissOnAction
                            , stacked = model.stacked
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
            ( model, Cmd.none )


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    let
        example options =
            styled Html.div
                (css "margin-top" "24px"
                    :: options
                )
    in
    page.body "Snackbar"
        "Snackbars provide brief feedback about an operation through a message at the bottom of the screen."
        [ Page.hero []
            [ styled Html.div
                [ css "position" "relative"
                , css "left" "0"
                , css "transform" "none"
                , cs "mdc-snackbar mdc-snackbar--open"
                ]
                [ styled Html.div
                    [ cs "mdc-snackbar__surface" ]
                    [ styled Html.div
                        [ cs "mdc-snackbar__label"
                        , role "status"
                        , aria "live" "polite"
                        , css "color" "hsla(0,0%,100%,.87)"
                        ]
                        [ text "Can't send photo. Retry in 5 seconds." ]
                    , styled Html.div
                        [ cs "mdc-snackbar__actions" ]
                        [ styled Html.button
                            [ Options.attribute (Html.type_ "button")
                            , cs "mdc-button"
                            , cs "mdc-snackbar__action"
                            ]
                            [ text "Retry"
                            ]
                        , styled Html.button
                            [ cs "mdc-icon-button"
                            , cs "mdc-snackbar__dismiss"
                            , cs "material-icons"
                            ]
                            [ text "close" ]
                        ]
                    ]
                ]
            ]
        , ResourceLink.links (lift << Mdc) model.mdc "snackbars" "snackbars" "mdc-snackbar"
        , Page.demos
            [ example []
                [ styled Html.h2 [ Typography.title ] [ text "Basic Example" ]
                , FormField.view []
                    [ Checkbox.view (lift << Mdc)
                        "snackbar-stacked-checkbox"
                        model.mdc
                        [ Options.onClick (lift ToggleStacked)
                        , Checkbox.checked model.stacked
                        ]
                        []
                    , Html.label [] [ text "Stacked" ]
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
                , TextField.view (lift << Mdc)
                    "snackbar-message-text-field"
                    model.mdc
                    [ TextField.value model.messageText
                    , TextField.label "Message Text"
                    , Options.on "input" (Json.map (lift << SetMessageText) Html.targetValue)
                    ]
                    []
                , Html.br [] []
                , TextField.view (lift << Mdc)
                    "snackbar-action-text-field"
                    model.mdc
                    [ TextField.value model.actionText
                    , TextField.label "Action Text"
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
                    "snackbar-show-button-dismissible"
                    model.mdc
                    [ Button.raised
                    , css "margin-top" "14px"
                    , Options.on "click" (Json.succeed (lift (Show "snackbar-dismissible-snackbar")))
                    ]
                    [ text "Show dismissible"
                    ]
                , text " "
                , Button.view (lift << Mdc)
                    "snackbar-show-button-leading"
                    model.mdc
                    [ Button.raised
                    , css "margin-top" "14px"
                    , Options.on "click" (Json.succeed (lift (Show "snackbar-leading-snackbar")))
                    ]
                    [ text "Show leading"
                    ]
                , text " "
                , Button.view (lift << Mdc)
                    "snackbar-show-button-leading-rtl"
                    model.mdc
                    [ Button.raised
                    , css "margin-top" "14px"
                    , Options.on "click" (Json.succeed (lift (Show "snackbar-leading-snackbar-rtl")))
                    ]
                    [ text "Show leading rtl"
                    ]
                , Snackbar.view (lift << Mdc) "snackbar-default-snackbar" model.mdc [] []
                , Snackbar.view (lift << Mdc)
                    "snackbar-dismissible-snackbar"
                    model.mdc
                    [ Snackbar.dismissible ]
                    []
                , Snackbar.view (lift << Mdc)
                    "snackbar-leading-snackbar"
                    model.mdc
                    [ Snackbar.dismissible
                    , Snackbar.leading
                    ]
                    []
                , Html.div
                    [ Html.attribute "dir" "rtl"
                    ]
                    [ Snackbar.view (lift << Mdc)
                        "snackbar-leading-snackbar-rtl"
                        model.mdc
                        [ Snackbar.dismissible
                        , Snackbar.leading
                        ]
                        []
                    ]
                ]
            ]
        ]
