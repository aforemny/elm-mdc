module Demo.DismissibleDrawer
    exposing
        ( Model
        , Msg(Mdc)
        , defaultModel
        , drawerHeader
        , drawerItems
        , subscriptions
        , update
        , view
        )

import Demo.Page exposing (Page)
import Html exposing (Html, text, h3, h6)
import Html.Attributes as Html
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.Drawer.Dismissible as Drawer
import Material.List as Lists
import Material.Options as Options exposing (cs, css, styled, when)
import Material.TopAppBar as TopAppBar
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , rtl : Bool
    , drawerOpen : Bool
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , rtl = False
    , drawerOpen = False
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleRtl
    | ToggleDrawer


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )

        ToggleDrawer ->
            ( { model | drawerOpen = not model.drawerOpen }, Cmd.none )


drawerHeader : Html m
drawerHeader =
    Drawer.header
        [ ]
        [ styled h3 [ cs "mdc-drawer__title" ]
              [ text "Mail" ]
        , styled h6 [ cs "mdc-drawer__subtitle" ]
            [ text "email@material.io" ]
        ]


drawerItems : Html m
drawerItems =
    styled Html.div [ Drawer.content ]
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


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    styled Html.div
        [ cs "drawer-frame-root"
        , css "display" "flex"
        , css "height" "100vh"
        , Options.attribute (Html.dir "rtl") |> when model.rtl
        ]
        [ Drawer.view (lift << Mdc)
            "dismissible-drawer-drawer"
            model.mdc
            [ Drawer.open |> when model.drawerOpen ]
            [ drawerHeader
            , drawerItems
            ]

        , styled Html.div
            [ cs "mdc-drawer-app-content"
            , css "width" "100%"
            ]
            [  TopAppBar.view (lift << Mdc)
                   "dismissible-drawer-topappbar"
                   model.mdc
                   [ cs "drawer-top-app-bar" ]
                   [ TopAppBar.section [ TopAppBar.alignStart ]
                         [ TopAppBar.navigationIcon [ Options.onClick (lift ToggleDrawer) ] "menu"
                         , TopAppBar.title [] [ text "Dismissible Drawer" ]
                         ]
                   ]
            , styled Html.div
                [ cs "drawer-main-content"
                , css "padding" "0 18px"
                , css "overflow" "auto"
                , css "height" "100%"
                ]
                [ styled Html.h1 [ Typography.display1, TopAppBar.fixedAdjust ] [ text "Dismissible Drawer" ]
                , styled Html.p
                    [ Typography.body1 ]
                    [ text "Click the menu icon above to open and close the drawer."
                    ]
                , Button.view (lift << Mdc)
                    "dismissible-drawer-toggle-rtl"
                    model.mdc
                    [ Options.on "click" (Json.succeed (lift ToggleRtl))
                    ]
                    [ text "Toggle RTL"
                    ]
                ]
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
