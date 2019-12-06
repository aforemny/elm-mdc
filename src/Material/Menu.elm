module Material.Menu exposing
    ( Property
    , Menu
    , view
    , ul
    , index
    , attach
    , anchorCorner
    , Corner
    , topStartCorner
    , topEndCorner
    , bottomStartCorner
    , bottomEndCorner
    , topLeftCorner
    , topRightCorner
    , bottomLeftCorner
    , bottomRightCorner
    , anchorMargin
    , Margin
    , quickOpen
    , Item
    , li
    , divider
    , text
    , selectionGroup
    , selectionGroupIcon
    , selected
    , disabled
    , onSelect
    , surfaceAnchor
    )

{-| The Menu component is a spec-aligned menu component adhering to the Material
Design menu specification.


# Resources

  - [Material Design guidelines: Menus](https://material.io/guidelines/components/menus.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#menu)


# Example

    import Html exposing (text)
    import Material.Button as Button
    import Material.Menu as Menu
    import Material.Options exposing (styled, cs, css)


    styled Html.div
        [ Menu.surfaceAnchor ]
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


# Menu

@docs Property
@docs Menu
@docs view
@docs ul
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


# Menu.ul children

@docs Item
@docs li
@docs divider

# Menu.li options

@docs selected
@docs disabled
@docs onSelect

# Selection Group Menu

Menus can contain a group of list items that can represent the selection state of elements within the group.

@docs selectionGroup
@docs selectionGroupIcon
@docs text

# Menu anchoring

@docs surfaceAnchor

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Menu.Implementation as Menu
import Material
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


{-| A single menu item.
-}
li : List (Lists.Property m) -> List (Html m) -> Item m
li =
    Menu.li


{-| Horizontal divider.
-}
divider : List (Lists.Property m) -> List (Html m) -> Item m
divider =
    Menu.divider


{-| A menu selection group.

Example:

    Menu.ul []
        [ Menu.selectionGroup []
            [ Menu.li []
                [ Menu.selectionGroupIcon []
                      [ Icon.view [ Icon.span ] "check"
                , Menu.text []
                      [ Html.text "Single" ]
                ]
            , Menu.li []
                [ Menu.selectionGroupIcon []
                      [ Icon.view [ Icon.span ] "check"
                , Menu.text []
                      [ HTml.text "Double" ]
                ]
            ]
        , Menu.divider [] []
        , Menu.li []
            [ text "Add space before paragraph" ]
        ]

-}
selectionGroup : List (Lists.Property m) -> List (Item m) -> Item m
selectionGroup =
    Menu.selectionGroup


{-| Menu structure before being turned into virtual dom. This is the
structure returned by `ul`.
-}
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


{-| Use this class on a parent to automatically anchor the menu to this parent.
-}
surfaceAnchor : Options.Property c m
surfaceAnchor =
    Menu.surfaceAnchor


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


{-| Used to indicate which element in a selection group is selected.
-}
selected : Lists.Property m
selected =
    Menu.selected


{-| Use when menu item is displayed in disabled state.
-}
disabled : Lists.Property m
disabled =
    Menu.disabled



{-| The text of an `li`.

Example:

    Menu.li []
        [ Menu.text [] [ text "My item" ]

-}
text : List (Lists.Property m) -> List (Html m) -> Html m
text =
    Menu.text



{-| The text of an `li`.

Example:

    Menu.li []
        [ Menu.selectionGroupIcon []
              [ Icon.view [ Icon.span ] "check" ]
        , Menu.text []
              [ Html.text "Single" ]
        ]

-}
selectionGroupIcon : List (Lists.Property m) -> List (Html m) -> Html m
selectionGroupIcon =
    Menu.selectionGroupIcon

