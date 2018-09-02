module Material.Checkbox
    exposing
        ( Property
        , checked
        , disabled
        , nativeControl
        , view
        )

{-| The Checkbox component is a spec-aligned checkbox component adhering to the
Material Design checkbox requirements.


# Resources

  - [Material Design guidelines: Selection Controls – Checkbox](https://material.io/guidelines/components/selection-controls.html#selection-controls-checkbox)
  - [Demo](https://aforemny.github.io/elm-mdc/#checkbox)


# Example

    import Html exposing (text)
    import Material.Checkbox as Checkbox
    import Material.FormField as FormField
    import Material.Options as Options exposing (styled, cs)


    FormField.view []
        [ Checkbox.view Mdc "my-checkbox" model.mdc
              [ Checkbox.checked True
              , Options.onClick Toggle
              ]
              []
        , Html.label
              [ Options.onClick Toggle
              ]
              [ text "My checkbox"
              ]
        ]


# Usage

@docs Property
@docs view
@docs checked
@docs disabled
@docs nativeControl

-}

import Html exposing (Html)
import Internal.Checkbox.Implementation as Checkbox
import Internal.Component exposing (Index)
import Material
import Material.Options as Options


{-| Checkbox property.
-}
type alias Property m =
    Checkbox.Property m


{-| Checkbox view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Checkbox.view


{-| Disable the checkbox.
-}
disabled : Property m
disabled =
    Checkbox.disabled


{-| Set checked state to True or False.

If not set, the checkbox will be in indeterminate state.

-}
checked : Bool -> Property m
checked =
    Checkbox.checked


{-| Apply properties to underlying native control element.
-}
nativeControl : List (Options.Property () m) -> Property m
nativeControl =
    Checkbox.nativeControl
