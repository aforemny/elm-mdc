module Demo.Elevation exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.Elevation as Elevation
import Material.Options as Options exposing (cs, css, styled, when)


type alias Model m =
    { mdc : Material.Model m
    , transition : Bool
    , elevation : Int
    }


defaultModel : Model m
defaultModel =
    { transition = False
    , elevation = 1
    , mdc = Material.defaultModel
    }


type Msg m
    = Mdc (Material.Msg m)


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model



-- VIEW


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    let
        demoSurface options =
            styled Html.figure
                (css "width" "96px"
                    :: css "height" "48px"
                    :: css "margin" "24px 24px"
                    :: css "background-color" "#212121"
                    :: css "color" "#f0f0f0"
                    :: css "display" "flex"
                    :: css "align-items" "center"
                    :: css "justify-content" "center"
                    :: css "font-size" ".8em"
                    :: options
                )
                << List.singleton
                << Html.figcaption []
    in
    page.body "Elevation"
        [ Page.hero []
            [ demoSurface
                [ Elevation.z0
                ]
                [ text "FLAT 0dp" ]
            , demoSurface
                [ Elevation.z4
                ]
                [ text "RAISED 4dp" ]
            ]
        , styled Html.div
            [ css "display" "flex"
            , css "flex-flow" "row wrap"
            , css "padding-top" "48px"
            ]
            (List.map
                (\z ->
                    styled Html.figure
                        [ case z of
                            0 ->
                                Elevation.z0

                            1 ->
                                Elevation.z1

                            2 ->
                                Elevation.z2

                            3 ->
                                Elevation.z3

                            4 ->
                                Elevation.z4

                            5 ->
                                Elevation.z5

                            6 ->
                                Elevation.z6

                            7 ->
                                Elevation.z7

                            8 ->
                                Elevation.z8

                            9 ->
                                Elevation.z9

                            10 ->
                                Elevation.z10

                            11 ->
                                Elevation.z11

                            12 ->
                                Elevation.z12

                            13 ->
                                Elevation.z13

                            14 ->
                                Elevation.z14

                            15 ->
                                Elevation.z15

                            16 ->
                                Elevation.z16

                            17 ->
                                Elevation.z17

                            18 ->
                                Elevation.z18

                            19 ->
                                Elevation.z19

                            20 ->
                                Elevation.z20

                            21 ->
                                Elevation.z21

                            22 ->
                                Elevation.z22

                            23 ->
                                Elevation.z23

                            _ ->
                                Elevation.z24
                        , css "width" "200px"
                        , css "height" "100px"
                        , css "margin" "0 60px 80px"
                        , css "color" "#9e9e9e"
                        , css "font-size" "0.8em"
                        , css "border-radius" "3px"
                        , css "justify-content" "center"
                        , css "align-items" "center"
                        ]
                        [ styled Html.figcaption
                            [ css "display" "flex"
                            ]
                            [ text (String.fromInt z ++ "dp")
                            , Html.br [] []
                            , text ("(Material.Elevation.z" ++ String.fromInt z ++ ")")
                            ]
                        ]
                )
                (List.range 0 24)
            )
        ]
