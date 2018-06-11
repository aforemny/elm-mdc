module Material.Select exposing
    ( box
    , disabled
    , label
    , preselected
    , Property
    , view
    )

{-|
Select provides Material Design single-option select menus. It functions
analogously to the browser's native `<select>` element

Because of limitations of the current implementation, you have to set a `width`
manually.


# Resources

- [Material Design guidelines: Select Menus](https://material.io/develop/web/components/input-controls/select-menus/)
- [Material Design guidelines: Menus](https://material.io/guidelines/components/menus.html)
- [Demo](https://aforemny.github.io/elm-mdc/#select)


# Example

```elm
import Html exposing (..)
import Material.Options exposing (css)
import Material.Select as Select


Select.view (lift << Mdc) id model.mdc
    [ Select.label "Food Group"
    , Select.preselected
    , Options.onChange ProcessMyChange
    , css "width" "377px"
    ]
    [ Html.option
          [ Html.value "Fruit Roll Ups"
          , Html.selected True
          ]
          [ text "Fruit Roll Ups" ]
    , Html.option
          [ Html.value "Candy (cotton)" ]
          [ text "Candy (cotton)" ]
    ]
```


# Usage

@docs Property
@docs view
@docs label
@docs preselected
@docs disabled
@docs box
-}

import Html exposing (Html)
import Material
import Internal.Component exposing (Index)
import Internal.Select.Implementation as Select


{-| Select property.
-}
type alias Property m =
    Select.Property m


{-| Select view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Select.view


{-| Style the select as a box select.
-}
box : Property m
box =
    Select.box


{-| Set the select's label.
-}
label : String -> Property m
label =
    Select.label


{-| Use this if an option has been preselected.
-}
preselected : Property m
preselected =
    Select.preselected


{-| Disable the select.
-}
disabled : Property m
disabled =
    Select.disabled
