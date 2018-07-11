module Internal.RadioButton.Implementation exposing
    ( disabled
    , nativeControl
    , Property
    , react
    , selected
    , view
    )

import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Internal.Component as Component exposing (Indexed, Index)
import Internal.Msg
import Internal.Options as Options exposing (cs, styled, when)
import Internal.RadioButton.Model exposing (Model, defaultModel, Msg(..))
import Internal.Ripple.Implementation as Ripple


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


type alias Config m =
    { value : Bool
    , disabled : Bool
    , nativeControl : List (Options.Property () m)
    , id_ : String
    }


defaultConfig : Config m
defaultConfig =
    { value = False
    , disabled = False
    , nativeControl = []
    , id_ = ""
    }


type alias Property m =
    Options.Property (Config m) m


disabled : Property m
disabled =
    Options.option (\ config -> { config | disabled = True })


selected : Property m
selected =
    Options.option (\config -> { config | value = True })


nativeControl : List (Options.Property () m) -> Property m
nativeControl =
    Options.nativeControl


radioButton : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
radioButton lift model options _ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        ripple =
            Ripple.view True (lift << RippleMsg) model.ripple []

        preventDefault =
          { preventDefault = True
          , stopPropagation = False
          }
    in
    Options.apply summary Html.div
    [ cs "mdc-radio"
    , Options.many
      [ ripple.interactionHandler
      , ripple.properties
      ]
    ]
    []
    [ Options.applyNativeControl summary Html.input
      [ cs "mdc-radio__native-control"
      , Options.id config.id_
      , Options.attribute <| Html.type_ "radio"
      , Options.attribute <| Html.checked config.value
      , Options.onFocus (lift (SetFocus True))
      , Options.onBlur (lift (SetFocus False))
      , Options.onWithOptions "click" preventDefault (Json.succeed (lift NoOp))
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
    (Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Internal.Msg.RadioButtonMsg update


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    \lift index store options ->
        Component.render get radioButton Internal.Msg.RadioButtonMsg lift index store
            (Options.id_ index :: options)
