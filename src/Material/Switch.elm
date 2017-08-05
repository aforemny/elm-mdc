module Material.Switch
    exposing
        ( Model
        , defaultModel
        , Msg
        , update
        , Config
        , view
        , render
        , disabled
        , on
        , react
        )

{-| TODO
-}

import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json
import Material.Component as Component exposing (Indexed)
import Material.Helpers exposing (map1st, map2nd, blurOn, filter, noAttr)
import Material.Internal.Options as Internal
import Material.Internal.Switch exposing (Msg(..))
import Material.Msg exposing (Index)
import Material.Options as Options exposing (Style, cs, styled, many, when, maybe)

-- MODEL


{-| Component model.
-}
type alias Model =
    { isFocused : Bool
    }


{-| Default component model.
-}
defaultModel : Model
defaultModel =
    { isFocused = False
    }



-- ACTION, UPDATE


{-| Component message.
-}
type alias Msg
    = Material.Internal.Switch.Msg


{-| Component update.
-}
update : x -> Msg -> Model -> ( Maybe Model, Cmd m )
update _ msg model =
    case msg of
        SetFocus focus ->
            ( Just { model | isFocused = focus }, Cmd.none )
        NoOp ->
            ( Nothing, Cmd.none )


-- OPTIONS


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


{-| TODO
-}
type alias Property m =
    Options.Property (Config m) m


{-| TODO
-}
disabled : Property m
disabled =
    Options.many
    [ cs "mdc-checkbox--disabled"
    , Internal.input
      [ Internal.attribute <| Html.disabled True
      ]
    ]


{-| TODO
-}
on : Property m
on =
    Internal.option (\config -> { config | value = True })


-- VIEW


{-| Component view.
-}
view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options
    in
    Internal.applyContainer summary Html.div
    [ cs "mdc-switch"
    , Internal.attribute <| blurOn "mouseup"
    ]
    [ Internal.applyInput summary
        Html.input
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


-- COMPONENT


type alias Store s =
    { s | switch : Indexed Model }


( get, set ) =
    Component.indexed .switch (\x y -> { y | switch = x }) defaultModel


{-| Component react function.
-}
react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.SwitchMsg update


{-| Component render (checkbox)
-}
render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render lift index store options =
    Component.render get view Material.Msg.SwitchMsg lift index store
        (Internal.dispatch lift :: options)
