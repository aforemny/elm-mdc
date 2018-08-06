module Material.LinearProgress
    exposing
        ( Property
        , buffered
        , determinate
        , indeterminate
        , reversed
        , view
        )

{-| The Linear Progress component is a spec-aligned linear progress indicator
component adhering to the Material Design progress & activity requirements.


# Resources

  - [Material Design guidelines: Progress & activity](https://material.io/guidelines/components/progress-activity.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#linear-progress)


# Example

    import Material.LinearProgress as LinearProgress

    LinearProgress.view
        [ LinearProgress.indeterminate
        ]
        []


# Usage

@docs Property
@docs view
@docs determinate
@docs indeterminate
@docs buffered
@docs reversed

-}

import Html exposing (Html)
import Internal.LinearProgress.Implementation as LinearProgress


{-| LinearProgress property.
-}
type alias Property m =
    LinearProgress.Property m


{-| LinearProgress view.
-}
view : List (Property m) -> List (Html m) -> Html m
view =
    LinearProgress.view


{-| Indeterminate indicators visualize an unspecified wait time.
-}
indeterminate : Property m
indeterminate =
    LinearProgress.indeterminate


{-| Determinate indicators display how long an operation will take.

The first argument is the determinate indicator as a floating point value
between 0 and 1.

-}
determinate : Float -> Property m
determinate =
    LinearProgress.determinate


{-| Include a buffer indicator along with a regular determinate indicator.

The first value is the determinate indicator and the second value is the buffer
indicator as a floating point value between 0 and 1.

-}
buffered : Float -> Float -> Property m
buffered =
    LinearProgress.buffered


{-| Reverse the indicator.
-}
reversed : Property m
reversed =
    LinearProgress.reversed
