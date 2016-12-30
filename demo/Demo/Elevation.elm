module Demo.Elevation exposing (view, update, Msg, Model, model)

import Html exposing (..)
import Array
import Material.Options as Options exposing (cs, css, Style, when)
import Material.Elevation as Elevation
import Material.Typography as Typography
import Material.Slider as Slider
import Material.Toggles as Toggles
import Material
import Demo.Page as Page
import Demo.Code as Code


-- MODEL


type alias Model =
    { transition : Bool
    , elevation : Int
    , mdl : Material.Model
    }


model : Model
model =
    { transition = False
    , elevation = 1
    , mdl = Material.model
    }



-- MSG / UPDATE


type Msg
    = SetElevation Int
    | FlipTransition
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetElevation k ->
            { model | elevation = k } ! []

        FlipTransition ->
            { model | transition = not model.transition } ! []

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


elevate : Model -> ( Style a, Int ) -> Html a
elevate model ( e, k ) =
    Options.div
        [ e
        , css "height" "96px"
        , css "width" "128px"
        , css "margin" "40px"
        , css "display" "inline-flex"
        , Elevation.transition 300 |> when model.transition
        , Options.center
        ]
        [ Options.div
            [ Typography.title
            , css "box-radius" "2pt"
            ]
            [ text <| toString k ]
        ]


noElevations : Float
noElevations =
    Array.length Elevation.elevations |> toFloat


demo2 : Model -> List (Html Msg)
demo2 model =
    let
        ( e, k ) =
            Array.get model.elevation Elevation.elevations
                |> Maybe.withDefault ( Elevation.e0, 0 )

        code =
            """
      Options.div
        [ Elevation.e""" ++ (toString k) ++ """
        , css "height" "96px"
        , css "width"  "128px" """
                ++ (if model.transition then
                        "\n        , Elevation.transition 300"
                    else
                        ""
                   )
                ++ """
        , Options.center
        ]
        [ text \""""
                ++ (toString k)
                ++ """" ]"""
    in
        [ Options.styled Html.h4
            []
            [ text "Elevator" ]
        , Options.div
            [ css "display" "flex"
            , css "align-items" "center"
            , css "flex-flow" "row wrap"
            ]
            [ elevate model ( e, k )
            , Options.div
                [ css "flex-direction" "column"
                , css "justify-content" "center"
                , css "flex-grow" "1"
                , css "min-width" "256px"
                ]
                [ Slider.view
                    [ Slider.onChange (floor >> SetElevation)
                    , Slider.value (toFloat model.elevation)
                    , Slider.min 0
                    , Slider.max (noElevations - 1)
                    , Slider.step 1
                    , css "max-width" "384px"
                    ]
                , Toggles.switch Mdl
                    [ 0 ]
                    model.mdl
                    [ Options.onToggle FlipTransition
                    , Toggles.value model.transition
                    , css "margin-left" "20px"
                    , css "margin-top" "24px"
                    ]
                    [ text "Animate" ]
                ]
            ]
        , Code.code [ css "margin" "40px" ] code
        ]



{-
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
             [ Typography.title
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
-}


view : Model -> Html Msg
view model =
    let
        boxes =
            Elevation.elevations |> Array.map (elevate model) |> Array.toList

        demo1 =
            List.append
                [ p [] [ text """Below are boxes drawn at various elevations.""" ] ]
                boxes
    in
        Page.body1_ "Elevation" srcUrl intro references demo1 (demo2 model)


intro : Html a
intro =
    Page.fromMDL "https://github.com/google/material-design-lite/blob/mdl-1.x/src/shadow/README.md" """
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


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Elevation"
    , Page.mds "https://www.google.com/design/spec/what-is-material/elevation-shadows.html"
    , Page.mdl "https://github.com/google/material-design-lite/blob/mdl-1.x/src/shadow/README.md"
    ]
