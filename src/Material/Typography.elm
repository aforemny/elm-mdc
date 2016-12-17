module Material.Typography
    exposing
        ( display1
        , display2
        , display3
        , display4
        , body1
        , body2
        , headline
        , subhead
        , caption
        , button
        , menu
        , title
        , contrast
        , capitalize
        , lowercase
        , uppercase
        , left
        , center
        , right
        , justify
        , nowrap
        , tableStriped
        )

{-| From the [Material Design Lite documentation](https://github.com/google/material-design-lite/tree/mdl-1.x/src/typography#introduction):

> The Material Design Lite (MDL) typography component is a comprehensive approach
> to standardizing the use of typefaces in applications and page displays. MDL
> typography elements are intended to replace the myriad fonts used by developers
> (which vary significantly in appearance) and provide a robust, uniform library
> of text styles from which developers can choose.
>
> The "Roboto" typeface is the standard for MDL display; it can easily be
> integrated into a web page using the CSS3 @font-face rule. However, Roboto is
> most simply accessed and included using a single standard HTML <link> element,
> which can be obtained at this Google fonts page.
>
> Because of the many possible variations in font display characteristics in HTML
> and CSS, MDL typography aims to provide simple and intuitive styles that use the
> Roboto font and produce visually attractive and internally consistent text
> results. See the typography component's [Material Design specifications](https://material.google.com/style/typography.html) page for
> details.

See also the
[Material Design Specification](https://www.google.com/design/spec/style/typography.html).

Refer to [this site](http://debois.github.io/elm-mdl/#typography)
for a live demo.

# Styles

The [Material Design
specification](https://material.google.com/style/typography.html#typography-other-typographic-guidelines)
stipulates that typography has particular color contrast. The styles in this
file gives correct contrast for black and white only; for colored typography or backgrounds, use the
`contrast` option to regulate color contrast.


@docs display1
@docs display2
@docs display3
@docs display4
@docs body1
@docs body2
@docs headline
@docs title
@docs subhead
@docs caption
@docs button
@docs menu

## Color contrast
@docs contrast

# Transforms
@docs capitalize
@docs lowercase
@docs uppercase

# Alignment
@docs left
@docs center
@docs right
@docs justify

# Utility
@docs nowrap
@docs tableStriped

-}

import Material.Options as Options exposing (cs, css)


{- The material specification requires many typographic elements to have
   particular color contrasts. MDL implements this by having both a default style
   (e.g., `mdl-typography--display-1`) and one with reduced contrast adhering to
   the spec when drawn black on white (e.g.,
   `mdl-typography--display-1-color-contrast`). The latter are implemented
   exclusively by setting opacity (e.g., `opacity: 0.54`).

   We achieve a nicer API not duplicating every stylename by inversion: The
   default `display1` style is drawn at `opacity: 0.54`; you can override it by
   adding a `contrast` style.
-}
-- Styles


{-| Regular 34px
-}
display1 : Options.Property c m
display1 =
    cs "mdl-typography--display-1-color-contrast"


{-| Regular 45px
-}
display2 : Options.Property c m
display2 =
    cs "mdl-typography--display-2-color-contrast"


{-| Regular 56px
-}
display3 : Options.Property c m
display3 =
    cs "mdl-typography--display-3-color-contrast"


{-| Light 112px
-}
display4 : Options.Property c m
display4 =
    cs "mdl-typography--display-4-color-contrast"


{-| Regular 24px
-}
headline : Options.Property c m
headline =
    cs "mdl-typography--headline-color-contrast"


{-| Medium 20px
-}
title : Options.Property c m
title =
    cs "mdl-typography--title-color-contrast"


{-| Regular 16px (Device), Regular 15px (Desktop)
-}
subhead : Options.Property c m
subhead =
    cs "mdl-typography--subhead-color-contrast"


{-| Regular 14px (Device), Regular 13px (Desktop)
-}
body1 : Options.Property c m
body1 =
    cs "mdl-typography--body-1-force-preferred-font-color-contrast"


{-| Medium 14px (Device), Medium 13px (Desktop)
-}
body2 : Options.Property c m
body2 =
    cs "mdl-typography--body-2-force-preferred-font-color-contrast"


{-| Regular 12px
-}
caption : Options.Property c m
caption =
    cs "mdl-typography--caption-force-preferred-font-color-contrast"


{-| Medium (All Caps) 14px
-}
button : Options.Property c m
button =
    cs "mdl-typography--button-color-contrast"


{-| Medium 14px (Device), Medium 13px (Desktop)
-}
menu : Options.Property c m
menu =
    cs "mdl-typography--menu-color-contrast"



-- Modifiers


{-| Modify contrast of typography. Implemented under the hood by setting CSS
`opacity`.
-}
contrast : Float -> Options.Property c m
contrast x =
    css "opacity" (toString x)



-- Utility


{-| No wrap text
-}
nowrap : Options.Property c m
nowrap =
    cs "mdl-typography--text-nowrap"


{-| Striped table
-}
tableStriped : Options.Property c m
tableStriped =
    cs "mdl-typography--table-striped"



-- Align


{-| Center aligned text
-}
center : Options.Property c m
center =
    cs "mdl-typography--text-center"


{-| Left aligned text
-}
left : Options.Property c m
left =
    cs "mdl-typography--text-left"


{-| Right aligned text
-}
right : Options.Property c m
right =
    cs "mdl-typography--text-right"


{-| Justified text
-}
justify : Options.Property c m
justify =
    cs "mdl-typography--text-justify"



-- Transform


{-| Capitalized text
-}
capitalize : Options.Property c m
capitalize =
    cs "mdl-typography--text-capitalize"


{-| Lowercased text
-}
lowercase : Options.Property c m
lowercase =
    cs "mdl-typography--text-lowercase"


{-| Uppercased text
-}
uppercase : Options.Property c m
uppercase =
    cs "mdl-typography--text-uppercase"
