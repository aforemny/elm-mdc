module Internal.Switch.Implementation
    exposing
        ( Property
        , disabled
        , nativeControl
        , on
        , react
        , view
        )

import Html exposing (Html, text)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Msg
import Internal.Options as Options exposing (cs, many, styled, when)
import Internal.Switch.Model exposing (Model, Msg(..), defaultModel)
import Json.Decode as Decode


update : x -> Msg -> Model -> ( Maybe Model, Cmd m )
update _ msg model =
    case msg of
        SetFocus focus ->
            ( Just { model | isFocused = focus }, Cmd.none )

        NoOp ->
            ( Nothing, Cmd.none )


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


switch : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
switch lift model options _ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        Html.div
        [ cs "mdc-switch"
        ]
        []
        [ Options.applyNativeControl summary
            Html.input
            [ cs "mdc-switch__native-control"
            , Options.id config.id_
            , Options.attribute <| Html.type_ "checkbox"
            , Options.attribute <| Html.checked config.value
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
            [ cs "mdc-switch__background"
            ]
            [ styled Html.div
                [ cs "mdc-switch__knob"
                ]
                []
            ]
        ]


type alias Store s =
    { s | switch : Indexed Model }


getSet =
    Component.indexed .switch (\x y -> { y | switch = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.SwitchMsg update


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
            switch
            Internal.Msg.SwitchMsg
            lift
            index
            store
            (Options.internalId index :: options)
