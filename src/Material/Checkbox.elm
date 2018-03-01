module Material.Checkbox exposing
    ( disabled
    , Model
    , Property
    , react
    , checked
    , view
    )

{-|
The MDC Checkbox component is a spec-aligned checkbox component adhering to
the Material Design checkbox requirements.

# Resources

- [Material Design guidelines: Selection Controls – Checkbox](https://material.io/guidelines/components/selection-controls.html#selection-controls-checkbox)
- [Demo](https://aforemny.github.io/elm-mdc/#checkbox)


# Example


```elm
Options.styled Html.div
    [ Options.cs "mdc-form-field"
    ]
    [ Checkbox.view Mdc [0] model.mdc
          [ Checkbox.checked True
          , Options.onClick Toggle
          ]
          []
    , Html.label
          [ Options.onClick Toggle
          ]
          [ text "My checkbox"
          ]
    ]
```


# Usage

@docs Property
@docs view
@docs checked
@docs disabled


# Internal
@docs react
@docs Model
-}

import GlobalEvents
import Html.Attributes as Html
import Html.Events as Html
import Html exposing (Html, text)
import Json.Decode as Json exposing (Decoder)
import Json.Encode
import Material.Component as Component exposing (Indexed)
import Material.Helpers exposing (blurOn, filter, noAttr)
import Material.Internal.Checkbox exposing (Msg(..), Animation(..), State(..))
import Material.Internal.Options as Internal
import Material.Msg exposing (Index)
import Material.Options as Options exposing (Style, cs, styled, many, when, maybe)
import Svg.Attributes as Svg
import Svg exposing (path)


{-| Checkbox model.

Internal use only.
-}
type alias Model =
    { isFocused : Bool
    , lastKnownState : Maybe (Maybe State)
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
    { state : Maybe State
    , disabled : Bool
    }


defaultConfig : Config
defaultConfig =
    { state = Nothing
    , disabled = False
    }


{-| Checkbox property.
-}
type alias Property m =
    Options.Property Config m


{-| Disable the checkbox.
-}
disabled : Property m
disabled =
    Internal.option (\ config -> { config | disabled = True })


type alias State =
    Material.Internal.Checkbox.State


{-| Set checked state to True or False.

If not set, the checkbox will be in indeterminate state.
-}
checked : Bool -> Property m
checked value =
    let
        state =
            if value then Checked else Unchecked
    in
    Internal.option (\ config -> { config | state = Just state })


checkbox : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
checkbox lift model options _ =
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
          config.state

        stateChangedOrUninitialized =
          (model.lastKnownState == Nothing) || (currentState /= configState)
    in
    Internal.apply summary Html.div
    [ cs "mdc-checkbox mdc-checkbox--upgraded"
    , cs "mdc-checkbox--indeterminate" |> when (currentState == Nothing)
    , cs "mdc-checkbox--checked" |> when (currentState == Just Checked)
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
          , Html.property "indeterminate" (Json.Encode.bool (currentState == Nothing))
          , Html.checked (currentState == Just Checked)
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


( get, set ) =
    Component.indexed .checkbox (\x y -> { y | checkbox = x }) defaultModel


{-| Checkbox view.
-}
view :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view lift index store options =
    Component.render get checkbox Material.Msg.CheckboxMsg lift index store
        (Internal.dispatch lift :: options)


{-| Checkbox react.

Internal use only.
-}
react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.CheckboxMsg update
    -- TODO: make react always like this ^^^^, don't use generalise?
