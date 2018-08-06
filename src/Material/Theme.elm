module Material.Theme
    exposing
        ( background
        , primary
        , primaryBg
        , primaryDark
        , primaryDarkBg
        , primaryLight
        , primaryLightBg
        , secondary
        , secondaryBg
        , secondaryDark
        , secondaryDarkBg
        , secondaryLight
        , secondaryLightBg
        , textDisabledOnBackground
        , textDisabledOnDark
        , textDisabledOnLight
        , textDisabledOnPrimary
        , textDisabledOnSecondary
        , textHintOnBackground
        , textHintOnDark
        , textHintOnLight
        , textHintOnPrimary
        , textHintOnSecondary
        , textIconOnBackground
        , textIconOnDark
        , textIconOnLight
        , textIconOnPrimary
        , textIconOnSecondary
        , textPrimaryOnBackground
        , textPrimaryOnDark
        , textPrimaryOnLight
        , textPrimaryOnPrimary
        , textPrimaryOnSecondary
        , textSecondaryOnBackground
        , textSecondaryOnDark
        , textSecondaryOnLight
        , textSecondaryOnPrimary
        , textSecondaryOnSecondary
        )

{-| This color palette comprises primary and secondary colors that can be used for
illustration or to develop your brand colors.

The colors in this module are derived from three theme colors:

  - Primary: the primary color used in your application, applies to a number of
    UI elements.
  - Secondary: the secondary color used in your application, applies to a number
    of UI elements. (Previously called "accent".)
  - Background: the background color for your application, aka the color on top
    of which your UI is drawn.

and five text styles:

  - Primary: used for most text
  - Secondary: used for text which is lower in the visual hierarchy
  - Hint: used for text hints, such as those in text fields and labels
  - Disabled: used for text in disabled components and content
  - Icon: used for icons


# Resources

  - [Material Design guidelines: Color](https://material.io/guidelines/style/color.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#theme)


# Usage


## Text color

@docs primary, primaryLight, primaryDark
@docs secondary, secondaryLight, secondaryDark


## Background colors

@docs background
@docs primaryBg, primaryLightBg, primaryDarkBg
@docs secondaryBg, secondaryLightBg, secondaryDarkBg


## Text colors on specific background colors

@docs textPrimaryOnPrimary
@docs textSecondaryOnPrimary
@docs textHintOnPrimary
@docs textDisabledOnPrimary
@docs textIconOnPrimary
@docs textPrimaryOnSecondary
@docs textSecondaryOnSecondary
@docs textHintOnSecondary
@docs textDisabledOnSecondary
@docs textIconOnSecondary
@docs textPrimaryOnBackground
@docs textSecondaryOnBackground
@docs textHintOnBackground
@docs textDisabledOnBackground
@docs textIconOnBackground


## Text colors on generic background colors

@docs textPrimaryOnLight
@docs textSecondaryOnLight
@docs textHintOnLight
@docs textDisabledOnLight
@docs textIconOnLight
@docs textPrimaryOnDark
@docs textSecondaryOnDark
@docs textHintOnDark
@docs textDisabledOnDark
@docs textIconOnDark

-}

import Internal.Theme.Implementation as Theme
import Material.Options exposing (Property)


{-| Sets the text color to the theme primary color.
-}
primary : Property c m
primary =
    Theme.primary


{-| Sets the text color to the theme secondary color.
-}
secondary : Property c m
secondary =
    Theme.secondary


{-| Sets the text color to the theme primary color (light variant).
-}
primaryLight : Property c m
primaryLight =
    Theme.primaryLight


{-| Sets the text color to the theme secondary color (light variant).
-}
secondaryLight : Property c m
secondaryLight =
    Theme.secondaryLight


{-| Sets the text color to the theme primary color (dark variant).
-}
primaryDark : Property c m
primaryDark =
    Theme.primaryDark


{-| Sets the text color to the theme secondary color (dark variant).
-}
secondaryDark : Property c m
secondaryDark =
    Theme.secondaryDark


{-| Sets the background color to the theme primary color.
-}
primaryBg : Property c m
primaryBg =
    Theme.primaryBg


{-| Sets the background color to the theme secondary color.
-}
secondaryBg : Property c m
secondaryBg =
    Theme.secondaryBg


{-| Sets the background color to the theme primary color (light variant).
-}
primaryLightBg : Property c m
primaryLightBg =
    Theme.primaryLightBg


{-| Sets the background color to the theme secondary color (light variant).
-}
secondaryLightBg : Property c m
secondaryLightBg =
    Theme.secondaryLightBg


{-| Sets the background color to the theme primary color (dark variant).
-}
primaryDarkBg : Property c m
primaryDarkBg =
    Theme.primaryDarkBg


{-| Sets the background color to the theme secondary color (dark variant).
-}
secondaryDarkBg : Property c m
secondaryDarkBg =
    Theme.secondaryDarkBg


{-| Sets the background color to the theme background color.
-}
background : Property c m
background =
    Theme.background


{-| Sets text to a suitable color for primary text on top of primary color
background.
-}
textPrimaryOnPrimary : Property c m
textPrimaryOnPrimary =
    Theme.textPrimaryOnPrimary


{-| Sets text to a suitable color for secondary text on top of primary color
background.
-}
textSecondaryOnPrimary : Property c m
textSecondaryOnPrimary =
    Theme.textSecondaryOnPrimary


{-| Sets text to a suitable color for hint text on top of primary color
background.
-}
textHintOnPrimary : Property c m
textHintOnPrimary =
    Theme.textHintOnPrimary


{-| Sets text to a suitable color for disabled text on top of primary color
background.
-}
textDisabledOnPrimary : Property c m
textDisabledOnPrimary =
    Theme.textDisabledOnPrimary


{-| Sets text to a suitable color for icons on top of primary color
background.
-}
textIconOnPrimary : Property c m
textIconOnPrimary =
    Theme.textIconOnPrimary


{-| Sets text to a suitable color for primary text on top of secondary color
background.
-}
textPrimaryOnSecondary : Property c m
textPrimaryOnSecondary =
    Theme.textPrimaryOnSecondary


{-| Sets text to a suitable color for secondary text on top of secondary color
background.
-}
textSecondaryOnSecondary : Property c m
textSecondaryOnSecondary =
    Theme.textSecondaryOnSecondary


{-| Sets text to a suitable color for hint text on top of secondary color
background.
-}
textHintOnSecondary : Property c m
textHintOnSecondary =
    Theme.textHintOnSecondary


{-| Sets text to a suitable color for disabled text on top of secondary color
background.
-}
textDisabledOnSecondary : Property c m
textDisabledOnSecondary =
    Theme.textDisabledOnSecondary


{-| Sets text to a suitable color for icons on top of secondary color
background.
-}
textIconOnSecondary : Property c m
textIconOnSecondary =
    Theme.textIconOnSecondary


{-| Sets text to a suitable color for primary text on top of background.
-}
textPrimaryOnBackground : Property c m
textPrimaryOnBackground =
    Theme.textPrimaryOnBackground


{-| Sets text to a suitable color for secondary text on top of background.
-}
textSecondaryOnBackground : Property c m
textSecondaryOnBackground =
    Theme.textSecondaryOnBackground


{-| Sets text to a suitable color for hint text on top of background.
-}
textHintOnBackground : Property c m
textHintOnBackground =
    Theme.textHintOnBackground


{-| Sets text to a suitable color for disabled text on top of background.
-}
textDisabledOnBackground : Property c m
textDisabledOnBackground =
    Theme.textDisabledOnBackground


{-| Sets text to a suitable color for icons on top of background.
-}
textIconOnBackground : Property c m
textIconOnBackground =
    Theme.textIconOnBackground


{-| Sets text to a suitable color for primary text on top of light background.
-}
textPrimaryOnLight : Property c m
textPrimaryOnLight =
    Theme.textPrimaryOnLight


{-| Sets text to a suitable color for secondary text on top of light
background.
-}
textSecondaryOnLight : Property c m
textSecondaryOnLight =
    Theme.textSecondaryOnLight


{-| Sets text to a suitable color for hint text on top of light background.
-}
textHintOnLight : Property c m
textHintOnLight =
    Theme.textHintOnLight


{-| Sets text to a suitable color for disabled text on top of light background.
-}
textDisabledOnLight : Property c m
textDisabledOnLight =
    Theme.textDisabledOnLight


{-| Sets text to a suitable color for icons on top of light background.
-}
textIconOnLight : Property c m
textIconOnLight =
    Theme.textIconOnLight


{-| Sets text to a suitable color for primary text on top of dark background.
-}
textPrimaryOnDark : Property c m
textPrimaryOnDark =
    Theme.textPrimaryOnDark


{-| Sets text to a suitable color for secondary text on top of dark background.
-}
textSecondaryOnDark : Property c m
textSecondaryOnDark =
    Theme.textSecondaryOnDark


{-| Sets text to a suitable color for hint text on top of dark background.
-}
textHintOnDark : Property c m
textHintOnDark =
    Theme.textHintOnDark


{-| Sets text to a suitable color for disabled text on top of dark background.
-}
textDisabledOnDark : Property c m
textDisabledOnDark =
    Theme.textDisabledOnDark


{-| Sets text to a suitable color for icons on top of dark background.
-}
textIconOnDark : Property c m
textIconOnDark =
    Theme.textIconOnDark
