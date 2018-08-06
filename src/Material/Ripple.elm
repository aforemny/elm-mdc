module Material.Ripple
    exposing
        ( Property
        , accent
        , bounded
        , primary
        , unbounded
        )

{-| The Ripple component adds a material "ink ripple" interaction effect to
HTML elements.

The ripple comes in `bounded` and `unbounded` variants. The first works well
for surfaces, the other works well for icons.

The view functions `unbounded` and `bounded` return a record with fields

  - `interactionHandler` that has to be added to the HTML element that should be
    interacted with,
  - `properties` that applies the ripple effect to the HTML element. This is
    usually the same as the one `interactionHandler` is applied to, and
  - `style` which is a HTML `<style>` element which has to be added to the DOM.
    It is recommended to make this a child of the element that is interacted
    with.


# Resources

  - [Material Design guidelines: Choreography](https://material.io/guidelines/motion/choreography.html#choreography-radial-reaction)
  - [Demo](https://aforemny.github.io/elm-mdc/#ripple)


# Example


## Bounded Ripple effect

    import Html exposing (text)
    import Material.Options as Options exposing (styled)
    import Material.Ripple as Ripple


    let
        { interactionHandler
        , properties
        , style
        } =
            Ripple.bounded Mdc "my-ripple" model.mdc
    in
    Options.styled Html.div
        [ interactionHandler
        , properties
        ]
        [ text "Interact with me!"
        , style
        ]


## Unbounded Ripple effect

    let
        { interactionHandler
        , properties
        , style
        } =
            Ripple.unbounded Mdc "my-ripple" model.mdc
    in
    Icon.view
        [ interactionHandler
        , properties
        ]
        "favorite"


# Usage

@docs Property
@docs unbounded
@docs bounded
@docs primary
@docs accent

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Ripple.Implementation as Ripple
import Material
import Material.Options as Options


{-| Ripple property.
-}
type alias Property m =
    Ripple.Property m


{-| Bounded view function.
-}
bounded :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    ->
        { interactionHandler : Options.Property c m
        , properties : Options.Property c m
        , style : Html m
        }
bounded =
    Ripple.bounded


{-| Unbounded view function.
-}
unbounded :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    ->
        { interactionHandler : Options.Property c m
        , properties : Options.Property c m
        , style : Html m
        }
unbounded =
    Ripple.unbounded


{-| Set ripple effect to the primary color.
-}
primary : Property m
primary =
    Ripple.primary


{-| Set ripple effect to the accent color.
-}
accent : Property m
accent =
    Ripple.accent
