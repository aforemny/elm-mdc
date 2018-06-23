module Demo.Startpage.Svg.Theme exposing (view)

import Html exposing (Html)
import Svg exposing (circle, path, svg, text)
import Svg.Attributes exposing (cx, cy, d, fill, r, viewBox)


view : Html msg
view =
    svg [ viewBox "0 0 24 24" ]
        [ path [ d "M12 2l-5.5 9h11z" ]
            []
        , circle [ cx "17.5", cy "17.5", r "4.5" ]
            []
        , path [ d "M3 13.5h8v8H3z" ]
            []
        , path [ fill "none", d "M0 0h24v24H0z" ]
            []
        ]
