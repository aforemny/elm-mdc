module Material.RadioButton exposing
    ( disabled
    , Property
    , selected
    , view
    )

{-|
The RadioButton component provides a radio button adhering to the Material
Design Specification.


# Resources

- [Material Design guidelines: Selection Controls – Radio buttons](https://material.io/guidelines/components/selection-controls.html#selection-controls-radio-button)
- [Demo](https://aforemny.github.io/elm-mdc/#radio-buttons)


# Example

```elm
import Html exposing (text)
import Material.FormField as FormField
import Material.Options as Options exposing (styled, cs)
import Material.RadioButton as RadioButton


FormField.view []
    [ RadioButton.view Mdc [0] model.mdc
          [ RadioButton.selected
          , Options.onClick Select
          ]
          []
    , Html.label
          [ Options.onClick Select
          ]
          [ text "Radio"
          ]
    ]
```

# Usage
@docs Property
@docs view
@docs selected
@docs disabled
-}

import Html exposing (Html)
import Material
import Material.Component exposing (Index)
import Material.Internal.RadioButton.Implementation as RadioButton


{-| RadioButton property.
-}
type alias Property m =
    RadioButton.Property m


{-| RadioButton view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    RadioButton.view


{-| Make the radio button selected.

Defaults to not selected. Use `Options.when` to make it interactive.
-}
selected : Property m
selected =
    RadioButton.selected


{-| Disable the radio button.
-}
disabled : Property m
disabled =
    RadioButton.disabled
