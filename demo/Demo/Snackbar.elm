module Demo.Snackbar exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
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
import Material.Options as Options exposing (aria, cs, css, role, styled)
import Material.Snackbar as Snackbar
import Material.TextField as TextField
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    }


type Msg m
    = Mdc (Material.Msg m)
    | Show Material.Index String String
    | Dismiss String
    | NoOp


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        NoOp ->
            ( model, Cmd.none )

        Show idx message label ->
            let
                stacked = idx == "snackbar-stacked"

                contents =
                    let
                        snack =
                            Snackbar.snack
                                (Just (lift (Dismiss "hello")))
                                message
                                label
                    in
                        { snack
                            | dismissOnAction = True
                            , stacked = stacked
                        }
                ( mdc, effects ) =
                    Snackbar.add (lift << Mdc) idx contents model.mdc
            in
            ( { model | mdc = mdc }, effects )

        Dismiss str ->
            ( model, Cmd.none )



snackbarButton lift index mdc buttonLabel message action =
    Button.view (lift << Mdc)
        ( "button-" ++index )
        mdc
        [ Button.raised
        , Options.on "click" (Json.succeed (lift (Show ("snackbar-" ++ index) message action)))
        , css "margin" "8px 16px"
        ]
        [ text buttonLabel
        ]

baselineButton lift mdc =
    snackbarButton lift "baseline" mdc "Baseline" "Can't send photo. Retry in 5 seconds." "Retry"

leadingButton lift mdc =
    snackbarButton lift "leading" mdc "Leading" "Your photo has been archived." "Undo"

stackedButton lift mdc =
    snackbarButton lift "stacked" mdc "Stacked" "This item already has the label \"travel\". You can add a new label." "Add a new label"


baselineSnackbar lift mdc =
    Snackbar.view (lift << Mdc)
        "snackbar-baseline"
        mdc
        [ Snackbar.dismissible
        ]
        []


leadingSnackbar lift mdc =
    Snackbar.view (lift << Mdc)
        "snackbar-leading"
        mdc
        [ Snackbar.dismissible
        , Snackbar.leading
        ]
        []


stackedSnackbar lift mdc =
    Snackbar.view (lift << Mdc)
        "snackbar-stacked"
        mdc
        [ Snackbar.dismissible
        ]
        []


heroComponent =
    styled Html.div
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


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Snackbar"
              , Hero.intro "Snackbars provide brief messages about app processes at the bottom of the screen."
              , Hero.component [] [ heroComponent ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "snackbars" "snackbars" "mdc-snackbar"
        , Page.demos
            [ baselineButton lift model.mdc
            , leadingButton lift model.mdc
            , stackedButton lift model.mdc
            , baselineSnackbar lift model.mdc
            , leadingSnackbar lift model.mdc
            , stackedSnackbar lift model.mdc
            ]
        ]
