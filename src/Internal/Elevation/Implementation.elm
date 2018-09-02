module Internal.Elevation.Implementation
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

import Internal.Options exposing (Property, cs)


z0 : Property c m
z0 =
    z 0


z1 : Property c m
z1 =
    z 1


z2 : Property c m
z2 =
    z 2


z3 : Property c m
z3 =
    z 3


z4 : Property c m
z4 =
    z 4


z5 : Property c m
z5 =
    z 5


z6 : Property c m
z6 =
    z 6


z7 : Property c m
z7 =
    z 7


z8 : Property c m
z8 =
    z 8


z9 : Property c m
z9 =
    z 9


z10 : Property c m
z10 =
    z 10


z11 : Property c m
z11 =
    z 11


z12 : Property c m
z12 =
    z 12


z13 : Property c m
z13 =
    z 13


z14 : Property c m
z14 =
    z 14


z15 : Property c m
z15 =
    z 15


z16 : Property c m
z16 =
    z 16


z17 : Property c m
z17 =
    z 17


z18 : Property c m
z18 =
    z 18


z19 : Property c m
z19 =
    z 19


z20 : Property c m
z20 =
    z 20


z21 : Property c m
z21 =
    z 21


z22 : Property c m
z22 =
    z 22


z23 : Property c m
z23 =
    z 23


z24 : Property c m
z24 =
    z 24


z : Int -> Property c m
z v =
    cs <| "mdc-elevation--z" ++ toString v


transition : Property c m
transition =
    cs "mdc-elevation-transition"
