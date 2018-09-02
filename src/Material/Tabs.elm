module Material.Tabs
    exposing
        ( Property
        , Tab
        , icon
        , iconText
        , indicator
        , scrolling
        , tab
        , view
        , withIconAndText
        )

{-| The Tabs component contains components which are used to create spec-aligned
tabbed navigation components adhering to the Material Design tabs guidelines.

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


## Tabs

@docs Tab
@docs tab
@docs withIconAndText
@docs icon
@docs iconText

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Tabs.Implementation as Tabs
import Material
import Material.Options as Options


{-| TabBar property.
-}
type alias Property m =
    Tabs.Property m


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
    Tabs.view


{-| Make the TabBar scroll if its tabs do not fit inside.

Displays forward and backward navigation arrows on either side if necessary and
advances scroll on pressing the Tab key.

-}
scrolling : Property m
scrolling =
    Tabs.scrolling


{-| Make the TabBar's tabs have an active indicator.
-}
indicator : Property m
indicator =
    Tabs.indicator


{-| A TabBar's tab type.

Use `tab` to construct.

-}
type alias Tab m =
    Tabs.Tab m


{-| A TabBar's tab.
-}
tab : List (Property m) -> List (Html m) -> Tab m
tab =
    Tabs.tab


{-| Configure tab to show both an icon and a text.

Use `icon` and `iconText` as children.

-}
withIconAndText : Property m
withIconAndText =
    Tabs.withIconAndText


{-| A tab's icon.
-}
icon : List (Options.Property c m) -> String -> Html m
icon =
    Tabs.icon


{-| A tab's icon text.
-}
iconText : List (Options.Property c m) -> String -> Html m
iconText =
    Tabs.iconText
