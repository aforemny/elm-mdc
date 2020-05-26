module Material.Fab exposing
    ( Property
    , view
    , icon
    , iconClass
    , mini
    , extended
    , label
    , ripple
    , exited
    )

{-| A floating action button represents the primary action in an application.


# Resources

  - [Material Design guidelines: Buttons](https://material.io/guidelines/components/buttons-floating-action-button.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#fab)


# Basic floating action button

    import Material.Fab as Fab
    import Material.Options as Options


    Fab.view Mdc "my-fab" model.mdc
        [ Fab.ripple
        , Options.onClick Click
        , Fab.icon "favorite_border"
        ]
        []


# Extended floating action button

    Fab.view Mdc
        "my-extended-fab"
        model.mdc
        [ Fab.ripple
        , Options.onClick Click
        , Fab.icon "add"
        , Fab.extended
        ]
        [ span [ Fab.label ] [ text "Create" ] ]


# Usage

@docs Property
@docs view
@docs icon
@docs iconClass
@docs mini
@docs extended
@docs label
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
    -> List (Html m)
    -> Html m
view =
    Fab.view


{-| Option to set the icon.
-}
icon : String -> Property m
icon =
    Fab.icon


{-| Icon class in case you want to have more control over the
structure, or want to build a floating action button with the icon on
the right hand side.
-}
iconClass : Property m
iconClass =
    Fab.iconClass


{-| Make the Fab smaller than regular size.
-}
mini : Property m
mini =
    Fab.mini


{-| Make an extended fab. Note that the label is mandatory, but the icon optional.
-}
extended : Property m
extended =
    Fab.extended


{-| An extended fab must have a label node. Use this class to mark that node.
-}
label : Property m
label =
    Fab.label


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
