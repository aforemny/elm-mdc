module Material.Table exposing
  (
    table, thead, tbody, tfoot
  , tr, th, td
  , ascending, descending, sorted, onClick, Order(Ascending,Descending)
  , selected, numeric

  , view, render
  )

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#tables-section):

> The Material Design Lite (MDL) data-table component is an enhanced version of
> the standard HTML <table>. A data-table consists of rows and columns of
> well-formatted data, presented with appropriate user interaction
> capabilities.

> Tables are a ubiquitous feature of most user interfaces, regardless of a
> site's content or function. Their design and use is therefore an important
> factor in the overall user experience. See the data-table component's
> Material Design specifications page for details.

> The available row/column/cell types in a data-table are mostly
> self-formatting; that is, once the data-table is defined, the individual
> cells require very little specific attention. For example, the rows exhibit
> shading behavior on mouseover and selection, numeric values are automatically
> formatted by default, and the addition of a single class makes the table rows
> individually or collectively selectable. This makes the data-table component
> convenient and easy to code for the developer, as well as attractive and
> intuitive for the user.

See also the
[Material Design Specification]([https://www.google.com/design/spec/components/data-tables.html).

Refer to
[this this](https://debois.github.io/elm-mdl/#/tables
for a live demo.

# HTML
@docs table, thead, tbody, tfoot
@docs tr, th, td

# Options
@docs selected
@docs ascending, descending, sorted
@docs numeric

# Parts & Elm architecture
@docs render, view
-}

import Dict
import Html.Events as Html
import Html exposing (Html, Attribute)

import Material.Options as Options exposing (Property, cs, nop)
import Parts exposing (Indexed)


{-|

    table []
    [ thead []
      [ tr []
        [ th [ ascending ] [ text "Material" ]
        , th [ numeric ] [ text "Quantity" ]
        , th [ numeric ] [ text "Unit Price" ]
        ]
      ]
    , tbody []
      [ tr []
        [ td [] [ text "Acrylic (Transparent)" ]
        , td [ numeric ] [ text "25" ]
        , td [ numeric ] [ text "$2.90" ]
        ]

      -- …
      ]
    ]
-}
table
  : List (Property {} m)
  -> List (Html m)
  -> Html m
table options nodes =
  let
    summary =
      Options.collect {} options
  in
    Options.apply summary Html.table
    [ cs "mdl-data-table"
    , cs "mdl-js-data-table"
    , cs "is-upgraded"
    ]
    [
    ]
    nodes


thead : List (Property {} m) -> List (Html m) -> Html m
thead options html =
  let
    summary =
      Options.collect {} options
  in
    Options.apply summary Html.thead [] [] html


tbody : List (Property {} m) -> List (Html m) -> Html m
tbody options html =
  let
    summary =
      Options.collect {} options
  in
    Options.apply summary Html.tbody [] [] html


tfoot : List (Property {} m) -> List (Html m) -> Html m
tfoot options html =
  let
    summary =
      Options.collect {} options
  in
    Options.apply summary Html.tfoot [] [] html


-- Row


{-| A row `tr` can be indicated as selected using `selected`.
-}
type alias Row =
  { selected : Bool
  }


defaultRow : { selected : Bool }
defaultRow =
  { selected = False
  }


tr : List (Property Row m) -> List (Html m) -> Html m
tr options html =
  let
    ({ config } as summary) =
      Options.collect defaultRow options
  in
    Options.apply summary Html.tr
    [ if config.selected then cs "is-selected" else nop
    ]
    [
    ]
    html


selected : Property { a | selected : Bool } m
selected =
  Options.set <| \self -> { self | selected = True }


select : Bool -> Property { a | selected : Bool } m
select value =
  Options.set <| \self -> { self | selected = value }


-- Header


{-| A header `th` that is `numeric` will right-align its text. Additionally,
headers can be indicated as being sorted `ascending` or `descending`. They can
receive mouse clicks via `onClick`.

  th [ ascending, numeric ] [ text "Price" ]
-}
type alias Header m =
  { numeric : Bool
  , sorted : Maybe Order
  , onClick : Maybe (Attribute m)
  }


defaultHeader : Header m
defaultHeader =
  { numeric = False
  , sorted = Nothing
  , onClick = Nothing
  }


th : List (Property (Header m) m) -> List (Html m) -> Html m
th options html =
  let
    ({ config } as summary) =
      Options.collect defaultHeader options
  in
    Options.apply summary Html.th
    [ if config.numeric then nop else cs "mdl-data-table__cell--non-numeric"
    , case config.sorted of
        Just Ascending -> cs "mdl-data-table__header--sorted-ascending"
        Just Descending -> cs "mdl-data-table__header--sorted-descending"
        Nothing -> nop
    ]
    [ config.onClick
    ]
    html


numeric : Property { a | numeric : Bool } m
numeric =
  Options.set <| \self -> { self | numeric = True }


ascending : Property { a | sorted : Maybe Order } m
ascending =
  sorted Ascending


descending : Property { a | sorted : Maybe Order } m
descending =
  sorted Descending


sorted : Order -> Property { a | sorted : Maybe Order } m
sorted order =
  Options.set <| \self -> { self | sorted = Just order }


type Order
  = Ascending
  | Descending


onClick : m -> Property { a | onClick : Maybe (Attribute m) } m
onClick x =
  Options.set (\options -> { options | onClick = Just (Html.onClick x) })


--Cell


{-| Like headers cells `td` can be `numeric`.

    td [ numeric ] [ text "$2.90" ]
-}
type alias Cell =
  { numeric : Bool
  }


defaultCell : { numeric : Bool }
defaultCell =
  { numeric = False
  }


td : List (Property Cell m) -> List (Html m) -> Html m
td options html =
  let
    ({ config } as summary) =
      Options.collect defaultCell options
  in
    Options.apply summary Html.td
    [ if config.numeric then nop else cs "mdl-data-table__cell--non-numeric"
    ]
    [
    ]
    html


-- PART


view
  : List (Property {} m)
  -> List (Html m)
  -> Html m
view = table


render
  : (Parts.Msg a -> m)
  -> Parts.Index
  -> Parts.View a (List (Property {} m) -> List (Html m) -> Html m)
render =
  Parts.create (\_ _ -> view)
    (\_ model -> (model, Cmd.none))
    (\_ -> Dict.empty)
    (\x y -> y)
    {}
