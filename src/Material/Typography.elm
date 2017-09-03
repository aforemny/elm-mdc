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


import Material.Options as Options exposing (Property, styled, cs, css)


typography : Property c m
typography =
    cs "mdc-typography"


display1 : Property c m
display1 =
    cs "mdc-typography--display1"


display2 : Property c m
display2 =
    cs "mdc-typography--display2"


display3 : Property c m
display3 =
    cs "mdc-typography--display3"


display4 : Property c m
display4 =
    cs "mdc-typography--display4"


title : Property c m
title =
    cs "mdc-typography--title"


caption : Property c m
caption =
    cs "mdc-typography--caption"


body1 : Property c m
body1 =
    cs "mdc-typography--body1"


body2 : Property c m
body2 =
    cs "mdc-typography--body2"


headline : Property c m
headline =
    cs "mdc-typography--headline"


subheading1 : Property c m
subheading1 =
    cs "mdc-typography--subheading"


subheading2 : Property c m
subheading2 =
    cs "mdc-typography--subheading"


adjustMargin : Property c m
adjustMargin =
    cs "mdc-typography--adjust-margin"
