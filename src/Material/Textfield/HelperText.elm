module Material.Textfield.HelperText
    exposing
        ( helperText
        , Property
        , persistent
        , validationMsg
        , Config
        , defaultConfig
        )


import Html exposing (Html)
import Material.Internal.Options as Internal
import Material.Options as Options exposing (cs, css, nop, Style, when)


-- OPTIONS


{-| TODO
-}
type alias Config =
    { persistent : Bool
    , validationMsg : Bool
    }


{-| TODO
-}
defaultConfig : Config
defaultConfig =
    { persistent = False
    , validationMsg = False
    }


{-| TODO
-}
type alias Property m =
    Options.Property Config m


{-| TODO
-}
persistent : Property m
persistent =
    Internal.option (\config -> { config | persistent = True })


{-| TODO
-}
validationMsg : Property m
validationMsg =
    Internal.option (\config -> { config | validationMsg = True })


-- VIEW


{-| TODO
-}
helperText : List (Property m) -> List (Html m) -> Html m
helperText options =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options
    in
    Options.styled Html.p
    (  cs "mdc-textfield-helptext"
    :: (cs "mdc-textfield-helptext--persistent" |> when config.persistent)
    :: (cs "mdc-textfield-helptext--validation-msg" |> when config.validationMsg)
    :: options
    )
