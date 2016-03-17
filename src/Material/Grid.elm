module Material.Grid
  ( grid, gridWithOptions, Options
  , cell
  , Device(..)
  , Align(..)
  , CellConfig
  , size
  , offset
  , align
  , hide
  , order
  ) where

{-| From the
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
>     row."

Example use:

    import Material.Grid exposing (grid, cell, size, Device(..))

    top : Html
    top =
      grid
        [ cell [ size All 4 ]
            [ h4 [] [text "Cell 1"]
            ]
        , cell [ offset All 2, size All 4 ]
            [ h4 [] [text "Cell 2"]
            , p [] [text "This cell is offset by 2"]
            ]
        , cell [ size All 6 ]
            [ h4 [] [text "Cell 3"]
            ]
        , cell [ size Tablet 6, size Desktop 12, size Phone 2 ]
            [ h4 [] [text "Cell 4"]
            , p [] [text "Size varies with device"]
            ]
        ]

# Grid container
@docs grid, Options, gridWithOptions

# Cells

Cells are configured with a `List CellConfig`; this configuration dictates the
size, offset, and alignment behaviour of the cell. Construct
individual `CellConfig` elements using `size`, `offset`, and `align`.

@docs cell, CellConfig, Device, size, offset, Align, align, hide, order
-}


{- TODO.

1. From MDL docs:

  "You can set a maximum grid width, after which the grid stays centered with
   padding on either side, by setting its max-width CSS property."

2. mdl-cell--stretch
-}


import Html exposing (..)
import Html.Attributes exposing (..)
import String
import Material.Helpers exposing (clip, filter)


{-| The `spacing` parameter indicates whether or not the grid should have
spacing between cells. The `maxWidth` parameter, which must be a valid CSS
dimension, indicates the maximum
width of the grid; if the grid is in a larger container, it stays centered with
padding on either side.
-}
type alias Options =
  { spacing : Bool
  , maxWidth : Maybe String
  }


{-| By default, a grid has spacing between columns, but no maximum width.
-}
defaultOptions : Options
defaultOptions =
  { spacing = True
  , maxWidth = Nothing
  }


{-| Construct a grid with options.
-}
gridWithOptions : Options -> List Cell -> Html
gridWithOptions options elms =
  div
    [ classList
        [ ("mdl-grid", True)
        , ("mdl-grid--no-spacing", not options.spacing)
        ]
    , style (
        options.maxWidth
        |> Maybe.map (\maxwidth -> [("max-width", maxwidth)])
        |> Maybe.withDefault []
      )
    ]
    (List.map (\(Cell elm) -> elm) elms)


{-| Construct a grid with default options (i.e., default spacing, no
maximum width.) Use `cell` some number of times to construct the argument
list.
-}
grid : List Cell -> Html
grid = gridWithOptions defaultOptions


{-| Device specifiers, used with `size` and `offset`. (A `Device` really
encapsulates a screen size.)
-}
type Device = All | Desktop | Tablet | Phone


{-| Opaque type; construct with `size`, `offset`, `align`, etc.
-}
type CellConfig = Config String


{- Opaque cell type.
-}
type Cell = Cell Html


suffix : Device -> String
suffix device =
  case device of
    All -> ""
    Desktop -> "-desktop"
    Tablet -> "-tablet"
    Phone -> "-phone"


{-| Specify cell size. On devices of type `Device`, the
cell being specified spans `Int` columns.
-}
size : Device -> Int -> CellConfig
size device k =
  let c =
    case device of
      All -> clip 1 12 k
      Desktop -> clip 1 12 k
      Tablet -> clip 1 8 k
      Phone -> clip 1 4 k
  in
    "mdl-cell--" ++ toString c ++ "-col" ++ suffix device |> Config


{-| Specify cell offset, i.e., empty number of empty cells before the present
one. On devices of type `Device`, leave `Int` columns blank before the present
one begins.
-}
offset : Device -> Int -> CellConfig
offset device k =
  let c =
    case device of
      All -> clip 1 11 k
      Desktop -> clip 1 11 k
      Tablet -> clip 1 7 k
      Phone -> clip 1 3 k
  in
    "mdl-cell--" ++ toString c ++ "-offset" ++ suffix device |> Config


{-| Vertical alignment of cells; use with `align`.
-}
type Align = Top | Middle | Bottom


{-| Specify vertical cell alignment. See `Align`.
-}
align : Align -> CellConfig
align a =
  Config <| case a of
    Top -> "mdl-cell--top"
    Middle -> "mdl-cell--middle"
    Bottom -> "mdl-cell--bottom"


{-| Specify that a cell should be hidden on given `Device`.
-}
hide : Device -> CellConfig
hide device =
  Config <| case device of
    All -> ""
    _ -> "mdl-cell--hide-" ++ suffix device


{-| Specify that a cell should re-order itself to position 'Int' on `Device`.
-}
order : Device -> Int -> CellConfig
order device n =
  Config <| "mdl-cell--order-" ++ (toString <| clip 1 12 n) ++ suffix device


{-| Construct a cell for use in the argument list for `grid`.
Construct the cell configuration (first argument) using `size`, `offset`, and
`align`. Supply contents for the cell as the second argument.
-}
cell : List CellConfig -> List Html -> Cell
cell configs elms =
  Cell <| div
    [class <| String.join " " ("mdl-cell" :: (List.map (\(Config s) -> s) configs))]
    elms
