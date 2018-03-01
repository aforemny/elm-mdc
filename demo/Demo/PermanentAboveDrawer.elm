module Demo.PermanentAboveDrawer exposing
    (
      Model
    , defaultModel
    , Msg(Mdc)
    , update
    , view
    , subscriptions
    )

import Demo.Page as Page exposing (Page)
import Html as Html_
import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Markdown
import Material
import Material.Button as Button
import Material.Drawer
import Material.Drawer.Permanent as Drawer
import Material.Elevation as Elevation
import Material.List as Lists
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Toolbar as Toolbar
import Material.Typography as Typography


type alias Model =
    { mdc : Material.Model
    , toggle0 : Bool
    , toggle1 : Bool
    , rtl : Bool
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    , toggle0 = False
    , toggle1 = False
    , rtl = False
    }


type Msg m
    = Mdc (Material.Msg m)
    | Toggle0
    | Toggle1
    | ToggleRtl


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (Mdc >> lift) msg_ model

        Toggle0 ->
            ( { model | toggle0 = not model.toggle0 }, Cmd.none )

        Toggle1 ->
            ( { model | toggle1 = not model.toggle1 }, Cmd.none )

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )


view : (Msg m -> m) -> Page m -> Model -> Html m
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
    , Options.attribute (Html.dir "rtl") |> when model.rtl
    ]
    [ 
      Drawer.render (Mdc >> lift) [0] model.mdc []
      [
        Drawer.toolbarSpacer [] []
      , Lists.listItem
        [ Options.attribute (Html.href "#permanent-drawer-above") ]
        [ Lists.graphicIcon [] "inbox"
        , text "Inbox"
        ]
      , Lists.listItem
        [ Options.attribute (Html.href "#permanent-drawer-above") ]
        [ Lists.graphicIcon [] "star"
        , text "Star"
        ]
      , Lists.listItem
        [ Options.attribute (Html.href "#permanent-drawer-above") ]
        [ Lists.graphicIcon [] "send"
        , text "Sent Mail"
        ]
      , Lists.listItem
        [ Options.attribute (Html.href "#permanent-drawer-above") ]
        [ Lists.graphicIcon [] "drafts"
        , text "Drafts"
        ]

      , Lists.divider [] []

      , Lists.listItem
        [ Options.attribute (Html.href "#permanent-drawer-above") ]
        [ Lists.graphicIcon [] "email"
        , text "All Mail"
        ]
      , Lists.listItem
        [ Options.attribute (Html.href "#permanent-drawer-above") ]
        [ Lists.graphicIcon [] "delete"
        , text "Trash"
        ]
      , Lists.listItem
        [ Options.attribute (Html.href "#permanent-drawer-above") ]
        [ Lists.graphicIcon [] "report"
        , text "Spam"
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
      [ Toolbar.view (Mdc >> lift) [1] model.mdc
        [
        ]
        [ Toolbar.row []
          [ Toolbar.section
            [ Toolbar.alignStart
            ]
            [ Toolbar.title
              [ cs "catalog-menu"
              , css "font-family" "'Roboto Mono', monospace"
              , css "margin-left" "8px"
              ]
              [ text "Permanent Drawer Above Toolbar"
              ]
            ]
          ]
        ]

      , styled Html.div
        [ cs "demo-main"
        , css "padding-left" "16px"
        ]
        [
          styled Html.h1
          [ Typography.display1
          ]
          [ text "Permanent Drawer"
          ]
        ,
          styled Html.p
          [ Typography.body2
          ]
          [ text "It sits to the left of this content."
          ]
        ,
          styled Html.div
          [ css "padding" "10px"
          ]
          [
            Button.render (lift << Mdc) [2] model.mdc
            [ Options.on "click" (Json.succeed (lift ToggleRtl))
            ]
            [ text "Toggle RTL"
            ]
          ]
        ,
          styled Html.div
          [ css "padding" "10px"
          ]
          [
            Button.render (lift << Mdc) [3] model.mdc
            [ Options.on "click" (Json.succeed (lift Toggle0))
            ]
            [ text "Toggle extra-wide content"
            ]
          ,
            styled Html.div
            [ css "width" "200vw"
            , css "display" "none" |> when (not model.toggle0)
            , Elevation.z2
            ]
            [ Markdown.toHtml [] "&nbsp;"
            ]
          ]
        ,
          styled Html.div
          [ css "padding" "10px"
          ]
          [
            Button.render (lift << Mdc) [4] model.mdc
            [ Options.on "click" (Json.succeed (lift Toggle1))
            ]
            [ text "Toggle extra-tall content"
            ]
          ,
            styled Html.div
            [ css "height" "200vh"
            , css "display" "none" |> when (not model.toggle1)
            , Elevation.z2
            ]
            [ Markdown.toHtml [] "&nbsp;"
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
      ]
    ]


subscriptions : (Msg m -> m) -> Model -> Sub m
subscriptions lift model =
    Material.Drawer.subs (Mdc >> lift) model.mdc
