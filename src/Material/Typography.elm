module Material.Typography exposing (..)

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#Typography-section):

> ...

See also the
[Material Design Specification]([https://www.google.com/design/spec/components/Typography.html).

Refer to [this site](http://debois.github.io/elm-mdl#/Typography)
for a live demo.

@docs Model, model, Msg, update
@docs view

# Component support

@docs Container, Observer, Instance, instance, fwdTypography
-}

-- Typography. Copy this to a file for your component, then update.

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



{- This is only in MDL -}


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


nowrap : String
nowrap =
  "mdl-typography--text-nowrap"


tableStriped : String
tableStriped =
  "mdl-typography--table-striped"


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


display1 : Html.Attribute msg
display1 =
  Html.class <| styleName Display1


display2 : Html.Attribute msg
display2 =
  Html.class <| styleName Display2


display3 : Html.Attribute msg
display3 =
  Html.class <| styleName Display3


display4 : Html.Attribute msg
display4 =
  Html.class <| styleName Display4


headline : Html.Attribute msg
headline =
  Html.class <| styleName Headline


title : Html.Attribute msg
title =
  Html.class <| styleName Title


subheading : Html.Attribute msg
subheading =
  Html.class <| styleName Subheading


body2 : Html.Attribute msg
body2 =
  Html.class <| styleName Body2


body1 : Html.Attribute msg
body1 =
  Html.class <| styleName Body1


caption : Html.Attribute msg
caption =
  Html.class <| styleName Caption


button : Html.Attribute msg
button =
  Html.class <| styleName Button


menu : Html.Attribute msg
menu =
  Html.class <| styleName Menu
