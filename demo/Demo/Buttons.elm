module Demo.Buttons exposing (Model,defaultModel,Msg(Mdc),update,view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.Button as Button
import Material.Options as Options exposing (styled, cs, css, when)
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

        outlinedButtons idx =
            example idx "Outlined Button"
            [ Button.outlined
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
              [
                Button.view (lift << Mdc) (idx ++ [0]) model.mdc
                ( options
                )
                [ text "Baseline" ]
              ,
                Button.view (lift << Mdc) (idx ++ [2]) model.mdc
                ( Button.dense
                :: options
                )
                [ text "Dense" ]
              ,
                Button.view (lift << Mdc) (idx ++ [3]) model.mdc
                ( cs "secondary-button"
                :: options
                )
                [ text "Secondary" ]
              ,
                Button.view (lift << Mdc) (idx ++ [4]) model.mdc
                ( Button.icon "favorite"
                :: options
                )
                [ text "Icon" ]
              ,
                Button.view (lift << Mdc) (idx ++ [5]) model.mdc
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
      [ Button.view (lift << Mdc) [0,0] model.mdc
        [ Button.ripple
        , css "margin-right" "32px"
        ]
        [ text "Flat"
        ]
      , Button.view (lift << Mdc) [0,1] model.mdc
        [ Button.ripple
        , Button.raised
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
      , outlinedButtons [4]
      ]
    ]
