module Material.TabBar exposing
    ( Property
    , view
    , scrolling
    , indicator
    , activeTab
    , Tab
    , tab
    , icon
    , stacked
    , smallIndicator
    )

{-| Tabs organize and allow navigation between groups of content that are related and at the same level of hierarchy.

This component consists of a TabBar containing Tabs. It supports scrolling of
Tabs.


# Resources

  - [Material Design guidelines: Tabs](https://material.io/guidelines/components/tabs.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#tabs)


# Example

    import Html exposing (text)
    import Material.Tabs as TabBar


    TabBar.view Mdc "my-tab-bar" model.mdc
        [ TabBar.indicator
        ]
        [ TabBar.tab [] [ text "Item One" ]
        , TabBar.tab [] [ text "Item Two" ]
        , TabBar.tab [] [ text "Item Three" ]
        ]


# Usage


## TabBar

@docs Property
@docs view
@docs scrolling
@docs indicator
@docs activeTab


## Tabs

@docs Tab
@docs tab
@docs withIconAndText
@docs icon
@docs iconText

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.TabBar.Implementation as TabBar
import Material
import Material.Options as Options


{-| TabBar property.
-}
type alias Property m =
    TabBar.Property m


{-| TabBar view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Tab m)
    -> Html m
view =
    TabBar.view


{-| Make the TabBar scroll if its tabs do not fit inside.

Displays forward and backward navigation arrows on either side if necessary and
advances scroll on pressing the Tab key.

-}
scrolling : Property m
scrolling =
    TabBar.scrolling


{-| Make the TabBar's tabs have an active indicator.
-}
indicator : Property m
indicator =
    TabBar.indicator


{-| Make the TabBar's `n`th tab active.
-}
activeTab : Int -> Property m
activeTab =
    TabBar.activeTab


{-| A TabBar's tab type.

Use `tab` to construct.

-}
type alias Tab m =
    TabBar.Tab m


{-| A tab.
-}
tab : List (Property m) -> List (Html m) -> Tab m
tab =
    TabBar.tab


{-| A tab's icon.
-}
icon : String -> Property m
icon =
    TabBar.icon


{-| Indicates that the tab icon and label should flow vertically instead of horizontally.
-}
stacked : Property m
stacked =
    TabBar.stacked


{-| Indicates that the indicator width will be restricted to the tab content width.
-}
smallIndicator : Property m
smallIndicator =
    TabBar.smallIndicator
