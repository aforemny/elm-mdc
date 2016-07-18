module Material.Typography exposing (..)

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
[Material Design Specification]([https://www.google.com/design/spec/style/typography.html).

Refer to [this site](http://debois.github.io/elm-mdl#/typography)
for a live demo.

@docs Model, model, Msg, update
@docs view

# Component support

@docs Container, Observer, Instance, instance, fwdTypography
-}

-- Typography. Copy this to a file for your component, then update.

import Material.Options as Options
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

    _ ->
      ""


forcePreferred : TextStyle -> String
forcePreferred style =
  case style of
    Body1 ->
      "mdl-typography--body-1-force-preferred-font"

    Body2 ->
      "mdl-typography--body-2-force-preferred-font"

    _ ->
      ""



-- Styles


{-| Regular 34px
-}
display1 : String
display1 =
  styleName Display1


{-| Display with color contrast
-}
display1ColorContrast : String
display1ColorContrast =
  styleName Display1


{-| Regular 45px
-}
display2 : String
display2 =
  styleName Display2


{-| Regular 56px
-}
display3 : String
display3 =
  styleName Display3


{-| Light 112px
-}
display4 : String
display4 =
  styleName Display4


{-| Regular 24px
-}
headline : String
headline =
  styleName Headline


{-| Medium 20px
-}
title : String
title =
  styleName Title


{-| Title with color contrast
-}
titleColorContrast : String
titleColorContrast =
  colorContrast Title


{-| Regular 16px (Device), Regular 15px (Desktop)
-}
subheading : String
subheading =
  styleName Subheading


{-| Subhead with color contrast
-}
subheadingColorContrast : String
subheadingColorContrast =
  colorContrast Subheading


{-| Medium 14px (Device), Medium 13px (Desktop)
-}
body2 : String
body2 =
  styleName Body2


{-| Medium 14px (Device), Medium 13px (Desktop)
-}
body2ForcePreferred : String
body2ForcePreferred =
  forcePreferred Body2


{-| Body with color contrast
-}
body2ColorContrast : String
body2ColorContrast =
  colorContrast Body2


{-| Regular 14px (Device), Regular 13px (Desktop)
-}
body1 : String
body1 =
  styleName Body1


{-| Regular 14px (Device), Regular 13px (Desktop)
-}
body1ForcePreferred : String
body1ForcePreferred =
  forcePreferred Body1


{-| Regular 12px
-}
caption : String
caption =
  styleName Caption


{-| Regular 12px
-}
captionColorContrast : String
captionColorContrast =
  colorContrast Caption


{-| Medium (All Caps) 14px
-}
button : String
button =
  styleName Button


{-| Medium 14px (Device), Medium 13px (Desktop)
-}
menu : String
menu =
  styleName Menu



-- Utility

{-| No wrap text
-}
nowrap : String
nowrap =
  "mdl-typography--text-nowrap"


{-| Striped table
-}
tableStriped : String
tableStriped =
  "mdl-typography--table-striped"


{-| Utility function to combine several classes into a `Html.Attribute msg`
-}
many : List String -> Html.Attribute msg
many classes =
  classes
    |> List.map (\ class -> (class, True))
    |> Html.classList


{-| Utility function to combine several classes into a `Options.Property c m`
-}
many' : List String -> Options.Property c m
many' classes =
  classes
    |> List.map (\ class -> Options.cs class )
    |> Options.many

-- Align


{-| Center aligned text
-}
center : String
center =
  alignName Center


{-| Left aligned text
-}
left : String
left =
  alignName Left


{-| Right aligned text
-}
right : String
right =
  alignName Right


{-| Justified text
-}
justify : String
justify =
  alignName Justify



-- Transform


{-| Capitalized text
-}
capitalize : String
capitalize =
  transformName Capitalize


{-| Lowercased text
-}
lowercase : String
lowercase =
  transformName Lowercase


{-| Uppercased text
-}
uppercase : String
uppercase =
  transformName Uppercase
