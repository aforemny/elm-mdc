module Material.Select exposing
    ( Property
    , view
    , label
    , required
    , disabled
    , selectedText
    , onSelect
    , option
    , value
    , selected
    , outlined
    , fullWidth
    )

{-| Select provides Material Design single-option select menus.

The select requires that you set the width of the `mdc-select__anchor`
element as well as setting the width of the `mdc-select__menu` element
to match. This is best done through the use of another class.


# Resources

  - [Material Design guidelines: Select Menus](https://material.io/develop/web/components/input-controls/select-menus/)
  - [Material Design guidelines: Menus](https://material.io/guidelines/components/menus.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#select)


# Example

    import Html exposing (..)
    import Material.Options exposing (css)
    import Material.Select as Select

    type Msg =
        ProcessSelection String

    Select.view Mdc "my-select" model.mdc
        [ Select.label "Food Group"
        , Select.required
        , Options.onSelect ProcessSelection
        , Select.selectedText model.selectedText
        ]
        [ Select.option
              [ Select.value "Fruit Roll Ups"
              , Select.selected
              ]
              [ text "Fruit Roll Ups" ]
        , Select.option
              [ Select.value "Candy (cotton)" ]
              [ text "Candy (cotton)" ]
        ]


# Usage


## The select element

@docs Property
@docs view
@docs label
@docs required
@docs disabled
@docs fullWidth
@docs outlined
@docs selectedText
@docs onSelect


## The option element
@docs option
@docs value
@docs selected

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Select.Implementation as Select
import Material
import Material.List as Lists
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


{-| Set the select's label.
-}
label : String -> Property m
label =
    Select.label


{-| Disable the select.
-}
disabled : Property m
disabled =
    Select.disabled


{-| Expand the width of the select to its container instead of its natural width.
-}
fullWidth : Property m
fullWidth =
    Select.fullWidth


{-| Draw outlined version of select.
-}
outlined : Property m
outlined =
    Select.outlined


{-| Is a selection required, if set, the user cannot select the empty
value from the menu.
-}
required : Property m
required =
    Select.required


{-| Send a message when user has made a selection.

The selected text on a select will not change by itself, unlike the
built-in HTML select. Use this message to set the `selectedText`
property to display once a selection has been made.
-}
onSelect : (String -> m) -> Property m
onSelect =
    Select.onSelect


{-| Sets the text to display as the selected text.
-}
selectedText : String -> Property m
selectedText =
    Select.selectedText


{-| A select's option.
-}
option : List (Lists.Property m) -> List (Html m) -> Menu.Item m
option =
    Select.option


{-| Set an option's value to send when selected.
-}
value : String -> Lists.Property m
value =
    Select.value


{-| Make an option selected.

There should be only one option selected.
-}
selected : Lists.Property m
selected =
    Select.selected
