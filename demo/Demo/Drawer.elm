module Demo.Drawer exposing
    ( Model
    , Msg(..)
    , defaultModel
    , subscriptions
    , update
    , view
    )

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Html.Attributes as Html
import Material
import Material.Drawer.Permanent as Drawer
import Material.List as Lists
import Material.Options as Options exposing (css, styled)
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
        [ css "display" "inline-block"
        , css "-ms-flex" "1 1 80%"
        , css "flex" "1 1 80%"
        , css "-ms-flex-pack" "distribute"
        , css "justify-content" "space-around"
        , css "min-height" "400px"
        , css "min-width" "400px"
        , css "padding" "15px"
        ]
        [ Html.div
            []
            [ Html.a
                [ Html.href ("." ++ url)
                , Html.target "_blank"
                ]
                [ styled Html.h3
                    [ Typography.subtitle1
                    ]
                    [ text label
                    ]
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


heroComponent lift model =
    Drawer.view (lift << Mdc)
        "permanent-drawer-drawer"
        model.mdc
        []
        [ Drawer.header
              []
              [ styled Html.h3
                    [ Drawer.title ]
                    [ text "Title" ]
              , styled Html.h6
                  [ Drawer.subTitle ]
                  [ text "subtext" ]
              ]
        , Drawer.content []
            [ Lists.ul (lift << Mdc)
                  "permanent-drawer-drawer-list"
                  model.mdc
                  [ Lists.singleSelection
                  , Lists.useActivated
                  ]
                  [ Lists.a
                        [ Options.attribute (Html.href "#drawer")
                        , Lists.activated
                        , Options.css "color" "red"
                        ]
                        [ Lists.graphicIcon [] "inbox"
                        , text "Inbox"
                        ]
                  , Lists.a
                      [ Options.attribute (Html.href "#drawer")
                      ]
                        [ Lists.graphicIcon [] "star"
                        , text "Star"
                        ]
                  , Lists.a
                      [ Options.attribute (Html.href "#drawer")
                      ]
                        [ Lists.graphicIcon [] "send"
                        , text "Sent Mail"
                        ]
                  , Lists.a
                      [ Options.attribute (Html.href "#drawer")
                      ]
                        [ Lists.graphicIcon [] "drafts"
                        , text "Drafts"
                        ]
                  ]
            ]
        ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Drawer"
              , Hero.intro "The navigation drawer slides in from the left and contains the navigation destinations for your app."
              , Hero.component [] [ heroComponent lift model ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "navigation-drawer" "drawers" "mdc-drawer"
        , Page.demos
            [ example "Permanent" "#permanent-drawer"
            , example "Dismissible" "#dismissible-drawer"
            , example "Modal" "#modal-drawer"
            ]
        ]


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Sub.none
