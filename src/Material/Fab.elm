module Material.Fab
    exposing
        ( Property
        , exited
        , mini
        , ripple
        , view
        )

{-| A floating action button represents the primary action in an application.


# Resources

  - [Material Design guidelines: Buttons](https://material.io/guidelines/components/buttons-floating-action-button.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#fab)


# Example

    import Material.Fab as Fab
    import Material.Options as Options


    Fab.view Mdc "my-fab" model.mdc
        [ Fab.ripple
        , Options.onClick Click
        ]
        "favorite_border"


# Usage

@docs Property
@docs view
@docs Property
@docs mini
@docs ripple
@docs exited

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Fab.Implementation as Fab
import Material


{-| Fab property.
-}
type alias Property m =
    Fab.Property m


{-| Fab view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> String
    -> Html m
view =
    Fab.view


{-| Make the Fab smaller than regular size.
-}
mini : Property m
mini =
    Fab.mini


{-| Animates the Fab out of view when this property is set.

It returns to view when this property is removed.

-}
exited : Property m
exited =
    Fab.exited


{-| Enable ripple effect on interaction.
-}
ripple : Property m
ripple =
    Fab.ripple
