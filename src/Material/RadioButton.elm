module Material.RadioButton
    exposing
        ( Property
        , disabled
        , nativeControl
        , selected
        , view
        )

{-| The RadioButton component provides a radio button adhering to the Material
Design Specification.


# Resources

  - [Material Design guidelines: Selection Controls – Radio buttons](https://material.io/guidelines/components/selection-controls.html#selection-controls-radio-button)
  - [Demo](https://aforemny.github.io/elm-mdc/#radio-buttons)


# Example

    import Html exposing (text)
    import Material.FormField as FormField
    import Material.Options as Options exposing (styled, cs)
    import Material.RadioButton as RadioButton


    FormField.view []
        [ RadioButton.view Mdc "my-radio-button" model.mdc
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


# Usage

@docs Property
@docs view
@docs selected
@docs disabled
@docs nativeControl

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.RadioButton.Implementation as RadioButton
import Material
import Material.Options as Options


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


{-| Apply properties to underlying native control element.
-}
nativeControl : List (Options.Property () m) -> Property m
nativeControl =
    RadioButton.nativeControl
