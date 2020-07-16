module Internal.DataTable.Implementation exposing
    ( Property
    , checkbox
    , headerCheckbox
    , headerRowCheckbox
    , numeric
    , rowCheckbox
    , selectedRow
    , table
    , tbody
    , td
    , th
    , thead
    , tr
    , trh
    , view
    )

import Html exposing (Html, div)
import Internal.Checkbox.Implementation as Checkbox
import Internal.Options as Options exposing (cs, role, styled)


type alias Property m =
    Options.Property {} m


view :
    List (Property m)
    -> List (Html m)
    -> Html m
view options nodes =
    let
        summary =
            Options.collect {} options
    in
    Options.apply summary
        Html.div
        [ block ]
        []
        [ styled div
              [ element "container"]
              nodes
        ]


table :
    List (Property m)
    -> List (Html m)
    -> Html m
table options nodes =
    let
        summary =
            Options.collect {} options
    in
    Options.apply summary
        Html.table
        [ element "table" ]
        []
        nodes


thead :
    List (Property m)
    -> List (Html m)
    -> Html m
thead options nodes =
    styled Html.thead options nodes


tbody :
    List (Property m)
    -> List (Html m)
    -> Html m
tbody options nodes =
    styled Html.tbody options nodes


trh :
    List (Property m)
    -> List (Html m)
    -> Html m
trh options nodes =
    let
        summary =
            Options.collect {} options
    in
    Options.apply summary
        Html.tr
        [ element "header-row" ]
        []
        nodes


tr :
    List (Property m)
    -> List (Html m)
    -> Html m
tr options nodes =
    let
        summary =
            Options.collect {} options
    in
    Options.apply summary
        Html.tr
        [ element "row" ]
        []
        nodes


th :
    List (Property m)
    -> List (Html m)
    -> Html m
th options nodes =
    let
        summary =
            Options.collect {} options
    in
    Options.apply summary
        Html.th
        [ element "header-cell"
        , role "columnheader"
        ]
        []
        nodes


td :
    List (Property m)
    -> List (Html m)
    -> Html m
td options nodes =
    let
        summary =
            Options.collect {} options
    in
    Options.apply summary
        Html.td
        [ element "cell" ]
        []
        nodes


numeric : Property m
numeric =
    cs "mdc-data-table__cell--numeric"


headerCheckbox : Property m
headerCheckbox =
    cs "mdc-data-table__header-cell--checkbox"


headerRowCheckbox : Checkbox.Property m
headerRowCheckbox =
    cs "mdc-data-table__header-row-checkbox"


checkbox : Property m
checkbox =
    cs "mdc-data-table__cell--checkbox"


rowCheckbox : Checkbox.Property m
rowCheckbox =
    cs "mdc-data-table__row-checkbox"


selectedRow : Property m
selectedRow =
    cs "mdc-data-table__row--selected"


{- Make it easier to work with BEM conventions
-}
block : Property m
block =
    cs blockName

element : String -> Property m
element module_ =
    cs ( blockName ++ "__" ++ module_ )

blockName : String
blockName =
    "mdc-data-table"
