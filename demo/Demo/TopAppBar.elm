module Demo.TopAppBar exposing (Model, defaultModel, Msg(..), update, view, subscriptions)

import Demo.Page as Page exposing (Page)
import Demo.Url exposing (TopAppBarPage(..))
import Dict exposing (Dict)
import Html.Attributes as Html
import Html exposing (Html, text, div, p)
import Material
import Material.Button as Button
import Material.Options as Options exposing (styled, cs, css, when)
import Material.TopAppBar as TopAppBar
import Material.Component as Component exposing (Index)


type alias Model m =
    { mdc : Material.Model m
    , examples : Dict Index Example
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
    | ExampleMsg Index ExampleMsg


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
                    Dict.get (Debug.log "index" index) model.examples
                        |> Maybe.withDefault defaultExample
                        |> updateExample msg_

                examples =
                    Dict.insert index example model.examples
            in
                { model | examples = examples } ! []


updateExample : ExampleMsg -> Example -> Example
updateExample msg model =
    case Debug.log "updateExample" msg of
        ToggleRtl ->
            { model | rtl = not model.rtl }

        OpenDrawer ->
            model


view : (Msg m -> m) -> Page m -> Maybe TopAppBarPage -> Model m -> Html m
view lift page topAppBarPage model =
    case topAppBarPage of
        Just DefaultTopAppBar ->
            defaultTopAppBar lift [ 0 ] model

        Just FixedTopAppBar ->
            fixedTopAppBar lift [ 1 ] model

        Just MenuTopAppBar ->
            menuTopAppBar lift [ 2 ] model

        Just DenseTopAppBar ->
            denseTopAppBar lift [ 3 ] model

        Just ProminentTopAppBar ->
            prominentTopAppBar lift [ 4 ] model

        Just ShortTopAppBar ->
            shortTopAppBar lift [ 5 ] model

        Just ShortAlwaysClosedTopAppBar ->
            shortAndClosedTopAppBar lift [ 6 ] model

        Nothing ->
            page.body "TopAppBar"
                [ Page.hero []
                    [ styled Html.div
                        [ css "width" "480px"
                        , css "height" "72px"
                        ]
                        [ TopAppBar.view (lift << Mdc)
                            [ 0 ]
                            model.mdc
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
                    [ iframe lift model "Normal TopAppBar" "default-topappbar"
                    , iframe lift model "Fixed TopAppBar" "fixed-topappbar"
                    , iframe lift model "Fixed TopAppBar with Menu" "menu-topappbar"
                    , iframe lift model "Dense TopAppBar" "dense-topappbar"
                    , iframe lift model "Prominent TopAppBar" "prominent-topappbar"
                    , iframe lift model "Short TopAppBar" "short-topappbar"
                    , iframe lift model "Short - Always Closed TopAppBar" "short-always-closed-topappbar"
                    ]
                ]


iframe : (Msg m -> m) -> Model m -> String -> String -> Html m
iframe lift model title sub =
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


topAppBarWrapper : (Msg m -> m) -> Index -> Model m -> Html m -> Html m
topAppBarWrapper lift index model topappbar =
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
            , body [] lift index model
            ]


defaultTopAppBar : (Msg m -> m) -> Index -> Model m -> Html m
defaultTopAppBar lift index model =
    topAppBarWrapper lift
        index
        model
        (TopAppBar.view (lift << Mdc)
            [ 0 ]
            model.mdc
            []
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
        )


fixedTopAppBar : (Msg m -> m) -> Index -> Model m -> Html m
fixedTopAppBar lift index model =
    topAppBarWrapper lift
        index
        model
        (TopAppBar.view (lift << Mdc)
            [ 0 ]
            model.mdc
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
        )


menuTopAppBar : (Msg m -> m) -> Index -> Model m -> Html m
menuTopAppBar lift index model =
    topAppBarWrapper lift
        index
        model
        (TopAppBar.view (lift << Mdc)
            [ 0 ]
            model.mdc
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
        )



-- , viewDrawer


denseTopAppBar : (Msg m -> m) -> Index -> Model m -> Html m
denseTopAppBar lift index model =
    topAppBarWrapper lift
        index
        model
        (TopAppBar.view (lift << Mdc)
            [ 0 ]
            model.mdc
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
        )


prominentTopAppBar : (Msg m -> m) -> Index -> Model m -> Html m
prominentTopAppBar lift index model =
    topAppBarWrapper lift
        index
        model
        (TopAppBar.view (lift << Mdc)
            [ 0 ]
            model.mdc
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
        )


shortTopAppBar : (Msg m -> m) -> Index -> Model m -> Html m
shortTopAppBar lift index model =
    topAppBarWrapper lift
        index
        model
        (TopAppBar.view (lift << Mdc)
            [ 0 ]
            model.mdc
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
        )


shortAndClosedTopAppBar : (Msg m -> m) -> Index -> Model m -> Html m
shortAndClosedTopAppBar lift index model =
    topAppBarWrapper lift
        index
        model
        (TopAppBar.view (lift << Mdc)
            [ 0 ]
            model.mdc
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
        )


body : List (Options.Property c m) -> (Msg m -> m) -> Index -> Model m -> Html m
body options lift index model =
    -- TODO: how to add options in here?
    styled Html.div
        [ TopAppBar.fixedAdjust
        , css "padding-top" "56px"
        , css "margin-top" "0"
        ]
        (Button.view (lift << Mdc)
            index
            model.mdc
            [ Button.outlined
            , Button.dense
            , Options.onClick (lift (ExampleMsg index ToggleRtl))
            ]
            [ text "Toggle RTL"
            ]
            :: (styled Html.p
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
        )


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
