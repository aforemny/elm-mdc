module Material.Internal.RadioButton.Implementation exposing
    ( disabled
    , Property
    , react
    , selected
    , view
    )

import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Material.Internal.Component as Component exposing (Indexed, Index)
import Material.Internal.Msg
import Material.Internal.Options as Options exposing (cs, styled, when)
import Material.Internal.Options.Internal as Internal
import Material.Internal.RadioButton.Model exposing (Model, defaultModel, Msg(..))
import Material.Internal.Ripple.Implementation as Ripple


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


type alias Property m =
    Options.Property Config m


disabled : Property m
disabled =
    Internal.option (\ config -> { config | disabled = True })


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


react :
    (Material.Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Internal.Msg.RadioButtonMsg update


view :
    (Material.Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view lift index store options =
    Component.render get radioButton Material.Internal.Msg.RadioButtonMsg lift index store
        (Internal.dispatch lift :: options)
