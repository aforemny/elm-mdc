module Main exposing (..)

import Html exposing (Html, text)
import Material
import Material.Button as Button
import Material.Options as Options


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


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , subscriptions = subscriptions
        , update = update
        , view = view
        }


init : ( Model, Cmd Msg )
init =
    ( defaultModel, Material.init Mdc )


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
    Html.div []
        [ Button.view Mdc
            "my-button"
            model.mdc
            [ Button.ripple
            , Options.onClick Click
            ]
            [ text "Click me!" ]
        ]
