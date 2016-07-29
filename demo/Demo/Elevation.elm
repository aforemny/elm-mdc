module Demo.Elevation exposing (view)

import Html exposing (..)

import Material.Options as Options exposing (cs, css, Style)
import Material.Elevation as Elevation
import Material.Typography as Typography

import Demo.Page as Page
import Demo.Code as Code


-- VIEW


elevate : (Style a, Int) -> Html a 
elevate (e, k) =
  Options.div
    [ css "display" "inline-flex"
    , css "flex-flow" "row wrap"
    , css "justify-content" "center"
    , css "align-items" "center"
    ]
    [ Options.div
        [ e
        , css "height" "96px"
        , css "width"  "128px"
        , css "margin" "40px"

        -- Center
        , css "display" "inline-flex"
        , css "flex-flow" "row wrap"
        , css "justify-content" "center"
        , css "align-items" "center"
        ]
        [ Options.div
            [ Typography.titleColorContrast
            , css "box-radius" "2pt"
            ]
            [ text <| toString k ]
        ]
    , Options.div
        [css "width" "300px"]
        [ Code.code
            (
             """
              Options.div
                [ Elevation.e""" ++ (toString k) ++ """
                , css "height" "96px"
                , css "width"  "128px"
                , css "margin" "40px"
                -- Center
                , css "display" "inline-flex"
                , css "flex-flow" "row wrap"
                , css "justify-content" "center"
                , css "align-items" "center"
                ]
                [ text \"""" ++ (toString k) ++ """\" ]"""
            )
        ]
    ]


view : Html a
view =
  (cs "", 0) :: Elevation.elevations
  |> List.map elevate
  |> (::) ( Code.code """import Material.Elevation as Elevation""" )
  |> (::) ( p [] [ text """Below are boxes drawn at various elevations.""" ] )
  |> Page.body1 "Elevation" srcUrl intro references



intro : Html a
intro =
  Page.fromMDL "https://github.com/google/material-design-lite/blob/master/src/shadow/README.md" """
  > The Material Design Lite (MDL) shadow is not a component in the same sense as
> an MDL card, menu, or textbox; it is a visual effect that can be assigned to a
> user interface element. The effect simulates a three-dimensional positioning of
> the element, as though it is slightly raised above the surface it rests upon —
> a positive z-axis value, in user interface terms. The shadow starts at the
> edges of the element and gradually fades outward, providing a realistic 3-D
> effect.
> 
> Shadows are a convenient and intuitive means of distinguishing an element from
> its surroundings. A shadow can draw the user's eye to an object and emphasize
> the object's importance, uniqueness, or immediacy.
> 
> Shadows are a well-established feature in user interfaces, and provide users
> with a visual clue to an object's intended use or value. Their design and use
> is an important factor in the overall user experience.)

The [Material Design Specification](https://www.google.com/design/spec/what-is-material/elevation-shadows.html#elevation-shadows-elevation-android-)
pre-defines appropriate elevation for most UI elements; you need to manually
assign shadows only to your own elements. 

You are encouraged to visit the
[Material Design specification](https://www.google.com/design/spec/what-is-material/elevation-shadows.html)
for details about appropriate use of shadows. 
"""


srcUrl : String
srcUrl = 
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Elevation.elm"


references : List (String, String)
references = 
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Elevation"
  , Page.mds "https://www.google.com/design/spec/what-is-material/elevation-shadows.html"
  , Page.mdl "https://github.com/google/material-design-lite/blob/master/src/shadow/README.md"
  ]


