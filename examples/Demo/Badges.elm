module Demo.Badges (..) where

import Html exposing (..)
import Material.Badge as Badge
import Material.Style exposing (styled)
import Material.Icon as Icon


-- VIEW


view : List Html
view =
  [ div
      []
      [ p [] []
      , styled span [ Badge.withBadge "2" ] [] [ text "Span with badge" ]
      , p [] []
      , styled span [ Badge.withBadge "22", Badge.noBackground ] [] [ text "Span with no background badge" ]
      , p [] []
      , styled span [ Badge.withBadge "33", Badge.overlap ] [] [ text "Span with badge overlap" ]
      , p [] []
      , styled span [ Badge.withBadge "99", Badge.overlap, Badge.noBackground ] [] [ text "Span with badge overlap and no background" ]
      , p [] []
      , styled span [ Badge.withBadge "♥" ] [] [ text "Span with HTML symbol - Black heart suit" ]
      , p [] []
      , styled span [ Badge.withBadge "→" ] [] [ text "Span with HTML symbol - Rightwards arrow" ]
      , p [] []
      , styled span [ Badge.withBadge "Δ" ] [] [ text "Span with HTML symbol - Delta" ]
      , p [] []
      , span [] [ text "Icon with badge" ]
      , Icon.view "face" [ Icon.size24, Badge.withBadge "33", Badge.overlap ] []
      , Icon.view "face" [ Icon.size48, Badge.withBadge "33", Badge.overlap ] []
      ]
  ]
