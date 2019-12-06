module Demo.TopAppBar exposing (Model, Msg(..), defaultModel, subscriptions, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Demo.Url as Url exposing (TopAppBarPage)
import Dict exposing (Dict)
import Html exposing (Html, div, p, text)
import Html.Attributes as Html
import Material
import Material.Button as Button
import Material.Options as Options exposing (Property, cs, css, styled, when)
import Material.TopAppBar as TopAppBar


type alias Model m =
    { mdc : Material.Model m
    , examples : Dict Material.Index Example
    }


type alias Example =
    { rtl : Bool
    }


defaultExample : Example
defaultExample =
    { rtl = False
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , examples = Dict.empty
    }


type Msg m
    = Mdc (Material.Msg m)
    | ExampleMsg Material.Index ExampleMsg


type ExampleMsg
    = ToggleRtl
    | OpenDrawer


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ExampleMsg index msg_ ->
            let
                example =
                    Dict.get index model.examples
                        |> Maybe.withDefault defaultExample
                        |> updateExample msg_

                examples =
                    Dict.insert index example model.examples
            in
            ( { model | examples = examples }, Cmd.none )


updateExample : ExampleMsg -> Example -> Example
updateExample msg model =
    case msg of
        ToggleRtl ->
            { model | rtl = not model.rtl }

        OpenDrawer ->
            model


heroComponent lift model =
    styled Html.div
        [ css "width" "480px"
        , css "height" "72px"
        ]
        [ TopAppBar.view (lift << Mdc)
              "top-app-bar-default-top-app-bar"
              model.mdc
              [ css "position" "static"
              ]
              [ TopAppBar.section
                    [ TopAppBar.alignStart
                    ]
                    [ TopAppBar.navigationIcon (lift << Mdc) "hero-menu" model.mdc [] "menu"
                    , TopAppBar.title [] [ text "Title" ]
                    ]
              , TopAppBar.section
                  [ TopAppBar.alignEnd
                  ]
                    [ TopAppBar.actionItem (lift << Mdc) "hero-file_download" model.mdc [] "file_download"
                    , TopAppBar.actionItem (lift << Mdc) "hero-print" model.mdc [] "print"
                    , TopAppBar.actionItem (lift << Mdc) "hero-more_vert" model.mdc [] "more_vert"
                    ]
              ]
        ]


view : (Msg m -> m) -> Page m -> Maybe TopAppBarPage -> Model m -> Html m
view lift page topAppBarPage model =
    case topAppBarPage of
        Just Url.StandardTopAppBar ->
            standardTopAppBar lift "top-app-bar-standard" model

        Just Url.FixedTopAppBar ->
            fixedTopAppBar lift "top-app-bar-fixed" model

        Just Url.DenseTopAppBar ->
            denseTopAppBar lift "top-app-bar-dense" model

        Just Url.ProminentTopAppBar ->
            prominentTopAppBar lift "top-app-bar-prominent" model

        Just Url.ShortTopAppBar ->
            shortTopAppBar lift "top-app-bar-short" model

        Just Url.ShortCollapsedTopAppBar ->
            shortCollapsedTopAppBar lift "top-app-bar-short-collapsed" model

        Nothing ->
            page.body
                [ Hero.view
                      [ Hero.header "Top App Bar"
                      , Hero.intro "Top App Bars are a container for items such as application title, navigation icon, and action items."
                      , Hero.component [] [ heroComponent lift model ]
                      ]
                , ResourceLink.links (lift << Mdc) model.mdc "app-bars-top" "top-app-bar" "mdc-top-app-bar"
                , styled Html.div
                    [ cs "mdc-topappbar-demo"
                    , css "display" "flex"
                    , css "flex-flow" "row wrap"
                    ]
                      [ iframe lift model "Standard TopAppBar" Url.StandardTopAppBar
                      , iframe lift model "Fixed TopAppBar" Url.FixedTopAppBar
                      , iframe lift model "Dense TopAppBar" Url.DenseTopAppBar
                      , iframe lift model "Prominent TopAppBar" Url.ProminentTopAppBar
                      , iframe lift model "Short TopAppBar" Url.ShortTopAppBar
                      , iframe lift
                          model
                          "Short - Always Closed TopAppBar"
                              Url.ShortCollapsedTopAppBar
                      ]
                ]


iframe : (Msg m -> m) -> Model m -> String -> TopAppBarPage -> Html m
iframe lift model title topAppBarPage =
    let
        url =
            (++) "./" <|
                Url.toString (Url.TopAppBar (Just topAppBarPage))
    in
    styled Html.div
        [ css "display" "flex"
        , css "flex-flow" "column"
        , css "margin" "24px"
        , css "width" "320px"
        , css "height" "600px"
        ]
        [ styled Html.h2
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
            [ styled Html.span
                [ cs "demo-topappbar-example-heading__text"
                , css "flex-grow" "1"
                , css "margin-right" "16px"
                ]
                [ text title ]
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
            []
        ]


topAppBarWrapper :
    (Msg m -> m)
    -> Material.Index
    -> Model m
    -> List (Property c m)
    -> Html m
    -> Html m
topAppBarWrapper lift index model options topappbar =
    let
        state =
            Dict.get index model.examples
                |> Maybe.withDefault defaultExample
    in
    styled Html.div
        [ cs "mdc-topappbar-demo"
        , Options.attribute (Html.dir "rtl") |> when state.rtl
        ]
        [ topappbar
        , body options lift index model
        ]


topAppBar : (Msg m -> m) -> Material.Index -> Model m -> List (TopAppBar.Property m) -> Html m
topAppBar lift index model options =
    TopAppBar.view (lift << Mdc)
        index
        model.mdc
        options
        [ TopAppBar.section
            [ TopAppBar.alignStart
            ]
            [ TopAppBar.navigationIcon (lift << Mdc) (index ++ "-menu") model.mdc [] "menu"
            , TopAppBar.title [] [ text "Title" ]
            ]
        , TopAppBar.section
            [ TopAppBar.alignEnd
            ]
            [ TopAppBar.actionItem (lift << Mdc) (index ++ "-file_down") model.mdc [] "file_download"
            , TopAppBar.actionItem (lift << Mdc) (index ++ "-print") model.mdc [] "print"
            , TopAppBar.actionItem (lift << Mdc) (index ++ "-bookmark") model.mdc [] "bookmark"
            ]
        ]


standardTopAppBar : (Msg m -> m) -> Material.Index -> Model m -> Html m
standardTopAppBar lift index model =
    topAppBarWrapper lift
        index
        model
        [ TopAppBar.fixedAdjust
        ]
        (topAppBar lift index model [])


fixedTopAppBar : (Msg m -> m) -> Material.Index -> Model m -> Html m
fixedTopAppBar lift index model =
    topAppBarWrapper lift
        index
        model
        [ TopAppBar.fixedAdjust
        ]
        (topAppBar lift index model [ TopAppBar.fixed ])


denseTopAppBar : (Msg m -> m) -> Material.Index -> Model m -> Html m
denseTopAppBar lift index model =
    topAppBarWrapper lift
        index
        model
        [ TopAppBar.denseFixedAdjust
        ]
        (topAppBar lift index model [ TopAppBar.dense ])


prominentTopAppBar : (Msg m -> m) -> Material.Index -> Model m -> Html m
prominentTopAppBar lift index model =
    topAppBarWrapper lift
        index
        model
        [ TopAppBar.prominentFixedAdjust
        ]
        (topAppBar lift index model [ TopAppBar.prominent ])


shortTopAppBar : (Msg m -> m) -> Material.Index -> Model m -> Html m
shortTopAppBar lift index model =
    topAppBarWrapper lift
        index
        model
        [ TopAppBar.fixedAdjust
        ]
        (TopAppBar.view (lift << Mdc)
            index
            model.mdc
            [ TopAppBar.short
            , TopAppBar.hasActionItem
            ]
            [ TopAppBar.section
                [ TopAppBar.alignStart
                ]
                [ TopAppBar.navigationIcon (lift << Mdc) (index ++ "-menu") model.mdc [] "menu"
                , TopAppBar.title [] [ text "Title" ]
                ]
            , TopAppBar.section
                [ TopAppBar.alignEnd
                ]
                [ TopAppBar.actionItem (lift << Mdc) (index ++ "-file_download") model.mdc [] "file_download"
                ]
            ]
        )


shortCollapsedTopAppBar : (Msg m -> m) -> Material.Index -> Model m -> Html m
shortCollapsedTopAppBar lift index model =
    topAppBarWrapper lift
        index
        model
        [ TopAppBar.fixedAdjust
        ]
        (TopAppBar.view (lift << Mdc)
            index
            model.mdc
            [ TopAppBar.short
            , TopAppBar.collapsed
            , TopAppBar.hasActionItem
            ]
            [ TopAppBar.section
                [ TopAppBar.alignStart
                ]
                [ TopAppBar.navigationIcon (lift << Mdc) (index ++ "-menu") model.mdc [] "menu"
                , TopAppBar.title [] [ text "Title" ]
                ]
            , TopAppBar.section
                [ TopAppBar.alignEnd
                ]
                [ TopAppBar.actionItem (lift << Mdc) (index ++ "-file_download") model.mdc [] "file_download"
                ]
            ]
        )


body : List (Options.Property c m) -> (Msg m -> m) -> Material.Index -> Model m -> Html m
body options lift index model =
    styled Html.div
        options
        (List.concat
            [ [ Button.view (lift << Mdc)
                    (index ++ "-toggle-rtl")
                    model.mdc
                    [ Button.outlined
                    , Button.dense
                    , Options.onClick (lift (ExampleMsg (index ++ "-toggle-rtl") ToggleRtl))
                    ]
                    [ text "Toggle RTL"
                    ]
              ]
            , List.repeat 18 <|
                Html.p []
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
            ]
        )


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
