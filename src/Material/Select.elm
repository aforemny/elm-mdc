module Material.Select exposing
    ( box
    , disabled
    , index
    , label
    , Property
    , selectedText
    , view
    )

{-|
Select provides Material Design single-option select menus. It functions
analogously to the browser's native `<select>` element

Because of limitations of the current implementation, you have to set a `width`
manually.


# Resources

- [Material Design guidelines: Text Fields](https://material.io/guidelines/components/text-fields.html)
- [Material Design guidelines: Menus](https://material.io/guidelines/components/menus.html)
- [Demo](https://aforemny.github.io/elm-mdc/#select)


# Example

```elm
import Material.Menu as Menu
import Material.Options exposing (css)
import Material.Select as Select


Select.view (lift << Mdc) id model.mdc
    [ Select.label "Food Group"
    , css "width" "377px"
    ]
    [ Menu.li
          [ Menu.onSelect (Select "Fruit Roll Ups")
          ]
          [ text "Fruit Roll Ups"
          ]
    , Menu.li
          [ Menu.onSelect (Select "Candy (cotton)")
          ]
          [ text "Candy (cotton)"
          ]
    ]
```


# Usage

@docs Property
@docs view
@docs label
@docs selectedText
@docs index
@docs disabled
@docs box
-}

import Html exposing (Html)
import Material
import Material.Component exposing (Index)
import Material.Internal.Select.Implementation as Select
import Material.Menu as Menu


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
    -> List (Menu.Item m)
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


{-| Set the index of the selected item.
-}
index : Int -> Property m
index =
    Select.index


{-| Set the textual representation of the selected item.
-}
selectedText : String -> Property m
selectedText =
    Select.selectedText


{-| Disable the select.
-}
disabled : Property m
disabled =
    Select.disabled
