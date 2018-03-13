module Material.Internal.Button.Implementation exposing
    ( compact
    , dense
    , disabled
    , icon
    , link
    , Model
    , Property
    , raised
    , react
    , ripple
    , stroked
    , unelevated
    , view
    )

import Html.Attributes as Html
import Html exposing (Html, text)
import Material.Internal.Button.Model exposing (Msg(..))
import Material.Internal.Component as Component exposing (Indexed, Index)
import Material.Internal.Icon.Implementation as Icon
import Material.Internal.Msg
import Material.Internal.Options as Options exposing (cs, css, when)
import Material.Internal.Options.Internal as Internal
import Material.Internal.Ripple.Implementation as Ripple


type alias Model =
    { ripple : Ripple.Model
    }


defaultModel : Model
defaultModel =
    { ripple = Ripple.defaultModel
    }


type alias Msg =
    Material.Internal.Button.Model.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RippleMsg msg_ ->
            let
                ( ripple, effects ) =
                    Ripple.update msg_ model.ripple
            in
            ( { model | ripple = ripple }, Cmd.map RippleMsg effects )


type alias Config =
    { ripple : Bool
    , link : Maybe String
    , disabled : Bool
    , icon : Maybe String
    }


defaultConfig : Config
defaultConfig =
    { ripple = False
    , link = Nothing
    , disabled = False
    , icon = Nothing
    }


type alias Property m =
    Options.Property Config m


icon : String -> Property m
icon str =
    Internal.option (\ config -> { config | icon = Just str })


raised : Property m
raised =
    cs "mdc-button--raised"


unelevated : Property m
unelevated =
    cs "mdc-button--unelevated"


stroked : Property m
stroked =
    cs "mdc-button--stroked"


dense : Property m
dense =
    cs "mdc-button--dense"


compact : Property m
compact =
    cs "mdc-button--compact"


ripple : Property m
ripple =
    Internal.option (\options -> { options | ripple = True })


link : String -> Property m
link href =
    Internal.option (\options -> { options | link = Just href })


disabled : Property m
disabled =
    Internal.option (\options -> { options | disabled = True })


button : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
button lift model options nodes =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        ripple =
            Ripple.view False (lift << RippleMsg) model.ripple []
    in
        Internal.apply summary
            (if config.link /= Nothing then Html.a else Html.button)
            [ cs "mdc-button"
            , cs "mdc-js-button"
            , cs "mdc-js-ripple-effect" |> when summary.config.ripple
            , css "box-sizing" "border-box"
            , Internal.attribute (Html.href (Maybe.withDefault "" config.link) )
                |> when ((config.link /= Nothing) && not config.disabled)
            , Internal.attribute (Html.disabled True)
                |> when config.disabled
            , cs "mdc-button--disabled"
                |> when config.disabled
            , when config.ripple << Options.many <|
              [ ripple.interactionHandler
              , ripple.properties
              ]
            ]
            []
            ( List.concat
              [
                config.icon
                |> Maybe.map (\ icon ->
                     [ Icon.view [ cs "mdc-button__icon" ] icon
                     ]
                   )
                |> Maybe.withDefault []
              ,
                nodes
              ,
                [ ripple.style
                ]
              ]
            )


type alias Store s =
    { s | button : Indexed Model }


( get, set ) =
    Component.indexed .button (\x y -> { y | button = x }) defaultModel


view :
    (Material.Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render get button Material.Internal.Msg.ButtonMsg


react :
    (Material.Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Internal.Msg.ButtonMsg (Component.generalise update)
