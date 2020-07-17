module Material.CircularProgress exposing
  (Property
  , view
  , progress
  , size
  )

{-| The MDC Circular Progress component is a spec-aligned circular
progress indicator component adhering to the [Material Design progress
& activity requirements](https://material.io/go/design-progress-indicators).


# Resources

  - [Progress indicators - Components for the Web](https://material.io/develop/web/components/progress-indicator)
  - [Guidelines](https://material.io/components/progress-indicators)
  - [Demo](https://aforemny.github.io/elm-mdc/#circular-progress)


# Determinate example

    import Html exposing (text)
    import Material.CircularProgress as CircularProgress

    CircularProgress.view
        [ CircularProgress.progress 0.75 ]
        [ ]



# Indeterminate example

    import Html exposing (text)
    import Material.CircularProgress as CircularProgress

    CircularProgress.view
        []
        []


# Usage

@docs Property
@docs view
@docs progress
@docs size

-}

import Html exposing (Html)
import Internal.CircularProgress.Implementation as CircularProgress


{-| CircularProgress property.
-}
type alias Property m =
    CircularProgress.Property m


{-| CircularProgress view.
-}
view : List (Property m) -> List (Html m) -> Html m
view =
    CircularProgress.view


{-| Determinate indicators display how long an operation will take.

The argument is a floating point value between 0 and 1.

-}
progress : Float -> Property m
progress =
    CircularProgress.progress


{-| Set the size of the circle. The default is 48. Common sizes are 36 and 24.
-}
size : Int -> Property m
size =
    CircularProgress.size
