module Demo.LayoutGrid exposing
    ( Model
    , Msg(..)
    , defaultModel
    , update
    , view
    )

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Html.Attributes as Html
import Html.Events as Html
import Material
import Material.LayoutGrid as LayoutGrid
import Material.Options exposing (cs, css, styled)
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel }


type Msg m
    = Mdc (Material.Msg m)


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model


demoGrid : List (LayoutGrid.Property m) -> List (Html m) -> Html m
demoGrid options =
    LayoutGrid.view
        (css "background" "rgba(0,0,0,.2)"
            :: css "min-width" "360px"
            :: options
        )


demoCell : List (LayoutGrid.Property m) -> Html m
demoCell options =
    LayoutGrid.cell
        (css "background" "rgba(0,0,0,.2)"
            :: css "height" "100px"
            :: options
        )
        []


heroGrid : Html m
heroGrid =
    demoGrid [] (List.repeat 3 (demoCell []))


columnsGrid : Html m
columnsGrid =
    demoGrid []
        [ demoCell [ LayoutGrid.span6 ]
        , demoCell [ LayoutGrid.span3 ]
        , demoCell [ LayoutGrid.span2 ]
        , demoCell [ LayoutGrid.span1 ]
        , demoCell [ LayoutGrid.span3 ]
        , demoCell [ LayoutGrid.span1 ]
        , demoCell [ LayoutGrid.span8 ]
        ]


leftAlignedGrid : Html m
leftAlignedGrid =
    demoGrid
        [ LayoutGrid.alignLeft
        , css "max-width" "800px"
        ]
        [ demoCell []
        , demoCell []
        , demoCell []
        ]


rightAlignedGrid : Html m
rightAlignedGrid =
    demoGrid
        [ LayoutGrid.alignRight
        , css "max-width" "800px"
        ]
        [ demoCell []
        , demoCell []
        , demoCell []
        ]


cellAlignmentGrid : Html m
cellAlignmentGrid =
    demoGrid
        [ css "min-height" "200px"
        , cs "demo-grid--cell-alignment"
        ]
        [ demoCell [ LayoutGrid.alignTop, css "max-height" "50px" ]
        , demoCell [ LayoutGrid.alignMiddle, css "max-height" "50px" ]
        , demoCell [ LayoutGrid.alignBottom, css "max-height" "50px" ]
        ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Layout Grid"
              , Hero.intro "Material design’s responsive UI is based on a 12-column grid layout."
              , Hero.component [] [ heroGrid ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "" "layout-grid" "mdc-layout-grid"
        , Page.demos
            [ styled Html.h3
                [ Typography.subtitle1 ]
                [ text "Columns" ]
            , columnsGrid
            , styled Html.h3
                [ Typography.subtitle1 ]
                [ text "Grid Left Alignment" ]
            , styled Html.p
                [ Typography.body2 ]
                [ text "This requires a max-width on the top-level grid element." ]
            , leftAlignedGrid
            , styled Html.h3
                [ Typography.subtitle1 ]
                [ text "Grid Right Alignment" ]
            , styled Html.p
                [ Typography.body2 ]
                [ text "This requires a max-width on the top-level grid element." ]
            , rightAlignedGrid
            , styled Html.h3
                [ Typography.subtitle1 ]
                [ text "Cell Alignment" ]
            , styled Html.p
                [ Typography.body2 ]
                [ text "Cell alignment requires a cell height smaller than the inner height of the grid." ]
            , cellAlignmentGrid
            ]
        ]
