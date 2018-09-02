module Material.Select
    exposing
        ( Property
        , box
        , disabled
        , label
        , option
        , preselected
        , selected
        , value
        , view
        )

{-| Select provides Material Design single-option select menus. It functions
analogously to the browser's native `<select>` element

Because of limitations of the current implementation, you have to set a `width`
manually.


# Resources

  - [Material Design guidelines: Select Menus](https://material.io/develop/web/components/input-controls/select-menus/)
  - [Material Design guidelines: Menus](https://material.io/guidelines/components/menus.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#select)


# Example

    import Html exposing (..)
    import Material.Options exposing (css)
    import Material.Select as Select


    Select.view Mdc "my-select" model.mdc
        [ Select.label "Food Group"
        , Select.preselected
        , Options.onChange ProcessMyChange
        ]
        [ Select.option
              [ Select.value "Fruit Roll Ups"
              , Select.selected True
              ]
              [ text "Fruit Roll Ups" ]
        , Select.option
              [ Select.value "Candy (cotton)" ]
              [ text "Candy (cotton)" ]
        ]


# Usage

@docs Property
@docs view
@docs label
@docs preselected
@docs disabled
@docs box

@docs option
@docs value
@docs selected

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Select.Implementation as Select
import Material


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


{-| A select's option.
-}
option : List (Property m) -> List (Html m) -> Html m
option =
    Select.option


{-| Set an option's value.
-}
value : String -> Property m
value =
    Select.value


{-| Make an option selected.

See `preselected`.

-}
selected : Property m
selected =
    Select.selected
