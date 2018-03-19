module Material.Internal.Switch.Implementation exposing
    ( disabled
    , nativeControl
    , on
    , Property
    , react
    , view
    )

import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Material.Internal.Component as Component exposing (Indexed, Index)
import Material.Internal.Msg
import Material.Internal.Options as Options exposing (cs, styled, many, when)
import Material.Internal.Options.Internal as Internal
import Material.Internal.Switch.Model exposing (Model, defaultModel, Msg(..))


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
    }


defaultConfig : Config m
defaultConfig =
    { value = False
    , disabled = False
    , nativeControl = []
    }


type alias Property m =
    Options.Property (Config m) m


disabled : Property m
disabled =
    Internal.option (\ config -> { config | disabled = True })


on : Property m
on =
    Internal.option (\config -> { config | value = True })


nativeControl : List (Options.Property () m) -> Property m
nativeControl =
    Internal.nativeControl


switch : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
switch lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        preventDefault =
          { preventDefault = True
          , stopPropagation = False
          }
    in
    Internal.apply summary Html.div
    [ cs "mdc-switch"
    ]
    []
    [ Internal.applyNativeControl summary
      Html.input
      [ cs "mdc-switch__native-control"
      , Internal.attribute <| Html.type_ "checkbox"
      , Internal.attribute <| Html.checked config.value
      , Options.onFocus (lift (SetFocus True))
      , Options.onBlur (lift (SetFocus False))
      , Options.onWithOptions "click" preventDefault (Json.succeed (lift NoOp))
      , when config.disabled << Options.many <|
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
        [
        ]
      ]
    ]


type alias Store s =
    { s | switch : Indexed Model }


( get, set ) =
    Component.indexed .switch (\x y -> { y | switch = x }) defaultModel


react :
    (Material.Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Internal.Msg.SwitchMsg update


view :
    (Material.Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view lift index store options =
    Component.render get switch Material.Internal.Msg.SwitchMsg lift index store
        (Internal.dispatch lift :: options)
