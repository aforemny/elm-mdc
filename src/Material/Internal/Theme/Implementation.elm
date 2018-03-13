module Material.Internal.Theme.Implementation exposing
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

{-|
This color palette comprises primary and secondary colors that can be used for
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

import Material.Internal.Options exposing (Property, cs)


{-| Sets the text color to the theme primary color.
-}
primary : Property c m
primary =
    cs "mdc-theme--primary"


{-| Sets the text color to the theme secondary color.
-}
secondary : Property c m
secondary =
    cs "mdc-theme--secondary"


{-| Sets the text color to the theme primary color (light variant).
-}
primaryLight : Property c m
primaryLight =
    cs "mdc-theme--primary-light"


{-| Sets the text color to the theme secondary color (light variant).
-}
secondaryLight : Property c m
secondaryLight =
    cs "mdc-theme--secondary-light"


{-| Sets the text color to the theme primary color (dark variant).
-}
primaryDark : Property c m
primaryDark =
    cs "mdc-theme--primary-dark"


{-| Sets the text color to the theme secondary color (dark variant).
-}
secondaryDark : Property c m
secondaryDark =
    cs "mdc-theme--secondary-dark"


{-| Sets the background color to the theme primary color.
-}
primaryBg : Property c m
primaryBg =
    cs "mdc-theme--primary-bg"


{-| Sets the background color to the theme secondary color.
-}
secondaryBg : Property c m
secondaryBg =
    cs "mdc-theme--secondary-bg"


{-| Sets the background color to the theme primary color (light variant).
-}
primaryLightBg : Property c m
primaryLightBg =
    cs "mdc-theme--primary-light-bg"


{-| Sets the background color to the theme secondary color (light variant).
-}
secondaryLightBg : Property c m
secondaryLightBg =
    cs "mdc-theme--secondary-light-bg"


{-| Sets the background color to the theme primary color (dark variant).
-}
primaryDarkBg : Property c m
primaryDarkBg =
    cs "mdc-theme--primary-dark-bg"


{-| Sets the background color to the theme secondary color (dark variant).
-}
secondaryDarkBg : Property c m
secondaryDarkBg =
    cs "mdc-theme--secondary-dark-bg"


{-| Sets the background color to the theme background color.
-}
background : Property c m
background =
    cs "mdc-theme--background"


{-| Sets text to a suitable color for primary text on top of primary color
background.
-}
textPrimaryOnPrimary : Property c m
textPrimaryOnPrimary =
    cs "mdc-theme--text-primary-on-primary"


{-| Sets text to a suitable color for secondary text on top of primary color
background.
-}
textSecondaryOnPrimary : Property c m
textSecondaryOnPrimary =
    cs "mdc-theme--text-secondary-on-primary"


{-| Sets text to a suitable color for hint text on top of primary color
background.
-}
textHintOnPrimary : Property c m
textHintOnPrimary =
    cs "mdc-theme--text-hint-on-primary"


{-| Sets text to a suitable color for disabled text on top of primary color
background.
-}
textDisabledOnPrimary : Property c m
textDisabledOnPrimary =
    cs "mdc-theme--text-disabled-on-primary"


{-| Sets text to a suitable color for icons on top of primary color
background.
-}
textIconOnPrimary : Property c m
textIconOnPrimary =
    cs "mdc-theme--text-icon-on-primary"


{-| Sets text to a suitable color for primary text on top of secondary color
background.
-}
textPrimaryOnSecondary : Property c m
textPrimaryOnSecondary =
    cs "mdc-theme--text-primary-on-secondary"


{-| Sets text to a suitable color for secondary text on top of secondary color
background.
-}
textSecondaryOnSecondary : Property c m
textSecondaryOnSecondary =
    cs "mdc-theme--text-secondary-on-secondary"


{-| Sets text to a suitable color for hint text on top of secondary color
background.
-}
textHintOnSecondary : Property c m
textHintOnSecondary =
    cs "mdc-theme--text-hint-on-secondary"


{-| Sets text to a suitable color for disabled text on top of secondary color
background.
-}
textDisabledOnSecondary : Property c m
textDisabledOnSecondary =
    cs "mdc-theme--text-disabled-on-secondary"


{-| Sets text to a suitable color for icons on top of secondary color
background.
-}
textIconOnSecondary : Property c m
textIconOnSecondary =
    cs "mdc-theme--text-icon-on-secondary"


{-| Sets text to a suitable color for primary text on top of background.
-}
textPrimaryOnBackground : Property c m
textPrimaryOnBackground =
    cs "mdc-theme--text-primary-on-background"


{-| Sets text to a suitable color for secondary text on top of background.
-}
textSecondaryOnBackground : Property c m
textSecondaryOnBackground =
    cs "mdc-theme--text-secondary-on-background"


{-| Sets text to a suitable color for hint text on top of background.
-}
textHintOnBackground : Property c m
textHintOnBackground =
    cs "mdc-theme--text-hint-on-background"


{-| Sets text to a suitable color for disabled text on top of background.
-}
textDisabledOnBackground : Property c m
textDisabledOnBackground =
    cs "mdc-theme--text-disabled-on-background"


{-| Sets text to a suitable color for icons on top of background.
-}
textIconOnBackground : Property c m
textIconOnBackground =
    cs "mdc-theme--text-icon-on-background"


{-| Sets text to a suitable color for primary text on top of light background.
-}
textPrimaryOnLight : Property c m
textPrimaryOnLight =
    cs "mdc-theme--text-primary-on-light"


{-| Sets text to a suitable color for secondary text on top of light
background.
-}
textSecondaryOnLight : Property c m
textSecondaryOnLight =
    cs "mdc-theme--text-secondary-on-light"


{-| Sets text to a suitable color for hint text on top of light background.
-}
textHintOnLight : Property c m
textHintOnLight =
    cs "mdc-theme--text-hint-on-light"


{-| Sets text to a suitable color for disabled text on top of light background.
-}
textDisabledOnLight : Property c m
textDisabledOnLight =
    cs "mdc-theme--text-disabled-on-light"


{-| Sets text to a suitable color for icons on top of light background.
-}
textIconOnLight : Property c m
textIconOnLight =
    cs "mdc-theme--text-icon-on-light"


{-| Sets text to a suitable color for primary text on top of dark background.
-}
textPrimaryOnDark : Property c m
textPrimaryOnDark =
    cs "mdc-theme--text-primary-on-dark"


{-| Sets text to a suitable color for secondary text on top of dark background.
-}
textSecondaryOnDark : Property c m
textSecondaryOnDark =
    cs "mdc-theme--text-secondary-on-dark"


{-| Sets text to a suitable color for hint text on top of dark background.
-}
textHintOnDark : Property c m
textHintOnDark =
    cs "mdc-theme--text-hint-on-dark"


{-| Sets text to a suitable color for disabled text on top of dark background.
-}
textDisabledOnDark : Property c m
textDisabledOnDark =
    cs "mdc-theme--text-disabled-on-dark"


{-| Sets text to a suitable color for icons on top of dark background.
-}
textIconOnDark : Property c m
textIconOnDark =
    cs "mdc-theme--text-icon-on-dark"
