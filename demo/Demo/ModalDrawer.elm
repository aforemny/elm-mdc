module Demo.ModalDrawer
    exposing
        ( Model
        , Msg(Mdc)
        , defaultModel
        , subscriptions
        , update
        , view
        )

import Demo.Page exposing (Page)
import Demo.DismissibleDrawer
import Html exposing (Html, text)
import Html.Attributes as Html
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.Drawer.Modal as Drawer
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
    | OpenDrawer
    | CloseDrawer


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case Debug.log "Msg" msg of
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
        [ Options.attribute (Html.dir "rtl") |> when model.rtl
        , cs "drawer-frame-root"
        ]
        [ Drawer.view (lift << Mdc)
            "modal-drawer-drawer"
            model.mdc
            [ Drawer.open |> when model.drawerOpen
            , Drawer.onClose (lift CloseDrawer)
            ]
            [ Demo.DismissibleDrawer.drawerHeader
            , Demo.DismissibleDrawer.drawerItems
            ]
        , Drawer.scrim (lift CloseDrawer)

        , TopAppBar.view (lift << Mdc)
            "modal-drawer-topappbar"
            model.mdc
            [ ]
            [ TopAppBar.section [ TopAppBar.alignStart ]
                [ TopAppBar.navigationIcon [ Options.onClick (lift OpenDrawer) ] "menu"
                , TopAppBar.title [] [ text "Modal Drawer" ]
                ]
            ]
        , styled Html.div
            [ TopAppBar.fixedAdjust
            , cs "drawer-main-content"
            , css "padding-left" "16px"
            , css "overflow" "auto"
            ]
            [ styled Html.h1 [ Typography.display1 ] [ text "Modal Drawer" ]
            , styled Html.p [ Typography.body1 ] [ text "Click the menu icon above to open." ]
            ]
        , Button.view (lift << Mdc)
            "modal-drawer-toggle-rtl"
            model.mdc
            [ Options.on "click" (Json.succeed (lift ToggleRtl))
            ]
            [ text "Toggle RTL"
            ]
        ]


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
