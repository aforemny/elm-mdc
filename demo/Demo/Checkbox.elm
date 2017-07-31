module Demo.Checkbox exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Material.Toggles as Toggles
import Material


-- MODEL


type alias Model =
    { mdl : Material.Model
    }


model : Model
model =
    { mdl = Material.model
    }


type Msg
    = Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model


-- VIEW


view : Model -> Html Msg
view model =
    div []
    [ Toggles.checkbox Mdl [0] model.mdl
      [
      ]
      [ text "Switch"
      ]
    ]
