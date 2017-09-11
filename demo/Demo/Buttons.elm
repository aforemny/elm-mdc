module Demo.Buttons exposing (Model,defaultModel,Msg(Mdl),update,view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.Button as Button
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Typography as Typography


type alias Model =
    { mdl : Material.Model
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
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
    let
        textButtons idx =
            example idx "Text Button"
            [ Button.ripple
            , css "margin" "16px"
            ]

        raisedButtons idx =
            example idx "Raised Button"
            [ Button.raised
            , Button.ripple
            , css "margin" "16px"
            ]

        unelevatedButtons idx =
            example idx "Unelevated Button"
            [ Button.unelevated
            , Button.ripple
            , css "margin" "16px"
            ]

        strokedButtons idx =
            example idx "Stroked Button"
            [ Button.stroked
            , Button.ripple
            , css "margin" "16px"
            ]

        example idx title options =
            styled Html.div
            [ css "padding" "0 24px 16px"
            ]
            [ styled Html.div
              [ Typography.title
              , css "padding" "48px 16px 24px"
              ]
              [ text title
              ]
            , styled Html.div []
              [ Button.render (Mdl >> lift) (idx ++ [0]) model.mdl
                ( options
                )
                [ text "Baseline" ]
              , Button.render (Mdl >> lift) (idx ++ [1]) model.mdl
                ( Button.compact
                :: options
                )
                [ text "Compact" ]
              , Button.render (Mdl >> lift) (idx ++ [2]) model.mdl
                ( Button.dense
                :: options
                )
                [ text "Dense" ]
              , Button.render (Mdl >> lift) (idx ++ [3]) model.mdl
                ( Button.primary
                :: options
                )
                [ text "Primary" ]
              , Button.render (Mdl >> lift) (idx ++ [4]) model.mdl
                ( Button.secondary
                :: options
                )
                [ text "Secondary" ]
              , Button.render (Mdl >> lift) (idx ++ [6]) model.mdl
                ( Button.link "#buttons"
                :: options
                )
                [ text "Link" ]
              ]
            ]
    in
    page.body "Buttons"
    [
      Page.hero []
      [ Button.render (Mdl >> lift) [0,0] model.mdl
        [ Button.ripple
        , css "margin-right" "32px"
        ]
        [ text "Flat"
        ]
      , Button.render (Mdl >> lift) [0,1] model.mdl
        [ Button.ripple
        , Button.raised
        , Button.primary
        , css "margin-left" "32px"
        ]
        [ text "Raised"
        ]
      ]
    ,
      styled Html.div
      [ cs "demo-wrapper"
      ]
      [ styled Html.h1
        [ Typography.display2
        , css "padding-left" "36px"
        , css "padding-top" "64px"
        , css "padding-bottom" "8px"
        ]
        [ text "Ripple Enabled"
        ]

      , textButtons [1]
      , raisedButtons [2]
      , unelevatedButtons [3]
      , strokedButtons [4]
      ]
    ]
