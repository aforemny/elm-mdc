module Main exposing (..)

import Browser
import Html exposing (Html, text)
import Material
import Material.Button as Button
import Material.Options as Options exposing (css, styled)


type alias Model =
    { mdc : Material.Model Msg
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    }


type Msg
    = Mdc (Material.Msg Msg)
    | Click


main : Program () Model Msg
main =
    Browser.element
        { init = \_ -> init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( defaultModel, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Material.subscriptions Mdc model


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdc msg_ ->
            Material.update Mdc msg_ model

        Click ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    styled Html.div [ css "padding" "1em" ]
        [ Button.view Mdc
            "my-button"
            model.mdc
            [ Button.ripple
            , Button.raised
            , Options.onClick Click
            ]
            [ text "Click me!" ]
        ]
