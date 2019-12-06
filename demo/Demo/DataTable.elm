module Demo.DataTable exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, div, text)
import Material
import Material.Checkbox as Checkbox
import Material.DataTable as DataTable exposing (checkbox, headerCheckbox, headerRowCheckbox, numeric, rowCheckbox, table, tbody, td, tdNum, th, thead, tr, trh)
import Material.Options as Options exposing (aria, css, styled, when)
import Set exposing (Set)


type alias Model m =
    { mdc : Material.Model m
    , checked : Set Int
    , maxRows : Int
    , allRowsChecked : Bool
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , checked = Set.fromList [ 2 ]
    , maxRows = 3
    , allRowsChecked = False
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleChecked Int


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleChecked idx ->
            let
                isMember =
                    Set.member idx model.checked

                checked =
                    if isMember then
                        Set.remove idx model.checked

                    else
                        Set.insert idx model.checked
            in
            ( { model | checked = checked, allRowsChecked = Set.size checked == model.maxRows }, Cmd.none )


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Data Table"
              , Hero.intro "Data tables display information in a way that’s easy to scan, so that users can look for patterns and insights."
              , Hero.component [] [ heroDataTable ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "data-tables" "data-tables" "mdc-data-table"
        , Page.demos
            [ standardDataTable
            , rowSelectionDataTable lift model
            ]
        ]


dataTable =
    DataTable.view
        []
        [ table
            [ aria "label" "Dessert calories" ]
            [ thead []
                [ trh []
                    [ th [] [ text "Dessert" ]
                    , th [] [ text "Calories" ]
                    , th [] [ text "Fat" ]
                    , th [] [ text "Carbs" ]
                    , th [] [ text "Protein (g)" ]
                    ]
                ]
            , tbody []
                [ tr []
                    [ td [] [ text "Frozen yogurt" ]
                    , td [ numeric ] [ text "159" ]
                    , td [ numeric ] [ text "6" ]
                    , td [ numeric ] [ text "24" ]
                    , td [ numeric ] [ text "4" ]
                    ]
                , tr []
                    [ td [] [ text "Icecream sandwich" ]
                    , tdNum [] [ text "237" ]
                    , tdNum [] [ text "9" ]
                    , tdNum [] [ text "37" ]
                    , tdNum [] [ text "4.3" ]
                    ]
                , tr []
                    [ td [] [ text "Eclair" ]
                    , tdNum [] [ text "262" ]
                    , tdNum [] [ text "16" ]
                    , tdNum [] [ text "24" ]
                    , tdNum [] [ text "6" ]
                    ]
                ]
            ]
        ]


dataTableWithRowSelection lift model =
    let
        tdCheckbox idx =
            let
                index =
                    "checkbox-row-" ++ String.fromInt idx

                isChecked =
                    Set.member idx model.checked
            in
            td
                [ checkbox ]
                [ Checkbox.view (lift << Mdc)
                    index
                    model.mdc
                    [ rowCheckbox
                    , Checkbox.checked isChecked
                    , Options.onClick (lift (ToggleChecked idx))
                    ]
                    []
                ]

        selectedRow idx =
            DataTable.selectedRow |> when (Set.member idx model.checked)
    in
    DataTable.view
        []
        [ table
            [ aria "label" "Dessert calories" ]
            [ thead []
                [ trh []
                    [ th [ headerCheckbox ]
                        [ Checkbox.view (lift << Mdc)
                            "checkbox-header"
                            model.mdc
                            [ headerRowCheckbox
                            , Checkbox.checked True |> when model.allRowsChecked
                            , Checkbox.checked False |> when (Set.isEmpty model.checked)
                            ]
                            []
                        ]
                    , th [] [ text "Dessert" ]
                    , th [] [ text "Calories" ]
                    , th [] [ text "Fat" ]
                    , th [] [ text "Carbs" ]
                    , th [] [ text "Protein (g)" ]
                    ]
                ]
            , tbody []
                [ tr [ selectedRow 1 ]
                    [ tdCheckbox 1
                    , td [] [ text "Frozen yogurt" ]
                    , td [ numeric ] [ text "159" ]
                    , td [ numeric ] [ text "6" ]
                    , td [ numeric ] [ text "24" ]
                    , td [ numeric ] [ text "4" ]
                    ]
                , tr [ selectedRow 2 ]
                    [ tdCheckbox 2
                    , td [] [ text "Icecream sandwich" ]
                    , tdNum [] [ text "237" ]
                    , tdNum [] [ text "9" ]
                    , tdNum [] [ text "37" ]
                    , tdNum [] [ text "4.3" ]
                    ]
                , tr [ selectedRow 3 ]
                    [ tdCheckbox 3
                    , td [] [ text "Eclair" ]
                    , tdNum [] [ text "262" ]
                    , tdNum [] [ text "16" ]
                    , tdNum [] [ text "24" ]
                    , tdNum [] [ text "6" ]
                    ]
                ]
            ]
        ]


heroDataTable =
    dataTable


h4 header =
    styled Html.h4
        [ css "font-size" "1rem"
        , css "font-weight" "400"
        , css "letter-spacing" "0.009375em"
        , css "line-height" "1.75rem"
        ]
        [ text header ]


standardDataTable =
    div []
        [ h4 "Data Table Standard"
        , dataTable
        ]


rowSelectionDataTable lift model =
    div []
        [ h4 "Data Table with Row Selection"
        , dataTableWithRowSelection lift model
        ]
