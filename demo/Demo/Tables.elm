module Demo.Tables exposing (..)

import Html exposing (Html, text)
import Dict exposing (Dict)

import Material
import Material.Options as Options exposing (when)
import Material.Table as Table
import Material.Toggles as Toggles

import Demo.Code as Code
import Demo.Page as Page


-- MODEL


type alias Model =
  { mdl : Material.Model
  , order : Table.Order

  , data : Dict Int
      { material : String
      , quantity : String
      , unitPrice : String
      , selected : Bool
      , index : Int
      }
  }


model : Model
model =
  { mdl = Material.model
  , order = Table.Ascending
  , data =
      Dict.fromList << List.map (\r -> (r.index, r)) <|
      [ { material = "Acrylic (Transparent)"
        , quantity = "25"
        , unitPrice = "$2.90"
        , selected = False
        , index = 0
        }
      , { material = "Plywood (Birch)"
        , quantity = "50"
        , unitPrice = "$1.25"
        , selected = False
        , index = 1
        }
      , { material = "Laminate (Gold on Blue)"
        , quantity = "10"
        , unitPrice = "$2.35"
        , selected = False
        , index = 2
        }
      ]
  }


-- ACTION, UPDATE


type Msg
  = MDL Material.Msg
  | Toggle (Maybe Int)
  | Click


update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of

    Click ->
      { model
        | order =
          case model.order of
            Table.Ascending -> Table.Descending
            _ -> Table.Ascending
      } ! []

    Toggle Nothing ->
      -- Note: We have access to all data, so we can do this:
      { model
        | data =
          Dict.map (\_ r -> { r | selected = not (allSelected model.data) })
          model.data
      } ! []

    Toggle (Just idx) ->
      { model
        | data =
          Dict.update idx (Maybe.map (\r -> { r | selected = not r.selected }))
          model.data
      } ! []

    MDL msg' ->
      Material.update MDL msg' model


-- VIEW


type alias Mdl =
  Material.Model


view : Model -> Html Msg
view model =
  [ table model 
  , code 
  ]
  |> Page.body2 "Tables" srcUrl intro references


table : Model -> Html Msg
table model =
  let
    sortedData =
      model.data
      |> Dict.values
      |> List.sortBy .material
      |> if model.order == Table.Descending then List.reverse else \x -> x
  in
    Table.table []
    [
      Table.thead
      [
      ]
      [ Table.tr []
        [ Table.th []
          [ Toggles.checkbox MDL [-1] model.mdl
            [ Toggles.onClick (Toggle Nothing)
            , Toggles.value (allSelected model.data)
            ] []
          ]
        , Table.th
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
             [ Table.selected `when` item.selected
             ]
             [ Table.td []
               [ Toggles.checkbox MDL [item.index] model.mdl
                 [ Toggles.onClick (Toggle (Just item.index))
                 , Toggles.value item.selected
                 ] []
               ]
             , Table.td [] [ text item.material ]
             , Table.td [ Table.numeric ] [ text item.quantity ]
             , Table.td [ Table.numeric ] [ text item.unitPrice ]
             ]
           )
      )
    ]

allSelected : Dict comparable { a | selected : Bool } -> Bool
allSelected data =
  data |> Dict.values >> List.map .selected >> List.foldl (&&) True


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
