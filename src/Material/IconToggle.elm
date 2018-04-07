module Material.IconToggle exposing
    ( className
    , disabled
    , icon
    , label
    , on
    , Property
    , view
    )

{-|
IconToggle provides a Material Design icon toggle button. It is fully
accessible, and is designed to work with any icon set.


# Resources

- [Material Design guidelines: Toggle buttons](https://material.io/guidelines/components/buttons.html#buttons-toggle-buttons)
- [Demo](https://aforemny.github.io/elm-mdc/#icon-toggle)


# Example

```elm
import Material.IconToggle as IconToggle


IconToggle.view Mdc [0] model.mdc
    [ IconToggle.icon
          { on = "favorite_border"
          , off = "favorite"
          }
    , IconToggle.label
          { on = "Remove from favorites"
          , off = "Add to favorites"
          }
    , IconToggle.on True
    , IconToggle.onClick Toggle
    ]
    []
```


# Usage

@docs Property
@docs view
@docs on
@docs icon
@docs label
@docs disabled
@docs className
-}

import Html exposing (Html)
import Material
import Material.Component as Component exposing (Index)
import Material.Internal.IconToggle.Implementation as IconToggle


{-| IconToggle property.
-}
type alias Property m =
    IconToggle.Property m


{-| IconToggle view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    IconToggle.view


{-| Make the icon toggle appear in its "on" state.

Defaults to "off". Use `Options.when` to make it interactive.
-}
on : Property m
on =
    IconToggle.on


{-| Sets an alternate classname of the icon.

Useful if you want to use a different icon set. For example use `"fa"` for
FontAwesome.
-}
className : String -> Property m
className =
    IconToggle.className


{-| Set the icon.

Specify an icon for the icon toggle's "on" and "off" state.
-}
icon : { on : String, off : String } -> Property m
icon =
    IconToggle.icon


{-| Set the icon toggle's label.

Specify a label for the icon toggle's "on" and "off" state.
-}
label : { on : String, off : String } -> Property m
label =
    IconToggle.label


{-| Disable the icon toggle.
-}
disabled : Property m
disabled =
    IconToggle.disabled
