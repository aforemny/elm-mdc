module Demo.Toolbar exposing (Model, Msg(..), defaultModel, subscriptions, update, view)

import Demo.Page as Page exposing (Page)
import Demo.Url exposing (ToolbarPage(..))
import Dict exposing (Dict)
import Html exposing (Html, text)
import Html.Attributes as Html
import Material
import Material.Button as Button
import Material.Icon as Icon
import Material.Menu as Menu
import Material.Options as Options exposing (cs, css, styled)
import Material.Toolbar as Toolbar
import Material.Typography as Typography


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


view : (Msg m -> m) -> Page m -> Maybe ToolbarPage -> Model m -> Html m
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

        Nothing ->
            page.body "Toolbar"
                [ Page.hero []
                    [ styled Html.div
                        [ css "width" "480px"
                        , css "height" "72px"
                        ]
                        [ Toolbar.view (lift << Mdc)
                            "toolbar-toolbar"
                            model.mdc
                            []
                            [ Toolbar.row
                                []
                                [ Toolbar.section
                                    [ Toolbar.alignStart
                                    ]
                                    [ Icon.view [ Toolbar.icon, Options.attribute (Html.href "#") ] "menu"
                                    , Toolbar.title [] [ text "Title" ]
                                    ]
                                , Toolbar.section
                                    [ Toolbar.alignEnd
                                    ]
                                    [ Icon.view [ Toolbar.icon, Options.attribute (Html.href "#") ] "file_download"
                                    , Icon.view [ Toolbar.icon, Options.attribute (Html.href "#") ] "print"
                                    , Icon.view [ Toolbar.icon, Options.attribute (Html.href "#") ] "more_vert"
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
                    [ iframe lift [ 0 ] model "Normal Toolbar" "default-toolbar"
                    , iframe lift [ 1 ] model "Fixed Toolbar" "fixed-toolbar"
                    , iframe lift [ 2 ] model "Fixed Toolbar with Menu" "menu-toolbar"
                    , iframe lift [ 3 ] model "Waterfall Toolbar" "waterfall-toolbar"
                    , iframe lift [ 4 ] model "Default Flexible Toolbar" "default-flexible-toolbar"
                    , iframe lift [ 5 ] model "Waterfall Flexible Toolbar" "waterfall-flexible-toolbar"
                    , iframe lift [ 6 ] model "Waterfall Toolbar Fix Last Row" "waterfall-toolbar-fix-last-row"
                    ]
                ]


iframe : (Msg m -> m) -> List Int -> Model m -> String -> String -> Html m
iframe lift index model title sub =
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
        [ styled Html.h2
            [ cs "demo-toolbar-example-heading"
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
                [ cs "demo-toolbar-example-heading__text"
                , css "flex-grow" "1"
                , css "margin-right" "16px"
                ]
                [ text title ]
            , Button.view (lift << Mdc)
                "toolbar-toggle-rtl"
                model.mdc
                [ Button.outlined
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
            []
        ]


defaultToolbar : (Msg m -> m) -> Model m -> Html m
defaultToolbar lift model =
    styled Html.div
        [ Typography.typography
        , cs "mdc-toolbar-demo"
        ]
        [ Toolbar.view (lift << Mdc)
            "default-toolbar-toolbar"
            model.mdc
            []
            [ Toolbar.row []
                [ Toolbar.section
                    [ Toolbar.alignStart
                    ]
                    [ Icon.view [ Toolbar.menuIcon, Options.attribute (Html.href "#") ] "menu"
                    , Toolbar.title [] [ text "Title" ]
                    ]
                , Toolbar.section
                    [ Toolbar.alignEnd
                    ]
                    [ Icon.view [ Toolbar.icon ] "file_download"
                    , Icon.view [ Toolbar.icon ] "print"
                    , Icon.view [ Toolbar.icon ] "bookmark"
                    ]
                ]
            ]
        , body [] model
        ]


fixedToolbar : (Msg m -> m) -> Model m -> Html m
fixedToolbar lift model =
    styled Html.div
        [ Typography.typography
        , cs "mdc-toolbar-demo"
        ]
        [ Toolbar.view (lift << Mdc)
            "fixed-toolbar-toolbar"
            model.mdc
            [ Toolbar.fixed
            ]
            [ Toolbar.row []
                [ Toolbar.section
                    [ Toolbar.alignStart
                    ]
                    [ Icon.view [ Toolbar.menuIcon ] "menu"
                    , Toolbar.title [] [ text "Title" ]
                    ]
                , Toolbar.section
                    [ Toolbar.alignEnd
                    ]
                    [ Icon.view [ Toolbar.icon ] "file_download"
                    , Icon.view [ Toolbar.icon ] "print"
                    , Icon.view [ Toolbar.icon ] "bookmark"
                    ]
                ]
            ]
        , body
            [ Toolbar.fixedAdjust "fixed-toolbar-toolbar" model.mdc
            ]
            model
        ]


menuToolbar : (Msg m -> m) -> Model m -> Html m
menuToolbar lift model =
    styled Html.div
        [ Typography.typography
        , cs "mdc-toolbar-demo"
        ]
        [ Toolbar.view (lift << Mdc)
            "menu-toolbar-toolbar"
            model.mdc
            [ Toolbar.fixed
            ]
            [ Toolbar.row []
                [ Toolbar.section
                    [ Toolbar.alignStart
                    ]
                    [ Icon.view [ Toolbar.menuIcon ] "menu"
                    , Toolbar.title [] [ text "Title" ]
                    ]
                , Toolbar.section
                    [ Toolbar.alignEnd
                    ]
                    [ Icon.view [ Toolbar.icon ] "file_download"
                    , Icon.view [ Toolbar.icon ] "print"
                    , Icon.view
                        [ Toolbar.icon
                        , Menu.attach (lift << Mdc) "menu-toolbar-menu"
                        ]
                        "more_vert"
                    , styled Html.div
                        [ cs "menu-anchor"
                        , css "position" "relative"
                        , css "overflow" "visible"
                        ]
                        [ Menu.view (lift << Mdc)
                            "menu-toolbar-menu"
                            model.mdc
                            [ Menu.anchorCorner Menu.topEndCorner
                            , Menu.anchorMargin
                                { top = 15
                                , right = 15
                                , bottom = 0
                                , left = 0
                                }
                            ]
                            (Menu.ul []
                                [ Menu.li [] [ text "Back" ]
                                , Menu.li [] [ text "Forward" ]
                                , Menu.li [] [ text "Reload" ]
                                , Menu.divider [] []
                                , Menu.li [] [ text "Save as…" ]
                                ]
                            )
                        ]
                    ]
                ]
            ]
        , body
            [ Toolbar.fixedAdjust "menu-toolbar-toolbar" model.mdc
            ]
            model
        ]


waterfallToolbar : (Msg m -> m) -> Model m -> Html m
waterfallToolbar lift model =
    styled Html.div
        [ Typography.typography
        , cs "mdc-toolbar-demo"
        ]
        [ Toolbar.view (lift << Mdc)
            "waterfall-toolbar-toolbar"
            model.mdc
            [ Toolbar.fixed
            , Toolbar.waterfall
            ]
            [ Toolbar.row []
                [ Toolbar.section
                    [ Toolbar.alignStart
                    ]
                    [ Icon.view [ Toolbar.menuIcon ] "menu"
                    , Toolbar.title [] [ text "Title" ]
                    ]
                , Toolbar.section
                    [ Toolbar.alignEnd
                    ]
                    [ Icon.view [ Toolbar.icon ] "file_download"
                    , Icon.view [ Toolbar.icon ] "print"
                    , Icon.view [ Toolbar.icon ] "bookmark"
                    ]
                ]
            ]
        , body
            [ Toolbar.fixedAdjust "waterfall-toolbar-toolbar" model.mdc
            ]
            model
        ]


defaultFlexibleToolbar : (Msg m -> m) -> Model m -> Html m
defaultFlexibleToolbar lift model =
    styled Html.div
        [ Typography.typography
        , cs "mdc-toolbar-demo"
        ]
        [ Toolbar.view (lift << Mdc)
            "default-flexible-toolbar-toolbar"
            model.mdc
            [ Toolbar.flexible
            , Toolbar.flexibleDefaultBehavior
            , Toolbar.backgroundImage "images/4-3.jpg"
            ]
            [ Toolbar.row []
                [ Toolbar.section
                    [ Toolbar.alignStart
                    ]
                    [ Icon.view [ Toolbar.menuIcon ] "menu"
                    , Toolbar.title [] [ text "Title" ]
                    ]
                , Toolbar.section
                    [ Toolbar.alignEnd
                    ]
                    [ Icon.view [ Toolbar.icon ] "file_download"
                    , Icon.view [ Toolbar.icon ] "print"
                    , Icon.view [ Toolbar.icon ] "bookmark"
                    ]
                ]
            ]
        , body [] model
        , floatingFooter model
        ]


waterfallFlexibleToolbar : (Msg m -> m) -> Model m -> Html m
waterfallFlexibleToolbar lift model =
    styled Html.div
        [ Typography.typography
        , cs "mdc-toolbar-demo"
        ]
        [ Toolbar.view (lift << Mdc)
            "waterfall-flexible-toolbar-toolbar"
            model.mdc
            [ Toolbar.fixed
            , Toolbar.flexible
            , Toolbar.flexibleDefaultBehavior
            , Toolbar.waterfall
            , Toolbar.backgroundImage "images/4-3.jpg"
            ]
            [ Toolbar.row []
                [ Toolbar.section
                    [ Toolbar.alignStart
                    ]
                    [ Icon.view [ Toolbar.menuIcon ] "menu"
                    , Toolbar.title [] [ text "Title" ]
                    ]
                , Toolbar.section
                    [ Toolbar.alignEnd
                    ]
                    [ Icon.view [ Toolbar.icon ] "file_download"
                    , Icon.view [ Toolbar.icon ] "print"
                    , Icon.view [ Toolbar.icon ] "bookmark"
                    ]
                ]
            ]
        , body
            [ Toolbar.fixedAdjust "waterfall-flexible-toolbar" model.mdc
            ]
            model
        , floatingFooter model
        ]


waterfallToolbarFix : (Msg m -> m) -> Model m -> Html m
waterfallToolbarFix lift model =
    styled Html.div
        [ Typography.typography
        , cs "mdc-toolbar-demo"
        ]
        [ Toolbar.view (lift << Mdc)
            "waterfall-toolbar-fix-last-row-toolbar"
            model.mdc
            [ Toolbar.fixed
            , Toolbar.flexible
            , Toolbar.flexibleDefaultBehavior
            , Toolbar.waterfall
            , Toolbar.backgroundImage "images/4-3.jpg"
            ]
            [ Toolbar.row []
                [ Toolbar.section
                    [ Toolbar.alignStart
                    ]
                    [ Icon.view [ Toolbar.menuIcon ] "menu"
                    , Toolbar.title [] [ text "Title" ]
                    ]
                ]
            , Toolbar.row []
                [ Toolbar.section
                    [ Toolbar.alignEnd
                    ]
                    [ Icon.view [ Toolbar.icon ] "file_download"
                    , Icon.view [ Toolbar.icon ] "print"
                    , Icon.view [ Toolbar.icon ] "more_vert"
                    ]
                ]
            ]
        , body
            [ Toolbar.fixedAdjust "waterfall-toolbar-fix-last-row-toolbar" model.mdc
            ]
            model
        ]


body : List (Options.Property c m) -> Model m -> Html m
body options model =
    styled Html.div
        options
        (styled Html.p
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


floatingFooter : Model m -> Html m
floatingFooter model =
    let
        getFlexibleExpansionRatio calculations scrollTop =
            let
                delta =
                    0.0001
            in
            max 0 (1 - scrollTop / (calculations.flexibleExpansionHeight + delta))

        flexibleExpansionRatio =
            Dict.get "toolbar-toolbar" model.mdc.toolbar
                |> Maybe.andThen
                    (\model ->
                        Maybe.map ((,) model.scrollTop) model.calculations
                    )
                |> Maybe.map
                    (\( scrollTop, calculations ) ->
                        getFlexibleExpansionRatio calculations scrollTop
                    )
                |> Maybe.withDefault 1
                |> ((*) 100 >> round >> toFloat >> flip (/) 100)
    in
    styled Html.footer
        [ cs "demo-toolbar-floating-footer"
        , css "position" "fixed"
        , css "bottom" "0"
        , css "width" "100%"
        , css "text-align" "center"
        , css "padding" "8px"
        , css "color" "white"
        , css "background-color" "rgba(0, 0, 0, 0.7)"
        ]
        [ styled Html.span
            []
            [ text ("Flexible Expansion Ratio: " ++ toString flexibleExpansionRatio)
            ]
        ]


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
