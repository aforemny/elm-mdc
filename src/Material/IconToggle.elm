module Material.IconToggle exposing
    ( -- VIEW
      view
    , Property
    , disabled
    , on

    , icon
    , label

    , primary
    , accent

    , inner
    
    -- TEA
    , Model
    , defaultModel
    , Msg
    , update

    -- RENDER
    , render
    , Store
    , react
    )

{-|
## Design & API Documentation

- [Material Design guidelines: Toggle buttons](https://material.io/guidelines/components/buttons.html#buttons-toggle-buttons)
- [Demo](https://aforemny.github.io/elm-mdc/#icon-toggle)

## View
@docs view

## Properties
@docs Property
@docs disabled
@docs on
@docs icon, label
@docs primary, accent
@docs inner

## TEA architecture
@docs Model, defaultModel, Msg, update

## Featured render
@docs render
@docs Store, react
-}

import Html exposing (Html, text)
import Material.Component as Component exposing (Index, Indexed)
import Material.Internal.IconToggle exposing (Msg(..))
import Material.Internal.Options as Internal
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Ripple as Ripple


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


type alias Property m =
    Options.Property Config m


on : Property m
on =
    Internal.option (\config -> { config | on = True })


icon : String -> String -> Property m
icon on off =
    Internal.option (\config -> { config | icon = { on = on, off = off } })


label : String -> String -> Property m
label on off =
    Internal.option (\config -> { config | label = { on = on, off = off } })


inner : String -> Property m
inner =
    Internal.option << (\value config -> { config | inner = Just value })


primary : Property m
primary =
    cs "mdc-icon-toggle--primary"


accent : Property m
accent =
    cs "mdc-icon-toggle--accent"


disabled : Property m
disabled =
    cs "mdc-icon-toggle--disabled"


view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options _ =
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


react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.IconToggleMsg (Component.generalise update)


render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render =
    Component.render get view Material.Msg.IconToggleMsg
