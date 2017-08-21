module Demo.Fabs exposing (Model, defaultModel, Msg(Mdl), update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.Fab as Fab
import Material.Msg
import Material.Options exposing (styled, css)


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
                ( Fab.ripple
                :: css "margin" "16px"
                :: options
                )
                "favorite_border"

        legend options =
            styled Html.div
            ( css "padding" "64px 16px 24px"
            :: options
            )
    in
    page.body "Floating action buttons"
    [
      Page.hero []
      [
        fab 0 []
      ]

    ,
      Html.section []
      [ Html.div []
        [ legend [] [ text "Normal FABs" ]
        , fab 1 []
        , fab 2 [ Fab.mini ]
        , fab 3 [ Fab.plain ]
        , fab 4 [ Fab.plain, Fab.mini ]
        ]

      , Html.div []
        [ legend [] [ text "Disabled FABs" ]
        , fab 5 [ Fab.disabled ]
        , fab 6 [ Fab.disabled, Fab.mini ]
        , fab 7 [ Fab.disabled, Fab.plain ]
        , fab 8 [ Fab.disabled, Fab.plain, Fab.mini ]
        ]
      ]
    ]
