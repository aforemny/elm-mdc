module Demo.TemporaryDrawer exposing (..)

import Html.Attributes as Html
import Html exposing (Html, text)
import Material
import Material.Component exposing (Index)
import Material.Drawer.Temporary as Drawer
import Material.List as Lists
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Theme as Theme
import Material.Toolbar as Toolbar
import Platform.Cmd exposing (Cmd, none)


-- MODEL


type alias Model =
    { mdl : Material.Model
    , open : Bool
    }


model : Model
model =
    { mdl = Material.model
    , open = False
    }


type Msg
    = Mdl (Material.Msg Msg)
    | Open Index


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model
        Open idx ->
            model ! [ Drawer.open Mdl idx ]


-- VIEW


view : Model -> Html Msg
view model =
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
                  , Options.onClick (Open [0])
                  ]
                  [ text "menu"
                  ]
            ]
          , Toolbar.title [] [ text "Temporary Drawer" ]
          ]
        ]
      ]

    , Drawer.render Mdl [0] model.mdl []
      [ Drawer.header
        [ Theme.primaryBg
        , Theme.textPrimaryOnPrimary
        ]
        [ Drawer.headerContent []
          [ text "Header here"
          ]
        ]

      , Drawer.content []
        [ Lists.ul []
          [ Lists.li []
            [ Lists.startDetailIcon "inbox" []
            , Html.a [ Html.href "#" ] [ text "Inbox" ]
            ]
          , Lists.li []
            [ Lists.startDetailIcon "star" []
            , Html.a [ Html.href "#" ] [ text "Star" ]
            ]
          , Lists.li []
            [ Lists.startDetailIcon "send" []
            , Html.a [ Html.href "#" ] [ text "Sent Mail" ]
            ]
          , Lists.li []
            [ Lists.startDetailIcon "drafts" []
            , Html.a [ Html.href "#" ] [ text "Drafts" ]
            ]

          , Lists.divider [] []

          , Lists.li []
            [ Lists.startDetailIcon "email" []
            , Html.a [ Html.href "#" ] [ text "All Mail" ]
            ]
          , Lists.li []
            [ Lists.startDetailIcon "delete" []
            , Html.a [ Html.href "#" ] [ text "Trash" ]
            ]
          , Lists.li []
            [ Lists.startDetailIcon "report" []
            , Html.a [ Html.href "#" ] [ text "Spam" ]
            ]
          ]
        ]
      ]
    ]
