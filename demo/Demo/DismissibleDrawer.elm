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
import Html.Events as Events
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.Drawer.Dismissible as Drawer
import Material.Icon as Icon
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
            -- model.drawerOpen gets briefly True, then False again for no apparent reason.
            -- Use Debug.log to see what I mean.
            [ Drawer.open |> when model.drawerOpen ]
            [ Demo.PermanentDrawer.drawerHeader
            , Demo.PermanentDrawer.drawerItems
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
                      -- TODO: bug: dismissible drawer does not want to open, no clue what's going on. The model change does not want to stick, first ruond it indeed passes the True model state, but next round it doesn't.
                      [ TopAppBar.navigationIcon [ Options.onClick (lift ToggleDrawer) ] "menu"
                      , TopAppBar.title [] [ text "Dismissible Drawer (Broken)" ]
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
