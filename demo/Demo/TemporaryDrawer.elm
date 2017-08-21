module Demo.TemporaryDrawer exposing
    (
      Model
    , defaultModel
    , Msg(Mdl)
    , update
    , view
    , subscriptions
    )

import Demo.Page exposing (Page)
import Html.Attributes as Html
import Html exposing (Html, text)
import Material
import Material.Component exposing (Index)
import Material.Drawer
import Material.Drawer.Temporary as Drawer
import Material.List as Lists
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Theme as Theme
import Material.Toolbar as Toolbar
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model =
    { mdl : Material.Model
    , open : Bool
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , open = False
    }


type Msg m
    = Mdl (Material.Msg m)
    | Open Index


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model
        Open idx ->
            model ! [ Drawer.emit (Mdl >> lift) idx Drawer.open ]


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    Html.div []
    [
      Toolbar.view
      [ Toolbar.fixed
      ]
      [ Toolbar.row []
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon_
            [ Toolbar.menu
            ]
            [ styled Html.i
                  [ cs "material-icons"
                  , css "cursor" "pointer"
                  , Options.onClick (lift (Open [0]))
                  ]
                  [ text "menu"
                  ]
            ]
          , Toolbar.title [] [ text "Temporary Drawer" ]
          ]
        ]
      ]

    , Drawer.render (Mdl >> lift) [0] model.mdl []
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
          [ Lists.startDetailIcon "inbox" []
          , text "Inbox"
          ]
        , Lists.listItem
          [ Options.attribute (Html.href "#temporary-drawer") ]
          [ Lists.startDetailIcon "star" []
          , text "Star"
          ]
        , Lists.listItem
          [ Options.attribute (Html.href "#temporary-drawer") ]
          [ Lists.startDetailIcon "send" []
          , text "Sent Mail"
          ]
        , Lists.listItem
          [ Options.attribute (Html.href "#temporary-drawer") ]
          [ Lists.startDetailIcon "drafts" []
          , text "Drafts"
          ]

        , Lists.divider [] []

        , Lists.listItem
          [ Options.attribute (Html.href "#temporary-drawer") ]
          [ Lists.startDetailIcon "email" []
          , text "All Mail"
          ]
        , Lists.listItem
          [ Options.attribute (Html.href "#temporary-drawer") ]
          [ Lists.startDetailIcon "delete" []
          , text "Trash"
          ]
        , Lists.listItem
          [ Options.attribute (Html.href "#temporary-drawer") ]
          [ Lists.startDetailIcon "report" []
          , text "Spam"
          ]
        ]
      ]

    , styled Html.div
      [ Toolbar.fixedAdjust
      , css "padding-left" "16px"
      , css "overflow" "auto"
      ]
      [
        styled Html.h1 [ Typography.display1 ] [ text "Temporary Drawer" ]
      , styled Html.p [ Typography.body1 ] [ text "Click the menu icon above to open." ]
      ]
    ]


subscriptions : (Msg m -> m) -> Model -> Sub m
subscriptions lift model =
    Material.Drawer.subs (Mdl >> lift) model.mdl
