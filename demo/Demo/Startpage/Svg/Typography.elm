module Demo.Startpage.Svg.Typography exposing (view)

import Html exposing (Html)
import Svg exposing (defs, desc, g, mask, path, rect, svg, text, text_, title, tspan, use)
import Svg.Attributes exposing (d, fill, fillRule, fontFamily, fontSize, fontWeight, height, id, letterSpacing, stroke, strokeDasharray, strokeLinecap, strokeWidth, version, viewBox, width, x, xlinkHref, y)


view : Html msg
view =
    svg [ viewBox "0 0 180 180", version "1.1" ]
        [ title []
            [ text "fonts_180px " ]
        , desc []
            [ text "Created with Sketch." ]
        , defs []
            [ rect [ id "__37HpfMz__path-1", x "0", y "0", width "180", height "180" ]
                []
            ]
        , g [ id "__37HpfMz__fonts_180px-", stroke "none", strokeWidth "1", fill "none", fillRule "evenodd" ]
            [ g [ id "__37HpfMz__Headline-4-+-Line-+-Line-Copy-2-+-Line-Copy-+-Line-Copy-3-Mask" ]
                [ mask [ id "__37HpfMz__mask-2", fill "white" ]
                    [ use [ xlinkHref "#__37HpfMz__path-1" ]
                        []
                    ]
                , use [ id "__37HpfMz__Mask", fill "#FAFAFA", xlinkHref "#__37HpfMz__path-1" ]
                    []
                , text_ [ id "__37HpfMz__Headline-4", Svg.Attributes.mask "url(#__37HpfMz__mask-2)", fontFamily "Roboto-Medium, Roboto", fontSize "150", fontWeight "400", letterSpacing "1.10294116", fill "#212121" ]
                    [ tspan [ x "20", y "143" ]
                        [ text "A" ]
                    , tspan [ x "120.932043", y "143", fontSize "130" ]
                        [ text "z" ]
                    ]
                , path [ d "M-26.5,36.5 L205.577573,36.5", id "__37HpfMz__Line", stroke "#212121", strokeWidth "2", strokeLinecap "square", Svg.Attributes.mask "url(#__37HpfMz__mask-2)" ]
                    []
                , path [ d "M22,211.077573 L22,-21", id "__37HpfMz__Line-Copy-2", stroke "#212121", strokeWidth "2", strokeLinecap "square", Svg.Attributes.mask "url(#__37HpfMz__mask-2)" ]
                    []
                , path [ d "M-26.5,142.5 L205.577573,142.5", id "__37HpfMz__Line-Copy", stroke "#212121", strokeWidth "2", strokeLinecap "square", Svg.Attributes.mask "url(#__37HpfMz__mask-2)" ]
                    []
                , path [ d "M1,76 L233.077573,76", id "__37HpfMz__Line-Copy-3", stroke "#212121", strokeWidth "2", strokeDasharray "10,6", Svg.Attributes.mask "url(#__37HpfMz__mask-2)" ]
                    []
                ]
            ]
        ]
