module Material.Spinner
    exposing
        ( spinner
        , active
        , singleColor
        , Property
        , Config
        , defaultConfig
        )

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#loading-section/spinner):

> The Material Design Lite (MDL) spinner component is an enhanced replacement
> for the classic "wait cursor" (which varies significantly among hardware and
> software versions) and indicates that there is an ongoing process, the
> results of which are not yet available. A spinner consists of an open circle
> that changes colors as it animates in a clockwise direction, and clearly
> communicates that a process has been started but not completed.

> A spinner performs no action itself, either by its display nor when the user
> clicks or touches it, and does not indicate a process's specific progress or
> degree of completion. The MDL spinner component provides various types of
> spinners, and allows you to add display effects.

> Spinners are a fairly new feature of most user interfaces, and provide users
> with a consistent visual cue about ongoing activity, regardless of hardware
> device, operating system, or browser environment. Their design and use is an
> important factor in the overall user experience.

Refer to
[this site](https://debois.github.io/elm-mdl/#loading)
for a live demo.

@docs spinner, active, singleColor
@docs Property, Config, defaultConfig

-}

import Html exposing (Html, Attribute)
import Material.Options as Options exposing (cs, css, nop, when)
import Material.Options.Internal as Internal



{-| A spinner is a loading indicator that by default changes color and is
invisible. Example use:

    spinner [ active True ] []
-}
spinner : List (Property m) -> Html m
spinner options =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options
    in
        Internal.apply summary
            Html.div
            [ cs "mdl-spinner mdl-js-spinner is-upgraded"
            , cs "is-active" |> when config.active 
            , cs "mdl-spinner--single-color" |> when config.singleColor 
            ]
            []
            layers


{-| Make a spinner visible
-}
active : Bool -> Property m
active =
    (\value config -> { config | active = value })
        >> Internal.option


{-| Make a spinner a single color (the active color) of the stylesheet.
-}
singleColor : Bool -> Property m
singleColor =
    (\value config -> { config | singleColor = value })
        >> Internal.option



-- MODEL


{-| Spinner config
-}
type alias Config =
    { active : Bool
    , singleColor : Bool
    }


{-| Spinner default config is not `active`, not `singleColor`.
-}
defaultConfig : Config
defaultConfig =
    { active = False
    , singleColor = False
    }


{-| A spinner's property.
-}
type alias Property m =
    Options.Property Config m



-- HELPER


layer : Int -> Html m
layer n =
    Options.div
        [ cs <| "mdl-spinner__layer mdl-spinner__layer-" ++ toString n
        ]
        ([ Options.div [ cs "mdl-spinner__circle-clipper mdl-spinner__left" ]
         , Options.div [ cs "mdl-spinner__gap-patch" ]
         , Options.div [ cs "mdl-spinner__circle-clipper mdl-spinner__right" ]
         ]
            |> List.map ((|>) [ Options.div [ cs "mdl-spinner__circle" ] [] ])
        )


layers : List (Html m)
layers =
    List.map layer (List.range 1 4) 


