module Material.Internal.LinearProgress.Implementation exposing
    ( buffered
    , determinate
    , indeterminate
    , Property
    , reversed
    , view
    )

{-|
The MDC Linear Progress component is a spec-aligned linear progress indicator
component adhering to the Material Design progress & activity requirements.


# Resources

- [Material Design guidelines: Progress & activity](https://material.io/guidelines/components/progress-activity.html)
- [Demo](https://aforemny.github.io/elm-mdc/#linear-progress)


# Example

```elm
import Material.LinearProgress as LinearProgress

LinearProgress.view
    [ LinearProgress.indeterminate
    ]
    []
```


# Usage

@docs Property
@docs view
@docs determinate
@docs indeterminate
@docs buffered
@docs reversed
-}

import Html exposing (Html)
import Material.Internal.Options as Options exposing (styled, cs, css, when)
import Material.Internal.Options.Internal as Internal


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


{-| LinearProgress property.
-}
type alias Property m =
    Options.Property Config m


{-| Indeterminate indicators visualize an unspecified wait time.
-}
indeterminate : Property m
indeterminate =
    Internal.option (\config -> { config | indeterminate = True })


{-| Determinate indicators display how long an operation will take.

The first argument is the determinate indicator as a floating point value
between 0 and 1.
-}
determinate : Float -> Property m
determinate value =
    Internal.option (\config -> { config | determinate = True, value = value })


{-| Include a buffer indicator along with a regular determinate indicator.

The first value is the determinate indicator and the second value is the buffer
indicator as a floating point value between 0 and 1.
-}
buffered : Float -> Float -> Property m
buffered value buffer =
    Internal.option (\config -> { config | buffered = True, value = value, buffer = buffer })


{-| Reverse the indicator.
-}
reversed : Property m
reversed =
    Internal.option (\config -> { config | reversed = True })


{-| LinearProgress view.
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
