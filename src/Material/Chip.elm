module Material.Chip exposing
    ( Property
    , view
    , selected
    , onClick
    , checkmark
    , leadingIcon
    , trailingIcon
    , chipset
    , choice
    , filter
    , input
    )

{-| The Chip component is a spec-aligned chip component adhering to the
Material Design chip requirements.


# Resources

  - [Chips - Components for the Web](https://material.io/develop/web/components/chips/)
  - [Material Design guidelines: Chips](https://material.io/guidelines/components/chips.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#chips)


# Example

    import Html exposing (text)
    import Material.Chip as Chip
    import Material.Options as Options

    Chip.view Mdc "my-chip" model.mdc
        [ Chip.onClick Click
        ]
        [ text "Chip"
        ]


# Usage

@docs Property
@docs view
@docs selected
@docs onClick
@docs checkmark


### Leading and trailing icon

@docs leadingIcon
@docs trailingIcon


# Chip sets

@docs chipset
@docs choice
@docs filter
@docs input

-}

import Html exposing (Html)
import Internal.Chip.Implementation as Chip
import Internal.Component exposing (Index)
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


{-| Show a checkmark if the chip is selected. Required property for filter chips.
-}
checkmark : Property m
checkmark =
    Chip.checkmark


{-| Click handler that respects the chip's ripple ink effect.

The event will be raised only after the ripple animation finished playing.

-}
onClick : m -> Property m
onClick =
    Chip.onClick


{-| Container of chips.
-}
chipset : List (Property m) -> List (Html m) -> Html m
chipset =
    Chip.chipset


{-| Use this property when you allow multiple selection from a `chipset`.
-}
filter : Property m
filter =
    Chip.filter


{-| Use this property when you allow single selection from a `chipset`.
-}
choice : Property m
choice =
    Chip.choice


{-| Input chips are a variant of chips which enable user input by
converting text into chips. Use this property on a `chipset` to mark
the chips as input chips.
-}
input : Property m
input =
    Chip.input
