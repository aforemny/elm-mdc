module Material.Elevation
    exposing
        ( e0
        , e2
        , e3
        , e4
        , e6
        , e8
        , e16
        , e24
        , elevations
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
Each of the values below denote an elevation of a certain heigh, e.g.,
`e4` will cast a shadow indicating an elevation of 4dp. The default elevation
is `e0`, no elevation.
@docs e0, e2, e3, e4, e6, e8, e16, e24
@docs elevations

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
shadow : Int -> Property a m
shadow z =
    cs ("mdl-shadow--" ++ toString z ++ "dp")


{-|
-}
e0 : Property a m
e0 =
    nop


{-|
-}
e2 : Property a m
e2 =
    shadow 2


{-|
-}
e3 : Property a m
e3 =
    shadow 3


{-|
-}
e4 : Property a m
e4 =
    shadow 4


{-|
-}
e6 : Property a m
e6 =
    shadow 6


{-|
-}
e8 : Property a m
e8 =
    shadow 8


{-|
-}
e16 : Property a m
e16 =
    shadow 16


{-|
-}
e24 : Property a m
e24 =
    shadow 24


{-| List of all elevations and their depth in dp.
-}
elevations : Array ( Property a m, Int )
elevations =
    Array.fromList
        [ ( e0, 0 )
        , ( e2, 2 )
        , ( e3, 3 )
        , ( e4, 4 )
        , ( e6, 6 )
        , ( e8, 8 )
        , ( e16, 16 )
        , ( e24, 24 )
        ]


{-| Add a CSS-transition to changes in elevation. Supply a transition
duration in milliseconds as argument.

NB! This property is dictated neither by MDL nor the Material Design Specification.
-}
transition : Float -> Property a m
transition duration =
    css "transition" ("box-shadow " ++ toString duration ++ "ms ease-in-out 0s")
