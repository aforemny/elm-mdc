module Material.Slider exposing
    ( disabled
    , discrete
    , max
    , min
    , onChange
    , onInput
    , Property
    , steps
    , trackMarkers
    , value
    , view
    )

{-|
Slider provides an implementation of the Material Design slider component.

Note that vertical sliders and range (multi-thumb) sliders are not supported,
due to their absence from the material design spec.

Slider uses custom `onChage` and `onInput` event handlers.


# Resources

- [Material Design guidelines: Sliders](https://material.io/guidelines/components/sliders.html)
- [Demo](https://aforemny.github.io/elm-mdc/slider)


# Example

```elm
import Material.Slider as Slider

Slider.view Mdc [0] model.mdc
    [ Slider.value 40
    , Slider.onChange Change
    ]
    []
```


# Usage


## Slider

@docs Property
@docs view
@docs value, min, max
@docs disabled
@docs onChange, onInput

## Discrete Slider

@docs discrete
@docs steps
@docs trackMarkers
-}

import Html exposing (Html)
import Material.Component exposing (Indexed, Index)
import Material.Internal.Slider.Implementation as Slider
import Material.Msg


{-| Properties for Slider options.
-}
type alias Property m =
    Slider.Property m


type alias Store s =
    { s | slider : Indexed Slider.Model }


{-| Slider view.
-}
view :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
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


{-| Specify a number of steps that value will be a multiple of.

Defaults to 1.
-}
steps : Int -> Property m
steps =
    Slider.steps


{-| Add track markers to the Slider every `step`.
-}
trackMarkers : Property m
trackMarkers =
    Slider.trackMarkers
