module Demo.Badges where

import Material.Icon as Icon
import Material.Badge as Badge
import Html exposing (..)
import Html.Attributes exposing (..)


view : List Html
view =
  [ 
    h1 [][text "Badges"],
    Icon.viewWithOptions "add" Icon.S18 [] { badgeInfo = Just (Badge.viewDefault "16")},
    Icon.viewWithOptions "add" Icon.S18 [] { badgeInfo = Just (Badge.view   { overlap = False, noBackground = False} "99")},
    Icon.viewWithOptions "add" Icon.S18 [] { badgeInfo = Just (Badge.view   { overlap = False, noBackground = True} "4")},
    Icon.view "add" Icon.S18 [],
    Icon.i "add"
  ]
