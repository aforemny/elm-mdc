module Demo.Grid where

import Material.Grid exposing (..)
import Material.Style exposing (Style, css)

import Markdown

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


intro : Html
intro = """
From the
[Material Design Lite documentation](http://www.getmdl.io/components/#layout-section/grid):

> The Material Design Lite (MDL) grid component is a simplified method for laying
> out content for multiple screen sizes. It reduces the usual coding burden
> required to correctly display blocks of content in a variety of display
> conditions.
>
> The MDL grid is defined and enclosed by a container element. A grid has 12
> columns in the desktop screen size, 8 in the tablet size, and 4 in the phone
> size, each size having predefined margins and gutters. Cells are laid out
> sequentially in a row, in the order they are defined, with some exceptions:
>
>   - If a cell doesn't fit in the row in one of the screen sizes, it flows
>     into the following line.
>   - If a cell has a specified column size equal to or larger than the number
>     of columns for the current screen size, it takes up the entirety of its
>     row.

#### See also

 - [Demo source code](https://github.com/debois/elm-mdl/blob/master/examples/Demo/Grid.elm)
 - [elm-mdl package documentation](http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Grid)
 - [Material Design Specification](https://www.google.com/design/spec/layout/responsive-ui.html#responsive-ui-grid)
 - [Material Design Lite documentation](http://www.getmdl.io/components/#layout-section/grid)

#### Demo

""" |> Markdown.toHtml


