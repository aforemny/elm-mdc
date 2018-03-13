module Material.Internal.Switch.Implementation exposing
    ( disabled
    , Model
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
import Material.Internal.Switch.Model exposing (Msg(..))


type alias Model =
    { isFocused : Bool
    }


defaultModel : Model
defaultModel =
    { isFocused = False
    }



type alias Msg
    = Material.Internal.Switch.Model.Msg


update : x -> Msg -> Model -> ( Maybe Model, Cmd m )
update _ msg model =
    case msg of
        SetFocus focus ->
            ( Just { model | isFocused = focus }, Cmd.none )
        NoOp ->
            ( Nothing, Cmd.none )


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


on : Property m
on =
    Internal.option (\config -> { config | value = True })


switch : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
switch lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options
    in
    Internal.apply summary Html.div
    [ cs "mdc-switch"
    ]
    []
    [ styled Html.input
      [ cs "mdc-switch__native-control"
      , Internal.attribute <| Html.type_ "checkbox"
      , Internal.attribute <| Html.checked config.value
      , Internal.on1 "focus" lift (SetFocus True)
      , Internal.on1 "blur" lift (SetFocus False)
      , Options.onWithOptions "click"
          { preventDefault = True
          , stopPropagation = False
          }
          (Json.succeed (lift NoOp))
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
