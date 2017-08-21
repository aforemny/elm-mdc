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

{-| Shadows provide important visual cues about objects’ depth and directional
movement. An object’s elevation determines the appearance of its shadow.

## Design & API Documentation

- [Material Design guidelines: Shadows & elevation](https://material.io/components/web/catalog/elevation/)
- [Demo](https://aforemny.github.io/elm-mdc/#elevation)


## Elevations

@docs z0, z1, z2, z3, z4, z5, z6, z7, z8, z9, z10, z11, z12, z13, z14, z15
@docs z16, z17, z18, z19, z20, z21, z22, z23, z24
@docs transition
-}

import Material.Options exposing (..)


z0 : Property a m
z0 =
    z 0


z1 : Property a m
z1 =
    z 1


z2 : Property a m
z2 =
    z 2


z3 : Property a m
z3 =
    z 3


z4 : Property a m
z4 =
    z 4


z5 : Property a m
z5 =
    z 5


z6 : Property a m
z6 =
    z 6


z7 : Property a m
z7 =
    z 7


z8 : Property a m
z8 =
    z 8


z9 : Property a m
z9 =
    z 9


z10 : Property a m
z10 =
    z 10


z11 : Property a m
z11 =
    z 11


z12 : Property a m
z12 =
    z 12


z13 : Property a m
z13 =
    z 13


z14 : Property a m
z14 =
    z 14


z15 : Property a m
z15 =
    z 15


z16 : Property a m
z16 =
    z 16


z17 : Property a m
z17 =
    z 17


z18 : Property a m
z18 =
    z 18


z19 : Property a m
z19 =
    z 19


z20 : Property a m
z20 =
    z 20


z21 : Property a m
z21 =
    z 21


z22 : Property a m
z22 =
    z 22


z23 : Property a m
z23 =
    z 23


z24 : Property a m
z24 =
    z 24


z : Int -> Property a m
z v =
    cs <| "mdc-elevation--z" ++ toString v


transition : Property a m
transition =
    cs "mdc-elevation--transition"
