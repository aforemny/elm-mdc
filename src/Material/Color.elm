module Material.Color
    exposing
        ( Hue(..)
        , hues
        , hueName
        , accentHues
        , Shade(..)
        , shades
        , Color
        , color
        , white
        , black
        , primary
        , primaryDark
        , primaryContrast
        , accent
        , accentContrast
        , background
        , text
        , scheme
        )

{-| Material Design color palette.

# Palette

From the
[Material Design Specification](https://www.google.com/design/spec/style/color.html#color-color-palette):

> The color palette starts with primary colors and fills in the spectrum to
> create a complete and usable palette for Android, Web, and iOS. Google suggests
> using the 500 colors as the primary colors in your app and the other colors as
> accents colors.

@docs Color, white, black, Hue, Shade, color

# Color Schemes

From the
[Material Design Specification](https://www.google.com/design/spec/style/color.html#color-color-palette):

> [The Material Design] palette comprises primary and accent colors that can be
> used for illustration or to develop your brand colors. They’ve been designed
> to work harmoniously with each other.  [...] Apps that don’t have existing
> color schemes may select colors from the material design color palette. Limit
> your selection of colors to three hues from the primary palette and one
> accent color from the secondary palette.

The Material Design Lite CSS supports this selection; you choose your primary
and accent colors when loading MDL css; see
`Material.top`. Many components can be instructed to take on one of the four hues
mentioned above; below you'll find `Options` for constructing these scheme-dependent
colors.

@docs primary, primaryDark, primaryContrast, accent, accentContrast

# Options
@docs background, text

# Misc
@docs hues, hueName, accentHues, shades, scheme
-}

import Array exposing (Array)
import String
import Material.Options exposing (..)


-- PALETTE


{-| Color palette.
-}
type Hue
    = Indigo
    | Blue
    | LightBlue
    | Cyan
    | Teal
    | Green
    | LightGreen
    | Lime
    | Yellow
    | Amber
    | Orange
    | Brown
    | BlueGrey
    | Grey
    | DeepOrange
    | Red
    | Pink
    | Purple
    | DeepPurple


{-| Hues as array. Mostly useful for demos.
-}
hues : Array Hue
hues =
    Array.fromList
        [ Indigo
        , Blue
        , LightBlue
        , Cyan
        , Teal
        , Green
        , LightGreen
        , Lime
        , Yellow
        , Amber
        , Orange
        , Brown
        , BlueGrey
        , Grey
        , DeepOrange
        , Red
        , Pink
        , Purple
        , DeepPurple
        ]


{-| Primary hues as array. Mostly useful for demos.
-}
accentHues : Array Hue
accentHues =
    Array.fromList
        [ Indigo
        , Blue
        , LightBlue
        , Cyan
        , Teal
        , Green
        , LightGreen
        , Lime
        , Yellow
        , Amber
        , Orange
        , DeepOrange
        , Red
        , Pink
        , Purple
        , DeepPurple
        ]


{-| Give the MDL CSS name of a color. (Can reasonably be used also for human consumption.)
-}
hueName : Hue -> String
hueName color =
    case color of
        Indigo ->
            "indigo"

        Blue ->
            "blue"

        LightBlue ->
            "light-blue"

        Cyan ->
            "cyan"

        Teal ->
            "teal"

        Green ->
            "green"

        LightGreen ->
            "light-green"

        Lime ->
            "lime"

        Yellow ->
            "yellow"

        Amber ->
            "amber"

        Orange ->
            "orange"

        Brown ->
            "brown"

        BlueGrey ->
            "blue-grey"

        Grey ->
            "grey"

        DeepOrange ->
            "deep-orange"

        Red ->
            "red"

        Pink ->
            "pink"

        Purple ->
            "purple"

        DeepPurple ->
            "deep-purple"


{-|
-}
type Shade
    = S50
    | S100
    | S200
    | S300
    | S400
    | S500
    | S600
    | S700
    | S800
    | S900
    | A100
    | A200
    | A400
    | A700


{-| Shades as array. Mostly useful for demos.
-}
shades : Array Shade
shades =
    Array.fromList
        [ S50
        , S100
        , S200
        , S300
        , S400
        , S500
        , S600
        , S700
        , S800
        , S900
        , A100
        , A200
        , A400
        , A700
        ]


shadeName : Shade -> String
shadeName shade =
    case shade of
        S50 ->
            "50"

        S100 ->
            "100"

        S200 ->
            "200"

        S300 ->
            "300"

        S400 ->
            "400"

        S500 ->
            "500"

        S600 ->
            "600"

        S700 ->
            "700"

        S800 ->
            "800"

        S900 ->
            "900"

        A100 ->
            "A100"

        A200 ->
            "A200"

        A400 ->
            "A400"

        A700 ->
            "A700"



-- COLOR CONSTRUCTORS


{-| Type of colors.
-}
type Color
    = C String


{-| Construct a specific color given a palette base hue and a shade.
-}
color : Hue -> Shade -> Color
color hue shade =
    C (hueName hue ++ "-" ++ shadeName shade)


{-| White color.
-}
white : Color
white =
    C "white"


{-| Black color.
-}
black : Color
black =
    C "black"


{-| Primary color of the theme.
-}
primary : Color
primary =
    C "primary"


{-| Primary color, dark variant.
-}
primaryDark : Color
primaryDark =
    C "primary-dark"


{-| Primary color, contrast variant.
-}
primaryContrast : Color
primaryContrast =
    C "primary-contrast"


{-| Accent color.
-}
accent : Color
accent =
    C "accent"


{-| Accent color, contrast variant.
-}
accentContrast : Color
accentContrast =
    C "accent-contrast"



-- COLOR OPTIONS


{-| Background color.
-}
background : Color -> Property c m
background (C color) =
    cs ("mdl-color--" ++ color)


{-| Text or foreground color.
-}
text : Color -> Property c m
text (C color) =
    cs ("mdl-color-text--" ++ color)



-- SCHEME/CSS SETUP


{-| Given primary and accent base colors, compute name of appropriate MDL .css-file.
(You are not likely to need to call this function.)
-}
scheme : Hue -> Hue -> String
scheme primary accent =
    let
        q =
            String.map
                (\x ->
                    if x == '-' then
                        '_'
                    else
                        x
                )

        cssFile =
            case accent of
                Grey ->
                    ""

                Brown ->
                    ""

                BlueGrey ->
                    ""

                _ ->
                    "." ++ q (hueName primary) ++ "-" ++ q (hueName accent)
    in
        "material" ++ cssFile ++ ".min.css"
