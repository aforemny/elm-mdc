module Material.RadioButton
    exposing
        ( -- VIEWW
          view
        , Property
        , disabled
        , selected
        , name
        
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
The MDC Radio Button component provides a radio button adhering to the Material
Design Specification. It requires no Javascript out of the box, but can be
enhanced with Javascript to provide better interaction UX as well as a
component-level API for state modification.

## Design & API Documentation

- [Material Design guidelines: Selection Controls – Radio buttons](https://material.io/guidelines/components/selection-controls.html#selection-controls-radio-button)
- [Demo](https://aforemny.github.io/elm-mdc/#radio-buttons)

## View
@docs view

## Properties
@docs Property, disabled, selected

## TEA architecture
@docs Model, defaultModel, Msg, update

## Featured render
@docs render
@docs Store, react
-}

import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Material.Component as Component exposing (Indexed)
import Material.Helpers exposing (blurOn, filter, noAttr)
import Material.Internal.Options as Internal
import Material.Internal.RadioButton exposing (Msg(..))
import Material.Msg exposing (Index)
import Material.Options as Options exposing (Style, cs, styled, many, when, maybe)
import Material.Ripple as Ripple

-- MODEL


{-| Component model.
-}
type alias Model =
    { ripple : Ripple.Model
    , isFocused : Bool
    }


{-| Default component model.
-}
defaultModel : Model
defaultModel =
    { ripple = Ripple.defaultModel
    , isFocused = False
    }



-- ACTION, UPDATE


{-| Component message.
-}
type alias Msg
    = Material.Internal.RadioButton.Msg


{-| Component update.
-}
update : (Msg -> m) -> Msg -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    case msg of
        RippleMsg msg_ ->
            let
                ( ripple, effects ) =
                    Ripple.update msg_ model.ripple
            in
            ( Just { model | ripple = ripple }
            ,
              Cmd.map (RippleMsg >> lift) effects
            )

        SetFocus focus ->
            ( Just { model | isFocused = focus }, Cmd.none )

        NoOp ->
            ( Nothing, Cmd.none )


-- OPTIONS


type alias Config m =
    { input : List (Options.Style m)
    , container : List (Options.Style m)
    , value : Bool
    }


defaultConfig : Config m
defaultConfig =
    { input = []
    , container = []
    , value = False
    }


{-| TODO
-}
type alias Property m =
    Options.Property (Config m) m


{-| TODO
-}
disabled : Property m
disabled =
    Options.many
    [ cs "mdc-radio--disabled"
    , Internal.input
      [ Internal.attribute <| Html.disabled True
      ]
    ]


{-| TODO
-}
selected : Property m
selected =
    Internal.option (\config -> { config | value = True })


{-| TODO
-}
name : String -> Property m
name value =
    Internal.attribute (Html.name value)


-- VIEW


{-| Component view.
-}
view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        ripple =
            Ripple.view True (RippleMsg >> lift) model.ripple [] []
    in
    Internal.applyContainer summary Html.div
    [ cs "mdc-radio"
    , Internal.attribute <| blurOn "mouseup"
    , Options.many
      [ ripple.interactionHandler
      , ripple.properties
      ]
    ]
    [ Internal.applyInput summary
        Html.input
        [ cs "mdc-radio__native-control"
        , Internal.attribute <| Html.type_ "radio"
        , Internal.attribute <| Html.checked config.value
        , Internal.on1 "focus" lift (SetFocus True)
        , Internal.on1 "blur" lift (SetFocus False)
        , Options.onWithOptions "click"
            { preventDefault = True
            , stopPropagation = False
            }
            (Json.succeed (lift NoOp))
        ]
        []
    , styled Html.div
      [ cs "mdc-radio__background"
      ]
      [ styled Html.div [ cs "mdc-radio__inner-circle" ] []
      , styled Html.div [ cs "mdc-radio__outer-circle" ] []
      ]

    , ripple.style
    ]


-- COMPONENT


type alias Store s =
    { s | radio : Indexed Model }


( get, set ) =
    Component.indexed .radio (\x y -> { y | radio = x }) defaultModel


{-| Component react function.
-}
react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.RadioButtonMsg update


{-| Component render (radio)
-}
render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render lift index store options =
    Component.render get view Material.Msg.RadioButtonMsg lift index store
        (Internal.dispatch lift :: options)
