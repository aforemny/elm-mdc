module Material.LayoutGrid
    exposing
        ( Property
        , alignBottom
        , alignLeft
        , alignMiddle
        , alignRight
        , alignTop
        , cell
        , fixedColumnWidth
        , inner
        , span1
        , span10
        , span10Desktop
        , span11
        , span11Desktop
        , span12
        , span12Desktop
        , span1Desktop
        , span1Phone
        , span1Tablet
        , span2
        , span2Desktop
        , span2Phone
        , span2Tablet
        , span3
        , span3Desktop
        , span3Phone
        , span3Tablet
        , span4
        , span4Desktop
        , span4Phone
        , span4Tablet
        , span5
        , span5Desktop
        , span5Tablet
        , span6
        , span6Desktop
        , span6Tablet
        , span7
        , span7Desktop
        , span7Tablet
        , span8
        , span8Desktop
        , span8Tablet
        , span9
        , span9Desktop
        , view
        )

{-| Material design’s responsive UI is based on a column-variate grid layout. It
has 12 columns on desktop, 8 columns on tablet and 4 columns on phone.


# Resources

  - [Material Design guidelines: Layout grid](https://material.io/guidelines/layout/responsive-ui.html#responsive-ui-grid)
  - [Demo](https://aforemny.github.io/elm-mdc/#layout-grid)


# Example

    import Material.LayoutGrid as LayoutGrid


    LayoutGrid.view []
        [ LayoutGrid.cell
              [ LayoutGrid.span6
              , LayoutGrid.span8Tablet
              ]
              []
        , LayoutGrid.cell
              [ LayoutGrid.span4
              , LayoutGrid.span6Tablet
              ]
              []
        , LayoutGrid.cell
              [ LayoutGrid.span2
              , LayoutGrid.span4Phone
              ]
              []
        ]


# Usage

@docs Property
@docs view
@docs fixedColumnWidth
@docs alignRight, alignLeft


# Cells

@docs cell
@docs span1, span2, span3, span4, span5, span6, span7, span8, span9, span10, span11, span12
@docs span1Phone, span2Phone, span3Phone, span4Phone
@docs span1Tablet, span2Tablet, span3Tablet, span4Tablet, span5Tablet, span6Tablet, span7Tablet, span8Tablet
@docs span1Desktop, span2Desktop, span3Desktop, span4Desktop, span5Desktop, span6Desktop, span7Desktop, span8Desktop, span9Desktop, span10Desktop, span11Desktop, span12Desktop
@docs alignTop, alignMiddle, alignBottom


# Nested LayoutGrids

    import Material.LayoutGrid as LayoutGrid

    LayoutGrid.view []
        [ LayoutGrid.cell
              [ LayoutGrid.span4
              ]
              [ LayoutGrid.inner []
                    [ LayoutGrid.cell [ LayoutGrid.span4 ] []
                    , LayoutGrid.cell [ LayoutGrid.span4 ] []
                    , LayoutGrid.cell [ LayoutGrid.span4 ] []
                    ]
              ]
        , LayoutGrid.cell [ LayoutGrid.span4 ] []
        , LayoutGrid.cell [ LayoutGrid.span4 ] []
        ]

@docs inner

-}

import Html exposing (Html)
import Internal.LayoutGrid.Implementation as LayoutGrid


{-| LayoutGrid property.
-}
type alias Property m =
    LayoutGrid.Property m


{-| LayoutGrid view.
-}
view : List (Property m) -> List (Html m) -> Html m
view =
    LayoutGrid.view


{-| Make the LayoutGrid left aligned instead of center aligned.
-}
alignLeft : Property m
alignLeft =
    LayoutGrid.alignLeft


{-| Make the LayoutGrid right aligned instead of center aligned.
-}
alignRight : Property m
alignRight =
    LayoutGrid.alignRight


{-| Specifiy that the grid should have fixed column width.
-}
fixedColumnWidth : Property m
fixedColumnWidth =
    LayoutGrid.fixedColumnWidth


{-| Specifiy that the cell should be top aligned.
-}
alignTop : Property m
alignTop =
    LayoutGrid.alignTop


{-| Specifiy that the cell should be middle aligned.
-}
alignMiddle : Property m
alignMiddle =
    LayoutGrid.alignMiddle


{-| Specifiy that the cell should be bottom aligned.
-}
alignBottom : Property m
alignBottom =
    LayoutGrid.alignBottom


{-| When your contents need extra structure that cannot be supported by single
layout grid, you can nest layout grid within each other. Use `inner` to nest
layout grids by wrapping around nested cell.
-}
inner : List (Property m) -> List (Html m) -> Html m
inner =
    LayoutGrid.inner


{-| LayoutGrid cell.
-}
cell : List (Property m) -> List (Html m) -> Html m
cell =
    LayoutGrid.cell


{-| Span 1 columns.
-}
span1 : Property m
span1 =
    LayoutGrid.span1


{-| Span 2 columns.
-}
span2 : Property m
span2 =
    LayoutGrid.span2


{-| Span 3 columns.
-}
span3 : Property m
span3 =
    LayoutGrid.span3


{-| Span 4 columns.
-}
span4 : Property m
span4 =
    LayoutGrid.span4


{-| Span 5 columns.
-}
span5 : Property m
span5 =
    LayoutGrid.span5


{-| Span 6 columns.
-}
span6 : Property m
span6 =
    LayoutGrid.span6


{-| Span 7 columns.
-}
span7 : Property m
span7 =
    LayoutGrid.span7


{-| Span 8 columns.
-}
span8 : Property m
span8 =
    LayoutGrid.span8


{-| Span 9 columns.
-}
span9 : Property m
span9 =
    LayoutGrid.span9


{-| Span 10 columns.
-}
span10 : Property m
span10 =
    LayoutGrid.span10


{-| Span 11 columns.
-}
span11 : Property m
span11 =
    LayoutGrid.span11


{-| Span 12 columns.
-}
span12 : Property m
span12 =
    LayoutGrid.span12


{-| Span 1 columns on a phone.
-}
span1Phone : Property m
span1Phone =
    LayoutGrid.span1Phone


{-| Span 2 columns on a phone.
-}
span2Phone : Property m
span2Phone =
    LayoutGrid.span2Phone


{-| Span 3 columns on a phone.
-}
span3Phone : Property m
span3Phone =
    LayoutGrid.span3Phone


{-| Span 4 columns on a phone.
-}
span4Phone : Property m
span4Phone =
    LayoutGrid.span4Phone


{-| Span 1 columns on a tablet.
-}
span1Tablet : Property m
span1Tablet =
    LayoutGrid.span1Tablet


{-| Span 2 columns on a tablet.
-}
span2Tablet : Property m
span2Tablet =
    LayoutGrid.span2Tablet


{-| Span 3 columns on a tablet.
-}
span3Tablet : Property m
span3Tablet =
    LayoutGrid.span3Tablet


{-| Span 4 columns on a tablet.
-}
span4Tablet : Property m
span4Tablet =
    LayoutGrid.span4Tablet


{-| Span 5 columns on a tablet.
-}
span5Tablet : Property m
span5Tablet =
    LayoutGrid.span5Tablet


{-| Span 6 columns on a tablet.
-}
span6Tablet : Property m
span6Tablet =
    LayoutGrid.span6Tablet


{-| Span 7 columns on a tablet.
-}
span7Tablet : Property m
span7Tablet =
    LayoutGrid.span7Tablet


{-| Span 8 columns on a tablet.
-}
span8Tablet : Property m
span8Tablet =
    LayoutGrid.span8Tablet


{-| Span 1 columns on a desktop.
-}
span1Desktop : Property m
span1Desktop =
    LayoutGrid.span1Desktop


{-| Span 2 columns on a desktop.
-}
span2Desktop : Property m
span2Desktop =
    LayoutGrid.span2Desktop


{-| Span 3 columns on a desktop.
-}
span3Desktop : Property m
span3Desktop =
    LayoutGrid.span3Desktop


{-| Span 4 columns on a desktop.
-}
span4Desktop : Property m
span4Desktop =
    LayoutGrid.span4Desktop


{-| Span 5 columns on a desktop.
-}
span5Desktop : Property m
span5Desktop =
    LayoutGrid.span5Desktop


{-| Span 6 columns on a desktop.
-}
span6Desktop : Property m
span6Desktop =
    LayoutGrid.span6Desktop


{-| Span 7 columns on a desktop.
-}
span7Desktop : Property m
span7Desktop =
    LayoutGrid.span7Desktop


{-| Span 8 columns on a desktop.
-}
span8Desktop : Property m
span8Desktop =
    LayoutGrid.span8Desktop


{-| Span 9 columns on a desktop.
-}
span9Desktop : Property m
span9Desktop =
    LayoutGrid.span9Desktop


{-| Span 10 columns on a desktop.
-}
span10Desktop : Property m
span10Desktop =
    LayoutGrid.span10Desktop


{-| Span 11 columns on a desktop.
-}
span11Desktop : Property m
span11Desktop =
    LayoutGrid.span11Desktop


{-| Span 12 columns on a desktop.
-}
span12Desktop : Property m
span12Desktop =
    LayoutGrid.span12Desktop
