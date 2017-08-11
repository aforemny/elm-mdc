module Demo.PersistentDrawer exposing (Model,defaultModel,Msg(Mdl),update,view)

import Html.Attributes as Html
import Html exposing (Html, text)
import Material
import Material.Component exposing (Index)
import Material.Drawer.Persistent as Drawer
import Material.List as Lists
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Toolbar as Toolbar
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


-- MODEL


type alias Model =
    { mdl : Material.Model
    , open : Bool
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
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
            model ! [ Drawer.toggle Mdl idx ]


-- VIEW


view : Model -> Html Msg
view model =
    styled Html.div
    [ cs "demo-body"
    , css "display" "flex"
    , css "flex-direction" "row"
    , css "padding" "0"
    , css "margin" "0"
    , css "box-sizing" "border-box"
    , css "height" "100%"
    , css "width" "100%"
    ]
    [
      Drawer.render Mdl [0] model.mdl []
      [
        Drawer.toolbarSpacer [] []
      , Lists.ul []
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

    , styled Html.div
      [ cs "demo-content"
      , css "display" "inline-flex"
      , css "flex-direction" "column"
      , css "flex-grow" "1"
      , css "height" "100%"
      , css "box-sizing" "border-box"
      ]
      [
        Toolbar.view []
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
            , Toolbar.title [] [ text "Persistent Drawer" ]
            ]
          ]
        ]

      , styled Html.div
        [ cs "demo-main"
        , css "padding-left" "16px"
        ]
        [ styled Html.h1
          [ Typography.display1
          ]
          [ text "Persistent Drawer"
          ]
        , styled Html.p
          [ Typography.body2
          ]
          [ text "Click the menu icon above to open and close the drawer."
          ]
        ]
      ]
    ]
