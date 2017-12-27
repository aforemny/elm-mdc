module Material.LayoutGrid exposing
  (
    -- VIEW
    view
  , inner
  , Property

  , cell

  , span1
  , span2
  , span3
  , span4
  , span5
  , span6
  , span7
  , span8
  , span9
  , span10
  , span11
  , span12

  , span1Phone
  , span2Phone
  , span3Phone
  , span4Phone

  , span1Tablet
  , span2Tablet
  , span3Tablet
  , span4Tablet
  , span5Tablet
  , span6Tablet
  , span7Tablet
  , span8Tablet

  , span1Desktop
  , span2Desktop
  , span3Desktop
  , span4Desktop
  , span5Desktop
  , span6Desktop
  , span7Desktop
  , span8Desktop
  , span9Desktop
  , span10Desktop
  , span11Desktop
  , span12Desktop

  , fixedColumnWidth
  , alignRight
  , alignLeft
  )

{-|
## Design & API Documentation

- [Material Design guidelines: Layout grid](https://material.io/guidelines/layout/responsive-ui.html#responsive-ui-grid)
- [Demo](https://aforemny.github.io/elm-mdc/#layout-grid)

## View
@docs view, inner, cell

## Cell spans
@docs span1, span2, span3, span4, span5, span6, span7, span8, span9, span10, span11, span12
@docs span1Phone, span2Phone, span3Phone, span4Phone
@docs span1Tablet, span2Tablet, span3Tablet, span4Tablet, span5Tablet, span6Tablet, span7Tablet, span8Tablet
@docs span1Desktop, span2Desktop, span3Desktop, span4Desktop, span5Desktop, span6Desktop, span7Desktop, span8Desktop, span9Desktop, span10Desktop, span11Desktop, span12Desktop

## Properties
@docs Property
@docs fixedColumnWidth, alignRight, alignLeft
-}

import Html exposing (Html)
import Material.Options as Options exposing (styled, cs, css, when)


type alias Config =
    {}


defaultConfig : Config
defaultConfig =
    {}


{-| A LayoutGrid's property.
-}
type alias Property m =
    Options.Property Config m


{-| Component view.
-}
view : List (Property m) -> List (Html m) -> Html m
view options =
    styled Html.div (cs "mdc-layout-grid" :: options)

{-| The grid is by default center aligned. This modifier changes this behaviour.


Note, this modifiers will have no effect when the grid already fills its container.
-}
alignLeft : Property m
alignLeft =
    cs "mdc-layout-grid--align-left"

{-| The grid is by default center aligned. This modifier changes this behaviour.

Note, this modifiers will have no effect when the grid already fills its container.
-}
alignRight : Property m
alignRight =
    cs "mdc-layout-grid--align-right"


{-| Specifies the grid should have fixed column width.
-}
fixedColumnWidth : Property m
fixedColumnWidth =
    cs "mdc-layout-grid--fixed-column-width"


{-| When your contents need extra structure that cannot be supported by single layout grid,
you can nest layout grid within each other. Use `inner` to nest layout grids, by wrapping around nested cell.
-}
inner : List (Property m) -> List (Html m) -> Html m
inner options =
    styled Html.div (cs "mdc-layout-grid__inner" :: options)


{-| Defines a layout grid cell.
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
