module Material.Elevation
    exposing
        ( elevation
        , transition
        )

{-| From the [Material Design Lite documentation](https://github.com/google/material-design-lite/blob/master/src/shadow/README.md)

> The Material Design Lite (MDL) shadow is not a component in the same sense as
> an MDL card, menu, or textbox; it is a visual effect that can be assigned to a
> user interface element. The effect simulates a three-dimensional positioning of
> the element, as though it is slightly raised above the surface it rests upon —
> a positive z-axis value, in user interface terms. The shadow starts at the
> edges of the element and gradually fades outward, providing a realistic 3-D
> effect.
>
> Shadows are a convenient and intuitive means of distinguishing an element from
> its surroundings. A shadow can draw the user's eye to an object and emphasize
> the object's importance, uniqueness, or immediacy.
>
> Shadows are a well-established feature in user interfaces, and provide users
> with a visual clue to an object's intended use or value. Their design and use
> is an important factor in the overall user experience.)

The [Material Design Specification](https://www.google.com/design/spec/what-is-material/elevation-shadows.html#elevation-shadows-elevation-android-)
pre-defines appropriate elevation for most UI elements; you need to manually
assign shadows only to your own elements.

You are encouraged to visit the
[Material Design specification](https://www.google.com/design/spec/what-is-material/elevation-shadows.html)
for details about appropriate use of shadows.

Refer to
[this site](https://debois.github.io/elm-mdl/#elevation)
for a live demo.


# Elevations
@docs elevation

# Transitions
@docs transition

-}

import Array exposing (Array)
import Material.Options exposing (..)


{-| Indicate the elevation of an element by giving it a shadow.
The argument indicates intended elevation; valid values
are 2, 3, 4, 6, 8, 16, 24. Invalid values produce no shadow.

(The specification uses only the values 1-6, 8, 9, 12, 16, 24 for standard UI
elements; MDL sources define all values 0-24, but omits most from production css.)
-}
elevation : Int -> Property a m
elevation z =
    cs ("mdc-elevation--z" ++ toString (clamp 0 24 z))


{-| Add a CSS-transition to changes in elevation. Supply a transition
duration in milliseconds as argument.

NB! This property is dictated neither by MDL nor the Material Design Specification.
-}
transition : Float -> Property a m
transition duration =
    css "transition" ("box-shadow " ++ toString duration ++ "ms ease-in-out 0s")
