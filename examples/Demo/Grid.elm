module Demo.Grid where

import Material.Grid exposing (..)
import Html exposing (..)


view : List Html
view =
  [ [1..12]
    |> List.map (\i -> cell [size All 1] [text "1"])
    |> grid []
  , [1 .. 3]
    |> List.map (\i -> cell [size All 4] [text <| "4"])
    |> grid []
  , [ cell [size All 6] [text "6"]
    , cell [size All 4] [text "4"]
    , cell [size All 2] [text "2"]
    ] |> grid []
  , [ cell [size All 6, size Tablet 8] [text "6 (8 tablet)"]
    , cell [size All 4, size Tablet 6] [text "4 (6 tablet)"]
    , cell [size All 2, size Phone 4] [text "2 (4 phone)"]
    ] |> grid []
  , Html.node "style" [] [text """
      .mdl-cell {
        text-sizing: border-box;
        background-color: #BDBDBD;
        height: 200px;
        padding-left: 8px;
        padding-top: 4px;
        color: white;
      }
      .mdl-grid:first-of-type .mdl-cell {
        height: 50px;
      }
    """]
  ]


