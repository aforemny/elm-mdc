module Internal.CircularProgress.Implementation exposing
    ( Property
    , progress
    , size
    , view
    )

import Html exposing (Html, div)
import Internal.Options as Options exposing (aria, cs, css, role, styled, when)
import Svg
import Svg.Attributes as Svg exposing (cx, cy, r, strokeDasharray, strokeDashoffset, strokeWidth, viewBox)


type alias Config =
    { progress : Maybe Float
    , radius : Float
    , size : Int
    }


defaultConfig : Config
defaultConfig =
    { progress = Nothing
    , radius = 18
    , size = 48
    }


type alias Property m =
    Options.Property Config m


progress : Float -> Property m
progress value =
    Options.option (\config -> { config | progress = Just value })


size : Int -> Property m
size value =
    Options.option (\config -> { config | size = value })


view : List (Property m) -> List (Html m) -> Html m
view options _ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        valuenow =
            Maybe.withDefault 0 config.progress

        isIndeterminate =
            config.progress == Nothing

        isDeterminate =
            config.progress /= Nothing

    in
    Options.apply summary
        Html.div
        [ block
        , modifier "indeterminate" |> when isIndeterminate
        , css "width" (String.fromInt config.size ++ "px" )
        , css "height" (String.fromInt config.size ++ "px" )
        , css "text-align" "left"
        , aria "valuemin" "0" |> when isDeterminate
        , aria "valuemax" "1" |> when isDeterminate
        , aria "valuenow" (String.fromFloat valuenow) |> when (not isIndeterminate)
        , role "progressbar"
        ]
        []
        [ if isIndeterminate then
              viewIndeterminateContainer config.size
          else
              viewDeterminateContainer config.size valuenow
        ]


viewDeterminateContainer : Int -> Float -> Html msg
viewDeterminateContainer size_ progress_ =
    let
        sizeStr = String.fromInt size_
    in
    styled div
        [ element "determinate-container" ]
        [ Svg.svg
              [ Svg.class "mdc-circular-progress__determinate-circle-graphic"
              , viewBox ( "0 0 " ++ sizeStr ++ " " ++ sizeStr ) ]
              [ viewDeterminateTrack size_ progress_
              , viewDeterminateCircle size_ progress_
              ]
        ]


viewDeterminateTrack : Int -> Float -> Html msg
viewDeterminateTrack size_ progress_ =
    let
        centre = size_ // 2

        stroke_width =
            round <| toFloat size_ / 12

        radius =
            case size_ of
                48 -> 18
                36 -> 12.5
                24 -> 8.75
                _ ->
                    -- TODO: I'm not sure I captured the right calculation here
                    toFloat ( centre - stroke_width - 2 )

        stroke_dash_array =
            2 * pi * radius

        unfilledArcLength =
          (1 - progress_) * (2 * pi * radius)
    in
    Svg.circle
        [ Svg.class "mdc-circular-progress__determinate-track"
        , cx (String.fromInt centre)
        , cy (String.fromInt centre)
        , r (String.fromFloat radius)
        , strokeDasharray (String.fromFloat stroke_dash_array)
        , strokeDashoffset (String.fromFloat unfilledArcLength)
        , strokeWidth (String.fromInt stroke_width)
        ]
        []


viewDeterminateCircle : Int -> Float -> Html msg
viewDeterminateCircle size_ progress_ =
    let
        centre = size_ // 2

        stroke_width =
            round <| toFloat size_ / 12

        radius =
            case size_ of
                48 -> 18
                36 -> 12.5
                24 -> 8.75
                _ ->
                    -- TODO: I'm not sure I captured the right calculation here
                    toFloat ( centre - stroke_width - 2 )

        stroke_dash_array =
            2 * pi * radius

        unfilledArcLength =
          (1 - progress_) * (2 * pi * radius)
    in
    Svg.circle
        [ Svg.class "mdc-circular-progress__determinate-circle"
        , cx (String.fromInt centre)
        , cy (String.fromInt centre)
        , r (String.fromFloat radius)
        , strokeDasharray (String.fromFloat stroke_dash_array)
        , strokeDashoffset (String.fromFloat unfilledArcLength)
        , strokeWidth (String.fromInt stroke_width)
        ]
        []



viewIndeterminateContainer : Int -> Html msg
viewIndeterminateContainer size_ =
    let
        centre = size_ // 2

        stroke_width =
            toFloat size_ / 12

        stroke_adjustment =
            stroke_width * 0.20

        radius =
            case size_ of
                48 -> 18
                36 -> 12.5
                24 -> 8.75
                _ ->
                    -- TODO: I'm not sure I captured the right calculation here
                    toFloat centre - stroke_width - 2

        stroke_dash_array =
            strokeDasharray <| String.fromFloat <| 2 * pi * radius

        progress_ = 0.50

        unfilledArcLength =
          (1 - progress_) * (2 * pi * radius)

        view_box = viewBox ( "0 0 " ++ String.fromInt size_ ++ " " ++ String.fromInt size_ )

        c = String.fromInt centre

        r = String.fromFloat radius

        stroke_dash_offset =
            strokeDashoffset (String.fromFloat unfilledArcLength)
    in
    styled div
        [ element "indeterminate-container" ]
        [ styled div
              [ element "spinner-layer" ]
              [ styled div
                    [ element "circle-clipper"
                    , element "circle-left"
                    ]
                    [ viewCircle view_box c r stroke_width stroke_dash_array stroke_dash_offset ]
              , styled div
                  [ element "gap-patch" ]
                  [ viewCircle view_box c r ( stroke_width - stroke_adjustment )  stroke_dash_array stroke_dash_offset ]
              , styled div
                  [ element "circle-clipper"
                  , element "circle-right"
                  ]
                  [ viewCircle view_box c r stroke_width  stroke_dash_array stroke_dash_offset ]
              ]
        ]


viewCircle : Svg.Attribute msg -> String -> String -> Float -> Svg.Attribute msg -> Svg.Attribute msg -> Html msg
viewCircle view_box c r_ stroke_width  stroke_dash_array stroke_dash_offset =
    Svg.svg
        [ Svg.class "mdc-circular-progress__indeterminate-circle-graphic"
        , view_box ]
        [ Svg.circle
              [ cx c
              , cy c
              , r r_
              , stroke_dash_array
              , stroke_dash_offset
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
    cs ( blockName ++ "__" ++ module_ )

modifier : String -> Property m
modifier modifier_ =
    cs ( blockName ++ "--" ++ modifier_ )

blockName : String
blockName =
    "mdc-circular-progress"
