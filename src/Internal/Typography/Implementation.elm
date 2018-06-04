module Internal.Typography.Implementation exposing
    ( adjustMargin
    , body1
    , body2
    , button
    , caption
    , display1
    , display2
    , display3
    , display4
    , headline
    , subheading1
    , subheading2
    , title
    , typography
    )

import Internal.Options exposing (Property, cs)


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


headline : Property c m
headline =
    cs "mdc-typography--headline"


caption : Property c m
caption =
    cs "mdc-typography--caption"


body1 : Property c m
body1 =
    cs "mdc-typography--body1"


body2 : Property c m
body2 =
    cs "mdc-typography--body2"


subheading1 : Property c m
subheading1 =
    cs "mdc-typography--subheading1"


subheading2 : Property c m
subheading2 =
    cs "mdc-typography--subheading2"


button : Property c m
button =
    cs "mdc-typography--button"


adjustMargin : Property c m
adjustMargin =
    cs "mdc-typography--adjust-margin"
