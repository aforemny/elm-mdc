module Material.Icon
    exposing
        ( Property
        , anchor
        , button
        , size18
        , size24
        , size36
        , size48
        , span
        , view
        )

{-| Convenience functions for producing Material Design Icons. Refer to the
[Material Design Icons page](https://google.github.io/material-design-icons),
or skip straight to the [Material Icons Library](https://design.google.com/icons/).

This implementation assumes that you have

```html
<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
```

or an equivalent means of loading the icons in your HTML header.

The icon will have the aria-hidden attribute set to true to ensure
that screen readers produce the correct output when reading this
element.


# Example

    import Material.Icon as Icon


    Icon.view [] "settings"


# Usage

@docs Property
@docs view


## Icon sizes

@docs size18
@docs size24
@docs size36
@docs size48


## Html node

@docs anchor
@docs button
@docs span

-}

import Html exposing (Html)
import Internal.Icon.Implementation as Icon


{-| Icon property.
-}
type alias Property m =
    Icon.Property m


{-| Icon view.

Renders a HTML `i` node by default.

-}
view : List (Property m) -> String -> Html m
view =
    Icon.view


{-| Set icon to have size 18px.
-}
size18 : Property m
size18 =
    Icon.size18


{-| Set icon to have size 24px.
-}
size24 : Property m
size24 =
    Icon.size24


{-| Set icon to have size 36px.
-}
size36 : Property m
size36 =
    Icon.size36


{-| Set icon to have size 48px.
-}
size48 : Property m
size48 =
    Icon.size48


{-| Icon will be a HTML `a` element.
-}
anchor : Property m
anchor =
    Icon.anchor


{-| Icon will be a HTML `button` element.
-}
button : Property m
button =
    Icon.button


{-| Icon will be a HTML `span` element.
-}
span : Property m
span =
    Icon.span
