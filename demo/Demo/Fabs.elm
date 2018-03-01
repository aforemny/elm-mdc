module Demo.Fabs exposing (Model, defaultModel, Msg(Mdc), update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.Fab as Fab
import Material.Msg
import Material.Options exposing (styled, css)


type alias Model =
    { mdc : Material.Model
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    }


type Msg m
    = Mdc (Material.Msg.Msg m)


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (Mdc >> lift) msg_ model


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    let
        fab idx options =
            Fab.render (Mdc >> lift) [idx] model.mdc
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
    page.body "Floating Action Button"
    [
      Page.hero [] [ fab 0 [] ]
    ,
      Html.section []
      [ Html.div []
        [
          legend [] [ text "FABs" ]
        , fab 1 []
        , fab 2 [ Fab.mini ]
        ]
      ]
    ]
