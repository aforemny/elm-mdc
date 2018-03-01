module Material.Checkbox
    exposing
        ( checked
        , defaultModel
        , disabled
        , indeterminate
        , Model
        , Msg
        , Property
        , react
        , render
        , Store
        , update
        , view
        )

{-| The MDC Checkbox component is a spec-aligned checkbox component adhering to
the Material Design checkbox requirements.

## Design & API Documentation

- [Material Design guidelines: Selection Controls – Checkbox](https://material.io/guidelines/components/selection-controls.html#selection-controls-checkbox)
- [Demo](https://aforemny.github.io/elm-mdc/#checkbox)

## View
@docs view

## Properties
@docs Property
@docs disabled, checked, indeterminate

## TEA architecture
@docs Model, defaultModel, Msg, update

## Featured render
@docs render
@docs Store, react
-}

import GlobalEvents
import Html.Attributes as Html
import Html.Events as Html
import Html exposing (Html, text)
import Json.Decode as Json exposing (Decoder)
import Json.Encode
import Material.Component as Component exposing (Indexed)
import Material.Helpers exposing (blurOn, filter, noAttr)
import Material.Internal.Checkbox exposing (Msg(..), Animation(..), State)
import Material.Internal.Options as Internal
import Material.Msg exposing (Index)
import Material.Options as Options exposing (Style, cs, styled, many, when, maybe)
import Svg.Attributes as Svg
import Svg exposing (path)


type alias Model =
    { isFocused : Bool
    , lastKnownState : Maybe State
    , animation : Maybe Animation
    }


defaultModel : Model
defaultModel =
    { isFocused = False
    , lastKnownState = Nothing
    , animation = Nothing
    }


type alias Msg
    = Material.Internal.Checkbox.Msg


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
                |> Maybe.andThen (flip animationState state)
            in
            ( Just
              { model
                | lastKnownState = Just state
                , animation = animation
              }
            ,
              Cmd.none
            )

        AnimationEnd ->
            ( Just { model | animation = Nothing }, Cmd.none )


type alias Config =
    { checked : Bool
    , indeterminate : Bool
    , disabled : Bool
    }


defaultConfig : Config
defaultConfig =
    { checked = False
    , indeterminate = False
    , disabled = False
    }


type alias Property m =
    Options.Property Config m


disabled : Property m
disabled =
    Internal.option (\ config -> { config | disabled = True })


checked : Property m
checked =
    Internal.option (\ config -> { config | checked = True })


indeterminate : Property m
indeterminate =
    Internal.option (\ config -> { config | indeterminate = True })


view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

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
          { checked = config.checked
          , indeterminate = config.indeterminate
          }

        stateChangedOrUninitialized =
          (model.lastKnownState == Nothing) || (currentState /= configState)
    in
    Internal.apply summary Html.div
    [ cs "mdc-checkbox mdc-checkbox--upgraded"
    , cs "mdc-checkbox--indeterminate" |> when currentState.indeterminate
    , cs "mdc-checkbox--checked" |> when currentState.checked
    , cs "mdc-checkbox--disabled" |> when config.disabled
    , animationClass model.animation
    , Internal.attribute <| blurOn "mouseup"
    , when stateChangedOrUninitialized <|
      Options.many << List.map Options.attribute <|
      GlobalEvents.onTick (Json.succeed (lift (Init model.lastKnownState configState)))
    , when (model.animation /= Nothing) <|
      Options.on "animationend" (Json.succeed (lift AnimationEnd))
    ]
    []
    [
        styled Html.input
        [ cs "mdc-checkbox__native-control"
        , Options.many << List.map Internal.attribute <|
          [ Html.type_ "checkbox"
          , Html.property "indeterminate" (Json.Encode.bool currentState.indeterminate)
          , Html.checked currentState.checked
          , Html.disabled config.disabled
          , Html.onWithOptions "click"
              { preventDefault = True
              , stopPropagation = False
              }
              (Json.succeed (lift NoOp))
          , Html.onWithOptions "change"
              { preventDefault = True
              , stopPropagation = False
              }
              (Json.succeed (lift NoOp))
          ]
        , Internal.on1 "focus" lift (SetFocus True)
        , Internal.on1 "blur" lift (SetFocus False)
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
          [
          ]
        ]
      , styled Html.div
        [ cs "mdc-checkbox__mixedmark"
        ]
        []
      ]
    ]

animationState : State -> State -> Maybe Animation
animationState oldState state =
  case ( oldState.indeterminate, oldState.checked, state.indeterminate, state.checked ) of
      ( _, False, True, _ ) ->
        Just UncheckedIndeterminate

      ( _, True, True, _ ) ->
        Just CheckedIndeterminate

      ( True, _, _, True ) ->
        Just IndeterminateChecked

      ( True, _, _, False ) ->
        Just IndeterminateUnchecked

      ( _, False, _, True ) ->
        Just UncheckedChecked

      ( _, True, _, False ) ->
        Just CheckedUnchecked
      
      _ ->
        Nothing


type alias Store s =
    { s | checkbox : Indexed Model }


( get, set ) =
    Component.indexed .checkbox (\x y -> { y | checkbox = x }) defaultModel


render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render lift index store options =
    Component.render get view Material.Msg.CheckboxMsg lift index store
        (Internal.dispatch lift :: options)


react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.CheckboxMsg update
    -- TODO: make react always like this ^^^^, don't use generalise?
