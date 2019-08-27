module Demo.Startpage.Svg.DataTable exposing (view)

import Html exposing (Html)
import Svg exposing (defs, desc, g, mask, path, rect, svg, text, text_, title, tspan, use)
import Svg.Attributes exposing (d, fill, fillOpacity, fillRule, fontFamily, fontSize, fontWeight, height, id, letterSpacing, opacity, rx, stroke, strokeWidth, transform, version, viewBox, width, x, xlinkHref, y)


view : Html msg
view =
    svg [ viewBox "0 0 180 180", version "1.1" ]
        [ title []
            [ text "data_table_180px" ]
        , g [ id "__3R_BED7__Page-1", stroke "none", strokeWidth "1", fill "none", fillRule "evenodd" ]
            [ g [ id "__3R_BED7__Group" ]
                  [ rect [ id "__3R_BED7__Rectangle", fill "#D1D1D1", x "0", y "0", width "180", height "180" ] []
                  , g [ id "__3R_BED7__ic_data_table_black_24dp", transform "translate(49.000000, 46.000000)" ]
                      [ rect [ id "__3R_BED7__Rectangle", x "0", y "0",  width "81", height "81" ] []
                      , path [ d "M6,7 L6,75 L74,75 L74,7 L6,7 Z M67.2,68.2 L12.8,68.2 L12.8,54.6 L67.2,54.6 L67.2,68.2 Z M67.2,47.8 L12.8,47.8 L12.8,34.2 L67.2,34.2 L67.2,47.8 Z M67.2,27.4 L12.8,27.4 L12.8,13.8 L67.2,13.8 L67.2,27.4 Z M16.2,17.2 L23,17.2 L23,24 L16.2,24 L16.2,17.2 Z M16.2,58 L23,58 L23,64.8 L16.2,64.8 L16.2,58 Z M16.2,37.6 L23,37.6 L23,44.4 L16.2,44.4 L16.2,37.6 Z", id "__3R_BED7__Shape",  fill "#000000", fillRule "nonzero" ] []
                      ]
                  ]
            ]
        ]
