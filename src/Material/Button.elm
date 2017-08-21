module Material.Button
    exposing
        ( -- VIEW
          view
        , Property
        , disabled

        , raised
        , ripple

        , compact
        , dense

        , primary
        , accent
        , colored
        , darkTheme

        , type_
        , link

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
The MDC Button component is a spec-aligned button component adhering to the
Material Design button requirements.

## Design & API Documentation

- [Material Design guidelines: Buttons](https://material.io/guidelines/components/buttons.html)
- [Demo](https://aforemny.github.io/elm-mdc/#buttons)

## View
@docs view

## Properties
@docs Property
@docs disabled
@docs raised, ripple
@docs compact, dense
@docs primary, accent, colored, darkTheme
@docs type_, link

## TEA architecture
@docs Model, defaultModel, Msg, update

## Featured render
@docs Property, render
-}

import Html.Attributes exposing (..)
import Html exposing (..)
import Material.Component as Component exposing (Indexed, Index)
import Material.Helpers as Helpers
import Material.Internal.Button exposing (Msg(..))
import Material.Internal.Options as Internal
import Material.Msg
import Material.Options as Options exposing (cs, css, when)
import Material.Ripple as Ripple


type alias Model =
    { ripple : Ripple.Model
    }


defaultModel : Model
defaultModel =
    { ripple = Ripple.defaultModel
    }


type alias Msg =
    Material.Internal.Button.Msg


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
    { ripple : Bool
    , link : Maybe String
    , disabled : Bool
    }


defaultConfig : Config
defaultConfig =
    { ripple = False
    , link = Nothing
    , disabled = False
    }


type alias Property m =
    Options.Property Config m


disabled : Property m
disabled =
    Internal.option (\options -> { options | disabled = True })


raised : Property m
raised =
    cs "mdc-button--raised"


ripple : Property m
ripple =
    Internal.option (\options -> { options | ripple = True })


compact : Property m
compact =
    cs "mdc-button--compact"


dense : Property m
dense =
    cs "mdc-button--dense"


primary : Property m
primary =
    cs "mdc-button--primary"


accent : Property m
accent =
    cs "mdc-button--accent"


colored : Property m
colored =
    cs "mdc-button--colored"


darkTheme : Property m
darkTheme =
    cs "mdc-button--dark-theme"


link : String -> Property m
link href =
    Internal.option (\options -> { options | link = Just href })


type_ : String -> Property m
type_ =
   Html.Attributes.type_ >> Internal.attribute


view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options nodes =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        ( rippleOptions, rippleStyles ) =
            Ripple.view False (RippleMsg >> lift) model.ripple () ()
    in
        Internal.apply summary
            (if config.link /= Nothing then Html.a else Html.button)
            [ cs "mdc-button"
            , cs "mdc-js-button"
            , cs "mdc-js-ripple-effect" |> when summary.config.ripple
            , css "box-sizing" "border-box"
            , Internal.attribute (Html.Attributes.href (Maybe.withDefault "" config.link) )
                |> when ((config.link /= Nothing) && not config.disabled)
            , Internal.attribute (Html.Attributes.disabled True)
                |> when config.disabled
            , cs "mdc-button--disabled"
                |> when config.disabled
            , rippleOptions
              |> when config.ripple
            ]
            [ Helpers.blurOn "mouseup"
            , Helpers.blurOn "mouseleave"
            , Helpers.blurOn "touchend"
            ]
            ( nodes ++ [rippleStyles]
            )


type alias Store s =
    { s | button : Indexed Model }


( get, set ) =
    Component.indexed .button (\x y -> { y | button = x }) defaultModel


render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render =
    Component.render get view Material.Msg.ButtonMsg


react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.ButtonMsg (Component.generalise update)
