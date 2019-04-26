module Demo.ModalDrawer exposing
    ( Model
    , Msg(..)
    , defaultModel
    , subscriptions
    , update
    , view
    )

import Demo.Page exposing (Page)
import Demo.PermanentDrawer
import Html exposing (Html, div, text)
import Html.Attributes as Html
import Material
import Material.Drawer.Modal as Drawer
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
    | OpenDrawer
    | CloseDrawer
    | SelectDrawerItem Int


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )

        OpenDrawer ->
            ( { model | drawerOpen = True }, Cmd.none )

        CloseDrawer ->
            ( { model | drawerOpen = False }, Cmd.none )

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
            "modal-drawer-drawer"
            model.mdc
            [ Drawer.open |> when model.drawerOpen
            , Drawer.onClose (lift CloseDrawer)
            ]
            [ Demo.PermanentDrawer.drawerHeader
            , Demo.PermanentDrawer.drawerItems (lift << Mdc) "modal-drawer-drawer-list" model.mdc "#modal-drawer" (lift << SelectDrawerItem) model.selected_drawer_item
            ]
        , Drawer.scrim [ Options.onClick (lift CloseDrawer) ] []
        , styled Html.div
            [ cs "drawer-frame-app-content" ]
            [ TopAppBar.view (lift << Mdc)
                "modal-drawer-top-app-bar"
                model.mdc
                []
                [ TopAppBar.section
                    [ TopAppBar.alignStart
                    ]
                    [ TopAppBar.navigationIcon (lift << Mdc) "modal-drawer-menu" model.mdc [ Options.onClick (lift OpenDrawer) ] "menu"
                    , TopAppBar.title [] [ text "Modal Drawer" ]
                    ]
                ]
            , Demo.PermanentDrawer.mainContent model (lift << Mdc) "modal-drawer-toggle-rtl" (lift ToggleRtl)
            ]
        ]


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
