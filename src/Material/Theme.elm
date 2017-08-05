module Material.Theme exposing
    (
      primary
    , accent

    , primaryBg
    , accentBg
    , background

    , dark

    , textPrimaryOnPrimary
    , textSecondaryOnPrimary
    , textHintOnPrimary
    , textDisabledOnPrimary
    , textIconOnPrimary

    , textPrimaryOnAccent
    , textSecondaryOnAccent
    , textHintOnAccent
    , textDisabledOnAccent
    , textIconOnAccent

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
    )


import Html exposing (Html, text)
import Material.Options exposing (Property, span, cs)


-- THEME


primary : Property c m
primary =
    cs "mdc-theme--primary"


accent : Property c m
accent =
    cs "mdc-theme--accent"


primaryBg : Property c m
primaryBg =
    cs "mdc-theme--primary-bg"


accentBg : Property c m
accentBg =
    cs "mdc-theme--accent-bg"


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


textPrimaryOnAccent : Property c m
textPrimaryOnAccent =
    cs "mdc-theme--text-primary-on-accent"


textSecondaryOnAccent : Property c m
textSecondaryOnAccent =
    cs "mdc-theme--text-secondary-on-accent"


textHintOnAccent : Property c m
textHintOnAccent =
    cs "mdc-theme--text-hint-on-accent"


textDisabledOnAccent : Property c m
textDisabledOnAccent =
    cs "mdc-theme--text-disabled-on-accent"


textIconOnAccent : List (Property c m) -> String -> Html m
textIconOnAccent options icon =
    span
    ( cs "mdc-theme--text-icon-on-accent"
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
