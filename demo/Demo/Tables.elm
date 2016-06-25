module Demo.Tables exposing (..)

import Html exposing (..)

import Material
import Material.Grid as Grid exposing (grid, cell, size, Device(..))
import Material.Helpers exposing (pure, map1st, map2nd)
import Material.Table as Table

import Demo.Code as Code
import Demo.Page as Page


-- MODEL


type alias Model =
  { mdl : Material.Model
  , order : Table.Order
  }


model : Model
model =
  { mdl = Material.model
  , order = Table.Ascending
  }


-- ACTION, UPDATE


type Msg
  = MDL Material.Msg
  | Click


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of

    Click ->
      pure
      { model | order =
                  case model.order of
                    Table.Ascending -> Table.Descending
                    _ -> Table.Ascending
      }

    MDL msg' ->
      Material.update MDL msg' model


-- VIEW


type alias Mdl =
  Material.Model


view : Model -> Html Msg
view model =
  [ grid []
    [ cell [ size Desktop 4, size Tablet 8, size Phone 4 ] [ table model ]
    , cell [ size Desktop 8, size Tablet 8, size Phone 4 ] [ code ]
    ]
  ]
  |> Page.body2 "Tables" srcUrl intro references


data
  : List
    { material : String
    , quantity : String
    , unitPrice : String
    }
data =
  [ { material = "Acrylic (Transparent)"
    , quantity = "25"
    , unitPrice = "$2.90"
    }
  , { material = "Plywood (Birch)"
    , quantity = "50"
    , unitPrice = "$1.25"
    }
  , { material = "Laminate (Gold on Blue)"
    , quantity = "10"
    , unitPrice = "$2.35"
    }
  ]


table : Model -> Html Msg
table model =
  let
    sortedData =
      data
      |> List.sortBy .material
      |> if model.order == Table.Descending then List.reverse else \x -> x
  in
    Table.table []
    [
      Table.thead
      [
      ]
      [ Table.tr []
        [ Table.th
          [ Table.sorted model.order
          , Table.onClick Click
          ]
          [ text "Material"
          ]
        , Table.th [ Table.numeric ]
          [ text "Quantity"
          ]
        , Table.th [ Table.numeric ]
          [ text "Unit Price"
          ]
        ]
      ]

    , Table.tbody []
      ( sortedData
        |> List.map (\item ->

             Table.tr
             [
             ]
             [ Table.td [] [ text item.material ]
             , Table.td [ Table.numeric ] [ text item.quantity ]
             , Table.td [ Table.numeric ] [ text item.unitPrice ]
             ]
           )
      )
    ]


code : Html msg
code =
  Code.code """
    Table.table []
      [ Table.thead []
          [ Table.tr []
              [ Table.th
                  [ Table.sorted model.order ]
                  [ text "Material" ]
              , Table.th 
                  [ Table.numeric ]
                  [ text "Quantity" ]
              , Table.th 
                  [ Table.numeric ]
                  [ text "Unit Price" ]
              ]
          ]
      , Table.tbody []
          ( sortedData |> List.map (\\item ->
             Table.tr []
               [ Table.td [] [ text item.material ]
               , Table.td [ Table.numeric ] [ text item.quantity ]
               , Table.td [ Table.numeric ] [ text item.unitPrice ]
               ]
            )
          )
      ]

    {- sortedData
        : List
            { material : String
            , quantity : String
            , unitPrice : String
            }
    -}
  """


intro : Html Msg
intro =
  Page.fromMDL "https://www.getmdl.io/components/index.html#tables-section" """
> The Material Design Lite (MDL) data-table component is an enhanced version of
> the standard HTML &lt;table&gt;. A data-table consists of rows and columns of
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
"""


srcUrl : String
srcUrl =
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Tables.elm"


references : List (String, String)
references =
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Table"
  , Page.mds "https://www.google.com/design/spec/components/data-tables.html"
  , Page.mdl "https://www.getmdl.io/components/index.html#tables"
  ]
