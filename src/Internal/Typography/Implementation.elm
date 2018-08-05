module Internal.Typography.Implementation
    exposing
        ( adjustMargin
        , body1
        , body2
        , button
        , caption
        , headline1
        , headline2
        , headline3
        , headline4
        , headline5
        , headline6
        , overline
        , subtitle1
        , subtitle2
        , title
        , typography
        )

import Internal.Options exposing (Property, cs)


typography : Property c m
typography =
    cs "mdc-typography"


title : Property c m
title =
    cs "mdc-typography--title"


headline1 : Property c m
headline1 =
    cs "mdc-typography--headline1"


headline2 : Property c m
headline2 =
    cs "mdc-typography--headline2"


headline3 : Property c m
headline3 =
    cs "mdc-typography--headline3"


headline4 : Property c m
headline4 =
    cs "mdc-typography--headline4"


headline5 : Property c m
headline5 =
    cs "mdc-typography--headline5"


headline6 : Property c m
headline6 =
    cs "mdc-typography--headline6"


subtitle1 : Property c m
subtitle1 =
    cs "mdc-typography--subtitle1"


subtitle2 : Property c m
subtitle2 =
    cs "mdc-typography--subtitle2"


overline : Property c m
overline =
    cs "mdc-typography--overline"


caption : Property c m
caption =
    cs "mdc-typography--caption"


body1 : Property c m
body1 =
    cs "mdc-typography--body1"


body2 : Property c m
body2 =
    cs "mdc-typography--body2"


button : Property c m
button =
    cs "mdc-typography--button"


adjustMargin : Property c m
adjustMargin =
    cs "mdc-typography--adjust-margin"
