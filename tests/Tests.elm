module Tests exposing (..)

import Test exposing (..)
import Expect

--Do not delete these imports as they are beeing compiled even when not beeing tested directly

import Material
import Material.Color as Color
import Material.Layout as Layout
import Material.Helpers exposing (pure, lift, map1st, map2nd)
import Material.Options as Options exposing (css, when)
import Material.Scheme as Scheme
import Material.Icon as Icon
import Material.Typography as Typography
import Material.Menu as Menu

import Demo.Page as Page
import Demo.Buttons
import Demo.Menus
import Demo.Tables
import Demo.Grid
import Demo.Textfields
import Demo.Snackbar
import Demo.Badges
import Demo.Elevation
import Demo.Toggles
import Demo.Loading
import Demo.Layout
import Demo.Footer
import Demo.Tooltip
import Demo.Tabs
import Demo.Slider
import Demo.Typography
import Demo.Cards
import Demo.Lists
import Demo.Dialog
import Demo.Chips



mainSuite : Test
mainSuite =
    describe "Main Test Suite"
        [ test "Sample test" <|
            \() ->
                Expect.equal (1) 1
        ]

all : Test
all =
    describe "elm-mdl"
        [ mainSuite
        ]
