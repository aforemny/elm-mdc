module Internal.LayoutGrid.Implementation
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

import Html exposing (Html)
import Internal.Options as Options exposing (cs, css, styled, when)


type alias Config =
    {}


defaultConfig : Config
defaultConfig =
    {}


type alias Property m =
    Options.Property Config m


view : List (Property m) -> List (Html m) -> Html m
view options =
    styled Html.div (cs "mdc-layout-grid" :: options) << List.singleton << inner []


alignLeft : Property m
alignLeft =
    cs "mdc-layout-grid--align-left"


alignRight : Property m
alignRight =
    cs "mdc-layout-grid--align-right"


fixedColumnWidth : Property m
fixedColumnWidth =
    cs "mdc-layout-grid--fixed-column-width"


alignTop : Property m
alignTop =
    cs "mdc-layout-grid__cell--align-top"


alignMiddle : Property m
alignMiddle =
    cs "mdc-layout-grid__cell--align-middle"


alignBottom : Property m
alignBottom =
    cs "mdc-layout-grid__cell--align-bottom"


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
        Just device_ ->
            cs ("mdc-layout-grid__cell--span-" ++ String.fromInt value ++ "-" ++ device_)

        Nothing ->
            cs ("mdc-layout-grid__cell--span-" ++ String.fromInt value)
