module Material.DataTable exposing
    ( Property
    , view
    , table
    , thead
    , trh
    , th
    , tbody
    , tr
    , td
    , tdNum
    , numeric
    , headerCheckbox
    , headerRowCheckbox
    , checkbox
    , rowCheckbox
    , selectedRow
    )

{-| Data tables display information in a grid-like format of rows and
columns. They organize information in a way that’s easy to scan, so
that users can look for patterns and insights.

WARNING: This interface will likely see breaking changes in the future
when more functionality is added by the MDC team.


# Resources

  - [Data Table - Components for the Web](https://material.io/develop/web/components/data-tables/)
  - [Material Design guidelines: Data tables](https://material.io/components/data-tables/)
  - [Demo](https://aforemny.github.io/elm-mdc/#data-tables)


# Example

    import Html exposing (text)
    import Material.DataTable as DataTable exposing
      (table, thead, tbody, tr, trh, th, td, numeric)

    DataTable.view
        [ ]
        [ table []
              [ thead []
                    [ trh []
                         [ th [] [ text "Dessert" ]
                         , th [] [ text "Calories" ]
                         ]
                    ]
              , tbody []
                    [ tr []
                         [ td [ ] [ text "Frozen yogurt" ]
                         , td [ numeric ] [ text "159" ]
                         ]
                    ]
              ]
        ]


# Usage

@docs Property
@docs view
@docs table
@docs thead
@docs trh
@docs th
@docs tbody
@docs tr
@docs td
@docs tdNum


# Cell modifier classes

@docs numeric


# Data table with row selection

@docs headerCheckbox
@docs headerRowCheckbox
@docs checkbox
@docs rowCheckbox
@docs selectedRow

-}

import Html exposing (Html)
import Internal.DataTable.Implementation as DataTable
import Material.Checkbox as Checkbox


{-| A data table property.
-}
type alias Property m =
    DataTable.Property m


{-| The data table view.
-}
view :
    List (Property m)
    -> List (Html m)
    -> Html m
view =
    DataTable.view


{-| Data table table.
-}
table :
    List (Property m)
    -> List (Html m)
    -> Html m
table =
    DataTable.table


{-| Data table thead.
-}
thead :
    List (Property m)
    -> List (Html m)
    -> Html m
thead =
    DataTable.thead


{-| Use this instead of `tr` inside a `thead`.
-}
trh :
    List (Property m)
    -> List (Html m)
    -> Html m
trh =
    DataTable.trh


{-| Data table th.
-}
th :
    List (Property m)
    -> List (Html m)
    -> Html m
th =
    DataTable.th


{-| Data table tbody.
-}
tbody :
    List (Property m)
    -> List (Html m)
    -> Html m
tbody =
    DataTable.tbody


{-| Data table tr in body.
-}
tr :
    List (Property m)
    -> List (Html m)
    -> Html m
tr =
    DataTable.tr


{-| Data table td.
-}
td :
    List (Property m)
    -> List (Html m)
    -> Html m
td =
    DataTable.td


{-| Cell with numeric data. Short-hand for `td [ numeric ] []`.
-}
tdNum :
    List (Property m)
    -> List (Html m)
    -> Html m
tdNum options nodes =
    td (numeric :: options) nodes


{-| Add this class to a table cell element that contains numeric data.
-}
numeric : Property m
numeric =
    DataTable.numeric


{-| Optional. Header table cell element that contains the mdc-checkbox.
-}
headerCheckbox : Property m
headerCheckbox =
    DataTable.headerCheckbox


{-| Add this class name to the `Checkbox.view` element rendered inside
the header cell to override styles required for data-table.
-}
headerRowCheckbox : Checkbox.Property m
headerRowCheckbox =
    DataTable.headerRowCheckbox


{-| Optional. Table cell element that contains the mdc-checkbox.
-}
checkbox : Property m
checkbox =
    DataTable.checkbox


{-| Add this class name to the `Checkbox.view` element rendered inside
the data cellto override styles required for data-table.
-}
rowCheckbox : Checkbox.Property m
rowCheckbox =
    DataTable.rowCheckbox


{-| Modifier class to add to a `tr` when a table row is selected.
-}
selectedRow : Property m
selectedRow =
    DataTable.selectedRow
