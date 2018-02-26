module Demo.Drawer exposing
    (
      Model
    , defaultModel
    , Msg(Mdl)
    , update
    , view
    , subscriptions
    )

import Demo.Page as Page exposing (Page)
import Html.Attributes as Html
import Html exposing (Html, text)
import Material
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


example : String -> String -> Html m
example label url =
    styled Html.div
    [ css "margin" "24px"
    ]
    [
      styled Html.h2
      [ Typography.headline
      ]
      [ text label
      ]
    ,
      styled Html.p
      [
      ]
      [ Html.a
        [ Html.href url
        , Html.target "_blank"
        ]
        [ text "View in separate window"
        ]
      ]
    ,
      styled Html.iframe
      [ Options.attribute (Html.src ("https://aforemny.github.io/elm-mdc" ++ url))
      , css "height" "600px"
      , css "width" "100vw"
      , css "max-width" "780px"
      ]
      []
    ]


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    page.body "Drawer"
    [
      styled Html.div
      [ css "display" "flex"
      , css "flex-wrap" "wrap"
      ]
      [ example "Temporary Drawer" "/#temporary-drawer"
      , example "Persistent Drawer" "/#persistent-drawer"
      , example "Permanent Drawer above toolbar" "/#permanent-drawer-above"
      , example "Permanent Drawer below toolbar" "/#permanent-drawer-below"
      ]
    ]


subscriptions : (Msg m -> m) -> Model -> Sub m
subscriptions lift model =
    Sub.none
