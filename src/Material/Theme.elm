module Material.Theme exposing
    (
      primary
    , accent

    , primaryBg
    , accentBg
    , background

    , typography
    , display1
    , title
    , body2

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
import Material.Options exposing (Style, span, cs)


-- THEME


primary : Style m
primary =
    cs "mdc-theme--primary"


accent : Style m
accent =
    cs "mdc-theme--accent"


primaryBg : Style m
primaryBg =
    cs "mdc-theme--primary-bg"


accentBg : Style m
accentBg =
    cs "mdc-theme--accent-bg"


background : Style m
background =
    cs "mdc-theme--background"


textPrimaryOnPrimary : Style m
textPrimaryOnPrimary =
    cs "mdc-theme--text-primary-on-primary"


textSecondaryOnPrimary : Style m
textSecondaryOnPrimary =
    cs "mdc-theme--text-secondary-on-primary"


textHintOnPrimary : Style m
textHintOnPrimary =
    cs "mdc-theme--text-hint-on-primary"


textDisabledOnPrimary : Style m
textDisabledOnPrimary =
    cs "mdc-theme--text-disabled-on-primary"


textIconOnPrimary : List (Style m) -> String -> Html m
textIconOnPrimary options icon =
    span
    ( cs "mdc-theme--text-icon-on-primary"
    :: cs "material-icons"
    :: options
    )
    [ text icon
    ]


textPrimaryOnAccent : Style m
textPrimaryOnAccent =
    cs "mdc-theme--text-primary-on-accent"


textSecondaryOnAccent : Style m
textSecondaryOnAccent =
    cs "mdc-theme--text-secondary-on-accent"


textHintOnAccent : Style m
textHintOnAccent =
    cs "mdc-theme--text-hint-on-accent"


textDisabledOnAccent : Style m
textDisabledOnAccent =
    cs "mdc-theme--text-disabled-on-accent"


textIconOnAccent : List (Style m) -> String -> Html m
textIconOnAccent options icon =
    span
    ( cs "mdc-theme--text-icon-on-accent"
    :: cs "material-icons"
    :: options
    )
    [ text icon
    ]


textPrimaryOnBackground : Style m
textPrimaryOnBackground =
    cs "mdc-theme--text-primary-on-background"


textSecondaryOnBackground : Style m
textSecondaryOnBackground =
    cs "mdc-theme--text-secondary-on-background"


textHintOnBackground : Style m
textHintOnBackground =
    cs "mdc-theme--text-hint-on-background"


textDisabledOnBackground : Style m
textDisabledOnBackground =
    cs "mdc-theme--text-disabled-on-background"


textIconOnBackground : List (Style m) -> String -> Html m
textIconOnBackground options icon =
    span
    ( cs "mdc-theme--text-icon-on-background"
    :: cs "material-icons"
    :: options
    )
    [ text icon
    ]


textPrimaryOnLight : Style m
textPrimaryOnLight =
    cs "mdc-theme--text-primary-on-light"


textSecondaryOnLight : Style m
textSecondaryOnLight =
    cs "mdc-theme--text-secondary-on-light"


textHintOnLight : Style m
textHintOnLight =
    cs "mdc-theme--text-hint-on-light"


textDisabledOnLight : Style m
textDisabledOnLight =
    cs "mdc-theme--text-disabled-on-light"


textIconOnLight : List (Style m) -> String -> Html m
textIconOnLight options icon =
    span
    ( cs "mdc-theme--text-icon-on-light"
    :: cs "material-icons"
    :: options
    )
    [ text icon
    ]


textPrimaryOnDark : Style m
textPrimaryOnDark =
    cs "mdc-theme--text-primary-on-dark"


textSecondaryOnDark : Style m
textSecondaryOnDark =
    cs "mdc-theme--text-secondary-on-dark"


textHintOnDark : Style m
textHintOnDark =
    cs "mdc-theme--text-hint-on-dark"


textDisabledOnDark : Style m
textDisabledOnDark =
    cs "mdc-theme--text-disabled-on-dark"


textIconOnDark : List (Style m) -> String -> Html m
textIconOnDark options icon =
    span
    ( cs "mdc-theme--text-icon-on-dark"
    :: cs "material-icons"
    :: options
    )
    [ text icon
    ]


-- TYPOGRPAHY


typography : Style m
typography =
    cs "mdc-typography"


display1 : Style m
display1 =
    cs "mdc-typography--display1"


title : Style m
title =
    cs "mdc-typography--title"


body2 : Style m
body2 =
    cs "mdc-typography--body2"
