module Material.Typography
    exposing
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
        , headline1
        , headline2
        , headline3
        , headline4
        , headline5
        , headline6
        , overline
        , subheading1
        , subheading2
        , subtitle1
        , subtitle2
        , title
        , typography
        )

{-| Material Design's text sizes and styles were developed to balance content
density and reading comfort under typical usage conditions.


# Resources

  - [Material Design guidelines: Typography](https://material.io/guidelines/style/typography.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#typography)


# Example

    import Html exposing (text)
    import Material.Options exposing (styled)
    import Material.Typography as Typography

    styled Html.div
        [ Typography.typography
        ]
        [ styled Html.h1
              [ Typography.headline1
              ]
              [ text "Big header"
              ]
        ]


# Usage

@docs typography
@docs display4, display3, display2, display1 (deprecated)
@docs headline6, headline5, headline4, headline3, headline2, headline1
@docs headline (deprecated)
@docs title
@docs subtitle2, subtitle1
@docs subheading2, subheading1 (deprecated)
@docs body2, body1
@docs caption
@docs button
@docs overline
@docs adjustMargin

-}

import Internal.Typography.Implementation as Typography
import Material.Options exposing (Property)


{-| Sets the font to Roboto.
-}
typography : Property c m
typography =
    Typography.typography


{-| Sets font properties as Display 1.
Deprecated - use headline1 through headline6
-}
display1 : Property c m
display1 =
    headline1


{-| Sets font properties as Display 2.
Deprecated - use headline1 through headline6
-}
display2 : Property c m
display2 =
    headline2


{-| Sets font properties as Display 3.
Deprecated - use headline1 through headline6
-}
display3 : Property c m
display3 =
    headline3


{-| Sets font properties as Display 4.
Deprecated - use headline1 through headline6
-}
display4 : Property c m
display4 =
    headline4


{-| Sets font properties as Title.
-}
title : Property c m
title =
    Typography.title


{-| Sets font properties as Headline.
Deprecated - use headline1 through headline6
-}
headline : Property c m
headline =
    Typography.headline6


{-| Sets font properties as Headline1.
-}
headline1 : Property c m
headline1 =
    Typography.headline1


{-| Sets font properties as Headline2.
-}
headline2 : Property c m
headline2 =
    Typography.headline2


{-| Sets font properties as Headline3.
-}
headline3 : Property c m
headline3 =
    Typography.headline3


{-| Sets font properties as Headline4.
-}
headline4 : Property c m
headline4 =
    Typography.headline4


{-| Sets font properties as Headline5.
-}
headline5 : Property c m
headline5 =
    Typography.headline5


{-| Sets font properties as Headline6.
-}
headline6 : Property c m
headline6 =
    Typography.headline6


{-| Sets font properties as Subtitle1.
-}
subtitle1 : Property c m
subtitle1 =
    Typography.subtitle1


{-| Sets font properties as Subtitle2.
-}
subtitle2 : Property c m
subtitle2 =
    Typography.subtitle2


{-| Sets font properties as Caption.
-}
caption : Property c m
caption =
    Typography.caption


{-| Sets font properties as Body 1.
-}
body1 : Property c m
body1 =
    Typography.body1


{-| Sets font properties as Body 2.
-}
body2 : Property c m
body2 =
    Typography.body2


{-| Sets font properties as Subheading 1.
Deprecated - use subtitle1 instead
-}
subheading1 : Property c m
subheading1 =
    subtitle1


{-| Sets font properties as Subheading 2.
Deprecated - use subtitle2 instead
-}
subheading2 : Property c m
subheading2 =
    subtitle2


{-| Sets font properties as Overline.
-}
overline : Property c m
overline =
    Typography.overline


{-| Sets font properties as Button.
-}
button : Property c m
button =
    Typography.button


{-| Positions text, used in conjunction with font classes above.

This property will change the margin properties of the element it is applied
to, to align text correctly. It should only be used in a text context; using
this property on UI elements such as buttons may cause them to be positioned
incorrectly.

-}
adjustMargin : Property c m
adjustMargin =
    Typography.adjustMargin
