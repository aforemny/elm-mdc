module Demo.LayoutGrid
    exposing
        ( Model
        , Msg(..)
        , defaultModel
        , init
        , subscriptions
        , update
        , view
        )

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Html.Attributes as Html
import Html.Events as Html
import Json.Decode as Json
import Material.LayoutGrid as LayoutGrid
import Material.Options as Options exposing (cs, css, styled, when)
import Task
import Window


type alias Model =
    { desktopMargin : String
    , desktopGutter : String
    , desktopColumnWidth : String
    , tabletMargin : String
    , tabletGutter : String
    , tabletColumnWidth : String
    , phoneMargin : String
    , phoneGutter : String
    , phoneColumnWidth : String
    , windowWidth : Maybe Int
    }


defaultModel : Model
defaultModel =
    { desktopMargin = "24px"
    , desktopGutter = "24px"
    , desktopColumnWidth = "72px"
    , tabletMargin = "16px"
    , tabletGutter = "16px"
    , tabletColumnWidth = "72px"
    , phoneMargin = "16px"
    , phoneGutter = "16px"
    , phoneColumnWidth = "72px"
    , windowWidth = Nothing
    }


type Msg
    = SetDesktopMargin String
    | SetDesktopGutter String
    | SetDesktopColumnWidth String
    | SetTabletMargin String
    | SetTabletGutter String
    | SetTabletColumnWidth String
    | SetPhoneMargin String
    | SetPhoneGutter String
    | SetPhoneColumnWidth String
    | Resize Window.Size


update : (Msg -> m) -> Msg -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        SetDesktopMargin v ->
            ( { model | desktopMargin = v }, Cmd.none )

        SetDesktopGutter v ->
            ( { model | desktopGutter = v }, Cmd.none )

        SetDesktopColumnWidth v ->
            ( { model | desktopColumnWidth = v }, Cmd.none )

        SetTabletMargin v ->
            ( { model | tabletMargin = v }, Cmd.none )

        SetTabletGutter v ->
            ( { model | tabletGutter = v }, Cmd.none )

        SetTabletColumnWidth v ->
            ( { model | tabletColumnWidth = v }, Cmd.none )

        SetPhoneMargin v ->
            ( { model | phoneMargin = v }, Cmd.none )

        SetPhoneGutter v ->
            ( { model | phoneGutter = v }, Cmd.none )

        SetPhoneColumnWidth v ->
            ( { model | phoneColumnWidth = v }, Cmd.none )

        Resize { width, height } ->
            ( { model | windowWidth = Just width }, Cmd.none )


view : (Msg -> m) -> Page m -> Model -> Html m
view lift page model =
    let
        demoGridLegend node text_ =
            styled node
                [ css "display" "block"
                , cs "demo-grid-legend"
                , css "margin" "16px 0 8px 0"
                ]
                [ text text_
                ]

        demoControls =
            Options.many
                [ cs "demo-controls"
                , css "display" "block"
                , css "margin-bottom" "8px"
                ]

        demoGrid =
            Options.many
                [ cs "demo-grid"
                , css "background-color" "#ddd"
                , css "margin-bottom" "32px"
                ]

        demoCell =
            Options.many
                [ cs "demo-cell"
                , css "box-sizing" "border-box"
                , css "background-color" "#666"
                , css "height" "200px"
                , css "padding" "8px"
                , css "color" "white"
                , css "font-size" "1.5rem"
                ]

        demoParentCell =
            Options.many
                [ cs "demo-parent-cell"
                , css "position" "relative"
                , css "background-color" "#aaa"
                ]

        demoChildCell =
            Options.many
                [ demoCell
                , cs "demo-child-cell"
                , css "position" "relative"
                ]

        demoRuler =
            Options.many
                [ cs "demo-ruler"
                , css "position" "fixed"
                , css "display" "flex"
                , css "justify-content" "center"
                , css "bottom" "0"
                , css "left" "0"
                , css "height" "20px"
                , css "width" "100%"
                , css "margin" "0"
                , css "background" "black"
                , css "color" "white"
                ]
    in
    page.body "Layout grid"
        [ Html.node "style"
            [ Html.type_ "text/css"
            ]
            [ text <| """
:root {
    --mdc-layout-grid-margin-desktop: """ ++ model.desktopMargin ++ """;
    --mdc-layout-grid-gutter-desktop: """ ++ model.desktopGutter ++ """;
    --mdc-layout-grid-column-width-desktop: """ ++ model.desktopColumnWidth ++ """;
    --mdc-layout-grid-margin-tablet: """ ++ model.tabletMargin ++ """;
    --mdc-layout-grid-gutter-tablet: """ ++ model.tabletGutter ++ """;
    --mdc-layout-grid-column-width-tablet: """ ++ model.tabletColumnWidth ++ """;
    --mdc-layout-grid-margin-phone: """ ++ model.phoneMargin ++ """;
    --mdc-layout-grid-gutter-phone: """ ++ model.phoneGutter ++ """;
    --mdc-layout-grid-column-width-phone: """ ++ model.phoneColumnWidth ++ """;
}
"""
            ]
        , Page.hero []
            [ LayoutGrid.view
                [ demoGrid
                ]
                (List.repeat 3 <|
                    LayoutGrid.cell
                        [ css "height" "60px"
                        , demoCell -- TODO: change order?
                        , LayoutGrid.span4
                        ]
                        []
                )
            ]
        , let
            margins =
                [ "8px"
                , "16px"
                , "24px"
                , "40px"
                ]

            gutters =
                margins

            columnWidths =
                [ "72px", "84px" ]

            control title set get options =
                styled Html.div
                    [ demoControls
                    ]
                    [ text title
                    , Html.select
                        [ Html.on "change" (Json.map (lift << set) Html.targetValue)
                        ]
                        (options
                            |> List.map
                                (\v ->
                                    Html.option
                                        [ Html.selected (get model == v)
                                        , Html.value v
                                        ]
                                        [ text v
                                        ]
                                )
                        )
                    ]

            controls device setMargin getMargin setGutter getGutter =
                LayoutGrid.cell []
                    [ control (device ++ " Margin:") setMargin getMargin margins
                    , control (device ++ " Gutter:") setGutter getGutter gutters
                    ]
          in
          styled Html.section
            [ cs "examples"
            , css "margin" "24px"
            ]
            [ LayoutGrid.view []
                (let
                    desktopControls =
                        controls "Desktop"
                            SetDesktopMargin
                            .desktopMargin
                            SetDesktopGutter
                            .desktopGutter

                    tabletControls =
                        controls "Tablet"
                            SetTabletMargin
                            .tabletMargin
                            SetTabletGutter
                            .tabletGutter

                    phoneControls =
                        controls "Phone"
                            SetPhoneMargin
                            .phoneMargin
                            SetPhoneGutter
                            .phoneGutter
                 in
                 [ desktopControls
                 , tabletControls
                 , phoneControls
                 ]
                )
            , styled Html.div [ cs "demo-warning" ] []
            , demoGridLegend Html.div "Grid of default wide (4 columns) items"
            , LayoutGrid.view [ demoGrid ]
                (LayoutGrid.cell [ demoCell ] [ text "4" ]
                    |> List.repeat 3
                )
            , demoGridLegend Html.div "Grid of 1 column wide items"
            , LayoutGrid.view [ demoGrid ]
                (LayoutGrid.cell [ demoCell, LayoutGrid.span1 ] [ text "1" ]
                    |> List.repeat 12
                )
            , demoGridLegend Html.div "Grid of differently sized items"
            , LayoutGrid.view [ demoGrid ]
                [ LayoutGrid.cell [ demoCell, LayoutGrid.span6 ] [ text "6" ]
                , LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "4" ]
                , LayoutGrid.cell [ demoCell, LayoutGrid.span2 ] [ text "2" ]
                ]
            , demoGridLegend Html.div "Grid of items with tweaks at different screen sizes"
            , LayoutGrid.view [ demoGrid ]
                [ LayoutGrid.cell
                    [ demoCell
                    , LayoutGrid.span6
                    , LayoutGrid.span8Tablet
                    ]
                    [ text "6 (8 tablet)"
                    ]
                , LayoutGrid.cell
                    [ demoCell
                    , LayoutGrid.span4
                    , LayoutGrid.span6Tablet
                    ]
                    [ text "4 (6 tablet)"
                    ]
                , LayoutGrid.cell
                    [ demoCell
                    , LayoutGrid.span2
                    , LayoutGrid.span4Phone
                    ]
                    [ text "2 (4 phone)"
                    ]
                ]
            , demoGridLegend Html.div "Grid nested within parent grid cell"
            , LayoutGrid.view [ demoGrid ]
                [ LayoutGrid.cell [ demoParentCell, LayoutGrid.span4 ]
                    [ LayoutGrid.inner []
                        (LayoutGrid.cell
                            [ demoChildCell
                            , LayoutGrid.span4
                            ]
                            [ styled Html.span
                                [ css "position" "absolute"
                                , css "bottom" "8px"
                                , css "right" "8px"
                                , css "color" "#ddd"
                                ]
                                [ text "Child 4"
                                ]
                            ]
                            |> List.repeat 3
                        )
                    , styled Html.span
                        [ css "position" "absolute"
                        , css "top" "8px"
                        , css "left" "8px"
                        , css "font-size" "1.5rem"
                        , css "color" "white"
                        ]
                        [ text "Parent 4"
                        ]
                    ]
                , LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "4" ]
                , LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "4" ]
                ]
            , demoGridLegend Html.h2 "Grid with max width"
            , demoGridLegend Html.div "Grid with max width (1280px) and center alignment by default"
            , LayoutGrid.view [ demoGrid, css "max-width" "1280px" ]
                [ LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "" ]
                , LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "" ]
                , LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "" ]
                ]
            , demoGridLegend Html.div "Grid with max width (1280px) and left alignment"
            , LayoutGrid.view [ demoGrid, css "max-width" "1280px", LayoutGrid.alignLeft ]
                [ LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "" ]
                , LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "" ]
                , LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "" ]
                ]
            , demoGridLegend Html.div "Fixed column width layout grid"

            -- TODO: demoControls
            , LayoutGrid.view []
                [ LayoutGrid.cell
                    [ demoControls
                    ]
                    [ control "Desktop Column Width:"
                        SetDesktopColumnWidth
                        .desktopColumnWidth
                        columnWidths
                    ]
                , LayoutGrid.cell
                    [ demoControls
                    ]
                    [ control "Tablet Column Width:"
                        SetTabletColumnWidth
                        .tabletColumnWidth
                        columnWidths
                    ]
                , LayoutGrid.cell
                    [ demoControls
                    ]
                    [ control "Phone Column Width:"
                        SetPhoneColumnWidth
                        .phoneColumnWidth
                        columnWidths
                    ]
                ]
            , demoGridLegend Html.div "Fixed column width layout grid and center alignment by default"
            , LayoutGrid.view
                [ demoGrid
                , LayoutGrid.fixedColumnWidth
                ]
                (LayoutGrid.cell [ demoCell, LayoutGrid.span1 ] []
                    |> List.repeat 3
                )
            , demoGridLegend Html.div "Fixed column width layout grid and right alignment"
            , LayoutGrid.view
                [ demoGrid
                , LayoutGrid.fixedColumnWidth
                , LayoutGrid.alignRight
                ]
                (LayoutGrid.cell [ demoCell, LayoutGrid.span1 ] []
                    |> List.repeat 3
                )
            , styled Html.div
                [ demoRuler
                ]
                [ let
                    device =
                        model.windowWidth
                            |> Maybe.map
                                (\width ->
                                    if width >= 840 then
                                        "desktop"
                                    else if width >= 480 then
                                        "tablet"
                                    else
                                        "phone"
                                )
                            |> Maybe.withDefault "desktop"
                  in
                  Html.div []
                    [ text <|
                        toString (Maybe.withDefault 0 model.windowWidth)
                            ++ "px ("
                            ++ device
                            ++ ")"
                    ]
                ]
            ]
        ]


init : (Msg -> m) -> ( Model, Cmd m )
init lift =
    ( defaultModel, Task.perform (lift << Resize) Window.size )


subscriptions : (Msg -> m) -> Model -> Sub m
subscriptions lift model =
    Window.resizes (lift << Resize)
