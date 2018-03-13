module Material.Internal.LinearProgress.Implementation exposing
    ( buffered
    , determinate
    , indeterminate
    , Property
    , reversed
    , view
    )

import Html exposing (Html)
import Material.Internal.Options as Options exposing (styled, cs, css, when)
import Material.Internal.Options.Internal as Internal


type alias Config =
    { value : Float
    , buffer : Float
    , determinate : Bool
    , indeterminate : Bool
    , buffered : Bool
    , reversed : Bool
    }


defaultConfig : Config
defaultConfig =
    { value = 0
    , buffer = 0
    , determinate = False
    , indeterminate = False
    , buffered = False
    , reversed = False
    }


type alias Property m =
    Options.Property Config m


indeterminate : Property m
indeterminate =
    Internal.option (\config -> { config | indeterminate = True })


determinate : Float -> Property m
determinate value =
    Internal.option (\config -> { config | determinate = True, value = value })


buffered : Float -> Float -> Property m
buffered value buffer =
    Internal.option (\config -> { config | buffered = True, value = value, buffer = buffer })


reversed : Property m
reversed =
    Internal.option (\config -> { config | reversed = True })


view : List (Property m) -> List (Html m) -> Html m
view options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options
    in
    Internal.apply summary Html.div
    [ cs "mdc-linear-progress"
    , cs "mdc-linear-progress--indeterminate" |> when config.indeterminate
    , cs "mdc-linear-progress--reversed" |> when config.reversed
    ]
    []
    [ styled Html.div
      [ cs "mdc-linear-progress__buffering-dots"
      ]
      []
    , styled Html.div
      [ cs "mdc-linear-progress__buffer"
      , when config.buffered <|
        css "transform" ("scaleX(" ++ toString config.buffer ++ ")")
      ]
      []
    , styled Html.div
      [ cs "mdc-linear-progress__bar mdc-linear-progress__primary-bar"
      , when (not config.indeterminate) <|
        css "transform" ("scaleX(" ++ toString config.value ++ ")")
      ]
      [ styled Html.span [ cs "mdc-linear-progress__bar-inner" ] []
      ]
    , styled Html.div
      [ cs "mdc-linear-progress__bar mdc-linear-progress__secondary-bar"
      ]
      [ styled Html.span [ cs "mdc-linear-progress__bar-inner" ] []
      ]
    ]
