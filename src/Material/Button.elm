module Material.Button
    exposing
        ( Property
        , dense
        , disabled
        , icon
        , link
        , onClick
        , outlined
        , raised
        , ripple
        , unelevated
        , view
        )

{-| The Button component is a spec-aligned button component adhering to the
Material Design button requirements.


# Resources

  - [Buttons - Internal.Components for the Web](https://material.io/develop/web/components/buttons/)
  - [Material Design guidelines: Buttons](https://material.io/guidelines/components/buttons.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#buttons)


# Example

    import Html exposing (text)
    import Material.Button as Button
    import Material.Options as Options


    Button.view Mdc "my-button" model.mdc
        [ Button.ripple
        , Options.onClick Click
        ]
        [ text "Button"
        ]


# Usage

@docs Property
@docs view
@docs ripple
@docs raised
@docs unelevated
@docs outlined
@docs dense
@docs icon
@docs disabled
@docs link
@docs onClick

-}

import Html exposing (Html)
import Internal.Button.Implementation as Button
import Internal.Component as Component exposing (Index)
import Material


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


{-| Make the button elevated upon the surface.
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
outlined : Property m
outlined =
    Button.outlined


{-| Make button's text slightly smaller.
-}
dense : Property m
dense =
    Button.dense


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


{-| Click handler that respects `ripple`.

The event will be raised only after the ripple animation finished playing. If
the button does not ripple, it is identical to `Options.onClick`.

-}
onClick : m -> Property m
onClick =
    Button.onClick
