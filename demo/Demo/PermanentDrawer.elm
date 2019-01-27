module Demo.PermanentDrawer exposing
    ( Model
    , Msg(..)
    , defaultModel
    , drawerHeader
    , drawerItems
    , mainContent
    , subscriptions
    , update
    , view
    )

import Demo.Page exposing (Page)
import Html exposing (Html, div, h3, h6, text)
import Html.Attributes as Html
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.Drawer.Permanent as Drawer
import Material.Icon as Icon
import Material.List as Lists
import Material.Options as Options exposing (cs, css, styled, when)
import Material.TopAppBar as TopAppBar
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , rtl : Bool
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , rtl = False
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleRtl


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )


drawerHeader : Html m
drawerHeader =
    Drawer.header
        []
        [ styled h3
            [ Drawer.title ]
            [ text "Mail" ]
        , styled h6
            [ Drawer.subTitle ]
            [ text "email@material.io" ]
        ]


drawerItems : Html m
drawerItems =
    Drawer.content []
        [ Lists.nav []
            [ Lists.a
                [ Options.attribute (Html.href "#persistent-drawer")
                , Lists.activated
                ]
                [ Lists.graphicIcon [] "inbox"
                , text "Inbox"
                ]
            , Lists.a
                [ Options.attribute (Html.href "#persistent-drawer")
                ]
                [ Lists.graphicIcon [] "star"
                , text "Star"
                ]
            , Lists.a
                [ Options.attribute (Html.href "#persistent-drawer")
                ]
                [ Lists.graphicIcon [] "send"
                , text "Sent Mail"
                ]
            , Lists.a
                [ Options.attribute (Html.href "#persistent-drawer")
                ]
                [ Lists.graphicIcon [] "drafts"
                , text "Drafts"
                ]
            , Lists.divider [] []
            , styled h6 [ cs "mdc-list-group__subheader" ] [ text "Labels" ]
            , Lists.a
                [ Options.attribute (Html.href "#persistent-drawer")
                ]
                [ Lists.graphicIcon [] "bookmark"
                , text "Family"
                ]
            , Lists.a
                [ Options.attribute (Html.href "#persistent-drawer")
                ]
                [ Lists.graphicIcon [] "bookmark"
                , text "Friends"
                ]
            , Lists.a
                [ Options.attribute (Html.href "#persistent-drawer")
                ]
                [ Lists.graphicIcon [] "bookmark"
                , text "Work"
                ]
            , Lists.divider [] []
            , Lists.a
                [ Options.attribute (Html.href "#persistent-drawer")
                ]
                [ Lists.graphicIcon [] "settings"
                , text "Settings"
                ]
            , Lists.a
                [ Options.attribute (Html.href "#persistent-drawer")
                ]
                [ Lists.graphicIcon [] "announcement"
                , text "Help & feedback"
                ]
            ]
        ]



--demoMain : Mdc -> String -> Cmd -> Html Msg


mainContent model mdc rtl_index cmd =
    styled Html.div
        [ cs "drawer-main-content"
        , css "padding-left" "18px"
        , css "padding-right" "18px"
        , css "overflow" "auto"
        , css "height" "100%"
        ]
        [ styled div [ TopAppBar.fixedAdjust ] []
        , styled Html.p
            []
            [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            ]
        , styled Html.p
            []
            [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            ]
        , styled Html.p
            []
            [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            ]
        , styled Html.p
            []
            [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            ]
        , Button.view mdc
            rtl_index
            model.mdc
            [ Options.on "click" (Json.succeed cmd)
            ]
            [ text "Toggle RTL"
            ]
        ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    styled Html.div
        [ cs "drawer-frame-root"
        , cs "mdc-typography"
        , css "display" "flex"
        , css "height" "100vh"
        , Options.attribute (Html.dir "rtl") |> when model.rtl
        ]
        [ Drawer.view (lift << Mdc)
            "permanent-drawer-drawer"
            model.mdc
            []
            [ drawerHeader
            , drawerItems
            ]
        , styled Html.div
            [ cs "drawer-frame-app-content" ]
            [ TopAppBar.view (lift << Mdc)
                "permanent-drawer-top-app-bar"
                model.mdc
                []
                [ TopAppBar.section
                    [ TopAppBar.alignStart
                    ]
                    [ TopAppBar.title [] [ text "Permanent Drawer" ]
                    ]
                ]
            , mainContent model (lift << Mdc) "permanent-drawer-toggle-rtl" (lift ToggleRtl)
            ]
        , Html.node "style"
            [ Html.type_ "text/css"
            ]
            [ text """
html, body {
  width: 100%;
  height: 100%;
}
        """
            ]
        ]


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
