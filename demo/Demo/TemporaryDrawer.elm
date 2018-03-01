module Demo.TemporaryDrawer exposing
    (
      Model
    , defaultModel
    , Msg(Mdc)
    , update
    , view
    , subscriptions
    )

import Demo.Page exposing (Page)
import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.Drawer
import Material.Drawer.Temporary as Drawer
import Material.List as Lists
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Theme as Theme
import Material.Toolbar as Toolbar
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model =
    { mdc : Material.Model
    , rtl : Bool
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    , rtl = False
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleRtl


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    styled Html.div
    [ Options.attribute (Html.dir "rtl") |> when model.rtl
    ]
    [
      Toolbar.view (lift << Mdc) [1] model.mdc
      [ Toolbar.fixed
      ]
      [ Toolbar.row []
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.menuIcon
            [ Drawer.openOn (lift << Mdc) [0] "click"
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

    , Drawer.render (lift << Mdc) [0] model.mdc []
      [ Drawer.header
        [ Theme.primaryBg
        , Theme.textPrimaryOnPrimary
        ]
        [ Drawer.headerContent []
          [ text "Header here"
          ]
        ]

      , Drawer.content []
        [ Lists.listItem
          [ Options.attribute (Html.href "#temporary-drawer") ]
          [ Lists.graphicIcon [] "inbox"
          , text "Inbox"
          ]
        , Lists.listItem
          [ Options.attribute (Html.href "#temporary-drawer") ]
          [ Lists.graphicIcon [] "star"
          , text "Star"
          ]
        , Lists.listItem
          [ Options.attribute (Html.href "#temporary-drawer") ]
          [ Lists.graphicIcon [] "send"
          , text "Sent Mail"
          ]
        , Lists.listItem
          [ Options.attribute (Html.href "#temporary-drawer") ]
          [ Lists.graphicIcon [] "drafts"
          , text "Drafts"
          ]

        , Lists.divider [] []

        , Lists.listItem
          [ Options.attribute (Html.href "#temporary-drawer") ]
          [ Lists.graphicIcon [] "email"
          , text "All Mail"
          ]
        , Lists.listItem
          [ Options.attribute (Html.href "#temporary-drawer") ]
          [ Lists.graphicIcon [] "delete"
          , text "Trash"
          ]
        , Lists.listItem
          [ Options.attribute (Html.href "#temporary-drawer") ]
          [ Lists.graphicIcon [] "report"
          , text "Spam"
          ]
        ]
      ]
    ,
      styled Html.div
      [ Toolbar.fixedAdjust [1] model.mdc
      , css "padding-left" "16px"
      , css "overflow" "auto"
      ]
      [
        styled Html.h1 [ Typography.display1 ] [ text "Temporary Drawer" ]
      , styled Html.p [ Typography.body1 ] [ text "Click the menu icon above to open." ]
      ]
    ,
      Button.render (lift << Mdc) [2] model.mdc
      [ Options.on "click" (Json.succeed (lift ToggleRtl))
      ]
      [ text "Toggle RTL"
      ]
    ]


subscriptions : (Msg m -> m) -> Model -> Sub m
subscriptions lift model =
    Material.Drawer.subs (lift << Mdc) model.mdc
