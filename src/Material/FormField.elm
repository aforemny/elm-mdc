module Material.FormField exposing
    ( Property
    , view
    , alignEnd
    , noWrap
    )

{-| FormField provides a helper view for easily making theme-aware, RTL-aware form
field + label combinations.


# Example

    import Html exposing (text)
    import Materail.Checkbox as Checkbox
    import Material.FormField as FormField
    import Material.Options as Options


    FormField.view []
        [ Checkbox.view Mdc "my-checkbox" model.mdc
              [ Options.onClick Toggle
              ]
              []
        , Html.label
              [ Options.onClick Toggle
              ]
              [ text "Toggle"
              ]
        ]


# Usage

@docs Property
@docs view
@docs alignEnd

# Options

@docs noWrap

-}

import Html exposing (Html)
import Internal.FormField.Implementation as FormField


{-| FormField property.
-}
type alias Property m =
    FormField.Property m


{-| FormField view.
-}
view : List (Property m) -> List (Html m) -> Html m
view =
    FormField.view


{-| Position the label before the input.

By default, the label is positioned after the input.

-}
alignEnd : Property m
alignEnd =
    FormField.alignEnd


{-| If the label text is too long for a single line, it will wrap the
text by default. You can force the text to stay on a single line and
ellipse the overflow text by using the `noWrap` property.

-}
noWrap : Property m
noWrap =
    FormField.noWrap

