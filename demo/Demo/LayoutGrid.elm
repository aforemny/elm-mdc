module Demo.LayoutGrid exposing (Model,defaultModel,Msg,update,view)

import Html.Attributes as Html
import Html exposing (Html, text)
import Material.LayoutGrid as LayoutGrid
import Material.Options as Options exposing (styled, cs, css, when)


type alias Model =
    {}


defaultModel : Model
defaultModel =
    {}


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    model ! []


view : Model -> Html Msg
view model =
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
    styled Html.section
    [ cs "examples"
    ]
    [ -- TODO: demoControls
      LayoutGrid.view
      [
      ]
      [ LayoutGrid.inner []
        [ LayoutGrid.cell []
          [ styled Html.div
            [ demoControls
            ]
            [ text "Desktop Margin:"
            , Html.select []
              [ Html.option [ Html.value "8px" ] [ text "8px" ]
              , Html.option [ Html.value "16px" ] [ text "16px" ]
              , Html.option [ Html.value "24px" ] [ text "24px" ]
              , Html.option [ Html.value "40px" ] [ text "40px" ]
              ]
            , Html.br [] []
            , text "Desktop Gutter:"
            , Html.select []
              [ Html.option [ Html.value "8px" ] [ text "8px" ]
              , Html.option [ Html.value "16px" ] [ text "16px" ]
              , Html.option [ Html.value "24px" ] [ text "24px" ]
              , Html.option [ Html.value "40px" ] [ text "40px" ]
              ]
            ]
          ]
        , LayoutGrid.cell []
          [ styled Html.div
            [ demoControls
            ]
            [ text "Tablet Margin:"
            , Html.select []
              [ Html.option [ Html.value "8px" ] [ text "8px" ]
              , Html.option [ Html.value "16px" ] [ text "16px" ]
              , Html.option [ Html.value "24px" ] [ text "24px" ]
              , Html.option [ Html.value "40px" ] [ text "40px" ]
              ]
            , Html.br [] []
            , text "Tablet Gutter:"
            , Html.select []
              [ Html.option [ Html.value "8px" ] [ text "8px" ]
              , Html.option [ Html.value "16px" ] [ text "16px" ]
              , Html.option [ Html.value "24px" ] [ text "24px" ]
              , Html.option [ Html.value "40px" ] [ text "40px" ]
              ]
            ]
          ]
        , LayoutGrid.cell []
          [ styled Html.div
            [ demoControls
            ]
            [ text "Phone Margin:"
            , Html.select []
              [ Html.option [ Html.value "8px" ] [ text "8px" ]
              , Html.option [ Html.value "16px" ] [ text "16px" ]
              , Html.option [ Html.value "24px" ] [ text "24px" ]
              , Html.option [ Html.value "40px" ] [ text "40px" ]
              ]
            , Html.br [] []
            , text "Phone Gutter:"
            , Html.select []
              [ Html.option [ Html.value "8px" ] [ text "8px" ]
              , Html.option [ Html.value "16px" ] [ text "16px" ]
              , Html.option [ Html.value "24px" ] [ text "24px" ]
              , Html.option [ Html.value "40px" ] [ text "40px" ]
              ]
            ]
          ]
        ]
      ]

    , styled Html.div [ cs "demo-warning" ] []

    , demoGridLegend Html.div "Grid of default wide (4 columns) items"
    , LayoutGrid.view [ demoGrid ]
      [ LayoutGrid.inner []
        ( LayoutGrid.cell [ demoCell ] [ text "4" ]
          |> List.repeat 3
        )
      ]

    , demoGridLegend Html.div "Grid of 1 column wide items"
    , LayoutGrid.view [ demoGrid ]
      [ LayoutGrid.inner []
        ( LayoutGrid.cell [ demoCell, LayoutGrid.span1 ] [ text "1" ]
          |> List.repeat 12
        )
      ]

    , demoGridLegend Html.div "Grid of differently sized items"
    , LayoutGrid.view [ demoGrid ]
      [ LayoutGrid.inner []
        [ LayoutGrid.cell [ demoCell, LayoutGrid.span6 ] [ text "6" ]
        , LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "4" ]
        , LayoutGrid.cell [ demoCell, LayoutGrid.span2 ] [ text "2" ]
        ]
      ]

    , demoGridLegend Html.div "Grid of items with tweaks at different screen sizes"
    , LayoutGrid.view [ demoGrid ]
      [ LayoutGrid.inner []
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
      ]

    , demoGridLegend Html.div "Grid nested within parent grid cell"
    , LayoutGrid.view [ demoGrid ]
      [ LayoutGrid.inner []
        [ LayoutGrid.cell [ demoParentCell, LayoutGrid.span4 ]
          [ LayoutGrid.inner []
            ( LayoutGrid.cell
              [ demoChildCell, LayoutGrid.span4
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
      ]

    , demoGridLegend Html.h2 "Grid with max width"
    , demoGridLegend Html.div "Grid with max width (1280px) and center alignment by default"
    , LayoutGrid.view [ demoGrid, css "max-width" "1280px" ]
      [ LayoutGrid.inner []
        [ LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "" ]
        , LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "" ]
        , LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "" ]
        ]
      ]

    , demoGridLegend Html.div "Grid with max width (1280px) and left alignment"
    , LayoutGrid.view [ demoGrid, css "max-width" "1280px", LayoutGrid.alignLeft ]
      [ LayoutGrid.inner []
        [ LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "" ]
        , LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "" ]
        , LayoutGrid.cell [ demoCell, LayoutGrid.span4 ] [ text "" ]
        ]
      ]

    , demoGridLegend Html.div "Fixed column width layout grid"

    -- TODO: demoControls
    , LayoutGrid.view []
      [ LayoutGrid.inner []
        [ LayoutGrid.cell
          [ demoControls
          ]
          [ text "Desktop Column Width:"
          , Html.select []
            [ Html.option [ Html.value "72px", Html.selected True ] [ text "72px" ]
            , Html.option [ Html.value "84px", Html.selected True ] [ text "84px" ]
            ]
          ]
        , LayoutGrid.cell
          [ demoControls
          ]
          [ text "Tablet Column Width:"
          , Html.select []
            [ Html.option [ Html.value "72px", Html.selected True ] [ text "72px" ]
            , Html.option [ Html.value "84px", Html.selected True ] [ text "84px" ]
            ]
          ]
        , LayoutGrid.cell
          [ demoControls
          ]
          [ text "Phone Column Width:"
          , Html.select []
            [ Html.option [ Html.value "72px", Html.selected True ] [ text "72px" ]
            , Html.option [ Html.value "84px", Html.selected True ] [ text "84px" ]
            ]
          ]
        ]
      ]

    , demoGridLegend Html.div "Fixed column width layout grid and center alignment by default"
    , LayoutGrid.view
      [ demoGrid
      -- TODO: fixedColumnWidth
      -- , LayoutGrid.fixedColumnWidth
      , css "max-width" "1280px"
      ]
      [ LayoutGrid.inner []
        ( LayoutGrid.cell [ demoCell, LayoutGrid.span1 ] []
          |> List.repeat 3
        )
      ]

    , demoGridLegend Html.div "Fixed column width layout grid and right alignment"
    , LayoutGrid.view
      [ demoGrid
      -- TODO: fixedColumnWidth
      -- , LayoutGrid.fixedColumnWidth
      , css "max-width" "1280px"
      , LayoutGrid.alignRight
      ]
      [ LayoutGrid.inner []
        ( LayoutGrid.cell [ demoCell, LayoutGrid.span1 ] []
          |> List.repeat 3
        )
      ]

    , -- TODO: demoRuler
      styled Html.div [ demoRuler ] [ text "???px (?)" ]
    ]
