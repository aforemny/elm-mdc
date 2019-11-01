module Internal.Button.Implementation exposing
    ( Property
    , dense
    , disabled
    , icon
    , label
    , link
    , onClick
    , outlined
    , raised
    , react
    , ripple
    , trailingIcon
    , unelevated
    , view
    )

import Html exposing (Html)
import Html.Attributes as Html
import Internal.Button.Model exposing (Model, Msg(..), defaultModel)
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Helpers as Helpers
import Internal.Icon.Implementation as Icon
import Internal.Msg
import Internal.Options as Options exposing (cs, when)
import Internal.Ripple.Implementation as Ripple


update : (Msg m -> m) -> Msg m -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    case msg of
        RippleMsg msg_ ->
            let
                ( rippleState, rippleCmd ) =
                    Ripple.update msg_ model.ripple
            in
            ( Just { model | ripple = rippleState }
            , Cmd.map (lift << RippleMsg) rippleCmd
            )

        Click doRipple msg_ ->
            ( Nothing
            , Helpers.delayedCmd
                (if doRipple then
                    150

                 else
                    0
                )
                msg_
            )


type alias Config m =
    { ripple : Bool
    , label : Maybe String
    , link : Maybe String
    , disabled : Bool
    , icon : Maybe String
    , onClick : Maybe m
    , trailingIcon : Bool
    }


defaultConfig : Config m
defaultConfig =
    { ripple = False
    , label = Nothing
    , link = Nothing
    , disabled = False
    , icon = Nothing
    , onClick = Nothing
    , trailingIcon = False
    }


type alias Property m =
    Options.Property (Config m) m


label : String -> Property m
label str =
    Options.option (\config -> { config | label = Just str })


icon : String -> Property m
icon str =
    Options.option (\config -> { config | icon = Just str })


trailingIcon : String -> Property m
trailingIcon str =
    Options.option (\config -> { config | icon = Just str, trailingIcon = True })


raised : Property m
raised =
    cs "mdc-button--raised"


unelevated : Property m
unelevated =
    cs "mdc-button--unelevated"


outlined : Property m
outlined =
    cs "mdc-button--outlined"


dense : Property m
dense =
    cs "mdc-button--dense"


ripple : Property m
ripple =
    Options.option (\options -> { options | ripple = True })


link : String -> Property m
link href =
    Options.option (\options -> { options | link = Just href })


disabled : Property m
disabled =
    Options.option (\options -> { options | disabled = True })


onClick : m -> Property m
onClick handler =
    Options.option (\options -> { options | onClick = Just handler })


button : Index -> (Msg m -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
button domId lift model options nodes =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        rippleInterface =
            Ripple.view False domId (lift << RippleMsg) model.ripple []
    in
    Options.apply summary
        (if config.link /= Nothing then
            Html.a

         else
            Html.button
        )
        [ cs "mdc-button"
        , cs "mdc-js-button"
        , cs "mdc-js-ripple-effect" |> when summary.config.ripple
        , Options.attribute (Html.href (Maybe.withDefault "" config.link))
            |> when ((config.link /= Nothing) && not config.disabled)
        , Options.attribute (Html.disabled True)
            |> when config.disabled
        , cs "mdc-button--disabled"
            |> when config.disabled
        , when config.ripple
            << Options.many
          <|
            [ rippleInterface.interactionHandler
            , rippleInterface.properties
            ]
        , config.onClick
            |> Maybe.map (Options.onClick << lift << Click config.ripple)
            |> Maybe.withDefault Options.nop
        ]
        []
        (List.concat
            [ if not config.trailingIcon then
                config.icon
                    |> Maybe.map
                        (\icon_ -> [ Icon.view [ cs "mdc-button__icon" ] icon_ ])
                    |> Maybe.withDefault []

              else
                []
            , config.label
                |> Maybe.map (\label_ -> [ Html.span [ Html.class "mdc-button__label" ] [ Html.text label_ ] ])
                |> Maybe.withDefault []
            , nodes
            , if config.trailingIcon then
                config.icon
                    |> Maybe.map
                        (\icon_ -> [ Icon.view [ cs "mdc-button__icon" ] icon_ ])
                    |> Maybe.withDefault []

              else
                []
            ]
        )


type alias Store s =
    { s | button : Indexed Model }


getSet :
    { get : Index -> { a | button : Indexed Model } -> Model
    , set :
        Index
        -> { a | button : Indexed Model }
        -> Model
        -> { a | button : Indexed Model }
    }
getSet =
    Component.indexed .button (\x y -> { y | button = x }) defaultModel


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    \lift index ->
        Component.render getSet.get (button index) Internal.Msg.ButtonMsg lift index


react :
    (Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.ButtonMsg update
