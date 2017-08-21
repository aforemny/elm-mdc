module Material.Checkbox
    exposing
        ( -- VIEW
          view
        , Property
        , disabled
        , checked
        , indeterminate

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

import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Json.Encode
import Material.Component as Component exposing (Indexed)
import Material.Helpers exposing (map1st, map2nd, blurOn, filter, noAttr)
import Material.Internal.Checkbox exposing (Msg(..))
import Material.Internal.Options as Internal
import Material.Msg exposing (Index)
import Material.Options as Options exposing (Style, cs, styled, many, when, maybe)
import Svg.Attributes as Svg
import Svg exposing (path)


type alias Model =
    { isFocused : Bool
    }


defaultModel : Model
defaultModel =
    { isFocused = False
    }


type alias Msg
    = Material.Internal.Checkbox.Msg


update : (Msg -> m) -> Msg -> Model -> ( Maybe Model, Cmd m )
update _ msg model =
    case msg of
        SetFocus focus ->
            ( Just { model | isFocused = focus }, Cmd.none )
        NoOp ->
            ( Nothing, Cmd.none )


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


type alias Property m =
    Options.Property (Config m) m


disabled : Property m
disabled =
    Options.many
    [ cs "mdc-checkbox--disabled"
    , Internal.input
      [ Internal.attribute <| Html.disabled True
      ]
    ]


checked : Property m
checked =
    Internal.option (\config -> { config | value = True })


indeterminate : Property m
indeterminate =
    Internal.input
    [ Internal.attribute <| Html.property "indeterminate" (Json.Encode.bool True)
    ]


view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options
    in
    Internal.applyContainer summary Html.div
    [ cs "mdc-checkbox"
    , Internal.attribute <| blurOn "mouseup"
    ]
    [ Internal.applyInput summary
        Html.input
        [ cs "mdc-checkbox__native-control"
        , Internal.attribute <| Html.type_ "checkbox"
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
      [ cs "mdc-checkbox__background"
      ]
      [ Svg.svg
        [ Svg.class "mdc-checkbox__checkmark"
        , Svg.viewBox "0 0 24 24"
        ]
        [ path
          [ Svg.class "mdc-checkbox__checkmark__path"
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
