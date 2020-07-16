module Internal.CircularProgress.Implementation exposing
    ( Property
    , progress
    , view
    )

import Html exposing (Html, div)
import Internal.Options as Options exposing (aria, cs, css, role, styled, when)
import Svg
import Svg.Attributes as Svg exposing (cx, cy, r, strokeDasharray, strokeDashoffset, strokeWidth, viewBox)


type alias Config =
    { progress : Maybe Float
    , radius : Float
    }


defaultConfig : Config
defaultConfig =
    { progress = Nothing
    , radius = 18
    }


type alias Property m =
    Options.Property Config m


progress : Float -> Property m
progress value =
    Options.option (\config -> { config | progress = Just value })


view : List (Property m) -> List (Html m) -> Html m
view options _ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        valuenow =
            Maybe.withDefault 0 config.progress

        isIndeterminate =
            config.progress == Nothing
    in
    Options.apply summary
        Html.div
        [ block
        , modifier "large"
        , aria "valuemin" "0"
        , aria "valuemax" "1"
        , aria "valuenow" (String.fromFloat valuenow) |> when (not isIndeterminate)
        , role "progressbar"
        ]
        []
        [ if isIndeterminate then
              viewIndeterminateContainer
          else
              viewDeterminateContainer valuenow config.radius
        ]


viewDeterminateContainer : Float -> Float -> Html msg
viewDeterminateContainer progress_ radius =
    let
        unfilledArcLength =
          (1 - progress_) * (2 * pi * radius)
    in
    styled div
        [ element "determinate-container" ]
        [ Svg.svg
              [ Svg.class "mdc-circular-progress__determinate-circle-graphic"
              , viewBox "0 0 48 48" ]
              [ Svg.circle
                    [ Svg.class "mdc-circular-progress__determinate-circle"
                    , cx "24"
                    , cy "24"
                    , r "18"
                    , strokeDasharray "113.097"
                    , strokeDashoffset (String.fromFloat unfilledArcLength)
                    , strokeWidth "4"
                    ]
                    []
              ]
        ]


viewIndeterminateContainer : Html msg
viewIndeterminateContainer =
    styled div
        [ element "indeterminate-container" ]
        [ styled div
              [ element "spinner-layer" ]
              [ styled div
                    [ element "circle-clipper"
                    , element "circle-left"
                    ]
                    [ viewCircle 4 ]
              , styled div
                  [ element "gap-patch" ]
                  [ viewCircle 3.2 ]
              , styled div
                  [ element "circle-clipper"
                  , element "circle-right"
                  ]
                  [ viewCircle 4 ]
              ]
        ]


viewCircle : Float -> Html msg
viewCircle stroke_width =
    Svg.svg
        [ Svg.class "mdc-circular-progress__indeterminate-circle-graphic"
        , viewBox "0 0 48 48" ]
        [ Svg.circle
              [ cx "24"
              , cy "24"
              , r "18"
              , strokeDasharray "113.097"
              , strokeDashoffset "56.549"
              , strokeWidth (String.fromFloat stroke_width)
              ]
              []
        ]


{- Make it easier to work with BEM conventions
-}
block : Property m
block =
    cs blockName

element : String -> Property m
element module_ =
    cs ( blockName ++ "__ " ++ module_ )

modifier : String -> Property m
modifier modifier_ =
    cs ( blockName ++ "__ " ++ modifier_ )

blockName : String
blockName =
    "mdc-circular-progress"
