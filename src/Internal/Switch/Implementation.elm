module Internal.Switch.Implementation exposing
    ( Property
    , disabled
    , nativeControl
    , on
    , react
    , view
    )

import Html exposing (Html)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Msg
import Internal.Options as Options exposing (cs, many, styled, when)
import Internal.Ripple.Implementation as Ripple
import Internal.Switch.Model exposing (Model, Msg(..), defaultModel)
import Json.Decode as Decode


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RippleMsg msg_ ->
            let
                ( rippleState, rippleCmd ) =
                    Ripple.update msg_ model.ripple
            in
            ( { model | ripple = rippleState }, Cmd.map RippleMsg rippleCmd )

        SetFocus focus ->
            ( { model | isFocused = focus }, Cmd.none )

        NoOp ->
            ( model, Cmd.none )


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
    Options.option (\config -> { config | disabled = True })


on : Property m
on =
    Options.option (\config -> { config | value = True })


nativeControl : List (Options.Property () m) -> Property m
nativeControl =
    Options.nativeControl


switch : Index -> (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
switch domId lift model options _ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        rippleDomId =
            domId ++ "-ripple"

        ripple =
            Ripple.view True rippleDomId (lift << RippleMsg) model.ripple []
    in
    Options.apply summary
        Html.div
        [ cs "mdc-switch"
        , cs "mdc-switch--disabled" |> when config.disabled
        , cs "mdc-switch--checked" |> when config.value
        ]
        []
        [ styled Html.div
            [ cs "mdc-switch__track" ]
            []
        , styled Html.div
            [ cs "mdc-switch__thumb-underlay"
            , ripple.interactionHandler
            , ripple.properties
            ]
            [ Options.applyNativeControl summary
                Html.input
                    [ cs "mdc-switch__native-control"
                    , Options.role "switch"
                    , Options.id config.id_
                    , Options.attribute <| Html.type_ "checkbox"
                    , Options.attribute (Html.attribute "checked" "checked") |> when config.value
                    , Options.aria "checked" ( if config.value then "true" else "false" )
                    , Options.onFocus (lift (SetFocus True))
                    , Options.onBlur (lift (SetFocus False))
                    , Options.onWithOptions "click"
                        (Decode.succeed
                            { message = lift NoOp
                            , preventDefault = True
                            , stopPropagation = False
                            }
                        )
                    , when config.disabled
                        << Options.many
                      <|
                        [ cs "mdc-checkbox--disabled"
                        , Options.attribute <| Html.disabled True
                        ]
                    ]
                    []
            , styled Html.div
                [ cs "mdc-switch__thumb" ]
                []
            ]
        ]


type alias Store s =
    { s | switch : Indexed Model }


getSet :
    { get : Index -> { a | switch : Indexed Model } -> Model
    , set :
        Index
        -> { a | switch : Indexed Model }
        -> Model
        -> { a | switch : Indexed Model }
    }
getSet =
    Component.indexed .switch (\x y -> { y | switch = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.SwitchMsg (Component.generalise update)


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    \lift index store options ->
        Component.render getSet.get
            (switch index)
            Internal.Msg.SwitchMsg
            lift
            index
            store
            (Options.internalId index :: options)
