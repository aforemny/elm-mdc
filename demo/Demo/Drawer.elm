module Demo.Drawer exposing
    ( Model
    , Msg(..)
    , defaultModel
    , subscriptions
    , update
    , view
    )

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text, p)
import Html.Attributes as Html
import Material
import Material.Options as Options exposing (cs, css, styled, when)
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


example : String -> String -> Html m
example label url =
    styled Html.div
        [ css "margin" "24px"
        ]
        [ styled Html.h2
            [ Typography.headline
            ]
            [ text label
            ]
        , styled Html.p
            []
            [ Html.a
                [ Html.href ("." ++ url)
                , Html.target "_blank"
                ]
                [ text "View in separate window"
                ]
            ]
        , styled Html.iframe
            [ Options.attribute (Html.src ("./index.html" ++ url))
            , css "height" "400px"
            , css "width" "100vw"
            , css "max-width" "780px"
            ]
            []
        ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body "Drawer"
        [ Page.header "Drawer"
        , styled p [ Typography.body1 ]
            [ text "The navigation drawer slides in from the left and contains the navigation destinations for your app."]
        , styled Html.div
            [ css "display" "inline-block"
            , css "flex" "1 1 80%"
            , css "min-width" "400px"
            , css "margin-left" "auto"
            , css "margin-right" "auto"
            ]
            [ example "Drawer" "#permanent-drawer"
            , example "Dismissible Drawer" "#dismissible-drawer"
            , example "Modal Drawer" "#modal-drawer"
            ]
        ]


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Sub.none
