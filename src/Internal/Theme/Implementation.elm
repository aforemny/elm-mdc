module Internal.Theme.Implementation
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

import Internal.Options exposing (Property, cs)


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


textIconOnPrimary : Property c m
textIconOnPrimary =
    cs "mdc-theme--text-icon-on-primary"


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


textIconOnSecondary : Property c m
textIconOnSecondary =
    cs "mdc-theme--text-icon-on-secondary"


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


textIconOnBackground : Property c m
textIconOnBackground =
    cs "mdc-theme--text-icon-on-background"


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


textIconOnLight : Property c m
textIconOnLight =
    cs "mdc-theme--text-icon-on-light"


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


textIconOnDark : Property c m
textIconOnDark =
    cs "mdc-theme--text-icon-on-dark"
