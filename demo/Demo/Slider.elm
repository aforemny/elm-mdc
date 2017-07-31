module Demo.Slider exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Material.Slider as Slider
import Material
import Material.Grid as Grid
import Material.Options as Options exposing (css)
import Dict exposing (Dict)


-- MODEL


type alias Model =
    { mdl : Material.Model
    , values : Dict Int Float
    }


model : Model
model =
    { mdl = Material.model
    , values = Dict.empty
    }



-- ACTION, UPDATE


type Msg
    = Slider Int Float
    | Mdl (Material.Msg Msg)


get : Int -> Dict Int Float -> Float
get key dict =
    Dict.get key dict |> Maybe.withDefault 0


getDef : Int -> Float -> Dict Int Float -> Float
getDef key def dict =
    Dict.get key dict |> Maybe.withDefault def


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Slider idx value ->
            let
                values =
                    Dict.insert idx value model.values
            in
                ( { model | values = values }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


view : Model -> Html Msg
view model =
    div [] []
