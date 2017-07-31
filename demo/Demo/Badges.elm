module Demo.Badges exposing (..)

import Html exposing (..)
import Platform.Cmd exposing (Cmd)
import Material


type Msg
    = Mdl (Material.Msg Msg)


type alias Model =
    { mdl : Material.Model
    }


model : Model
model =
    { mdl = Material.model
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


view : Model -> Html Msg
view model =
    div [] []
