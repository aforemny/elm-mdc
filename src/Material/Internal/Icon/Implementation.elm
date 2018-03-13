module Material.Internal.Icon.Implementation exposing
    ( Property
    , size18
    , size24
    , size36
    , size48
    , view
    )

import Html exposing (Html, text)
import Material.Internal.Options as Options exposing (Property, cs, css, styled)


type alias Config =
    {}


defaultConfig : Config
defaultConfig =
    {}


type alias Property m =
    Options.Property Config m


view : List (Property m) -> String -> Html m
view options name =
    styled Html.i (cs "material-icons" :: options) [ text name ]


size18 : Property m
size18 =
    css "font-size" "18px"


size24 : Property m
size24 =
    css "font-size" "24px"


size36 : Property m
size36 =
    css "font-size" "36px"


size48 : Property m
size48 =
    css "font-size" "48px"
