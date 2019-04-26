module Demo.DismissibleDrawer exposing
    ( Model
    , Msg(..)
    , defaultModel
    , subscriptions
    , update
    , view
    )

import Demo.Page exposing (Page)
import Demo.PermanentDrawer
import Html exposing (Html, text)
import Html.Attributes as Html
import Material
import Material.Drawer.Dismissible as Drawer
import Material.Options as Options exposing (cs, css, styled, when)
import Material.TopAppBar as TopAppBar
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , rtl : Bool
    , drawerOpen : Bool
    , selected_drawer_item : Int
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , rtl = False
    , drawerOpen = False
    , selected_drawer_item = 0
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleRtl
    | ToggleDrawer
    | SelectDrawerItem Int


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )

        ToggleDrawer ->
            ( { model | drawerOpen = not model.drawerOpen }, Cmd.none )

        SelectDrawerItem index ->
            ( { model | selected_drawer_item = index }, Cmd.none )


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
            "dismissible-drawer-drawer"
            model.mdc
            [ Drawer.open |> when model.drawerOpen
            , Drawer.onClose (lift ToggleDrawer)
            ]
            [ Demo.PermanentDrawer.drawerHeader
            , Demo.PermanentDrawer.drawerItems (lift << Mdc) "dismissible-drawer-drawer-list" model.mdc "#dismissible-drawer" (lift << SelectDrawerItem) model.selected_drawer_item
            ]
        , styled Html.div
            [ Drawer.appContent ]
            [ TopAppBar.view (lift << Mdc)
                "dismissible-drawer-top-app-bar"
                model.mdc
                []
                [ TopAppBar.section
                    [ TopAppBar.alignStart
                    ]
                    [ TopAppBar.navigationIcon (lift << Mdc) "dismissible-drawer-menu" model.mdc [ Options.onClick (lift ToggleDrawer) ] "menu"
                    , TopAppBar.title [] [ text "Dismissible Drawer" ]
                    ]
                ]
            , Demo.PermanentDrawer.mainContent model (lift << Mdc) "dismissible-drawer-toggle-rtl" (lift ToggleRtl)
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
