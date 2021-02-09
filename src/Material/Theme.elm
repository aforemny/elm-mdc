module Material.Theme exposing
    ( primary
    , secondary
    , background
    , surface
    , onPrimary
    , onSecondary
    , onSurface
    , primaryBg
    , secondaryBg
    , textPrimaryOnLight
    , textSecondaryOnLight
    , textHintOnLight
    , textDisabledOnLight
    , textIconOnLight
    , textPrimaryOnDark
    , textSecondaryOnDark
    , textHintOnDark
    , textDisabledOnDark
    , textIconOnDark
    )

{-| Color scheme will only get you 80% of the way to a well-designed app. Inevitably there will be some components that do not work "out of the box". To fix problems with accessibility and design, we suggest you use our Sass mixins, such as `button.filled-accessible()`. For more information, consult the documentation for each component.

Only a very limited number of Material Design color customization
features are supported for non-Sass clients. They are a set of CSS
custom properties, and a set of CSS classes.

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

  - [Material Design guidelines: Color](https://material.io/design/guidelines-overview)
  - [Demo](https://aforemny.github.io/elm-mdc/#theme)


# Usage


## Text color

@docs primary
@docs secondary


## Background colors

@docs background
@docs surface
@docs primaryBg
@docs secondaryBg


## Text colors on specific background colors

@docs onPrimary
@docs onSecondary
@docs onSurface


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


{-| Sets the background color to the theme background color.
-}
background : Property c m
background =
    Theme.background


{-| Sets the surface color to the theme surface color.
-}
surface : Property c m
surface =
    Theme.surface


{-| Sets the text color to the theme on-primary color
-}
onPrimary : Property c m
onPrimary =
    Theme.onPrimary


{-| Sets the text color to the theme on-secondary color.
-}
onSecondary : Property c m
onSecondary =
    Theme.onSecondary


{-| Sets the text color to the theme on-secondary color.
-}
onSurface : Property c m
onSurface =
    Theme.onSurface


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
