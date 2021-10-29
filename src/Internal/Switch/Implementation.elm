module Internal.Switch.Implementation exposing
    ( Property
    , disabled
    , nativeControl
    , on
    , react
    , view
    )

import Html exposing (Html, div)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Msg
import Internal.Options as Options exposing (aria, cs, many, role, styled, when)
import Internal.Ripple.Implementation as Ripple
import Internal.Switch.Model exposing (Model, Msg(..), defaultModel)
import Json.Decode as Decode
import Svg exposing (path, svg)
import Svg.Attributes as Svg exposing (viewBox)


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
        Html.button
        [ block
        , cs "mdc-switch--disabled" |> when config.disabled
        , cs "mdc-switch--selected" |> when config.value
        , Options.attribute <| Html.type_ "button"
        , aria "checked" ( if config.value then "true" else "false" )
        , role "switch"
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
                [ element "unselected"
                , Options.attribute <| Html.disabled True
                ]
        ]
        []
        [ styled div
            [ element "track" ]
            []
        , styled div
            [ element "handle-track"
            ]
            [ styled div
                [ element "handle" ]
                [ styled div
                      [ element "shadow" ]
                      [ styled div [ cs "mdc-elevation-overlay" ] [] ]
                , styled div
                    [ element "ripple"
                    , ripple.interactionHandler
                    , ripple.properties
                    ]
                    []
                , styled div
                    [ element "icons" ]
                    [ svg
                        [ Svg.class "mdc-switch__icon"
                        , Svg.class "mdc-switch__icon--on"
                        , viewBox "0 0 24 24"
                        ]
                        [ path [ Svg.d "M19.69,5.23L8.96,15.96l-4.23-4.23L2.96,13.5l6,6L21.46,7L19.69,5.23z" ] [] ]
                    , svg
                        [ Svg.class "mdc-switch__icon"
                        , Svg.class "mdc-switch__icon--off"
                        , viewBox "0 0 24 24"
                        ]
                        [ path [ Svg.d "M20 13H4v-2h16v2z" ] [] ]
                    ]
                ]
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


{- Make it easier to work with BEM conventions
-}
block : Property m
block =
    cs blockName

element : String -> Property m
element module_ =
    cs ( blockName ++ "__" ++ module_ )

modifier : String -> Property m
modifier modifier_ =
    cs ( blockName ++ "--" ++ modifier_ )

blockName : String
blockName =
    "mdc-switch"
