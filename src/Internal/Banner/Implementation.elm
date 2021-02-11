module Internal.Banner.Implementation exposing
    ( Property
    , actions
    , centered
    , fixed
    , graphic
    , graphicTextWrapper
    , icon
    , stacked
    , primaryAction
    , secondaryAction
    , text
    , view
    )

import Html exposing (Html)
import Html.Attributes exposing (alt)
import Internal.Options as Options exposing (aria, cs, css, role, styled, when)
import Internal.Button.Implementation as Button


type alias Config =
    { fixed : Bool
    }


defaultConfig : Config
defaultConfig =
    { fixed = False
    }


type alias Property m =
    Options.Property Config m


centered : Property m
centered =
    modifier "centered"


fixed : Property m
fixed =
    Options.option (\config -> { config | fixed = True })


stacked : Property m
stacked =
    modifier "mobile-stacked"


view : List (Property m) -> List (Html m) -> Html m
view options nodes =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        Html.div
        [ block
        , role "banner"
        ]
        []
        [ if config.fixed then
              fixedWrapper [] [ content [] nodes ]
            else
                content [] nodes
        ]


fixedWrapper : List (Property m) -> List (Html m) -> Html m
fixedWrapper options nodes =
    styled Html.div
        [ element "fixed"
        ]
        nodes


content : List (Property m) -> List (Html m) -> Html m
content options nodes =
    styled Html.div
        [ element "content"
        , role "status"
        , aria "live" "assertive"
        ]
        nodes

graphicTextWrapper : List (Property m) -> List (Html m) -> Html m
graphicTextWrapper options nodes =
    styled Html.div
        [ element "graphic-text-wrapper"
        ]
        nodes


graphic : List (Property m) -> List (Html m) -> Html m
graphic options nodes =
    styled Html.div
        [ element "graphic"
        , role "img"
        , Options.attribute (alt "")
        ]
        nodes


icon : String -> Html m
icon name =
    styled Html.i
        [ element "icon"
        , cs "material-icons"
        ]
        [ Html.text name ]


text : List (Property m) -> List (Html m) -> Html m
text options nodes =
    styled Html.div
        [ element "text"
        ]
        nodes


actions : List (Property m) -> List (Html m) -> Html m
actions options nodes =
    styled Html.div
        [ element "actions"
        ]
        nodes


primaryAction : Button.Property m
primaryAction =
    cs "mdc-banner__primary-action"


secondaryAction : Button.Property m
secondaryAction =
    cs "mdc-banner__secondary-action"


{- Make it easier to work with BEM conventions
-}
block : Property m
block =
    cs blockName

element : String -> Property m
element module_ =
    cs ( blockName ++ "__" ++ module_ )

modifier : String -> Property m
modifier modifier_ =
    cs ( blockName ++ "--" ++ modifier_ )

blockName : String
blockName =
    "mdc-banner"
