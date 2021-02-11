module Internal.LinearProgress.Implementation exposing
    ( Property
    , buffered
    , determinate
    , indeterminate
    , reversed
    , view
    )

import Html exposing (Html)
import Internal.Options as Options exposing (aria, cs, css, role, styled, when)


type alias Config =
    { value : Float
    , buffer : Float
    , determinate : Bool
    , indeterminate : Bool
    , buffered : Bool
    , reversed : Bool
    }


defaultConfig : Config
defaultConfig =
    { value = 0
    , buffer = 0
    , determinate = False
    , indeterminate = False
    , buffered = False
    , reversed = False
    }


type alias Property m =
    Options.Property Config m


indeterminate : Property m
indeterminate =
    Options.option (\config -> { config | indeterminate = True })


determinate : Float -> Property m
determinate value =
    Options.option (\config -> { config | determinate = True, value = value })


buffered : Float -> Float -> Property m
buffered value buffer =
    Options.option (\config -> { config | buffered = True, value = value, buffer = buffer })


reversed : Property m
reversed =
    Options.option (\config -> { config | reversed = True })


view : List (Property m) -> List (Html m) -> Html m
view options _ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        isDeterminate = not config.indeterminate
    in
    Options.apply summary
        Html.div
        [ cs "mdc-linear-progress"
        , cs "mdc-linear-progress--indeterminate" |> when config.indeterminate
        , cs "mdc-linear-progress--reversed" |> when config.reversed
        , aria "valuemin" "0" |> when isDeterminate
        , aria "valuemax" "1" |> when isDeterminate
        , aria "valuenow" (String.fromFloat config.value) |> when (not config.indeterminate)
        , role "progressbar"
        ]
        []
        [ styled Html.div
            [ cs "mdc-linear-progress__buffer"
            ]
            [ styled Html.div
                  [ cs "mdc-linear-progress__buffer-bar"
                  , when config.buffered <|
                      css "flex-basis" <| String.fromFloat (config.buffer * 100)  ++ "%"
                  ]
                  []
            , styled Html.div
                  [ cs "mdc-linear-progress__buffer-dots"
                  ]
                  []
            ]
        , styled Html.div
            [ cs "mdc-linear-progress__bar mdc-linear-progress__primary-bar"
            , when (not config.indeterminate) <|
                css "transform" ("scaleX(" ++ String.fromFloat config.value ++ ")")
            ]
            [ styled Html.span [ cs "mdc-linear-progress__bar-inner" ] []
            ]
        , styled Html.div
            [ cs "mdc-linear-progress__bar mdc-linear-progress__secondary-bar"
            ]
            [ styled Html.span [ cs "mdc-linear-progress__bar-inner" ] []
            ]
        ]
