module Material.Internal.FormField.Implementation exposing
    ( alignEnd
    , Property
    , view
    )

{-|
FormField provides a helper view for easily making theme-aware, RTL-aware form
field + label combinations.


# Example

```elm
import Html exposing (text)
import Materail.Checkbox as Checkbox
import Material.FormField as FormField
import Material.Options as Options


FormField.view []
    [ Checkbox.view Mdc [0] model.mdc
          [ Options.onClick Toggle
          ]
          []
    , Html.label
          [ Options.onClick Toggle
          ]
          [ text "Toggle"
          ]
    ]
```

# Usage

@docs Property
@docs view
@docs alignEnd
-}

import Html exposing (Html)
import Material.Internal.Options as Options exposing (styled, cs)


type alias Config =
    {}


{-| FormField property.
-}
type alias Property m =
    Options.Property Config m


{-| FormField view.
-}
view : List (Property m) -> List (Html m) -> Html m
view options =
    styled Html.div (cs "mdc-form-field" :: options)


{-| Position the label before the input.

By default, the label is positioned after the input.
-}
alignEnd : Property m
alignEnd =
    cs "mdc-form-field--align-end"
