module Material.Button exposing
    ( compact
    , dense
    , disabled
    , icon
    , link
    , Property
    , raised
    , ripple
    , stroked
    , unelevated
    , view
    )

{-|
The MDC Button component is a spec-aligned button component adhering to the
Material Design button requirements.


# Resources

- [Material Design guidelines: Buttons](https://material.io/guidelines/components/buttons.html)
- [Demo](https://aforemny.github.io/elm-mdc/#buttons)


# Example

```elm
import Html exposing (text)
import Material.Button as Button
import Material.Options as Options


Button.view Mdc [0] model.mdc
    [ Button.ripple
    , Options.onClick Click
    ]
    [ text "Button"
    ]
```


# Usage

@docs Property
@docs view
@docs ripple
@docs raised
@docs unelevated
@docs stroked
@docs dense
@docs compact
@docs icon
@docs disabled
@docs link
-}

import Html exposing (Html)
import Material
import Material.Component as Component exposing (Index)
import Material.Internal.Button.Implementation as Button


{-| Button property.
-}
type alias Property m =
    Button.Property m


{-| Button view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Button.view


{-| Give the button an icon.
-}
icon : String -> Property m
icon =
    Button.icon


{-| Make the  button elevated upon the surface.
-}
raised : Property m
raised =
    Button.raised


{-| Make the button flush with the surface.
-}
unelevated : Property m
unelevated =
    Button.unelevated


{-| Make the button flush with the surface, but have a visible border.
-}
stroked : Property m
stroked =
    Button.stroked


{-| Make button's text slightly smaller.
-}
dense : Property m
dense =
    Button.dense


{-| Reduce the amount of horizontal padding in the button.
-}
compact : Property m
compact =
    Button.compact


{-| Enable ripple ink effect for the button.
-}
ripple : Property m
ripple =
    Button.ripple


{-| Make the button be an anchor tag instead of a div.
-}
link : String -> Property m
link =
    Button.link


{-| Disable the button.
-}
disabled : Property m
disabled =
    Button.disabled
