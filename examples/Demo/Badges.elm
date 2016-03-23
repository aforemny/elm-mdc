module Demo.Badges where

import Html exposing (..)
import Html.Attributes exposing (class, style, key)
import Material.Badge as Badge
import Material.Style exposing (..)

-- VIEW

view : List Html
view = [  div [][p [][]
        , styled span  [Badge.withBadge "56", Badge.overlap]  [ ] [ text "Span with badge" ]
        , p [][]
        -- , styled span  (Badge.badgeStyle   { overlap = True, noBackground = False} "7")  [ ] [ text "Span with no background badge" ]
        -- , p [][]
        -- , styled span  (Badge.badgeStyle   { overlap = True, noBackground = False} "14")  [ ] [ text "Span with badge overlap" ]
    ]
  ]