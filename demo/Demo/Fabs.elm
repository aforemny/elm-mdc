module Demo.Fabs exposing (Model, defaultModel, Msg(Mdl), update, view)

import Html exposing (Html, text)
import Material
import Material.Fab as Fab
import Material.Msg
import Material.Options exposing (css)
import Demo.Page exposing (Page)


type alias Model =
    { mdl : Material.Model
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    }


type Msg m
    = Mdl (Material.Msg.Msg m)


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    let
        fab idx options =
            Fab.render (Mdl >> lift) [idx] model.mdl
                (css "margin" "16px" :: options)
                "favorite_border"
    in
    page.body "Floating action buttons"
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
