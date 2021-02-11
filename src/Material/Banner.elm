module Material.Banner exposing
    ( Property
    , actions
    , centered
    , fixed
    , graphicTextWrapper
    , graphic
    , icon
    , stacked
    , primaryAction
    , secondaryAction
    , text
    , view
    )

{-| A banner displays a prominent message and related optional actions.

# Resources

  - [Banner - Material Components for the Web](https://github.com/material-components/material-components-web/tree/master/packages/mdc-banner)
  - [Material Design guidelines: Banners](https://material.io/guidelines/components/banners.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#banners)


# Example

    import Material.Banner as Banner

    Banner.view []
        [ Banner.graphicTextWrapper []
            [ Banner.text [] [ text "There was a problem processing a transaction on your credit card." ]
            ]
        , Banner.actions []
            [ Button.view Mdc
                "primary-action-button"
                model.mdc
                [ Button.ripple
                , Banner.primaryAction
                ]
                [ text "Fix it"
                ]
            ]
        ]


# Usage

@docs Property
@docs view
@docs graphicTextWrapper
@docs actions

# Variants

@docs centered
@docs fixed
@docs stacked

# Text and graphics

@docs text
@docs graphic
@docs icon

# Actions

@docs primaryAction
@docs secondaryAction

-}

import Html exposing (Html)
import Internal.Banner.Implementation as Banner
import Internal.Button.Implementation as Button


{-| Banner property.
-}
type alias Property m =
    Banner.Property m


{-| Banner view.
-}
view : List (Property m) -> List (Html m) -> Html m
view =
    Banner.view


{-| By default, banners are positioned as leading. They can optionally
be displayed centered by using this option.
-}
centered : Property m
centered =
    Banner.centered


{-| When used below top app bars, banners should remain fixed at the
top of the screen. This can be done by using the fixed option.
-}
fixed : Property m
fixed =
    Banner.fixed


{-| On mobile view, banners with long text should have their action(s)
be positioned below the text instead of alongside it. It is usually
better to accomplish this with the Sass mixin, see documentation.
-}
stacked : Property m
stacked =
    Banner.stacked


{-| Wrap the text and graphic elements inside this wrapper.
-}
graphicTextWrapper : List (Property m) -> List (Html m) -> Html m
graphicTextWrapper =
    Banner.graphicTextWrapper


{-| Wrapper for graphic element such as icon.
-}
graphic : List (Property m) -> List (Html m) -> Html m
graphic =
    Banner.graphic


{-| Display a material icon.
-}
icon : String -> Html m
icon =
    Banner.icon


{-| Banner text.
-}
text : List (Property m) -> List (Html m) -> Html m
text =
    Banner.text


{-| Wrap the action buttons inside this element.
-}
actions : List (Property m) -> List (Html m) -> Html m
actions =
    Banner.actions


{-| Banners may have one or two low-emphasis text buttons.
-}
primaryAction : Button.Property m
primaryAction =
    Banner.primaryAction


{-| Add a second low emphasis text button.
-}
secondaryAction : Button.Property m
secondaryAction =
    Banner.secondaryAction
