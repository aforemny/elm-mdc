module Material.RadioButton exposing
    ( disabled
    , Model
    , Property
    , react
    , selected
    , view
    )

{-|
The RadioButton component provides a radio button adhering to the Material
Design Specification.


# Resources

- [Material Design guidelines: Selection Controls – Radio buttons](https://material.io/guidelines/components/selection-controls.html#selection-controls-radio-button)
- [Demo](https://aforemny.github.io/elm-mdc/#radio-buttons)


# Example

```elm
Options.styled Html.div
    [ Options.cs "mdc-form-field"
    ]
    [ RadioButton.view Mdc [0] model.mdc
          [ RadioButton.selected
          , Options.onClick Select
          ]
          []
    , Html.label
          [ Options.onClick Select
          ]
          [ text "Radio"
          ]
    ]
```

# Usage
@docs Property
@docs view
@docs selected
@docs disabled


# Internal
@docs Model
@docs react
-}

import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Material.Component as Component exposing (Indexed)
import Material.Helpers exposing (blurOn, filter, noAttr)
import Material.Internal.Options as Internal
import Material.Internal.RadioButton exposing (Msg(..))
import Material.Msg exposing (Index)
import Material.Options as Options exposing (cs, styled, when)
import Material.Ripple as Ripple


{-| RadioButton model.

Internal use only.
-}
type alias Model =
    { ripple : Ripple.Model
    , isFocused : Bool
    }


defaultModel : Model
defaultModel =
    { ripple = Ripple.defaultModel
    , isFocused = False
    }


type alias Msg
    = Material.Internal.RadioButton.Msg


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
              Cmd.map (lift << RippleMsg) effects
            )

        NoOp ->
            ( Nothing, Cmd.none )

        SetFocus focus ->
            ( Just { model | isFocused = focus }, Cmd.none )


type alias Config =
    { value : Bool
    , disabled : Bool
    }


defaultConfig : Config
defaultConfig =
    { value = False
    , disabled = False
    }


{-| RadioButton property.
-}
type alias Property m =
    Options.Property Config m


{-| Disable the radio button.
-}
disabled : Property m
disabled =
    Internal.option (\ config -> { config | disabled = True })


{-| Make the radio button selected.

Defaults to not selected. Use `Options.when` to make it interactive.
-}
selected : Property m
selected =
    Internal.option (\config -> { config | value = True })


radioButton : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
radioButton lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        ripple =
            Ripple.view True (lift << RippleMsg) model.ripple []
    in
    Internal.apply summary Html.div
    [ cs "mdc-radio"
    , Internal.attribute <| blurOn "mouseup"
    , Options.many
      [ ripple.interactionHandler
      , ripple.properties
      ]
    ]
    []
    [ styled Html.input
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
        , when config.disabled << Options.many <|
          [ cs "mdc-radio--disabled"
          , Options.attribute <| Html.disabled True
          ]
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


type alias Store s =
    { s | radio : Indexed Model }


( get, set ) =
    Component.indexed .radio (\x y -> { y | radio = x }) defaultModel


{-| RadioButton react.

Internal use only.
-}
react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.RadioButtonMsg update


{-| RadioButton view.
-}
view :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view lift index store options =
    Component.render get radioButton Material.Msg.RadioButtonMsg lift index store
        (Internal.dispatch lift :: options)
