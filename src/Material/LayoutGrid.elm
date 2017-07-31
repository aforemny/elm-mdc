module Material.LayoutGrid exposing
  ( view
  , alignRight
  , alignLeft
  , fixedColumnWidth
  , inner
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
  , span5Phone
  , span6Phone
  , span7Phone
  , span8Phone
  , span9Phone
  , span10Phone
  , span11Phone
  , span12Phone
  , span1Tablet
  , span2Tablet
  , span3Tablet
  , span4Tablet
  , span5Tablet
  , span6Tablet
  , span7Tablet
  , span8Tablet
  , span9Tablet
  , span10Tablet
  , span11Tablet
  , span12Tablet
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
  )

import Html exposing (Html)
import Material.Options as Options exposing (Style, styled, cs, css, when)


view : List (Style m) -> List (Html m) -> Html m
view options =
    styled Html.div (cs "mdc-layout-grid" :: options)


alignLeft : Style m
alignLeft =
    cs "mdc-layout-grid--align-left"


alignRight : Style m
alignRight =
    cs "mdc-layout-grid--align-right"


fixedColumnWidth : Style m
fixedColumnWidth =
    cs "mdc-layout-grid--fixed-column-width"


inner : List (Style m) -> List (Html m) -> Html m
inner options =
    styled Html.div (cs "mdc-layout-grid__inner" :: options)


cell : List (Style m) -> List (Html m) -> Html m
cell options =
    styled Html.div (cs "mdc-layout-grid__cell" :: options)


span1 : Style m
span1 =
    span Nothing 1


span2 : Style m
span2 =
    span Nothing 2


span3 : Style m
span3 =
    span Nothing 3


span4 : Style m
span4 =
    span Nothing 4


span5 : Style m
span5 =
    span Nothing 5


span6 : Style m
span6 =
    span Nothing 6


span7 : Style m
span7 =
    span Nothing 7


span8 : Style m
span8 =
    span Nothing 8


span9 : Style m
span9 =
    span Nothing 9


span10 : Style m
span10 =
    span Nothing 10


span11 : Style m
span11 =
    span Nothing 11


span12 : Style m
span12 =
    span Nothing 12


span1Phone : Style m
span1Phone =
    span (Just "phone") 1


span2Phone : Style m
span2Phone =
    span (Just "phone") 2


span3Phone : Style m
span3Phone =
    span (Just "phone") 3


span4Phone : Style m
span4Phone =
    span (Just "phone") 4


span5Phone : Style m
span5Phone =
    span (Just "phone") 5


span6Phone : Style m
span6Phone =
    span (Just "phone") 6


span7Phone : Style m
span7Phone =
    span (Just "phone") 7


span8Phone : Style m
span8Phone =
    span (Just "phone") 8


span9Phone : Style m
span9Phone =
    span (Just "phone") 9


span10Phone : Style m
span10Phone =
    span (Just "phone") 10


span11Phone : Style m
span11Phone =
    span (Just "phone") 11


span12Phone : Style m
span12Phone =
    span (Just "phone") 12


span1Tablet : Style m
span1Tablet =
    span (Just "tablet") 1


span2Tablet : Style m
span2Tablet =
    span (Just "tablet") 2


span3Tablet : Style m
span3Tablet =
    span (Just "tablet") 3


span4Tablet : Style m
span4Tablet =
    span (Just "tablet") 4


span5Tablet : Style m
span5Tablet =
    span (Just "tablet") 5


span6Tablet : Style m
span6Tablet =
    span (Just "tablet") 6


span7Tablet : Style m
span7Tablet =
    span (Just "tablet") 7


span8Tablet : Style m
span8Tablet =
    span (Just "tablet") 8


span9Tablet : Style m
span9Tablet =
    span (Just "tablet") 9


span10Tablet : Style m
span10Tablet =
    span (Just "tablet") 10


span11Tablet : Style m
span11Tablet =
    span (Just "tablet") 11


span12Tablet : Style m
span12Tablet =
    span (Just "tablet") 12


span1Desktop : Style m
span1Desktop =
    span (Just "desktop") 1


span2Desktop : Style m
span2Desktop =
    span (Just "desktop") 2


span3Desktop : Style m
span3Desktop =
    span (Just "desktop") 3


span4Desktop : Style m
span4Desktop =
    span (Just "desktop") 4


span5Desktop : Style m
span5Desktop =
    span (Just "desktop") 5


span6Desktop : Style m
span6Desktop =
    span (Just "desktop") 6


span7Desktop : Style m
span7Desktop =
    span (Just "desktop") 7


span8Desktop : Style m
span8Desktop =
    span (Just "desktop") 8


span9Desktop : Style m
span9Desktop =
    span (Just "desktop") 9


span10Desktop : Style m
span10Desktop =
    span (Just "desktop") 10


span11Desktop : Style m
span11Desktop =
    span (Just "desktop") 11


span12Desktop : Style m
span12Desktop =
    span (Just "desktop") 12


span : Maybe String -> Int -> Style m
span device value =
    case device of
        Just device ->
            cs ("mdc-layout-grid__cell--span-" ++ toString value ++ "-" ++ device)
        Nothing ->
            cs ("mdc-layout-grid__cell--span-" ++ toString value)
