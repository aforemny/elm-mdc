module Demo.Toolbar exposing (Model, defaultModel, Msg(..), update, view, subscriptions)

import Demo.Page as Page exposing (Page, ToolbarPage(..))
import Html.Attributes as Html
import Html exposing (Html, text)
import Material
import Material.List as Lists
import Material.Menu as Menu
import Material.Options as Options exposing (styled, cs, css)
import Material.Toolbar as Toolbar
import Material.Typography as Typography


type alias Model =
    { mdl : Material.Model
    , scroll : { pageX : Float, pageY : Float }
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , scroll = { pageX = 0, pageY = 0 }
    }


type Msg m
    = Mdl (Material.Msg m)
    | Scroll { pageX : Float, pageY : Float }


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model
        Scroll scroll ->
            ( { model | scroll = scroll }, Cmd.none )


view : (Msg m -> m) -> Page m -> Maybe ToolbarPage -> Model -> Html m
view lift page toolbarPage model =
    case toolbarPage of
        Just DefaultToolbar ->
            defaultToolbar lift model

        Just FixedToolbar ->
            fixedToolbar lift model

        Just MenuToolbar ->
            menuToolbar lift model

        Just WaterfallToolbar ->
            waterfallToolbar lift model

        Just DefaultFlexibleToolbar ->
            defaultFlexibleToolbar lift model

        Just WaterfallFlexibleToolbar ->
            waterfallFlexibleToolbar lift model

        Just WaterfallToolbarFix ->
            waterfallToolbarFix lift model

        Just CustomToolbar ->
            customToolbar lift model

        Nothing ->
            page.body "Toolbar"
            [
              Page.hero []
              [ styled Html.div
                [ css "width" "480px"
                , css "height" "72px"
                ]
                [ Toolbar.render (Mdl >> lift) [0] model.mdl
                  [
                  ]
                  [ Toolbar.row
                    [
                    ]
                    [ Toolbar.section
                      [ Toolbar.alignStart
                      ]
                      [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
                      , Toolbar.title [] [ text "Title" ]
                      ]
                    , Toolbar.section
                      [ Toolbar.alignEnd
                      ]
                      [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
                      , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
                      , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
                      ]
                    ]
                  ]
                ]
              ]

            , styled Html.div
              [ cs "mdc-toolbar-demo"
              , css "display" "flex"
              , css "flex-flow" "row wrap"
              ]
              [ iframe "Normal Toolbar" "default-toolbar"
              , iframe "Fixed Toolbar" "fixed-toolbar"
              , iframe "Fixed Toolbar with Menu" "menu-toolbar"
              , iframe "Waterfall Toolbar" "waterfall-toolbar"
              , iframe "Default Flexible Toolbar" "default-flexible-toolbar"
              , iframe "Waterfall Flexible Toolbar" "waterfall-flexible-toolbar"
              , iframe "Waterfall Toolbar Fix Last Row" "waterfall-toolbar-fix-last-row"
              , iframe "Waterfall Flexible Toolbar with Custom Style" "waterfall-flexible-toolbar-custom-style"
              ]
            ]


iframe : String -> String -> Html m
iframe title sub =
    let
        url =
            "https://aforemny.github.io/elm-mdc/#toolbar/" ++ sub
    in
    styled Html.div
    [ css "display" "flex"
    , css "flex-flow" "column"
    , css "margin" "24px"
    , css "width" "320px"
    , css "height" "600px"
    ]
    [
      styled Html.h2
      [ css "font-size" "24px"
      , css "margin-bottom" "16px"
      ]
      [ text title
      , Html.button [] [ text "Toggle RTL" ]
      ]

    , Html.p
      []
      [ Html.a
        [ Html.href url
        , Html.target "_blank"
        ]
        [ text "View in separate window"
        ]
      ]

    , styled Html.iframe
      [ Options.attribute (Html.src url)
      , css "border" "1px solid #eee"
      , css "height" "500px"
      , css "font-size" "16px"
      , css "overflow" "scroll"
      ]
      [
      ]
    ]


defaultToolbar : (Msg m -> m) -> Model -> Html m
defaultToolbar lift model =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.render (Mdl >> lift) [0] model.mdl
      [
      ]
      [ Toolbar.row
        [
        ]
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
          ]
        ]
      ]

    , body
    ]


fixedToolbar : (Msg m -> m) -> Model -> Html m
fixedToolbar lift model =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.render (Mdl >> lift) [0] model.mdl
      [ Toolbar.fixed
      ]
      [ Toolbar.row
        [
        ]
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
          ]
        ]
      ]
    , body
    ]


menuToolbar : (Msg m -> m) -> Model -> Html m
menuToolbar lift model =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.render (Mdl >> lift) [0] model.mdl
      [ Toolbar.fixed
      ]
      [ Toolbar.row
        [
        ]
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon
            [ Options.attribute (Html.href "#")
            , Menu.attach (Mdl >> lift) [0]
            ]
            "more_vert"
          , Menu.render (Mdl >> lift) [0] model.mdl []
            ( Menu.ul Lists.ul []
              [ Menu.li Lists.li
                [
                ]
                [ text "Back"
                ]
              ]
            )
          ]
        ]
      ]
    , body
    ]


waterfallToolbar : (Msg m -> m) -> Model -> Html m
waterfallToolbar lift model =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.render (Mdl >> lift) [0] model.mdl
      [ Toolbar.fixed
      , Toolbar.waterfall model.scroll.pageY
      ]
      [ Toolbar.row
        [
        ]
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
          ]
        ]
      ]
    , body
    ]


defaultFlexibleToolbar : (Msg m -> m) -> Model -> Html m
defaultFlexibleToolbar lift model =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.render (Mdl >> lift) [0] model.mdl
      [ Toolbar.flexible model.scroll.pageY
      , Toolbar.backgroundImage "images/4-3.jpg"
      ]
      [ Toolbar.row
        [ css "height" "224px"
        ]
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
          ]
        ]
      ]
    , body
    ]


waterfallFlexibleToolbar : (Msg m -> m) -> Model -> Html m
waterfallFlexibleToolbar lift model =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.render (Mdl >> lift) [0] model.mdl
      [ Toolbar.fixed
      , Toolbar.flexible model.scroll.pageY
      , Toolbar.backgroundImage "images/4-3.jpg"
      , Toolbar.waterfall model.scroll.pageY
      ]
      [ Toolbar.row []
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
          ]
        ]
      ]
    , body
    ]


waterfallToolbarFix : (Msg m -> m) -> Model -> Html m
waterfallToolbarFix lift model =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.render (Mdl >> lift) [0] model.mdl
      [ Toolbar.fixed
      , Toolbar.flexible model.scroll.pageY
      , Toolbar.backgroundImage "images/4-3.jpg"
      , Toolbar.waterfall model.scroll.pageY
      ]
      [ Toolbar.row
        [ css "height" "224px"
        ]
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        ]
      , Toolbar.row []
        [ Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
          ]
        ]
      ]
    , body
    ]


customToolbar : (Msg m -> m) -> Model -> Html m
customToolbar lift model =
    styled Html.div
    [ Typography.typography
    , cs "mdc-toolbar-demo"
    ]
    [ Toolbar.render (Mdl >> lift) [0] model.mdl
      [ Toolbar.fixed
      , Toolbar.waterfall model.scroll.pageY
      , Toolbar.flexible model.scroll.pageY
      , Toolbar.fixedLastRow
      ]
      [ Toolbar.row
        [ css "height" "224px"
        ]
        [ Toolbar.section
          [ Toolbar.alignStart
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "menu"
          , Toolbar.title [] [ text "Title" ]
          ]
        , Toolbar.section
          [ Toolbar.alignEnd
          ]
          [ Toolbar.icon [ Options.attribute (Html.href "#") ] "file_download"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "print"
          , Toolbar.icon [ Options.attribute (Html.href "#") ] "more_vert"
          ]
        ]
      ]
    , body
    ]


body : Html msg
body =
    Html.div []
    ( styled Html.p
      [ cs "demo-paragraph"
      ]
      [ text """Pellentesque habitant morbi tristique senectus et netus et
malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae,
ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas
semper. Aenean ultricies mi vitae est. Pellentesque habitant morbi tristique
senectus et netus et malesuada fames ac turpis egestas. Vestibulum tortor quam,
feugiat vitae, ultricies eget, tempor sit amet, ante. Donec eu libero sit amet
quam egestas semper. Aenean ultricies mi vitae est."""
      ]
      |> List.repeat 3
    )


subscriptions : (Msg m -> m) -> Model -> Sub m
subscriptions lift model =
    Material.subscriptions (Mdl >> lift) model
