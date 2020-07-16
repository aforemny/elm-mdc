module Demo.Startpage.Svg.CircularProgress exposing (view)

import Html exposing (Html)
import Svg
import Svg.Attributes as Svg exposing (cx, cy, fill, r, stroke, strokeDasharray, strokeDashoffset, strokeWidth, viewBox)


view : Html msg
view =
    Svg.svg
        [ viewBox "0 0 180 180" ]
        [ Svg.circle
              [ cx "90"
              , cy "90"
              , r "18"
              , fill "transparent"
              , stroke "black"
              , strokeDasharray "113.097"
              , strokeDashoffset "28.2743"
              , strokeWidth "4"
              ]
              []
        ]
