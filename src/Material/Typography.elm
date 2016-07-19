module Material.Typography
  exposing
    ( display1
    , display1ColorContrast
    , display2
    , display3
    , display4
    , body1
    , body1ForcePreferred
    , body2
    , body2ForcePreferred
    , body2ColorContrast
    , headline
    , subheading
    , subheadingColorContrast
    , caption
    , captionColorContrast
    , button
    , menu
    , title
    , titleColorContrast
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

Refer to [this site](http://debois.github.io/elm-mdl#/typography)
for a live demo.

# Styles

@docs display1, display1ColorContrast
@docs display2
@docs display3
@docs display4
@docs body1, body1ForcePreferred
@docs body2, body2ForcePreferred, body2ColorContrast
@docs headline
@docs subheading, subheadingColorContrast
@docs caption, captionColorContrast
@docs button
@docs menu
@docs title
@docs titleColorContrast

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

import Material.Options as Options exposing (cs)
import Html
import Html.Attributes as Html


type TextStyle
  = Display4
  | Display3
  | Display2
  | Display1
  | Headline
  | Title
  | Subheading
  | Body2
  | Body1
  | Caption
  | Button
  | Menu


type TextTransform
  = Capitalize
  | Lowercase
  | Uppercase


type TextAlign
  = Center
  | Left
  | Right
  | Justify


alignName : TextAlign -> String
alignName align =
  case align of
    Center ->
      "mdl-typography--text-center"

    Left ->
      "mdl-typography--text-left"

    Right ->
      "mdl-typography--text-right"

    Justify ->
      "mdl-typography--text-justify"


transformName : TextTransform -> String
transformName transform =
  case transform of
    Capitalize ->
      "mdl-typography--text-capitalize"

    Lowercase ->
      "mdl-typography--text-lowercase"

    Uppercase ->
      "mdl-typography--text-uppercase"


styleName : TextStyle -> String
styleName style =
  case style of
    Display4 ->
      "mdl-typography--display-4"

    Display3 ->
      "mdl-typography--display-3"

    Display2 ->
      "mdl-typography--display-2"

    Display1 ->
      "mdl-typography--display-1"

    Headline ->
      "mdl-typography--display-1"

    Title ->
      "mdl-typography--title"

    Subheading ->
      "mdl-typography--subhead"

    Body2 ->
      "mdl-typography--body-2"

    Body1 ->
      "mdl-typography--body-1"

    Caption ->
      "mdl-typography--caption"

    Button ->
      "mdl-typography--button"

    Menu ->
      "mdl-typography--menu"


colorContrast : TextStyle -> String
colorContrast style =
  case style of
    Display1 ->
      "mdl-typography--display-1-color-contrast"

    Body2 ->
      "mdl-typography--body-2-color-contrast"

    Subheading ->
      "mdl-typography--subhead-color-contrast"

    Title ->
      "mdl-typography--title-color-contrast"

    Caption ->
      "mdl-typography--caption-color-contrast"

    -- Should _never_ happen (Can check with Debug.crash)
    _ ->
      ""


forcePreferred : TextStyle -> String
forcePreferred style =
  case style of
    Body1 ->
      "mdl-typography--body-1-force-preferred-font"

    Body2 ->
      "mdl-typography--body-2-force-preferred-font"

    -- Should _never_ happen (Can check with Debug.crash)
    _ ->
      ""



-- Styles


{-| Regular 34px
-}
display1 : Options.Property c m
display1 =
  cs <| styleName Display1


{-| Display with color contrast
-}
display1ColorContrast : Options.Property c m
display1ColorContrast =
  cs <| styleName Display1


{-| Regular 45px
-}
display2 : Options.Property c m
display2 =
  cs <| styleName Display2


{-| Regular 56px
-}
display3 : Options.Property c m
display3 =
  cs <| styleName Display3


{-| Light 112px
-}
display4 : Options.Property c m
display4 =
  cs <| styleName Display4


{-| Regular 24px
-}
headline : Options.Property c m
headline =
  cs <| styleName Headline


{-| Medium 20px
-}
title : Options.Property c m
title =
  cs <| styleName Title


{-| Title with color contrast
-}
titleColorContrast : Options.Property c m
titleColorContrast =
  cs <| colorContrast Title


{-| Regular 16px (Device), Regular 15px (Desktop)
-}
subheading : Options.Property c m
subheading =
  cs <| styleName Subheading


{-| Subhead with color contrast
-}
subheadingColorContrast : Options.Property c m
subheadingColorContrast =
  cs <| colorContrast Subheading


{-| Medium 14px (Device), Medium 13px (Desktop)
-}
body2 : Options.Property c m
body2 =
  cs <| styleName Body2


{-| Medium 14px (Device), Medium 13px (Desktop)
-}
body2ForcePreferred : Options.Property c m
body2ForcePreferred =
  cs <| forcePreferred Body2


{-| Body with color contrast
-}
body2ColorContrast : Options.Property c m
body2ColorContrast =
  cs <| colorContrast Body2


{-| Regular 14px (Device), Regular 13px (Desktop)
-}
body1 : Options.Property c m
body1 =
  cs <| styleName Body1


{-| Regular 14px (Device), Regular 13px (Desktop)
-}
body1ForcePreferred : Options.Property c m
body1ForcePreferred =
  cs <| forcePreferred Body1


{-| Regular 12px
-}
caption : Options.Property c m
caption =
  cs <| styleName Caption


{-| Regular 12px
-}
captionColorContrast : Options.Property c m
captionColorContrast =
  cs <| colorContrast Caption


{-| Medium (All Caps) 14px
-}
button : Options.Property c m
button =
  cs <| styleName Button


{-| Medium 14px (Device), Medium 13px (Desktop)
-}
menu : Options.Property c m
menu =
  cs <| styleName Menu



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
  cs <| alignName Center


{-| Left aligned text
-}
left : Options.Property c m
left =
  cs <| alignName Left


{-| Right aligned text
-}
right : Options.Property c m
right =
  cs <| alignName Right


{-| Justified text
-}
justify : Options.Property c m
justify =
  cs <| alignName Justify



-- Transform


{-| Capitalized text
-}
capitalize : Options.Property c m
capitalize =
  cs <| transformName Capitalize


{-| Lowercased text
-}
lowercase : Options.Property c m
lowercase =
  cs <| transformName Lowercase


{-| Uppercased text
-}
uppercase : Options.Property c m
uppercase =
  cs <| transformName Uppercase
