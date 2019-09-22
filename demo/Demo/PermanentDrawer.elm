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
import Material.List as Lists
import Material.Options as Options exposing (cs, css, styled, when)
import Material.TopAppBar as TopAppBar
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , rtl : Bool
    , selected_drawer_item : Int
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , rtl = False
    , selected_drawer_item = 0
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleRtl
    | SelectDrawerItem Int


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )

        SelectDrawerItem index ->
            ( { model | selected_drawer_item = index }, Cmd.none )


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


drawerItems : (Material.Msg m -> m) -> Material.Index -> Material.Model m -> String -> (Int -> m) -> Int -> Html m
drawerItems lift index mdc url select selected =
    let
        href =
            Options.attribute (Html.href url)
    in
    Drawer.content []
        [ Lists.nav lift
            index
            mdc
            [ Lists.singleSelection
            , Lists.useActivated
            , Lists.onSelectListItem select ]
            [ Lists.a
                [ href
                , Lists.activated |> when (selected == 0)
                ]
                [ Lists.graphicIcon [] "inbox"
                , text "Inbox"
                ]
            , Lists.a
                [ href
                , Lists.activated |> when (selected == 1)
                ]
                [ Lists.graphicIcon [] "star"
                , text "Star"
                ]
            , Lists.a
                [ href
                , Lists.activated |> when (selected == 2)
                ]
                [ Lists.graphicIcon [] "send"
                , text "Sent Mail"
                ]
            , Lists.a
                [ href
                , Lists.activated |> when (selected == 3)
                ]
                [ Lists.graphicIcon [] "drafts"
                , text "Drafts"
                ]
            , Lists.hr [] []
            , Lists.asListItem Html.h6 [ Lists.subheaderClass ] [ text "Labels" ]
            , Lists.a
                [ href
                , Lists.activated |> when (selected == 6)
                ]
                [ Lists.graphicIcon [] "bookmark"
                , text "Family"
                ]
            , Lists.a
                [ href
                , Lists.activated |> when (selected == 7)
                ]
                [ Lists.graphicIcon [] "bookmark"
                , text "Friends"
                ]
            , Lists.a
                [ href
                , Lists.activated |> when (selected == 8)
                ]
                [ Lists.graphicIcon [] "bookmark"
                , text "Work"
                ]
            , Lists.hr [] []
            , Lists.a
                [ href
                , Lists.activated |> when (selected == 10)
                ]
                [ Lists.graphicIcon [] "settings"
                , text "Settings"
                ]
            , Lists.a
                [ href
                , Lists.activated |> when (selected == 11)
                ]
                [ Lists.graphicIcon [] "announcement"
                , text "Help & feedback"
                ]
            ]
        ]


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
            , drawerItems (lift << Mdc) "permanent-drawer-drawer-list" model.mdc "#persistent-drawer" (lift << SelectDrawerItem) model.selected_drawer_item
            ]
        , styled Html.div
            [ cs "drawer-frame-app-content"
            , css "position" "relative"
            ]
            [ TopAppBar.view (lift << Mdc)
                "permanent-drawer-top-app-bar"
                model.mdc
                [ css "position" "absolute" ]
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
