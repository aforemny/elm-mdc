module Material.LinearProgress
    exposing
        ( view
        , Property
        , determinate
        , indeterminate
        , buffered
        , reversed
        )

{-|
The MDC Linear Progress component is a spec-aligned linear progress indicator component adhering to the Material Design progress & activity requirements.

## Design & API Documentation

- [Guidelines](https://material.io/guidelines/components/progress-activity.html)
- [Demo](https://aforemny.github.io/elm-mdc/#linear-progress)

## View
@docs view

## Properties
@docs Property
@docs determinate, indeterminate, buffered
@docs reversed
-}

import Html exposing (Html)
import Material.Internal.Options as Internal
import Material.Options as Options exposing (styled, cs, css, when)


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


{-| A LinearProgress property.
-}
type alias Property m =
    Options.Property Config m


{-| Determinate indicators display how long an operation will take.
-}
determinate : Float -> Property m
determinate value =
    Internal.option (\config -> { config | determinate = True, value = value })


{-| Indeterminate indicators visualize an unspecified wait time.
-}
indeterminate : Property m
indeterminate =
    Internal.option (\config -> { config | indeterminate = True })


{-| Include a buffer indicator along with a regular determinate indicator.
-}
buffered : Float -> Float -> Property m
buffered value buffer =
    Internal.option (\config -> { config | buffered = True, value = value, buffer = buffer })


{-| Reverse the indicator
-}
reversed : Property m
reversed =
    Internal.option (\config -> { config | reversed = True })


{-| Component view.
-}
view : List (Property m) -> List (Html m) -> Html m
view options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options
    in
    Internal.apply summary Html.div
    [ cs "mdc-linear-progress"
    , cs "mdc-linear-progress--indeterminate" |> when config.indeterminate
    , cs "mdc-linear-progress--reversed" |> when config.reversed
    ]
    []
    [ styled Html.div
      [ cs "mdc-linear-progress__buffering-dots"
      ]
      []
    , styled Html.div
      [ cs "mdc-linear-progress__buffer"
      , when config.buffered <|
        css "transform" ("scaleX(" ++ toString config.buffer ++ ")")
      ]
      []
    , styled Html.div
      [ cs "mdc-linear-progress__bar mdc-linear-progress__primary-bar"
      , when (not config.indeterminate) <|
        css "transform" ("scaleX(" ++ toString config.value ++ ")")
      ]
      [ styled Html.span [ cs "mdc-linear-progress__bar-inner" ] []
      ]
    , styled Html.div
      [ cs "mdc-linear-progress__bar mdc-linear-progress__secondary-bar"
      ]
      [ styled Html.span [ cs "mdc-linear-progress__bar-inner" ] []
      ]
    ]
