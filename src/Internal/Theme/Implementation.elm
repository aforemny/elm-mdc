module Internal.Theme.Implementation exposing
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

import Internal.Options exposing (Property, cs)


primary : Property c m
primary =
    cs "mdc-theme--primary"


secondary : Property c m
secondary =
    cs "mdc-theme--secondary"


background : Property c m
background =
    cs "mdc-theme--background"


surface : Property c m
surface =
    cs "mdc-theme--surface"


onPrimary : Property c m
onPrimary =
    cs "mdc-theme--on-primary"


onSecondary : Property c m
onSecondary =
    cs "mdc-theme--on-secondary"


onSurface : Property c m
onSurface =
    cs "mdc-theme--on-surface"


primaryBg : Property c m
primaryBg =
    cs "mdc-theme--primary-bg"


secondaryBg : Property c m
secondaryBg =
    cs "mdc-theme--secondary-bg"


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
