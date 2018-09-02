module Material.Switch
    exposing
        ( Property
        , disabled
        , nativeControl
        , on
        , view
        )

{-| The Switch component is a spec-aligned switch component adhering to the
Material Design Switch requirements.


# Resources

  - [Material Design guidelines: Switches](https://material.io/guidelines/components/selection-controls.html#selection-controls-switch)
  - [Demo](https://aforemny.github.io/elm-mdc/#switch)


# Example

    import Html exposing (text)
    import Html.Events
    import Material.FormField as FormField
    import Material.Options as Options exposing (styled)
    import Material.Switch as Switch


    FormField.view []
        [ Switch.view Mdc "my-switch" model.mdc
              [ Switch.on
              , Options.onClick Toggle
              ]
              []
        , Html.label
              [ Html.Events.onClick Toggle
              ]
              [ text "on/off"
              ]
        ]


# Usage

@docs Property
@docs view
@docs on
@docs disabled
@docs nativeControl

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Switch.Implementation as Switch
import Material
import Material.Options as Options


{-| Switch property.
-}
type alias Property m =
    Switch.Property m


{-| Switch view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Switch.view


{-| Make switch display its "on" state.

Defaults to "off". Use `Options.when` to make it interactive.

-}
on : Property m
on =
    Switch.on


{-| Disable the switch.
-}
disabled : Property m
disabled =
    Switch.disabled


{-| Apply properties to underlying native control element.
-}
nativeControl : List (Options.Property () m) -> Property m
nativeControl =
    Switch.nativeControl
