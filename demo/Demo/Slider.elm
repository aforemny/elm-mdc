module Demo.Slider exposing (Model,defaultModel,Msg(Mdl),update,view)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Material
import Dict exposing (Dict)
import Demo.Page exposing (Page)


type alias Model =
    { mdl : Material.Model
    , values : Dict Int Float
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , values = Dict.empty
    }


type Msg m
    = Mdl (Material.Msg m)


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    div [] []
