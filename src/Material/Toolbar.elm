module Material.Toolbar exposing
    ( view
    , fixed
    , waterfall
    , flexible
    , flexibleDefaultBehavior
    , flexibleSpaceMaximized
    , icon
    , icon_
    , menu
    , title
    , row
    , section
    , alignStart
    , alignEnd
    , fixedAdjust
    )


import Html exposing (Html, text)
import Material.Options exposing (Style, styled, cs)


view : List (Style m) -> List (Html m) -> Html m
view options =
    styled Html.header
    ( cs "mdc-toolbar"
    :: options
    )


fixed : Style m
fixed =
    cs "mdc-toolbar--fixed"


waterfall : Style m
waterfall =
    cs "mdc-toolbar--waterfall"


flexible : Style m
flexible =
    cs "mdc-toolbar--flexible"


flexibleDefaultBehavior : Style m
flexibleDefaultBehavior =
    cs "mdc-toolbar--flexible-default-behavior"


flexibleSpaceMaximized : Style m
flexibleSpaceMaximized =
    cs "mdc-toolbar--flexible-space-maximized"


icon : List (Style m) -> String -> Html m
icon options icon =
    styled Html.div
    ( cs "mdc-toolbar__icon"
    :: cs "material-icons"
    :: options
    )
    [ text icon
    ]


icon_ : List (Style m) -> List (Html m) -> Html m
icon_ options =
    styled Html.div
    ( cs "mdc-toolbar__icon"
    :: cs "material-icons"
    :: options
    )


menu : Style m
menu =
    cs "mdc-toolbar__icon--menu"


title : List (Style m) -> List (Html m) -> Html m
title options =
    styled Html.span
    ( cs "mdc-toolbar__title"
    :: options
    )


row : List (Style m) -> List (Html m) -> Html m
row options =
    styled Html.div
    ( cs "mdc-toolbar__row"
    :: options
    )


section : List (Style m) -> List (Html m) -> Html m
section options =
    styled Html.section
    ( cs "mdc-toolbar__section"
    :: options
    )


alignStart : Style m
alignStart =
    cs "mdc-toolbar__section--align-start"


alignEnd : Style m
alignEnd =
    cs "mdc-toolbar__section--align-end"


fixedAdjust : Style m
fixedAdjust =
    cs "mdc-toolbar-fixed-adjust"
