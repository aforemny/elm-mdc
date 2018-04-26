module Demo.PersistentDrawer exposing
    (
      Model
    , defaultModel
    , Msg(Mdc)
    , update
    , view
    , subscriptions
    , drawerItems
    )

import Demo.Page exposing (Page)
import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.Drawer.Persistent as Drawer
import Material.Icon as Icon
import Material.List as Lists
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Toolbar as Toolbar
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , rtl : Bool
    , drawerOpen: Bool
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
            ( {model | drawerOpen = not model.drawerOpen}, Cmd.none )


drawerItems : Html m
drawerItems =
    Lists.ul
    [ Drawer.content
    ]
    [ Lists.li []
      [ Html.a
        [ Html.href "#persistent-drawer"
        ]
        [ Lists.graphicIcon [] "inbox"
        , text "Inbox"
        ]
      ]
    , Lists.li []
      [ Html.a
        [ Html.href "#persistent-drawer"
        ]
        [ Lists.graphicIcon [] "star"
        , text "Star"
        ]
      ]
    , Lists.li []
      [ Html.a
        [ Html.href "#persistent-drawer"
        ]
        [ Lists.graphicIcon [] "send"
        , text "Sent Mail"
        ]
      ]
    , Lists.li []
      [ Html.a
        [ Html.href "#persistent-drawer"
        ]
        [ Lists.graphicIcon [] "drafts"
        , text "Drafts"
        ]
      ]

    , Lists.divider [] []

    , Lists.li []
      [ Html.a
        [ Html.href "#persistent-drawer"
        ]
        [ Lists.graphicIcon [] "email"
        , text "All Mail"
        ]
      ]
    , Lists.li []
      [ Html.a
        [ Html.href "#persistent-drawer"
        ]
        [ Lists.graphicIcon [] "delete"
        , text "Trash"
        ]
      ]
    , Lists.li []
      [ Html.a
        [ Html.href "#persistent-drawer"
        ]
        [ Lists.graphicIcon [] "report"
        , text "Spam"
        ]
      ]
    ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    styled Html.div
    [ cs "demo-body"
    , css "display" "flex"
    , css "flex-direction" "row"
    , css "padding" "0"
    , css "margin" "0"
    , css "box-sizing" "border-box"
    , css "width" "100%"
    , css "height" "100%"
    , Options.attribute (Html.dir "rtl") |> when model.rtl
    ]
    [
      Drawer.view (lift << Mdc) [0] model.mdc
      [ Drawer.open |> when model.drawerOpen]
      [
        Drawer.toolbarSpacer [] []
      , drawerItems
      ]

    , styled Html.div
      [ cs "demo-content"
      , css "display" "inline-flex"
      , css "flex-direction" "column"
      , css "flex-grow" "1"
      , css "height" "100%"
      , css "box-sizing" "border-box"
      ]
      [
        Toolbar.view (lift << Mdc) [1] model.mdc
        []
        [ Toolbar.row []
          [ Toolbar.section
            [ Toolbar.alignStart
            ]
            [ Icon.view
              [ Options.onClick (lift ToggleDrawer)
              , Toolbar.menuIcon
              ]
              "menu"
            , Toolbar.title
              [ cs "catalog-menu"
              , css "font-family" "'Roboto Mono', monospace"
              , css "margin-left" "8px"
              ]
              [ text "Persistent Drawer" ]
            ]
          ]
        ]

      , styled Html.div
        [ cs "demo-main"
        , css "padding-left" "16px"
        ]
        [
          styled Html.h1 [ Typography.display1 ] [ text "Persistent Drawer" ]
        ,
          styled Html.p [ Typography.body1 ]
          [ text "Click the menu icon above to open and close the drawer."
          ]
        ,
          Button.view (lift << Mdc) [2] model.mdc
          [ Options.on "click" (Json.succeed (lift ToggleRtl))
          ]
          [ text "Toggle RTL"
          ]
        ]
      ]
    ,
      Html.node "style"
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
