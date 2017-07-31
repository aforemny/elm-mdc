module Demo.Fabs exposing (Model, model, Msg, update, view)


import Html exposing (Html, text)
import Material
import Material.Fab as Fab
import Material.Msg
import Material.Options exposing (css)


-- MODEL


type alias Model =
    { mdl : Material.Model
    }


model : Model
model =
    { mdl = Material.model
    }


type Msg
    = Mdl (Material.Msg.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model


-- VIEW

view : Model -> Html Msg
view model =
    let
        fab idx options =
            Fab.render Mdl [idx] model.mdl (css "margin" "16px" :: options) "favorite_border"
    in
    Html.div []
    [
      Html.section []
      [ Html.fieldset []
        [ Html.legend [] [ text "Normal FABs" ]
        , fab 0 []
        , fab 1 [ Fab.mini ]
        , fab 2 [ Fab.plain ]
        , fab 3 [ Fab.plain, Fab.mini ]
        ]

      , Html.fieldset []
        [ Html.legend [] [ text "Disabled FABs" ]
        , fab 4 [ Fab.disabled ]
        , fab 5 [ Fab.disabled, Fab.mini ]
        , fab 6 [ Fab.disabled, Fab.plain ]
        , fab 7 [ Fab.disabled, Fab.plain, Fab.mini ]
        ]
      ]
    ]
