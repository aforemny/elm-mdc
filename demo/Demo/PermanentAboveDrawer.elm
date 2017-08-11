module Demo.PermanentAboveDrawer exposing (Model,defaultModel,Msg(Mdl),update,view)

import Demo.Page as Page exposing (Page)
import Html as Html_
import Html.Attributes as Html
import Html exposing (Html, text, map)
import Material
import Material.Component exposing (Index)
import Material.Drawer.Permanent as Drawer
import Material.Elevation as Elevation
import Material.List as Lists
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Toolbar as Toolbar
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


-- MODEL


type alias Model =
    { mdl : Material.Model
    , toggle0 : Bool
    , toggle1 : Bool
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , toggle0 = False
    , toggle1 = False
    }


type Msg
    = Mdl (Material.Msg Msg)
    | Open Index
    | Toggle0
    | Toggle1


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model
        Open idx ->
            model ! [ Drawer.open Mdl idx ]
        Toggle0 ->
            { model | toggle0 = not model.toggle0 } ! []
        Toggle1 ->
            { model | toggle1 = not model.toggle1 } ! []


-- VIEW


view : (Msg -> m) -> Page m -> Model -> Html m
view lift page model =
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
      Html_.map lift <|
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
      [ Toolbar.view
        [
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
                , Options.onClick page.clearTab
                , css "cursor" "pointer"
                ]
                [ text "arrow_back" ]
              ]
            , Toolbar.title [] [ text "Permanent Drawer Above Toolbar" ]
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
          [ text "Permanent Drawer"
          ]
        , styled Html.p
          [ Typography.body2
          ]
          [ text "It sits to the left of this content."
          ]
        , styled Html.div
          [ css "padding" "10px"
          ]
          [ styled Html.button
            [ Options.onClick (lift Toggle0)
            ]
            [ text "Toggle extra-wide content"
            ]
          , styled Html.div
            [ css "width" "200vw"
            , css "display" "none" |> when (not model.toggle0)
            , Elevation.elevation 2
            ]
            [ text "&nbsp;" ]
          ]
        , styled Html.div
          [ css "padding" "10px"
          ]
          [ styled Html.button
            [ Options.onClick (lift Toggle1)
            ]
            [ text "Toggle extra-tall content"
            ]
          , styled Html.div
            [ css "height" "200vh"
            , css "display" "none" |> when (not model.toggle1)
            , Elevation.elevation 2
            ]
            [ text "&nbsp;" ]
          ]
        ]
      ]
    ]
