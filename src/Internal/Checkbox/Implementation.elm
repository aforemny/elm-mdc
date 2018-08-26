module Internal.Checkbox.Implementation
    exposing
        ( Property
        , checked
        , disabled
        , nativeControl
        , react
        , view
        )

import Html exposing (Html, text)
import Html.Attributes as Html
import Internal.Checkbox.Model exposing (Animation(..), Model, Msg(..), State(..), defaultModel)
import Internal.Component as Component exposing (Index, Indexed)
import Internal.GlobalEvents as GlobalEvents
import Internal.Msg
import Internal.Options as Options exposing (cs, many, styled, when)
import Json.Decode as Decode exposing (Decoder)
import Json.Encode as Encode
import Svg exposing (path)
import Svg.Attributes as Svg


update : (Msg -> m) -> Msg -> Model -> ( Maybe Model, Cmd m )
update _ msg model =
    case msg of
        NoOp ->
            ( Nothing, Cmd.none )

        SetFocus focus ->
            ( Just { model | isFocused = focus }, Cmd.none )

        Init lastKnownState state ->
            let
                animation =
                    lastKnownState
                        |> Maybe.andThen
                            (\lastKnownState_ ->
                                animationState lastKnownState_ state
                            )
            in
            ( Just
                { model
                    | lastKnownState = Just state
                    , animation = animation
                }
            , Cmd.none
            )

        AnimationEnd ->
            ( Just { model | animation = Nothing }, Cmd.none )


type alias Config m =
    { state : Maybe State
    , disabled : Bool
    , nativeControl : List (Options.Property () m)
    , id_ : String
    }


defaultConfig : Config m
defaultConfig =
    { state = Nothing
    , disabled = False
    , nativeControl = []
    , id_ = ""
    }


type alias Property m =
    Options.Property (Config m) m


disabled : Property m
disabled =
    Options.option (\config -> { config | disabled = True })


type alias State =
    Internal.Checkbox.Model.State


checked : Bool -> Property m
checked value =
    let
        state =
            if value then
                Checked
            else
                Unchecked
    in
    Options.option (\config -> { config | state = Just state })


nativeControl : List (Options.Property () m) -> Property m
nativeControl =
    Options.nativeControl


checkbox : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
checkbox lift model options _ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        animationClass animation =
            case animation of
                Just UncheckedChecked ->
                    cs "mdc-checkbox--anim-unchecked-checked"

                Just UncheckedIndeterminate ->
                    cs "mdc-checkbox--anim-unchecked-indeterminate"

                Just CheckedUnchecked ->
                    cs "mdc-checkbox--anim-checked-unchecked"

                Just CheckedIndeterminate ->
                    cs "mdc-checkbox--anim-checked-indeterminate"

                Just IndeterminateChecked ->
                    cs "mdc-checkbox--anim-indeterminate-checked"

                Just IndeterminateUnchecked ->
                    cs "mdc-checkbox--anim-indeterminate-unchecked"

                Nothing ->
                    Options.nop

        currentState =
            model.lastKnownState
                |> Maybe.withDefault configState

        configState =
            config.state

        stateChangedOrUninitialized =
            (model.lastKnownState == Nothing) || (currentState /= configState)
    in
    Options.apply summary
        Html.div
        [ cs "mdc-checkbox mdc-checkbox--upgraded"
        , cs "mdc-checkbox--indeterminate" |> when (currentState == Nothing)
        , cs "mdc-checkbox--checked" |> when (currentState == Just Checked)
        , cs "mdc-checkbox--disabled" |> when config.disabled
        , animationClass model.animation
        , when stateChangedOrUninitialized <|
            GlobalEvents.onTick (Decode.succeed (lift (Init model.lastKnownState configState)))
        , when (model.animation /= Nothing) <|
            Options.on "animationend" (Decode.succeed (lift AnimationEnd))
        ]
        []
        [ Options.applyNativeControl summary
            Html.input
            [ cs "mdc-checkbox__native-control"
            , Options.many
                << List.map Options.attribute
              <|
                [ Html.type_ "checkbox"
                , Html.id config.id_
                , Html.property "indeterminate" (Encode.bool (currentState == Nothing))
                , Html.checked (currentState == Just Checked)
                , Html.disabled config.disabled
                ]
            , Options.onWithOptions "click"
                (Decode.succeed
                    { message = lift NoOp
                    , preventDefault = True
                    , stopPropagation = False
                    }
                )
            , Options.onWithOptions "change"
                (Decode.succeed
                    { message = lift NoOp
                    , preventDefault = True
                    , stopPropagation = False
                    }
                )
            , Options.onFocus (lift (SetFocus True))
            , Options.onBlur (lift (SetFocus False))
            ]
            []
        , styled Html.div
            [ cs "mdc-checkbox__background"
            ]
            [ Svg.svg
                [ Svg.class "mdc-checkbox__checkmark"
                , Svg.viewBox "0 0 24 24"
                ]
                [ path
                    [ Svg.class "mdc-checkbox__checkmark-path"
                    , Svg.fill "none"
                    , Svg.stroke "white"
                    , Svg.d "M1.73,12.91 8.1,19.28 22.79,4.59"
                    ]
                    []
                ]
            , styled Html.div
                [ cs "mdc-checkbox__mixedmark"
                ]
                []
            ]
        ]


animationState : Maybe State -> Maybe State -> Maybe Animation
animationState oldState state =
    case ( oldState, state ) of
        ( Just Unchecked, Nothing ) ->
            Just UncheckedIndeterminate

        ( Just Checked, Nothing ) ->
            Just CheckedIndeterminate

        ( Nothing, Just Checked ) ->
            Just IndeterminateChecked

        ( Nothing, Just Unchecked ) ->
            Just IndeterminateUnchecked

        ( Just Unchecked, Just Checked ) ->
            Just UncheckedChecked

        ( Just Checked, Just Unchecked ) ->
            Just CheckedUnchecked

        _ ->
            Nothing


type alias Store s =
    { s | checkbox : Indexed Model }


getSet =
    Component.indexed .checkbox (\x y -> { y | checkbox = x }) defaultModel


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
            checkbox
            Internal.Msg.CheckboxMsg
            lift
            index
            store
            (Options.internalId index :: options)


react :
    (Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.CheckboxMsg update



-- TODO: make react always like this ^^^^, don't use generalise?
