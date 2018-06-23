module Demo.Startpage.Svg.LayoutGrid exposing (view)

import Html exposing (Html)
import Svg exposing (defs, desc, g, mask, rect, svg, text, title, use)
import Svg.Attributes exposing (fill, fillRule, height, id, stroke, strokeWidth, version, viewBox, width, x, xlinkHref, y)


view : Html msg
view =
    svg [ viewBox "0 0 180 180", version "1.1" ]
        [ title []
            [ text "layout_grid_180px" ]
        , desc []
            [ text "Created with Sketch." ]
        , defs []
            [ rect [ id "__15ihfzO__path-1", x "0", y "0", width "180", height "180" ]
                []
            ]
        , g [ id "__15ihfzO__layout_grid_180px", stroke "none", strokeWidth "1", fill "none", fillRule "evenodd" ]
            [ g [ id "__15ihfzO__Container-+-Container-Copy-3-+-Container-Copy-11-+-Container-Copy-12-+-Container-Copy-+-Container-Copy-4-+-Container-Copy-7-+-Container-Copy-8-+-Container-Copy-2-+-Container-Copy-5-Mask" ]
                [ mask [ id "__15ihfzO__mask-2", fill "white" ]
                    [ use [ xlinkHref "#__15ihfzO__path-1" ]
                        []
                    ]
                , use [ id "__15ihfzO__Mask", fill "#FAFAFA", xlinkHref "#__15ihfzO__path-1" ]
                    []
                , rect [ id "__15ihfzO__Container", fill "#E3E3E3", Svg.Attributes.mask "url(#__15ihfzO__mask-2)", x "24", y "22", width "88", height "88" ]
                    []
                , rect [ id "__15ihfzO__Container-Copy-3", fill "#E3E3E3", Svg.Attributes.mask "url(#__15ihfzO__mask-2)", x "24", y "68", width "42", height "42" ]
                    []
                , rect [ id "__15ihfzO__Container-Copy-11", fill "#E3E3E3", Svg.Attributes.mask "url(#__15ihfzO__mask-2)", x "116", y "68", width "19", height "19" ]
                    []
                , rect [ id "__15ihfzO__Container-Copy-12", fill "#E3E3E3", Svg.Attributes.mask "url(#__15ihfzO__mask-2)", x "139", y "68", width "19", height "19" ]
                    []
                , rect [ id "__15ihfzO__Container-Copy", fill "#E3E3E3", Svg.Attributes.mask "url(#__15ihfzO__mask-2)", x "70", y "22", width "42", height "42" ]
                    []
                , rect [ id "__15ihfzO__Container-Copy-4", fill "#E3E3E3", Svg.Attributes.mask "url(#__15ihfzO__mask-2)", x "70", y "68", width "42", height "42" ]
                    []
                , rect [ id "__15ihfzO__Container-Copy-7", fill "#E3E3E3", Svg.Attributes.mask "url(#__15ihfzO__mask-2)", x "70", y "114", width "42", height "42" ]
                    []
                , rect [ id "__15ihfzO__Container-Copy-8", fill "#E3E3E3", Svg.Attributes.mask "url(#__15ihfzO__mask-2)", x "24", y "114", width "42", height "42" ]
                    []
                , rect [ id "__15ihfzO__Container-Copy-2", fill "#E3E3E3", Svg.Attributes.mask "url(#__15ihfzO__mask-2)", x "116", y "22", width "42", height "42" ]
                    []
                , rect [ id "__15ihfzO__Container-Copy-5", fill "#E3E3E3", Svg.Attributes.mask "url(#__15ihfzO__mask-2)", x "116", y "91", width "42", height "65" ]
                    []
                ]
            ]
        ]
