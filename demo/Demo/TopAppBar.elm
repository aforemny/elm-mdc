module Demo.TopAppBar exposing (Model, defaultModel, Msg(..), update, view, subscriptions)

import Demo.Page as Page exposing (Page)
import Demo.Url exposing (TopAppBarPage(..))
import Html.Attributes as Html
import Html exposing (Html, text, div, p)
import Material
import Material.Button as Button
import Material.Menu as Menu
import Material.Options as Options exposing (styled, cs, css)
import Material.TopAppBar as TopAppBar


type alias Model m =
    { mdc : Material.Model m
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    }


type Msg m
    = Mdc (Material.Msg m)


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model


view : (Msg m -> m) -> Page m -> Maybe TopAppBarPage -> Model m -> Html m
view lift page topAppBarPage model =
    case topAppBarPage of
        Just DefaultTopAppBar ->
            defaultTopAppBar lift model

        Just FixedTopAppBar ->
            fixedTopAppBar lift model

        Just MenuTopAppBar ->
            menuTopAppBar lift model

        Just DenseTopAppBar ->
            denseTopAppBar lift model

        Just ProminentTopAppBar ->
            prominentTopAppBar lift model

        Just ShortTopAppBar ->
            shortTopAppBar lift model

        Just ShortAlwaysClosedTopAppBar ->
            shortAndClosedTopAppBar lift model

        Nothing ->
            page.body "TopAppBar"
            [
              Page.hero []
              [ styled Html.div
                [ css "width" "480px"
                , css "height" "72px"
                ]
                [ TopAppBar.view (lift << Mdc) [0] model.mdc
                  [ css "position" "static"
                  ]
                  [ TopAppBar.section
                        [ TopAppBar.alignStart
                        ]
                        [ TopAppBar.navigation [] "menu"
                        , TopAppBar.title [] [ text "Title" ]
                        ]
                  , TopAppBar.section
                        [ TopAppBar.alignEnd
                        ]
                        [ TopAppBar.actionItem [] "file_download"
                        , TopAppBar.actionItem [] "print"
                        , TopAppBar.actionItem [] "more_vert"
                        ]
                  ]
                ]
              ]

            , styled Html.div
              [ cs "mdc-topappbar-demo"
              , css "display" "flex"
              , css "flex-flow" "row wrap"
              ]
              [ iframe lift [0] model "Normal TopAppBar" "default-topappbar"
              , iframe lift [1] model "Fixed TopAppBar" "fixed-topappbar"
              , iframe lift [2] model "Fixed TopAppBar with Menu" "menu-topappbar"
              , iframe lift [1] model "Dense TopAppBar" "dense-topappbar"
              , iframe lift [1] model "Prominent TopAppBar" "prominent-topappbar"
              , iframe lift [1] model "Short TopAppBar" "short-topappbar"
              , iframe lift [1] model "Short - Always Closed TopAppBar" "short-always-closed-topappbar"
              ]
            ]


iframe : (Msg m -> m) -> List Int -> Model m -> String -> String -> Html m
iframe lift index model title sub =
    let
        url =
            "./#topappbar/" ++ sub
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
      [ cs "demo-topappbar-example-heading"
      , css "font-size" "24px"
      , css "margin-bottom" "16px"
      , css "font-family" "Roboto, sans-serif"
      , css "font-size" "2.8125rem"
      , css "line-height" "3rem"
      , css "font-weight" "400"
      , css "letter-spacing" "normal"
      , css "text-transform" "inherit"
      ]
      [
        styled Html.span
        [ cs "demo-topappbar-example-heading__text"
        , css "flex-grow" "1"
        , css "margin-right" "16px"
        ]
        [ text title ]
      ,
        Button.view (lift << Mdc) index model.mdc
        [ Button.stroked
        , Button.dense
        ]
        [ text "Toggle RTL"
        ]
      ]

    , Html.p []
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


defaultTopAppBar : (Msg m -> m) -> Model m -> Html m
defaultTopAppBar lift model =
    styled Html.div
    [ cs "mdc-topappbar-demo"
    ]
    [
      TopAppBar.view (lift << Mdc) [0] model.mdc []
      [ TopAppBar.section
            [ TopAppBar.alignStart
            ]
            [ TopAppBar.navigation [] "menu"
            , TopAppBar.title [] [ text "Title" ]
            ]
      , TopAppBar.section
          [ TopAppBar.alignEnd
          ]
            [ TopAppBar.actionItem [] "file_download"
            , TopAppBar.actionItem [] "print"
            , TopAppBar.actionItem [] "bookmark"
            ]
      ]
    , styled div [ TopAppBar.fixedAdjust, css "padding-top" "56px", css "margin-top" "0" ]
        [ body [] model
        ]
    ]


fixedTopAppBar : (Msg m -> m) -> Model m -> Html m
fixedTopAppBar lift model =
    styled Html.div
    [ cs "mdc-topappbar-demo"
    ]
    [
      TopAppBar.view (lift << Mdc) [0] model.mdc
      [ TopAppBar.fixed
      ]
      [ TopAppBar.section
            [ TopAppBar.alignStart
            ]
            [ TopAppBar.navigation [] "menu"
            , TopAppBar.title [] [ text "Title" ]
            ]
      , TopAppBar.section
          [ TopAppBar.alignEnd
          ]
            [ TopAppBar.actionItem [] "file_download"
            , TopAppBar.actionItem [] "print"
            , TopAppBar.actionItem [] "bookmark"
            ]
      ]
    , styled div [ TopAppBar.fixedAdjust, css "padding-top" "56px", css "margin-top" "0" ]
        [ body [ ] model
        ]
    ]


menuTopAppBar : (Msg m -> m) -> Model m -> Html m
menuTopAppBar lift model =
    styled Html.div
    [ cs "mdc-topappbar-demo"
    ]
    [
      TopAppBar.view (lift << Mdc) [0] model.mdc
      [ TopAppBar.fixed
      ]
      [ TopAppBar.section
            [ TopAppBar.alignStart
            ]
            [ TopAppBar.navigation [] "menu"
            , TopAppBar.title [] [ text "Title" ]
            ]
      , TopAppBar.section
          [ TopAppBar.alignEnd
          ]
            [ TopAppBar.actionItem [] "file_download"
            , TopAppBar.actionItem [] "print"
            , TopAppBar.actionItem [] "bookmark"
            ]
      ]
    -- , viewDrawer
    , styled div [ TopAppBar.fixedAdjust, css "padding-top" "56px", css "margin-top" "0" ]
        [ body [ ] model
        ]
    ]


denseTopAppBar : (Msg m -> m) -> Model m -> Html m
denseTopAppBar lift model =
    styled Html.div
    [ cs "mdc-topappbar-demo"
    ]
    [
      TopAppBar.view (lift << Mdc) [0] model.mdc
      [ TopAppBar.dense
      ]
      [ TopAppBar.section
            [ TopAppBar.alignStart
            ]
            [ TopAppBar.navigation [] "menu"
            , TopAppBar.title [] [ text "Title" ]
            ]
      , TopAppBar.section
          [ TopAppBar.alignEnd
          ]
            [ TopAppBar.actionItem [] "file_download"
            , TopAppBar.actionItem [] "print"
            , TopAppBar.actionItem [] "bookmark"
            ]
      ]
    , styled div [ TopAppBar.fixedAdjust, css "padding-top" "56px", css "margin-top" "0" ]
        [ p [] [ text "There should be a shadow when scrolling under bar, but doesn't happen." ]
        , body [ ] model
        ]
    ]


prominentTopAppBar : (Msg m -> m) -> Model m -> Html m
prominentTopAppBar lift model =
    styled Html.div
    [ cs "mdc-topappbar-demo"
    ]
    [
      TopAppBar.view (lift << Mdc) [0] model.mdc
      [ TopAppBar.prominent
      ]
      [ TopAppBar.section
            [ TopAppBar.alignStart
            ]
            [ TopAppBar.navigation [] "menu"
            , TopAppBar.title [] [ text "Title" ]
            ]
      , TopAppBar.section
          [ TopAppBar.alignEnd
          ]
            [ TopAppBar.actionItem [] "file_download"
            , TopAppBar.actionItem [] "print"
            , TopAppBar.actionItem [] "bookmark"
            ]
      ]
    , styled div [ TopAppBar.fixedAdjust, css "padding-top" "56px", css "margin-top" "0" ]
        [ p [] [ text "There should be a shadow when scrolling under bar, but doesn't happen." ]
        , body [ ] model
        ]
    ]


shortTopAppBar : (Msg m -> m) -> Model m -> Html m
shortTopAppBar lift model =
    styled Html.div
    [ cs "mdc-topappbar-demo"
    ]
    [
      TopAppBar.view (lift << Mdc) [0] model.mdc
      [ TopAppBar.short
      , TopAppBar.hasActionItem
      ]
      [ TopAppBar.section
            [ TopAppBar.alignStart
            ]
            [ TopAppBar.navigation [] "menu"
            , TopAppBar.title [] [ text "Title" ]
            ]
      , TopAppBar.section
          [ TopAppBar.alignEnd
          ]
            [ TopAppBar.actionItem [] "file_download"
            ]
      ]
    , styled div [ TopAppBar.fixedAdjust, css "padding-top" "56px", css "margin-top" "0" ]
        [ p [] [ text "There should be a shadow when scrolling under bar, but doesn't happen." ]
        , body [ ] model
        ]
    ]


shortAndClosedTopAppBar : (Msg m -> m) -> Model m -> Html m
shortAndClosedTopAppBar lift model =
    styled Html.div
    [ cs "mdc-topappbar-demo"
    ]
    [
      TopAppBar.view (lift << Mdc) [0] model.mdc
      [ TopAppBar.short
      , TopAppBar.collapsed
      , TopAppBar.hasActionItem
      ]
      [ TopAppBar.section
            [ TopAppBar.alignStart
            ]
            [ TopAppBar.navigation [] "menu"
            , TopAppBar.title [] [ text "Title" ]
            ]
      , TopAppBar.section
          [ TopAppBar.alignEnd
          ]
            [ TopAppBar.actionItem [] "file_download"
            ]
      ]
    , styled div [ TopAppBar.fixedAdjust, css "padding-top" "56px", css "margin-top" "0" ]
        [ body [ ] model
        ]
    ]


body : List (Options.Property c m) -> Model m -> Html m
body options model =
    styled Html.div options
    ( styled Html.p
      [ cs "demo-paragraph"
      , css "padding" "20px 28px"
      , css "margin" "0"
      ]
      [ text """
Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac
turpis egestas. Vestibulum tortor quam, feugiat vitae, ultricies eget, tempor
sit amet, ante. Donec eu libero sit amet quam egestas semper. Aenean ultricies
mi vitae est. Pellentesque habitant morbi tristique senectus et netus et
malesuada fames ac turpis egestas. Vestibulum tortor quam, feugiat vitae,
ultricies eget, tempor sit amet, ante. Donec eu libero sit amet quam egestas
semper. Aenean ultricies mi vitae est.
        """
      ]
      |> List.repeat 18
    )


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
