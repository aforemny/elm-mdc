module Material.Typography
    exposing
        ( typography
        , title
        , caption
        , body1
        , body2
        , headline
        , subheading1
        , subheading2
        , display1
        , display2
        , display3
        , display4
        , adjustMargin
        )


import Material.Options as Options exposing (Style, styled, cs, css)


-- TYPOGRPAHY


typography : Style m
typography =
    cs "mdc-typography"


display1 : Style m
display1 =
    cs "mdc-typography--display1"


display2 : Style m
display2 =
    cs "mdc-typography--display2"


display3 : Style m
display3 =
    cs "mdc-typography--display3"


display4 : Style m
display4 =
    cs "mdc-typography--display4"


title : Style m
title =
    cs "mdc-typography--title"


caption : Style m
caption =
    cs "mdc-typography--caption"


body1 : Style m
body1 =
    cs "mdc-typography--body1"


body2 : Style m
body2 =
    cs "mdc-typography--body2"


headline : Style m
headline =
    cs "mdc-typography--headline"


subheading1 : Style m
subheading1 =
    cs "mdc-typography--subheading"


subheading2 : Style m
subheading2 =
    cs "mdc-typography--subheading"


adjustMargin : Style m
adjustMargin =
    cs "mdc-typography--adjust-margin"
