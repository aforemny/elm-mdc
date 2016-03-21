module Demo.Grid where

import Material.Grid exposing (..)
import Material.Style exposing (Style, css)

import Html exposing (..)

-- Cell styling

style : Int -> List Style
style h = 
  [ css "text-sizing" "border-box"
  , css "background-color" "#BDBDBD"
  , css "height" (toString h ++ "px")
  , css "padding-left" "8px"
  , css "padding-top" "4px"
  , css "color" "white"
  ]

-- Cell variants

democell : Int -> List Style -> List Html -> Cell
democell k styling = 
  cell <| List.concat [style k, styling] 
  
small : List Style -> List Html -> Cell
small = democell 50

std : List Style -> List Html -> Cell
std = democell 200

-- Grid 

view : List Html
view =
  [ [1..12]
    |> List.map (\i -> small [size All 1] [text "1"])
    |> grid []
  , [1 .. 3]
    |> List.map (\i -> std [size All 4] [text <| "4"])
    |> grid []
  , [ std [size All 6] [text "6"]
    , std [size All 4] [text "4"]
    , std [size All 2] [text "2"]
    ] |> grid []
  , [ std [size All 6, size Tablet 8] [text "6 (8 tablet)"]
    , std [size All 4, size Tablet 6] [text "4 (6 tablet)"]
    , std [size All 2, size Phone 4] [text "2 (4 phone)"]
    ] |> grid []
  ]


