module Material.Slider
    exposing
        ( Property
        , disabled
        , discrete
        , max
        , min
        , onChange
        , onInput
        , step
        , trackMarkers
        , value
        , view
        )

{-| Slider provides an implementation of the Material Design slider component.

Note that vertical sliders and range (multi-thumb) sliders are not supported,
due to their absence from the material design spec.

Slider uses custom `onChage` and `onInput` event handlers.


# Resources

  - [Material Design guidelines: Sliders](https://material.io/guidelines/components/sliders.html)
  - [Demo](https://aforemny.github.io/elm-mdc/slider)


# Example

    import Material.Slider as Slider

    Slider.view Mdc "my-slider" model.mdc
        [ Slider.value 40
        , Slider.onChange Change
        ]
        []


# Usage


## Slider

@docs Property
@docs view
@docs value, min, max
@docs disabled
@docs onChange, onInput
@docs step


## Discrete Slider

@docs discrete
@docs trackMarkers

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Slider.Implementation as Slider
import Material


{-| Properties for Slider options.
-}
type alias Property m =
    Slider.Property m


{-| Slider view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Slider.view


{-| Specify the slider's value.

This will be clamped between `min` and `max`.

-}
value : Float -> Property m
value =
    Slider.value


{-| Specify the minimum value.
-}
min : Int -> Property m
min =
    Slider.min


{-| Specify the maximum value.
-}
max : Int -> Property m
max =
    Slider.max


{-| Make the slider only take integer values.
-}
discrete : Property m
discrete =
    Slider.discrete


{-| Disable the slider.
-}
disabled : Property m
disabled =
    Slider.disabled


{-| Slider `onChange` event listener.
-}
onChange : (Float -> m) -> Property m
onChange =
    Slider.onChange


{-| Slider `onInput` event listener.
-}
onInput : (Float -> m) -> Property m
onInput =
    Slider.onInput


{-| Specify the steps the value will be a multiple of.

For example by specyfing 2 the allowed values will only be 0, 2, 4, 6,
etc. if your initial value is 0. By specifying 0.25 the sequence is 0,
0.25, 0.5, 0.75, 1, 1.25, etc.

Defaults to 1.

This value cannot be changed dynamically.

-}
step : Float -> Property m
step =
    Slider.step


{-| Discrete sliders support display markers on their tracks. A marker is displayed every `step`.
-}
trackMarkers : Property m
trackMarkers =
    Slider.trackMarkers
