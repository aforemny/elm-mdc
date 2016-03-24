module Demo.Badges where

import Html exposing (..)
import Html.Attributes exposing (class, style, key)
import Material.Badge as Badge
import Material.Style exposing (..)

-- VIEW

view : List Html
view = [  div [][p [][]
        , styled span  [Badge.withBadge "2"]  [ ] [ text "Span with badge" ]
        , p [][]
        , styled span  [Badge.withBadge "22", Badge.noBackground]  [ ] [ text "Span with no background badge" ]
        , p [][]
        , styled span  [Badge.withBadge "33", Badge.overlap]  [ ] [ text "Span with badge overlap" ]
        , p [][]
        , styled span  [Badge.withBadge "99", Badge.overlap, Badge.noBackground]  [ ] [ text "Span with badge overlap and no background" ]
        , p [][]
    ]
  ]