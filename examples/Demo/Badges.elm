module Demo.Badges where

import Html exposing (..)
import Html.Attributes exposing (class, style, key)
import Material.Badge as Badge
import Material.Style exposing (..)

-- VIEW

view : List Html
view = [  div [][p [][]
        , styled span  (Badge.badgeStyle   { overlap = False, noBackground = False} "4")  [ ] [ text "Span with badge" ]
        , p [][]
        , styled span  (Badge.badgeStyle   { overlap = True, noBackground = False} "7")  [ ] [ text "Span with no background badge" ]
        , p [][]
        , styled span  (Badge.badgeStyle   { overlap = True, noBackground = False} "14")  [ ] [ text "Span with badge overlap" ]
    ]
  ]