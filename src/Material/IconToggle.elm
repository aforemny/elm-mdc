module Material.IconToggle exposing
    ( className
    , disabled
    , icon
    , label
    , Model
    , on
    , Property
    , react
    , view
    )

{-|
IconToggle provides a Material Design icon toggle button. It is fully
accessible, and is designed to work with any icon set.


# Resources

- [Material Design guidelines: Toggle buttons](https://material.io/guidelines/components/buttons.html#buttons-toggle-buttons)
- [Demo](https://aforemny.github.io/elm-mdc/#icon-toggle)


# Example

```elm
import Material.IconToggle as IconToggle


IconToggle.view Mdc [0] model.mdc
    [ IconToggle.icon
          { on = "favorite_border"
          , off = "favorite"
          }
    , IconToggle.label
          { on = "Remove from favorites"
          , off "Add to favorites"
          }
    , IconToggle.on True
    , IconToggle.onClick Toggle
    ]
    []
```


# Usage

@docs Property
@docs view
@docs on
@docs icon
@docs label
@docs disabled
@docs className


# Internal
@docs Model
@docs react
-}

import Html exposing (Html, text)
import Material.Component as Component exposing (Index, Indexed)
import Material.Internal.IconToggle exposing (Msg(..))
import Material.Internal.Options as Internal
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Ripple as Ripple


{-| IconToggle model.

Internal use only.
-}
type alias Model =
    { on : Bool
    , ripple : Ripple.Model
    }


defaultModel : Model
defaultModel =
    { on = False
    , ripple = Ripple.defaultModel
    }


type alias Msg =
    Material.Internal.IconToggle.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RippleMsg msg_ ->
          let
              ( ripple, effects ) =
                  Ripple.update msg_ model.ripple
          in
          ( { model | ripple = ripple }, Cmd.map RippleMsg effects )


type alias Config =
    { on : Bool
    , label : { on : String, off : String }
    , icon : { on : String, off : String }
    , inner : Maybe String
    }


defaultConfig : Config
defaultConfig =
    { on = False
    , label = { on = "", off = "" }
    , icon = { on = "", off = "" }
    , inner = Nothing
    }


{-| IconToggle property.
-}
type alias Property m =
    Options.Property Config m


{-| Make the icon toggle appear in its "on" state.

Defaults to "off". Use `Options.when` to make it interactive.
-}
on : Property m
on =
    Internal.option (\config -> { config | on = True })


{-| Sets an alternate classname of the icon.

Useful if you want to use a different icon set. For example use `"fa"` for
FontAwesome.
-}
className : String -> Property m
className className =
    Internal.option (\ config -> { config | inner = Just className })


{-| Set the icon.

Specify an icon for the icon toggle's "on" and "off" state.
-}
icon : { on : String, off : String } -> Property m
icon icon =
    Internal.option (\config -> { config | icon = icon })


{-| Set the icon toggle's label.

Specify a label for the icon toggle's "on" and "off" state.
-}
label : { on : String, off : String } -> Property m
label label =
    Internal.option (\config -> { config | label = label })


{-| Disable the icon toggle.
-}
disabled : Property m
disabled =
    cs "mdc-icon-toggle--disabled"


iconToggle : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
iconToggle lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        ripple =
            Ripple.view True (lift << RippleMsg) model.ripple []
    in
    Internal.apply summary (if config.inner == Nothing then Html.i else Html.span)
    ( cs "mdc-icon-toggle"
    :: when (config.inner == Nothing) (cs "material-icons")
    :: Options.aria "label" (if config.on then config.label.on else config.label.off)
    :: Options.many
       [ ripple.interactionHandler
       , ripple.properties
       ]
    :: options
    )
    []
    [ if config.inner /= Nothing then
          styled Html.i
          [ cs (Maybe.withDefault "material-icons" config.inner)
          , if config.on then
                cs config.icon.on
            else
                cs config.icon.off
          ]
          []
      else
          text (if config.on then config.icon.on else config.icon.off)
    ,
      ripple.style
    ]


type alias Store s =
    { s | iconToggle : Indexed Model
    }


( get, set ) =
    Component.indexed .iconToggle (\x y -> { y | iconToggle = x }) defaultModel


{-| IconToggle react.

Internal use only.
-}
react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.IconToggleMsg (Component.generalise update)


{-| IconToggle view.
-}
view :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render get iconToggle Material.Msg.IconToggleMsg
