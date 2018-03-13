module Material.Internal.LayoutGrid.Implementation exposing
    ( alignLeft
    , alignRight
    , cell
    , fixedColumnWidth
    , inner
    , Property
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

{-|
Material design’s responsive UI is based on a column-variate grid layout. It
has 12 columns on desktop, 8 columns on tablet and 4 columns on phone.


# Resources

- [Material Design guidelines: Layout grid](https://material.io/guidelines/layout/responsive-ui.html#responsive-ui-grid)
- [Demo](https://aforemny.github.io/elm-mdc/#layout-grid)


# Example

```elm
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
```


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


# Nested LayoutGrids

```elm
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
```

@docs inner
-}

import Html exposing (Html)
import Material.Internal.Options as Options exposing (styled, cs, css, when)


type alias Config =
    {}


defaultConfig : Config
defaultConfig =
    {}


{-| LayoutGrid property.
-}
type alias Property m =
    Options.Property Config m


{-| LayoutGrid view.
-}
view : List (Property m) -> List (Html m) -> Html m
view options =
    styled Html.div (cs "mdc-layout-grid" :: options) << List.singleton << inner []


{-| Make the LayoutGrid left aligned instead of center aligned.
-}
alignLeft : Property m
alignLeft =
    cs "mdc-layout-grid--align-left"


{-| Make the LayoutGrid right aligned instead of center aligned.
-}
alignRight : Property m
alignRight =
    cs "mdc-layout-grid--align-right"


{-| Specifiy that the grid should have fixed column width.
-}
fixedColumnWidth : Property m
fixedColumnWidth =
    cs "mdc-layout-grid--fixed-column-width"


{-| When your contents need extra structure that cannot be supported by single
layout grid, you can nest layout grid within each other. Use `inner` to nest
layout grids by wrapping around nested cell.
-}
inner : List (Property m) -> List (Html m) -> Html m
inner options =
    styled Html.div (cs "mdc-layout-grid__inner" :: options)


{-| LayoutGrid cell.
-}
cell : List (Property m) -> List (Html m) -> Html m
cell options =
    styled Html.div (cs "mdc-layout-grid__cell" :: options)


{-| Span 1 columns.
-}
span1 : Property m
span1 =
    span Nothing 1


{-| Span 2 columns.
-}
span2 : Property m
span2 =
    span Nothing 2


{-| Span 3 columns.
-}
span3 : Property m
span3 =
    span Nothing 3


{-| Span 4 columns.
-}
span4 : Property m
span4 =
    span Nothing 4


{-| Span 5 columns.
-}
span5 : Property m
span5 =
    span Nothing 5


{-| Span 6 columns.
-}
span6 : Property m
span6 =
    span Nothing 6


{-| Span 7 columns.
-}
span7 : Property m
span7 =
    span Nothing 7


{-| Span 8 columns.
-}
span8 : Property m
span8 =
    span Nothing 8


{-| Span 9 columns.
-}
span9 : Property m
span9 =
    span Nothing 9


{-| Span 10 columns.
-}
span10 : Property m
span10 =
    span Nothing 10


{-| Span 11 columns.
-}
span11 : Property m
span11 =
    span Nothing 11


{-| Span 12 columns.
-}
span12 : Property m
span12 =
    span Nothing 12


{-| Span 1 columns on a phone.
-}
span1Phone : Property m
span1Phone =
    span (Just "phone") 1


{-| Span 2 columns on a phone.
-}
span2Phone : Property m
span2Phone =
    span (Just "phone") 2


{-| Span 3 columns on a phone.
-}
span3Phone : Property m
span3Phone =
    span (Just "phone") 3


{-| Span 4 columns on a phone.
-}
span4Phone : Property m
span4Phone =
    span (Just "phone") 4


{-| Span 1 columns on a tablet.
-}
span1Tablet : Property m
span1Tablet =
    span (Just "tablet") 1


{-| Span 2 columns on a tablet.
-}
span2Tablet : Property m
span2Tablet =
    span (Just "tablet") 2


{-| Span 3 columns on a tablet.
-}
span3Tablet : Property m
span3Tablet =
    span (Just "tablet") 3


{-| Span 4 columns on a tablet.
-}
span4Tablet : Property m
span4Tablet =
    span (Just "tablet") 4


{-| Span 5 columns on a tablet.
-}
span5Tablet : Property m
span5Tablet =
    span (Just "tablet") 5


{-| Span 6 columns on a tablet.
-}
span6Tablet : Property m
span6Tablet =
    span (Just "tablet") 6


{-| Span 7 columns on a tablet.
-}
span7Tablet : Property m
span7Tablet =
    span (Just "tablet") 7


{-| Span 8 columns on a tablet.
-}
span8Tablet : Property m
span8Tablet =
    span (Just "tablet") 8


{-| Span 1 columns on a desktop.
-}
span1Desktop : Property m
span1Desktop =
    span (Just "desktop") 1


{-| Span 2 columns on a desktop.
-}
span2Desktop : Property m
span2Desktop =
    span (Just "desktop") 2


{-| Span 3 columns on a desktop.
-}
span3Desktop : Property m
span3Desktop =
    span (Just "desktop") 3


{-| Span 4 columns on a desktop.
-}
span4Desktop : Property m
span4Desktop =
    span (Just "desktop") 4


{-| Span 5 columns on a desktop.
-}
span5Desktop : Property m
span5Desktop =
    span (Just "desktop") 5


{-| Span 6 columns on a desktop.
-}
span6Desktop : Property m
span6Desktop =
    span (Just "desktop") 6


{-| Span 7 columns on a desktop.
-}
span7Desktop : Property m
span7Desktop =
    span (Just "desktop") 7


{-| Span 8 columns on a desktop.
-}
span8Desktop : Property m
span8Desktop =
    span (Just "desktop") 8


{-| Span 9 columns on a desktop.
-}
span9Desktop : Property m
span9Desktop =
    span (Just "desktop") 9


{-| Span 10 columns on a desktop.
-}
span10Desktop : Property m
span10Desktop =
    span (Just "desktop") 10


{-| Span 11 columns on a desktop.
-}
span11Desktop : Property m
span11Desktop =
    span (Just "desktop") 11


{-| Span 12 columns on a desktop.
-}
span12Desktop : Property m
span12Desktop =
    span (Just "desktop") 12


span : Maybe String -> Int -> Property m
span device value =
    case device of
        Just device ->
            cs ("mdc-layout-grid__cell--span-" ++ toString value ++ "-" ++ device)
        Nothing ->
            cs ("mdc-layout-grid__cell--span-" ++ toString value)
