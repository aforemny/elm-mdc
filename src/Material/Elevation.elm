module Material.Elevation
    exposing
        (
          z0
        , z1
        , z2
        , z3
        , z4
        , z5
        , z6
        , z7
        , z8
        , z9
        , z10
        , z11
        , z12
        , z13
        , z14
        , z15
        , z16
        , z17
        , z18
        , z19
        , z20
        , z21
        , z22
        , z23
        , z24
        , transition
        )

{-|
Shadows provide important visual cues about objects’ depth and directional
movement. They are the only visual cue indicating the amount of separation
between surfaces. An object’s elevation determines the appearance of its
shadow. The elevation values are mapped out in a "z-space" and range from 0 to
24.


# Resources

- [Material Design guidelines: Shadows & elevation](https://material.io/components/web/catalog/elevation/)
- [Demo](https://aforemny.github.io/elm-mdc/#elevation)


# Example

```elm
import Html
import Material.Elevation as Elevation
import Material.Options exposing (styled)


styled Html.div
    [ Elevation.z8
    ]
    [ text "Hello"
    ]
```


# Usage

@docs z0, z1, z2, z3, z4, z5, z6, z7, z8, z9, z10, z11, z12, z13, z14, z15
@docs z16, z17, z18, z19, z20, z21, z22, z23, z24
@docs transition
-}

import Material.Options exposing (Property, cs)


{-| Sets the elevation to 0 dp.
-}
z0 : Property c m
z0 =
    z 0


{-| Sets the elevation to 1 dp.
-}
z1 : Property c m
z1 =
    z 1


{-| Sets the elevation to 2 dp.
-}
z2 : Property c m
z2 =
    z 2


{-| Sets the elevation to 3 dp.
-}
z3 : Property c m
z3 =
    z 3


{-| Sets the elevation to 4 dp.
-}
z4 : Property c m
z4 =
    z 4


{-| Sets the elevation to 5 dp.
-}
z5 : Property c m
z5 =
    z 5


{-| Sets the elevation to 6 dp.
-}
z6 : Property c m
z6 =
    z 6


{-| Sets the elevation to 7 dp.
-}
z7 : Property c m
z7 =
    z 7


{-| Sets the elevation to 8 dp.
-}
z8 : Property c m
z8 =
    z 8


{-| Sets the elevation to 9 dp.
-}
z9 : Property c m
z9 =
    z 9


{-| Sets the elevation to 10 dp.
-}
z10 : Property c m
z10 =
    z 10


{-| Sets the elevation to 11 dp.
-}
z11 : Property c m
z11 =
    z 11


{-| Sets the elevation to 12 dp.
-}
z12 : Property c m
z12 =
    z 12


{-| Sets the elevation to 13 dp.
-}
z13 : Property c m
z13 =
    z 13


{-| Sets the elevation to 14 dp.
-}
z14 : Property c m
z14 =
    z 14


{-| Sets the elevation to 15 dp.
-}
z15 : Property c m
z15 =
    z 15


{-| Sets the elevation to 16 dp.
-}
z16 : Property c m
z16 =
    z 16


{-| Sets the elevation to 17 dp.
-}
z17 : Property c m
z17 =
    z 17


{-| Sets the elevation to 18 dp.
-}
z18 : Property c m
z18 =
    z 18


{-| Sets the elevation to 19 dp.
-}
z19 : Property c m
z19 =
    z 19


{-| Sets the elevation to 20 dp.
-}
z20 : Property c m
z20 =
    z 20


{-| Sets the elevation to 21 dp.
-}
z21 : Property c m
z21 =
    z 21


{-| Sets the elevation to 22 dp.
-}
z22 : Property c m
z22 =
    z 22


{-| Sets the elevation to 23 dp.
-}
z23 : Property c m
z23 =
    z 23


{-| Sets the elevation to 24 dp.
-}
z24 : Property c m
z24 =
    z 24


z : Int -> Property c m
z v =
    cs <| "mdc-elevation--z" ++ toString v


{-| Applies the correct css rules to transition an element between elevations.
-}
transition : Property c m
transition =
    cs "mdc-elevation-transition"
