module Demo.LinearProgress exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.LinearProgress as LinearProgress
import Material.Options exposing (styled)
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    }


type Msg m
    = Mdc (Material.Msg m)


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Linear Progress Indicator"
              , Hero.intro "Progress indicators display the length of a process or express an unspecified wait time."
              , Hero.component []
                  [ LinearProgress.view [ LinearProgress.determinate 0.5 ] []
                  ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "progress-indicators" "linear-progress" "mdc-linear-progress"
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Buffered" ]
            , LinearProgress.view [ LinearProgress.buffered 0.5 0.75 ] []
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Indeterminate" ]
            , LinearProgress.view [ LinearProgress.indeterminate ] []
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Reversed" ]
            , LinearProgress.view
                [ LinearProgress.determinate 0.5
                , LinearProgress.reversed
                ]
                []
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Reversed Buffered" ]
            , LinearProgress.view
                [ LinearProgress.buffered 0.5 0.75
                , LinearProgress.reversed
                ]
                []
            ]
        ]
