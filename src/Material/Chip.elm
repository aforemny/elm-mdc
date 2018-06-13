module Material.Chip
    exposing
        ( Property
        , chipset
        , leadingIcon
        , onClick
        , ripple
        , selected
        , trailingIcon
        , view
        )

{-| The Chip component is a spec-aligned chip component adhering to the
Material Design chip requirements.

# Resources

- [Chips - Internal.Components for the Web](https://material.io/develop/web/components/chips/)
- [Material Design guidelines: Chips](https://material.io/guidelines/components/chips.html)
- [Demo](https://aforemny.github.io/elm-mdc/#chips)


# Example

```elm
import Html exposing (text)
import Material.Chip as Chip
import Material.Options as Options

Chip.view Mdc "my-chip" model.mdc
    [ Chip.ripple
    , Chip.onClick Click
    ]
    [ text "Chip"
    ]
```


# Usage

@docs Property
@docs view

@docs chipset

@docs leadingIcon
@docs trailingIcon
@docs selected
@docs ripple
@docs onClick
-}

import Html exposing (Html)
import Internal.Chip.Implementation as Chip
import Internal.Component as Component exposing (Index)
import Material


{-| Chip property.
-}
type alias Property m =
    Chip.Property m


{-| Chip view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Chip.view


{-| Give the chip an leading icon.
-}
leadingIcon : String -> Property m
leadingIcon =
    Chip.leadingIcon


{-| Give the chip an trailing icon.
-}
trailingIcon : String -> Property m
trailingIcon =
    Chip.trailingIcon


{-| Make the chip selected
-}
selected : Property m
selected =
    Chip.selected


{-| Enable ripple ink effect for the chip.
-}
ripple : Property m
ripple =
    Chip.ripple


{-| Container of chips
-}
chipset : List (Html m) -> Html m
chipset =
    Chip.chipset


{-| Click handler that respects `ripple`.

The event will be raised only after the ripple animation finished playing. If
the chip does not ripple, it is identical to `Options.onClick`.

-}
onClick : m -> Property m
onClick =
    Chip.onClick
