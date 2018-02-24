module Material.Fab
    exposing
        ( defaultModel
        , exited
        , mini
        , Model
        , Msg
        , Property
        , react
        , render
        , ripple
        , Store
        , update
        , view
        )

{-| The MDC FAB component is a spec-aligned button component adhering to the
Material Design FAB requirements.

## Design & API Documentation

- [Material Design guidelines: Buttons](https://material.io/guidelines/components/buttons-floating-action-button.html)
- [Demo](https://aforemny.github.io/elm-mdc/#fab)

## View
@docs view

## Properties
@docs Property
@docs disabled, plain, mini, ripple

## TEA architecture
@docs Model, defaultModel, Msg, update

## Featured render
@docs render
@docs Store, react
-}

import Html exposing (..)
import Material.Component as Component exposing (Indexed, Index)
import Material.Internal.Fab exposing (Msg(..))
import Material.Internal.Options as Internal
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Ripple as Ripple


type alias Model =
    { ripple : Ripple.Model
    }


defaultModel : Model
defaultModel =
    { ripple = Ripple.defaultModel
    }


type alias Msg =
    Material.Internal.Fab.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RippleMsg msg_ ->
            let
                ( ripple, effects ) =
                    Ripple.update msg_ model.ripple
            in
            ( { model | ripple = ripple }, Cmd.map RippleMsg effects )

        NoOp ->
            ( model, Cmd.none )


type alias Config =
    { ripple : Bool
    }


defaultConfig : Config
defaultConfig =
    { ripple = False
    }


type alias Property m =
    Options.Property Config m


mini : Property m
mini =
    cs "mdc-fab--mini"


exited : Property m
exited =
    cs "mdc-fab--exited"


ripple : Property m
ripple =
    Internal.option (\config -> { config | ripple = True })


view : (Msg -> m) -> Model -> List (Property m) -> String -> Html m
view lift model options icon =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        ripple =
            Ripple.view False (RippleMsg >> lift) model.ripple () ()
    in
        Internal.apply summary
            Html.button
            [ cs "mdc-fab"
            , cs "material-icons"
            , when config.ripple << Options.many <|
              [ ripple.interactionHandler
              , ripple.properties
              ]
            ]
            []
            ( List.concat
              [ [ styled Html.span
                  [ cs "mdc-fab__icon"
                  ]
                  [ text icon
                  ]
                ]
              ,
                if config.ripple then
                    [ ripple.style ]
                else
                    []
              ]
            )


type alias Store s =
    { s | fab : Indexed Model }


( get, set ) =
    Component.indexed .fab (\x y -> { y | fab = x }) defaultModel


render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> String
    -> Html m
render =
    Component.render get view Material.Msg.FabMsg


react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.FabMsg (Component.generalise update)
