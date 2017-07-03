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


view : Model -> Html Msg
view model =
    Page.body1_ "Elevation" srcUrl intro references []
    [ Options.div
      [ css "display" "flex"
      , css "flex-flow" "row wrap"
      ]
      ( List.map (\z ->
            Options.div
            [ Elevation.elevation z
            , css "width" "200px"
            , css "height" "100px"
            , css "margin" "0 60px 80px"
            , css "line-height" "100px"
            , css "color" "#9e9e9e"
            , css "font-size" "0.8em"
            , css "border-radius" "3px"
            ]
            [ text (toString z ++ "dp")
            ]
          )
          (List.range 0 24)
      )
    ]


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
