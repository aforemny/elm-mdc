module Internal.Chip.Implementation
    exposing
        ( Property
        , checkmark
        , chipset
        , choice
        , filter
        , input
        , leadingIcon
        , onClick
        , react
        , selected
        , trailingIcon
        , view
        )

import Html exposing (Html, text)
import Html.Attributes as Html
import Html.Events as Html
import Internal.Chip.Model exposing (Key, KeyCode, Model, Msg(..), defaultModel)
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Helpers as Helpers
import Internal.Icon.Implementation as Icon
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Internal.Ripple.Implementation as Ripple
import Json.Decode as Json exposing (Decoder)
import Svg exposing (path)
import Svg.Attributes as Svg


update : (Msg m -> m) -> Msg m -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    case msg of
        RippleMsg msg_ ->
            let
                ( ripple, cmd ) =
                    Ripple.update msg_ model.ripple
            in
            ( Just { model | ripple = ripple }, Cmd.map (lift << RippleMsg) cmd )

        Click msg_ ->
            ( Nothing, Helpers.delayedCmd 150 msg_ )


type alias Config m =
    { leadingIcon : Maybe String
    , trailingIcon : Maybe String
    , onClick : Maybe m
    , selected : Bool
    , checkmark : Bool
    }


defaultConfig : Config m
defaultConfig =
    { leadingIcon = Nothing
    , trailingIcon = Nothing
    , onClick = Nothing
    , selected = False
    , checkmark = False
    }


type alias Property m =
    Options.Property (Config m) m


leadingIcon : String -> Property m
leadingIcon str =
    Options.option (\config -> { config | leadingIcon = Just str })


trailingIcon : String -> Property m
trailingIcon str =
    Options.option (\config -> { config | trailingIcon = Just str })


selected : Property m
selected =
    Options.option (\config -> { config | selected = True })


checkmark : Property m
checkmark =
    Options.option (\config -> { config | checkmark = True })


onClick : m -> Property m
onClick msg =
    let
        trigger key keyCode =
            let
                isEnter =
                    key == "Enter" || keyCode == 13
            in
            if isEnter then
                Json.succeed msg
            else
                Json.fail ""
    in
    Options.many
        [ Options.onClick msg
        , Options.on "keyup" (Json.map2 trigger decodeKey decodeKeyCode |> Json.andThen identity)
        ]


decodeKey : Decoder Key
decodeKey =
    Json.at [ "key" ] Json.string


decodeKeyCode : Decoder KeyCode
decodeKeyCode =
    Html.keyCode


chipset : List (Property m) -> List (Html m) -> Html m
chipset options nodes =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
    Options.apply summary
        Html.div
        [ cs "mdc-chip-set"
        ]
        []
        nodes


filter : Property m
filter =
    cs "mdc-chip-set--filter"


choice : Property m
choice =
    cs "mdc-chip-set--choice"


input : Property m
input =
    cs "mdc-chip-set--input"


chip : (Msg m -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
chip lift model options nodes =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        ripple =
            Ripple.view False (lift << RippleMsg) model.ripple []
    in
    Options.apply summary
        Html.div
        [ cs "mdc-chip"
        , when config.selected (cs "mdc-chip--selected")
        , cs "mdc-js-ripple-effect"
        , Options.many
            [ ripple.interactionHandler
            , ripple.properties
            ]
        , config.onClick
            |> Maybe.map (Options.onClick << lift << Click)
            |> Maybe.withDefault Options.nop
        , Options.attribute (Html.tabindex 0)
        ]
        []
        (List.concat
            [ config.leadingIcon
                |> Maybe.map
                    (\icon ->
                        [ Icon.view
                            [ cs "mdc-chip__icon mdc-chip__icon--leading"
                            , when (config.selected && config.checkmark) <|
                                cs "mdc-chip__icon--leading-hidden"
                            , -- Make icon size fixed during animation
                              css "font-size" "20px"
                            ]
                            icon
                        ]
                    )
                |> Maybe.withDefault []
            , [ if config.checkmark then
                    styled Html.div
                        [ cs "mdc-chip__checkmark" ]
                        [ Svg.svg
                            [ Svg.class "mdc-chip__checkmark-svg"
                            , Svg.viewBox "-2 -3 30 30"
                            ]
                            [ path
                                [ Svg.class "mdc-chip__checkmark-path"
                                , Svg.fill "none"
                                , Svg.stroke "white"
                                , Svg.d "M1.73,12.91 8.1,19.28 22.79,4.59"
                                ]
                                []
                            ]
                        ]
                else
                    text ""
              ]
            , [ styled Html.div [ cs "mdc-chip__text" ] nodes ]
            , config.trailingIcon
                |> Maybe.map
                    (\icon ->
                        [ Icon.view
                            [ cs "mdc-chip__icon mdc-chip__icon--trailing"
                            , Options.attribute (Html.tabindex 0)
                            , Options.role "button"
                            ]
                            icon
                        ]
                    )
                |> Maybe.withDefault []
            , [ ripple.style
              ]
            ]
        )


type alias Store s =
    { s | chip : Indexed Model }


( get, set ) =
    Component.indexed .chip (\x y -> { y | chip = x }) defaultModel


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render get chip Internal.Msg.ChipMsg


react :
    (Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Internal.Msg.ChipMsg update
