module Demo.TemporaryDrawer
    exposing
        ( Model
        , Msg(..)
        , defaultModel
        , subscriptions
        , update
        , view
        )

import Demo.Page exposing (Page)
import Demo.PersistentDrawer
import Html exposing (Html, text)
import Html.Attributes as Html
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.Drawer.Temporary as Drawer
import Material.Icon as Icon
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Theme as Theme
import Material.Toolbar as Toolbar
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
        [ Options.attribute (Html.dir "rtl") |> when model.rtl
        ]
        [ Toolbar.view (lift << Mdc)
            "temporary-drawer-toolbar"
            model.mdc
            [ Toolbar.fixed
            ]
            [ Toolbar.row []
                [ Toolbar.section
                    [ Toolbar.alignStart
                    ]
                    [ Icon.view
                        [ Toolbar.menuIcon
                        , Options.onClick (lift OpenDrawer)
                        ]
                        "menu"
                    , Toolbar.title
                        [ cs "catalog-menu"
                        , css "font-family" "'Roboto Mono', monospace"
                        , css "margin-left" "8px"
                        ]
                        [ text "Temporary Drawer" ]
                    ]
                ]
            ]
        , Drawer.view (lift << Mdc)
            "temporary-drawer-drawer"
            model.mdc
            [ Drawer.open |> when model.drawerOpen
            , Drawer.onClose (lift CloseDrawer)
            ]
            [ Drawer.header
                [ Theme.primaryBg
                , Theme.textPrimaryOnPrimary
                ]
                [ Drawer.headerContent []
                    [ text "Header here"
                    ]
                ]
            , Demo.PersistentDrawer.drawerItems
            ]
        , styled Html.div
            [ Toolbar.fixedAdjust "temporary-drawer-toolbar" model.mdc
            , css "padding-left" "16px"
            , css "overflow" "auto"
            ]
            [ styled Html.h1 [ Typography.display1 ] [ text "Temporary Drawer" ]
            , styled Html.p [ Typography.body1 ] [ text "Click the menu icon above to open." ]
            ]
        , Button.view (lift << Mdc)
            "temporary-drawer-toggle-rtl"
            model.mdc
            [ Options.on "click" (Json.succeed (lift ToggleRtl))
            ]
            [ text "Toggle RTL"
            ]
        ]


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
