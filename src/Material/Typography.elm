module Material.Typography exposing
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


{-|
Material Design's text sizes and styles were developed to balance content
density and reading comfort under typical usage conditions.


# Resources

- [Material Design guidelines: Typography](https://material.io/guidelines/style/typography.html)
- [Demo](https://aforemny.github.io/elm-mdc/#typography)


# Example

```
import Html exposing (text)
import Material.Options exposing (styled)
import Material.Typography as Typography

styled Html.div
    [ Typography.typography
    ]
    [ styled Html.h1
          [ Typography.display4
          ]
          [ text "Big header"
          ]
    ]
```


# Usage

@docs typography
@docs display4, display3, display2, display1
@docs headline
@docs title
@docs subheading2, subheading1
@docs body2, body1
@docs caption
@docs button
@docs adjustMargin
-}


import Material.Options exposing (Property)
import Internal.Typography.Implementation as Typography


{-| Sets the font to Roboto.
-}
typography : Property c m
typography =
    Typography.typography


{-| Sets font properties as Display 1.
-}
display1 : Property c m
display1 =
    Typography.display1


{-| Sets font properties as Display 2.
-}
display2 : Property c m
display2 =
    Typography.display2


{-| Sets font properties as Display 3.
-}
display3 : Property c m
display3 =
    Typography.display3


{-| Sets font properties as Display 4.
-}
display4 : Property c m
display4 =
    Typography.display4


{-| Sets font properties as Title.
-}
title : Property c m
title =
    Typography.title


{-| Sets font properties as Headline.
-}
headline : Property c m
headline =
    Typography.headline


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
-}
subheading1 : Property c m
subheading1 =
    Typography.subheading1


{-| Sets font properties as Subheading 2.
-}
subheading2 : Property c m
subheading2 =
    Typography.subheading2


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
