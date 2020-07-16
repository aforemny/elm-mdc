module Material.CircularProgress exposing
  (Property
  , view
  , progress
  )

{-| The MDC Circular Progress component is a spec-aligned circular
progress indicator component adhering to the [Material Design progress
& activity requirements](https://material.io/go/design-progress-indicators).


# Resources

  - [Progress indicators - Components for the Web](https://material.io/develop/web/components/progress-indicator)
  - [Guidelines](https://material.io/components/progress-indicators)
  - [Demo](https://aforemny.github.io/elm-mdc/#circular-progress)


# Example

    import Html exposing (text)
    import Material.CircularProgress as CircularProgress
    import Material.Options as Options

    CircularProgress.view Mdc "my-progress" model.mdc
        []
        [ text "Chip"
        ]


# Usage

@docs Property
@docs view

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

