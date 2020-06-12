module Material.TabBar exposing
    ( Property
    , view
    , activeTab
    , Tab
    , tab
    , icon
    , stacked
    , smallIndicator
    , indicatorIcon
    , fadingIconIndicator
    )

{-| Tabs organize and allow navigation between groups of content that are related and at the same level of hierarchy.

This component consists of a TabBar containing Tabs.

Note that scrolling tabs will not work properly if a font change
occurs. Make sure your font is fully loaded before rendering this component.


# Resources

  - [Material Components for the Web - Tab Bar](https://material.io/design/components/tabs.html)
  - [Material Design guidelines: Tabs](https://material.io/design/components/tabs.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#tabs)


# Example

    import Html exposing (text)
    import Material.TabBar as TabBar


    TabBar.view Mdc "my-tab-bar" model.mdc
        [ TabBar.activeTab 0
        ]
        [ TabBar.tab [] [ text "Item One" ]
        , TabBar.tab [] [ text "Item Two" ]
        , TabBar.tab [] [ text "Item Three" ]
        ]

Set the Options.onClick property on each tab to send a message to
update the active tab in your model.


# Usage


## TabBar

@docs Property
@docs view
@docs activeTab


## Tabs

@docs Tab
@docs tab
@docs icon
@docs stacked
@docs smallIndicator
@docs indicatorIcon
@docs fadingIconIndicator

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.TabBar.Implementation as TabBar
import Material


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


{-| Indicates the icon to use for the sliding indicator icon effect.
-}
indicatorIcon : String -> Property m
indicatorIcon =
    TabBar.indicatorIcon


{-| Indicates that the indicator icon effect will use a fading effect.
-}
fadingIconIndicator : Property m
fadingIconIndicator =
    TabBar.fadingIconIndicator
