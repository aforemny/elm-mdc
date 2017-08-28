module Material.Theme exposing
    (
      primary
    , secondary
    , primaryLight
    , secondaryLight
    , primaryDark
    , secondaryDark

    , primaryBg
    , secondaryBg
    , primaryLightBg
    , secondaryLightBg
    , primaryDarkBg
    , secondaryDarkBg
    , background

    , textPrimaryOnPrimary
    , textSecondaryOnPrimary
    , textHintOnPrimary
    , textDisabledOnPrimary
    , textIconOnPrimary

    , textPrimaryOnSecondary
    , textSecondaryOnSecondary
    , textHintOnSecondary
    , textDisabledOnSecondary
    , textIconOnSecondary

    , textPrimaryOnBackground
    , textSecondaryOnBackground
    , textHintOnBackground
    , textDisabledOnBackground
    , textIconOnBackground

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

    , dark
    )

{-|
> This color palette comprises primary and secondary colors that can be used
> for illustration or to develop your brand colors.
>
> MDC Theme is a foundational module that themes MDC Web components. The colors
> in this module are derived from three theme colors:
>
> - Primary: the primary color used in your application, applies to a number of UI elements.
> - Secondary: the secondary color used in your application, applies to a number of UI elements. (Previously called “accent”.)
> - Background: the background color for your application, aka the color on top of which your UI is drawn.
>
> and five text styles:

- Primary: used for most text
- Secondary: used for text which is lower in the visual hierarchy
- Hint: used for text hints, such as those in text fields and labels
- Disabled: used for text in disabled components and content
- Icon: used for icons

> A note about Primary and Secondary, don’t confuse primary/secondary color
> with primary/secondary text. The former refers to the primary/secondary theme
> color that is used to establish a visual identity and color many parts of
> your application. The latter refers to the style of text that is most
> prominent (low opacity, high contrast), and used to display most content.

> Some components can change their appearance when in a Dark Theme context, aka
> placed on top of a dark background. There are two ways to specify if a
> component is in a Dark Theme context. The first is to add mdc-theme--dark to
> a container element, which holds the component. The second way is to add
> <component_name>--theme-dark modifier class to the actual component element.
> For example, mdc-button--theme-dark would put the MDC Button in a Dark Theme
> context.

> A note about Dark Theme context, don’t confuse Dark Theme context with a
> component that has a dark color. Dark Theme context means the component sits
> on top of a dark background.

## Design & API Documentation

- [Material Design guidelines: Color](https://material.io/guidelines/style/color.html)
- [Demo](https://aforemny.github.io/elm-mdc/#theme)

# Theme Colors
@docs primary, secondary, primaryLight, secondaryLight, primaryDark, secondaryDark
@docs primaryBg, secondaryBg, primaryLightBg, secondaryLightBg, primaryDarkBg, secondaryDarkBg, background

# Text colors
@docs textPrimaryOnPrimary, textSecondaryOnPrimary, textHintOnPrimary, textDisabledOnPrimary, textIconOnPrimary
@docs textPrimaryOnSecondary, textSecondaryOnSecondary, textHintOnSecondary, textDisabledOnSecondary, textIconOnSecondary
@docs textPrimaryOnBackground, textSecondaryOnBackground, textHintOnBackground, textDisabledOnBackground, textIconOnBackground
@docs textPrimaryOnLight, textSecondaryOnLight, textHintOnLight, textDisabledOnLight, textIconOnLight
@docs textPrimaryOnDark, textSecondaryOnDark, textHintOnDark, textDisabledOnDark, textIconOnDark

# Dark
@docs dark
-}


import Html exposing (Html, text)
import Material.Options exposing (Property, span, cs)


-- THEME


primary : Property c m
primary =
    cs "mdc-theme--primary"


secondary : Property c m
secondary =
    cs "mdc-theme--secondary"


primaryLight : Property c m
primaryLight =
    cs "mdc-theme--primary-light"


secondaryLight : Property c m
secondaryLight =
    cs "mdc-theme--secondary-light"


primaryDark : Property c m
primaryDark =
    cs "mdc-theme--primary-dark"


secondaryDark : Property c m
secondaryDark =
    cs "mdc-theme--secondary-dark"


primaryBg : Property c m
primaryBg =
    cs "mdc-theme--primary-bg"


secondaryBg : Property c m
secondaryBg =
    cs "mdc-theme--secondary-bg"


primaryLightBg : Property c m
primaryLightBg =
    cs "mdc-theme--primary-light-bg"


secondaryLightBg : Property c m
secondaryLightBg =
    cs "mdc-theme--secondary-light-bg"


primaryDarkBg : Property c m
primaryDarkBg =
    cs "mdc-theme--primary-dark-bg"


secondaryDarkBg : Property c m
secondaryDarkBg =
    cs "mdc-theme--secondary-dark-bg"


background : Property c m
background =
    cs "mdc-theme--background"


textPrimaryOnPrimary : Property c m
textPrimaryOnPrimary =
    cs "mdc-theme--text-primary-on-primary"


textSecondaryOnPrimary : Property c m
textSecondaryOnPrimary =
    cs "mdc-theme--text-secondary-on-primary"


textHintOnPrimary : Property c m
textHintOnPrimary =
    cs "mdc-theme--text-hint-on-primary"


textDisabledOnPrimary : Property c m
textDisabledOnPrimary =
    cs "mdc-theme--text-disabled-on-primary"


textIconOnPrimary : List (Property c m) -> String -> Html m
textIconOnPrimary options icon =
    span
    ( cs "mdc-theme--text-icon-on-primary"
    :: cs "material-icons"
    :: options
    )
    [ text icon
    ]


textPrimaryOnSecondary : Property c m
textPrimaryOnSecondary =
    cs "mdc-theme--text-primary-on-secondary"


textSecondaryOnSecondary : Property c m
textSecondaryOnSecondary =
    cs "mdc-theme--text-secondary-on-secondary"


textHintOnSecondary : Property c m
textHintOnSecondary =
    cs "mdc-theme--text-hint-on-secondary"


textDisabledOnSecondary : Property c m
textDisabledOnSecondary =
    cs "mdc-theme--text-disabled-on-secondary"


textIconOnSecondary : List (Property c m) -> String -> Html m
textIconOnSecondary options icon =
    span
    ( cs "mdc-theme--text-icon-on-secondary"
    :: cs "material-icons"
    :: options
    )
    [ text icon
    ]


textPrimaryOnBackground : Property c m
textPrimaryOnBackground =
    cs "mdc-theme--text-primary-on-background"


textSecondaryOnBackground : Property c m
textSecondaryOnBackground =
    cs "mdc-theme--text-secondary-on-background"


textHintOnBackground : Property c m
textHintOnBackground =
    cs "mdc-theme--text-hint-on-background"


textDisabledOnBackground : Property c m
textDisabledOnBackground =
    cs "mdc-theme--text-disabled-on-background"


textIconOnBackground : List (Property c m) -> String -> Html m
textIconOnBackground options icon =
    span
    ( cs "mdc-theme--text-icon-on-background"
    :: cs "material-icons"
    :: options
    )
    [ text icon
    ]


textPrimaryOnLight : Property c m
textPrimaryOnLight =
    cs "mdc-theme--text-primary-on-light"


textSecondaryOnLight : Property c m
textSecondaryOnLight =
    cs "mdc-theme--text-secondary-on-light"


textHintOnLight : Property c m
textHintOnLight =
    cs "mdc-theme--text-hint-on-light"


textDisabledOnLight : Property c m
textDisabledOnLight =
    cs "mdc-theme--text-disabled-on-light"


textIconOnLight : List (Property c m) -> String -> Html m
textIconOnLight options icon =
    span
    ( cs "mdc-theme--text-icon-on-light"
    :: cs "material-icons"
    :: options
    )
    [ text icon
    ]


textPrimaryOnDark : Property c m
textPrimaryOnDark =
    cs "mdc-theme--text-primary-on-dark"


textSecondaryOnDark : Property c m
textSecondaryOnDark =
    cs "mdc-theme--text-secondary-on-dark"


textHintOnDark : Property c m
textHintOnDark =
    cs "mdc-theme--text-hint-on-dark"


textDisabledOnDark : Property c m
textDisabledOnDark =
    cs "mdc-theme--text-disabled-on-dark"


textIconOnDark : List (Property c m) -> String -> Html m
textIconOnDark options icon =
    span
    ( cs "mdc-theme--text-icon-on-dark"
    :: cs "material-icons"
    :: options
    )
    [ text icon
    ]


dark : Property c m
dark =
    cs "mdc-theme--dark"
