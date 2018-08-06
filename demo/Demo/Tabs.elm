module Demo.Tabs exposing (Model, Msg(Mdc), defaultModel, subscriptions, update, view)

import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (..)
import Material
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Tabs as TabBar
import Material.Theme as Theme
import Material.Toolbar as Toolbar
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


-- MODEL


type alias Model m =
    { mdc : Material.Model m
    , examples : Dict Material.Index Example
    }


type alias Example =
    { tab : Int
    }


defaultExample : Example
defaultExample =
    { tab = 0
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , examples = Dict.empty
    }


type Msg m
    = Mdc (Material.Msg m)
    | SelectTab Material.Index Int


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        SelectTab index tabIndex ->
            let
                example =
                    Dict.get index model.examples
                        |> Maybe.withDefault defaultExample
                        |> (\example ->
                                { example | tab = tabIndex }
                           )
            in
            { model | examples = Dict.insert index example model.examples } ! []


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body "Tabs"
        [ Page.hero []
            [ heroTabs lift model.mdc "tabs-hero-tabs" (Dict.get "tabs-hero-tabs" model.examples |> Maybe.withDefault defaultExample)
            ]
        , example0 lift model.mdc "tabs-example-0-tabs" (Dict.get "tabs-example-0-tabs" model.examples |> Maybe.withDefault defaultExample)
        , example1 lift model.mdc "tabs-example-1-tabs" (Dict.get "tabs-example-1-tabs" model.examples |> Maybe.withDefault defaultExample)
        , example2 lift model.mdc "tabs-example-2-tabs" (Dict.get "tabs-example-2-tabs" model.examples |> Maybe.withDefault defaultExample)
        , example3 lift model.mdc "tabs-example-3-tabs" (Dict.get "tabs-example-3-tabs" model.examples |> Maybe.withDefault defaultExample)

        -- , example4  lift model.mdc "tabs-example-5-tabs" (Dict.get  "tabs-example-5-tabs" model.examples |> Maybe.withDefault defaultExample)
        -- , example5  lift model.mdc "tabs-example-6-tabs" (Dict.get  "tabs-example-6-tabs" model.examples |> Maybe.withDefault defaultExample)
        , example6 lift model.mdc "tabs-example-7-tabs" (Dict.get "tabs-example-7-tabs" model.examples |> Maybe.withDefault defaultExample)
        , example7 lift model.mdc "tabs-example-8-tabs" (Dict.get "tabs-example-8-tabs" model.examples |> Maybe.withDefault defaultExample)

        -- , example8  lift model.mdc "tabs-example-9-tabs" (Dict.get "tabs-example-9-tabs" model.examples |> Maybe.withDefault defaultExample)
        -- , example9  lift model.mdc "tabs-example-10-tabs" (Dict.get "tabs-example-10-tabs" model.examples |> Maybe.withDefault defaultExample)
        , example10 lift model.mdc "tabs-example-11-tabs" (Dict.get "tabs-example-11-tabs" model.examples |> Maybe.withDefault defaultExample)
        ]


heroTabs : (Msg m -> m) -> Material.Model m -> Material.Index -> Example -> Html m
heroTabs lift mdc index model =
    TabBar.view (lift << Mdc)
        index
        mdc
        [ TabBar.indicator
        ]
        [ TabBar.tab [] [ text "Item One" ]
        , TabBar.tab [] [ text "Item Two" ]
        , TabBar.tab [] [ text "Item Three" ]
        ]


example0 : (Msg m -> m) -> Material.Model m -> Material.Index -> Example -> Html m
example0 lift mdc index model =
    Html.section []
        [ fieldset []
            [ legend []
                [ text "Basic Tab Bar"
                ]
            , heroTabs lift mdc index model
            ]
        ]


example1 : (Msg m -> m) -> Material.Model m -> Material.Index -> Example -> Html m
example1 lift mdc index model =
    Html.section []
        [ fieldset []
            [ legend []
                [ text "Tab Bar with Scroller"
                ]
            , TabBar.view (lift << Mdc)
                index
                mdc
                [ TabBar.indicator
                , TabBar.scrolling
                ]
                [ TabBar.tab [] [ text "Item One" ]
                , TabBar.tab [] [ text "Item Two" ]
                , TabBar.tab [] [ text "Item Three" ]
                , TabBar.tab [] [ text "Item Four" ]
                , TabBar.tab [] [ text "Item Five" ]
                , TabBar.tab [] [ text "Item Six" ]
                , TabBar.tab [] [ text "Item Seven" ]
                , TabBar.tab [] [ text "Item Eight" ]
                , TabBar.tab [] [ text "Item Nine" ]
                ]
            ]
        ]


example2 : (Msg m -> m) -> Material.Model m -> Material.Index -> Example -> Html m
example2 lift mdc index model =
    Html.section []
        [ fieldset []
            [ legend []
                [ text "Icon Tab Labels"
                ]
            , TabBar.view (lift << Mdc)
                index
                mdc
                [ TabBar.indicator
                ]
                [ TabBar.tab [] [ TabBar.icon [] "phone" ]
                , TabBar.tab [] [ TabBar.icon [] "favorite" ]
                , TabBar.tab [] [ TabBar.icon [] "person_pin" ]
                ]
            ]
        ]


example3 : (Msg m -> m) -> Material.Model m -> Material.Index -> Example -> Html m
example3 lift mdc index model =
    Html.section []
        [ fieldset []
            [ legend []
                [ text "Icon Tab Labels"
                ]
            , TabBar.view (lift << Mdc)
                index
                mdc
                [ TabBar.indicator
                ]
                [ TabBar.tab [ TabBar.withIconAndText ] [ TabBar.icon [] "phone", TabBar.iconText [] "Recents" ]
                , TabBar.tab [] [ TabBar.icon [] "favorite", TabBar.iconText [] "Favorites" ]
                , TabBar.tab [] [ TabBar.icon [] "person_pin", TabBar.iconText [] "Nearby" ]
                ]
            ]
        ]



--example4 : (Msg m -> m) -> Material.Model m -> Int -> Example -> Html m
--example4 lift mdc index model =
--    Html.section []
--    [ fieldset []
--      [ legend []
--          [ text "Primary Color Indicator"
--          ]
--        , TabBar.view (lift << Mdc) index mdc
--          [ TabBar.indicator
--          , TabBar.indicatorPrimary
--          ]
--          [ TabBar.tab [] [ text "Item One" ]
--          , TabBar.tab [] [ text "Item Two" ]
--          , TabBar.tab [] [ text "Item Three" ]
--          ]
--      ]
--    ]
--
--
--example5 : (Msg m -> m) -> Material.Model m -> Int -> Example -> Html m
--example5 lift mdc index model =
--    Html.section []
--    [ fieldset []
--      [ legend []
--        [ text "Accent Color Indicator"
--        ]
--      , TabBar.view (lift << Mdc) index mdc
--        [ TabBar.indicator
--        , TabBar.indicatorAccent
--        ]
--        [ TabBar.tab [] [ text "Item One" ]
--        , TabBar.tab [] [ text "Item Two" ]
--        , TabBar.tab [] [ text "Item Three" ]
--        ]
--      ]
--    ]


example6 : (Msg m -> m) -> Material.Model m -> Material.Index -> Example -> Html m
example6 lift mdc index model =
    Html.section []
        [ fieldset []
            [ legend []
                [ text "Within mdc-toolbar"
                ]
            , Toolbar.view (lift << Mdc)
                (index ++ "-toolbar")
                mdc
                []
                [ Toolbar.row []
                    [ Toolbar.section
                        [ Toolbar.alignStart
                        ]
                        [ Toolbar.title [] [ text "Title" ]
                        ]
                    , Toolbar.section
                        [ Toolbar.alignEnd
                        ]
                        [ TabBar.view (lift << Mdc)
                            (index ++ "tab-bar")
                            mdc
                            [ TabBar.indicator
                            ]
                            [ TabBar.tab [] [ text "Item One" ]
                            , TabBar.tab [] [ text "Item Two" ]
                            , TabBar.tab [] [ text "Item Three" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]


example7 : (Msg m -> m) -> Material.Model m -> Material.Index -> Example -> Html m
example7 lift mdc index model =
    Html.section []
        [ fieldset []
            [ legend []
                [ text "Within mdc-toolbar"
                ]
            , Toolbar.view (lift << Mdc)
                (index ++ "-toolbar")
                mdc
                []
                [ Toolbar.row []
                    [ Toolbar.section
                        [ Toolbar.alignStart
                        ]
                        [ Toolbar.title [] [ text "Title" ]
                        ]
                    , Toolbar.section
                        [ Toolbar.alignEnd
                        , css "position" "absolute"
                        , css "right" "0"
                        , css "bottom" "-16px"
                        ]
                        [ TabBar.view (lift << Mdc)
                            (index ++ "-tab-bar")
                            mdc
                            []
                            [ TabBar.tab [] [ text "Item One" ]
                            , TabBar.tab [] [ text "Item Two" ]
                            , TabBar.tab [] [ text "Item Three" ]
                            ]
                        ]
                    ]
                ]
            ]
        ]



--example8 : (Msg m -> m) -> Material.Model m -> Int -> Example -> Html m
--example8 lift mdc index model =
--    Html.section []
--    [ fieldset []
--      [ legend []
--        [ text "Within mdc-toolbar + primary indicator"
--        ]
--      , Toolbar.view (lift << Mdc) (index ++ "-toolbar") mdc
--        [ Theme.secondaryBg
--        ]
--        [ Toolbar.row []
--          [ Toolbar.section
--            [ Toolbar.alignStart
--            ]
--            [ Toolbar.title [] [ text "Title" ]
--            ]
--          , Toolbar.section
--            [ Toolbar.alignEnd
--            ]
--            [ TabBar.view (lift << Mdc) (index ++ "-tab-bar") mdc
--              [ TabBar.indicator
--              , TabBar.indicatorPrimary
--              ]
--              [ TabBar.tab [] [ text "Item One" ]
--              , TabBar.tab [] [ text "Item Two" ]
--              , TabBar.tab [] [ text "Item Three" ]
--              ]
--            ]
--          ]
--        ]
--      ]
--    ]
--example9 : (Msg m -> m) -> Material.Model m -> Int -> Example -> Html m
--example9 lift mdc index model =
--    Html.section []
--    [ fieldset []
--      [ legend []
--        [ text "Within mdc-toolbar + accent indicator"
--        ]
--      , Toolbar.view (lift << Mdc) (index ++ "-toolbar") mdc
--        [ Theme.primaryBg
--        ]
--        [ Toolbar.row []
--          [ Toolbar.section
--            [ Toolbar.alignStart
--            ]
--            [ Toolbar.title [] [ text "Title" ]
--            ]
--          , Toolbar.section
--            [ Toolbar.alignEnd
--            ]
--            [ TabBar.view (lift << Mdc) (index ++ "-tab-bar") mdc
--              [ TabBar.indicator
--              , TabBar.indicatorAccent
--              ]
--              [ TabBar.tab [] [ text "Item One" ]
--              , TabBar.tab [] [ text "Item Two" ]
--              , TabBar.tab [] [ text "Item Three" ]
--              ]
--            ]
--          ]
--        ]
--      ]
--    ]


example10 : (Msg m -> m) -> Material.Model m -> Material.Index -> Example -> Html m
example10 lift mdc index model =
    let
        items =
            [ "Item One", "Item Two", "Item Three" ]
    in
    Html.section []
        [ fieldset []
            [ legend []
                [ text "Within Toolbar, Dynamic Content Control"
                ]
            , Toolbar.view (lift << Mdc)
                (index ++ "-toolbar")
                mdc
                [ Theme.primaryBg
                ]
                [ Toolbar.row []
                    [ Toolbar.section
                        [ Toolbar.alignEnd
                        ]
                        [ TabBar.view (lift << Mdc)
                            (index ++ "-tab-bar")
                            mdc
                            [ TabBar.indicator
                            ]
                            (items
                                |> List.indexedMap
                                    (\i label ->
                                        TabBar.tab
                                            [ Options.onClick (lift (SelectTab index i))
                                            ]
                                            [ text label
                                            ]
                                    )
                            )
                        ]
                    ]
                ]
            , styled Html.section
                [ cs "panels"
                , css "padding" "8px"
                , css "border" "1px solid #ccc"
                , css "border-radius" "4px"
                , css "margin-top" "8px"
                ]
                ([ "Item One"
                 , "Item Two"
                 , "Item Three"
                 ]
                    |> List.indexedMap
                        (\i str ->
                            let
                                isActive =
                                    model.tab == i
                            in
                            styled Html.p
                                [ cs "panel"
                                , cs "active" |> when isActive
                                , css "display" "none" |> when (not isActive)
                                ]
                                [ text str
                                ]
                        )
                )
            , styled Html.section
                [ cs "dots"
                , css "display" "flex"
                , css "justify-content" "flex-start"
                , css "margin-top" "4px"
                , css "padding-bottom" "16px"
                ]
                (List.range 0 2
                    |> List.map
                        (\i ->
                            let
                                isActive =
                                    model.tab == i
                            in
                            styled Html.a
                                [ cs "dot"
                                , css "margin" "0 4px"
                                , css "border-radius" "50%"
                                , css "border" "1px solid #64DD17"
                                , css "width" "20px"
                                , css "height" "20px"
                                , when isActive <|
                                    Options.many
                                        [ cs "active"
                                        , css "background-color" "#64DD17"
                                        , css "border-color" "#64DD17"
                                        ]
                                ]
                                []
                        )
                )
            ]
        ]


legend : List (Options.Property c m) -> List (Html m) -> Html m
legend options =
    styled Html.legend
        (css "display" "block"
            :: css "padding" "64px 16px 24px"
            :: Typography.title
            :: options
        )


fieldset : List (Options.Property c m) -> List (Html m) -> Html m
fieldset options =
    styled Html.div
        (css "display" "block"
            :: css "padding" "0 24px 16px"
            :: options
        )


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
