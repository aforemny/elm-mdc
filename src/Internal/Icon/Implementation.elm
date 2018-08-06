module Internal.Icon.Implementation
    exposing
        ( Property
        , anchor
        , button
        , size18
        , size24
        , size36
        , size48
        , span
        , view
        )

import Html exposing (Html, text)
import Internal.Options as Options exposing (Property, cs, css, styled)


type alias Config =
    { node : String
    }


defaultConfig : Config
defaultConfig =
    { node = "i"
    }


type alias Property m =
    Options.Property Config m


view : List (Property m) -> String -> Html m
view options name =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        (Html.node config.node)
        [ cs "material-icons"
        , Options.aria "hidden" "true"
        ]
        []
        [ text name ]


node : String -> Property m
node ctor =
    Options.option (\config -> { config | node = ctor })


anchor : Property m
anchor =
    node "a"


button : Property m
button =
    node "button"


span : Property m
span =
    node "span"


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
