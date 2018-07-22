module Material.Menu exposing
    ( anchorCorner
    , anchorMargin
    , attach
    , bottomEndCorner
    , bottomLeftCorner
    , bottomRightCorner
    , bottomStartCorner
    , Corner
    , divider
    , index
    , Item
    , li
    , Margin
    , onSelect
    , Property
    , quickOpen
    , topEndCorner
    , topLeftCorner
    , topRightCorner
    , topStartCorner
    , ul
    , view
    )

{-|
The Menu component is a spec-aligned menu component adhering to the Material
Design menu specification.


# Resources
- [Material Design guidelines: Menus](https://material.io/guidelines/components/menus.html)
- [Demo](https://aforemny.github.io/elm-mdc/#menu)


# Example

```elm
import Html exposing (text)
import Material.Button as Button
import Material.Menu as Menu
import Material.Options exposing (styled, cs, css)


styled Html.div
    [ Options.cs "mdc-menu-anchor"
    , Options.css "position" "relative"
    ]
    [ Button.view Mdc "my-button" model.mdc
          [ Menu.attach (lift << Mdc) "my-menu"
          ]
          [ text "Show"
          ]
    , Menu.view Mdc "my-menu" model.mdc []
          ( Menu.ul []
                [ Menu.li
                      [ Menu.onSelect (Select "Item 1")
                      ]
                      [ text "Item 1"
                      ]
                , Menu.li
                      [ Menu.onSelect (Select "Item 2")
                      ]
                      [ text "Item 2"
                      ]
                ]
          )
    ]
```


# Usage
@docs Property
@docs view
@docs ul
@docs Item
@docs li
@docs divider
@docs onSelect
@docs index
@docs attach
@docs anchorCorner
@docs Corner
@docs topStartCorner
@docs topEndCorner
@docs bottomStartCorner
@docs bottomEndCorner
@docs topLeftCorner
@docs topRightCorner
@docs bottomLeftCorner
@docs bottomRightCorner
@docs anchorMargin
@docs Margin
@docs quickOpen
-}

import Html exposing (Html)
import Material
import Internal.Component exposing (Index)
import Internal.Menu.Implementation as Menu
import Material.List as Lists
import Material.Options as Options


{-| Menu property.
-}
type alias Property m =
    Menu.Property m


{-| Menu view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> Menu m
    -> Html m
view =
    Menu.view


{-| Menu item.
-}
type alias Item m =
    Menu.Item m


{-| Menu item wrapper.
-}
li : List (Lists.Property m) -> List (Html m) -> Item m
li =
    Menu.li



{-| Menu item divider.
-}
divider : List (Lists.Property m) -> List (Html m) -> Item m
divider =
    Menu.divider


type alias Menu m =
    Menu.Menu m


{-| Menu items wrapper.
-}
ul : List (Lists.Property m) -> List (Item m) -> Menu m
ul =
    Menu.ul


{-| Component property to attach the menu.
-}
attach : (Material.Msg m -> m) -> Index -> Options.Property c m
attach =
    Menu.attach


{-| Menu margin from `anchorCorner`.

Defaults to zero margin.
-}
type alias Margin =
    Menu.Margin


{-| Specify the menu item that has focus when the menu opens.
-}
index : Int -> Property m
index =
    Menu.index


{-| Hint to anchor the menu if space is available.

The menu will auto-position itself if not enough space is available. Prefer
RTL-aware corners when possible.
-}
anchorCorner : Corner -> Property m
anchorCorner =
    Menu.anchorCorner


{-| Set the menu's margin from the specified `anchorCorner`.
-}
anchorMargin : Margin -> Property m
anchorMargin =
    Menu.anchorMargin


{-| Open the menu without an animation.
-}
quickOpen : Property m
quickOpen =
    Menu.quickOpen


{-| One of the four corners.

Consider using RTL aware corners when possible.
-}
type alias Corner =
    Menu.Corner


{-| Top left corner.
-}
topLeftCorner : Corner
topLeftCorner =
    Menu.topLeftCorner


{-| Top right corner.
-}
topRightCorner : Corner
topRightCorner =
    Menu.topRightCorner


{-| Bottom left corner.
-}
bottomLeftCorner : Corner
bottomLeftCorner =
    Menu.bottomLeftCorner


{-| Bottom right corner.
-}
bottomRightCorner : Corner
bottomRightCorner =
    Menu.bottomRightCorner


{-| Top left corner in RTL and top right corner otherwise.
-}
topStartCorner : Corner
topStartCorner =
    Menu.topStartCorner


{-| Top right corner in RTL and top left corner otherwise.
-}
topEndCorner : Corner
topEndCorner =
    Menu.topEndCorner


{-| Bottom left corner in RTL and bottom right corner otherwise.
-}
bottomStartCorner : Corner
bottomStartCorner =
    Menu.bottomStartCorner


{-| Bottom right corner in RTL and bottom left corner otherwise.
-}
bottomEndCorner : Corner
bottomEndCorner =
    Menu.bottomEndCorner


{-| Event listener for the menu's select event.

Use this rather than `Options.onClick`, etc. so that it works with keyboard
selection.
-}
onSelect : m -> Lists.Property m
onSelect =
    Menu.onSelect
