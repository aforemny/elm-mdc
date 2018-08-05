module Material.Elevation
    exposing
        ( transition
        , z0
        , z1
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
        , z2
        , z20
        , z21
        , z22
        , z23
        , z24
        , z3
        , z4
        , z5
        , z6
        , z7
        , z8
        , z9
        )

{-| Shadows provide important visual cues about objects’ depth and directional
movement. They are the only visual cue indicating the amount of separation
between surfaces. An object’s elevation determines the appearance of its
shadow. The elevation values are mapped out in a "z-space" and range from 0 to


# Resources

  - [Material Design guidelines: Shadows & elevation](https://material.io/components/web/catalog/elevation/)
  - [Demo](https://aforemny.github.io/elm-mdc/#elevation)


# Example

    import Html exposing (text)
    import Material.Elevation as Elevation
    import Material.Options exposing (styled)


    styled Html.div
        [ Elevation.z8
        ]
        [ text "Hello"
        ]


# Usage

@docs z0, z1, z2, z3, z4, z5, z6, z7, z8
@docs z9, z10, z11, z12, z13, z14, z15, z16
@docs z17, z18, z19, z20, z21, z22, z23, z24
@docs transition

-}

import Internal.Elevation.Implementation as Elevation
import Material.Options exposing (Property)


{-| Sets the elevation to 0 dp.
-}
z0 : Property c m
z0 =
    Elevation.z0


{-| Sets the elevation to 1 dp.
-}
z1 : Property c m
z1 =
    Elevation.z1


{-| Sets the elevation to 2 dp.
-}
z2 : Property c m
z2 =
    Elevation.z2


{-| Sets the elevation to 3 dp.
-}
z3 : Property c m
z3 =
    Elevation.z3


{-| Sets the elevation to 4 dp.
-}
z4 : Property c m
z4 =
    Elevation.z4


{-| Sets the elevation to 5 dp.
-}
z5 : Property c m
z5 =
    Elevation.z5


{-| Sets the elevation to 6 dp.
-}
z6 : Property c m
z6 =
    Elevation.z6


{-| Sets the elevation to 7 dp.
-}
z7 : Property c m
z7 =
    Elevation.z7


{-| Sets the elevation to 8 dp.
-}
z8 : Property c m
z8 =
    Elevation.z8


{-| Sets the elevation to 9 dp.
-}
z9 : Property c m
z9 =
    Elevation.z9


{-| Sets the elevation to 10 dp.
-}
z10 : Property c m
z10 =
    Elevation.z10


{-| Sets the elevation to 11 dp.
-}
z11 : Property c m
z11 =
    Elevation.z11


{-| Sets the elevation to 12 dp.
-}
z12 : Property c m
z12 =
    Elevation.z12


{-| Sets the elevation to 13 dp.
-}
z13 : Property c m
z13 =
    Elevation.z13


{-| Sets the elevation to 14 dp.
-}
z14 : Property c m
z14 =
    Elevation.z14


{-| Sets the elevation to 15 dp.
-}
z15 : Property c m
z15 =
    Elevation.z15


{-| Sets the elevation to 16 dp.
-}
z16 : Property c m
z16 =
    Elevation.z16


{-| Sets the elevation to 17 dp.
-}
z17 : Property c m
z17 =
    Elevation.z17


{-| Sets the elevation to 18 dp.
-}
z18 : Property c m
z18 =
    Elevation.z18


{-| Sets the elevation to 19 dp.
-}
z19 : Property c m
z19 =
    Elevation.z19


{-| Sets the elevation to 20 dp.
-}
z20 : Property c m
z20 =
    Elevation.z20


{-| Sets the elevation to 21 dp.
-}
z21 : Property c m
z21 =
    Elevation.z21


{-| Sets the elevation to 22 dp.
-}
z22 : Property c m
z22 =
    Elevation.z22


{-| Sets the elevation to 23 dp.
-}
z23 : Property c m
z23 =
    Elevation.z23


{-| Sets the elevation to 24 dp.
-}
z24 : Property c m
z24 =
    Elevation.z24


{-| Applies the correct css rules to transition an element between elevations.
-}
transition : Property c m
transition =
    Elevation.transition
