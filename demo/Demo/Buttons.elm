module Demo.Buttons exposing (..)

import Html exposing (..)
import Material
import Platform.Cmd exposing (Cmd)


-- MODEL


type alias Index =
    List Int


type Misc
    = Default
    | Ripple
    | Disabled


type Color
    = Plain
    | Colored


type Kind
    = Flat
    | Raised
    | FAB
    | MiniFAB
    | Icon


type alias Model =
    { mdl : Material.Model
    }


model : Model
model =
    { mdl = Material.model
    }



-- ACTION/UPDATE


type Msg
    = Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Mdl msg_ ->
            Material.update Mdl msg_ model


-- VIEW


view : Model -> Html Msg
view model =
    div [] []
