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


type alias Property m =
    Options.Property Config m


view : List (Property m) -> List (Html m) -> Html m
view options =
    styled Html.div (cs "mdc-layout-grid" :: options)


alignLeft : Property m
alignLeft =
    cs "mdc-layout-grid--align-left"


alignRight : Property m
alignRight =
    cs "mdc-layout-grid--align-right"


fixedColumnWidth : Property m
fixedColumnWidth =
    cs "mdc-layout-grid--fixed-column-width"


inner : List (Property m) -> List (Html m) -> Html m
inner options =
    styled Html.div (cs "mdc-layout-grid__inner" :: options)


cell : List (Property m) -> List (Html m) -> Html m
cell options =
    styled Html.div (cs "mdc-layout-grid__cell" :: options)


span1 : Property m
span1 =
    span Nothing 1


span2 : Property m
span2 =
    span Nothing 2


span3 : Property m
span3 =
    span Nothing 3


span4 : Property m
span4 =
    span Nothing 4


span5 : Property m
span5 =
    span Nothing 5


span6 : Property m
span6 =
    span Nothing 6


span7 : Property m
span7 =
    span Nothing 7


span8 : Property m
span8 =
    span Nothing 8


span9 : Property m
span9 =
    span Nothing 9


span10 : Property m
span10 =
    span Nothing 10


span11 : Property m
span11 =
    span Nothing 11


span12 : Property m
span12 =
    span Nothing 12


span1Phone : Property m
span1Phone =
    span (Just "phone") 1


span2Phone : Property m
span2Phone =
    span (Just "phone") 2


span3Phone : Property m
span3Phone =
    span (Just "phone") 3


span4Phone : Property m
span4Phone =
    span (Just "phone") 4


span5Phone : Property m
span5Phone =
    span (Just "phone") 5


span6Phone : Property m
span6Phone =
    span (Just "phone") 6


span7Phone : Property m
span7Phone =
    span (Just "phone") 7


span8Phone : Property m
span8Phone =
    span (Just "phone") 8


span9Phone : Property m
span9Phone =
    span (Just "phone") 9


span10Phone : Property m
span10Phone =
    span (Just "phone") 10


span11Phone : Property m
span11Phone =
    span (Just "phone") 11


span12Phone : Property m
span12Phone =
    span (Just "phone") 12


span1Tablet : Property m
span1Tablet =
    span (Just "tablet") 1


span2Tablet : Property m
span2Tablet =
    span (Just "tablet") 2


span3Tablet : Property m
span3Tablet =
    span (Just "tablet") 3


span4Tablet : Property m
span4Tablet =
    span (Just "tablet") 4


span5Tablet : Property m
span5Tablet =
    span (Just "tablet") 5


span6Tablet : Property m
span6Tablet =
    span (Just "tablet") 6


span7Tablet : Property m
span7Tablet =
    span (Just "tablet") 7


span8Tablet : Property m
span8Tablet =
    span (Just "tablet") 8


span9Tablet : Property m
span9Tablet =
    span (Just "tablet") 9


span10Tablet : Property m
span10Tablet =
    span (Just "tablet") 10


span11Tablet : Property m
span11Tablet =
    span (Just "tablet") 11


span12Tablet : Property m
span12Tablet =
    span (Just "tablet") 12


span1Desktop : Property m
span1Desktop =
    span (Just "desktop") 1


span2Desktop : Property m
span2Desktop =
    span (Just "desktop") 2


span3Desktop : Property m
span3Desktop =
    span (Just "desktop") 3


span4Desktop : Property m
span4Desktop =
    span (Just "desktop") 4


span5Desktop : Property m
span5Desktop =
    span (Just "desktop") 5


span6Desktop : Property m
span6Desktop =
    span (Just "desktop") 6


span7Desktop : Property m
span7Desktop =
    span (Just "desktop") 7


span8Desktop : Property m
span8Desktop =
    span (Just "desktop") 8


span9Desktop : Property m
span9Desktop =
    span (Just "desktop") 9


span10Desktop : Property m
span10Desktop =
    span (Just "desktop") 10


span11Desktop : Property m
span11Desktop =
    span (Just "desktop") 11


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
