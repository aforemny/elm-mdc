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
import Html exposing (Html, div, p, text)
import Html.Attributes as Html
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.Drawer.Modal as Drawer
import Material.Icon as Icon
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Theme as Theme
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
    | OpenDrawer
    | CloseDrawer


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
            , Demo.PermanentDrawer.drawerItems
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
                    [ TopAppBar.navigationIcon [ Options.onClick (lift OpenDrawer) ] "menu"
                    , TopAppBar.title [] [ text "Modal Drawer" ]
                    ]
                ]
            , Demo.PermanentDrawer.mainContent model (lift << Mdc) "modal-drawer-toggle-rtl" (lift ToggleRtl)
            ]
        ]


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
