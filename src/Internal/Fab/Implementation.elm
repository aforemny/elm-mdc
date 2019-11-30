module Internal.Fab.Implementation exposing
    ( Property
    , exited
    , extended
    , icon
    , iconClass
    , label
    , mini
    , react
    , ripple
    , view
    )

import Html exposing (Html, text, div)
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Fab.Model exposing (Model, Msg(..), defaultModel)
import Internal.Msg
import Internal.Options as Options exposing (cs, styled, when)
import Internal.Ripple.Implementation as Ripple


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RippleMsg msg_ ->
            let
                ( rippleState, rippleCmd ) =
                    Ripple.update msg_ model.ripple
            in
            ( { model | ripple = rippleState }, Cmd.map RippleMsg rippleCmd )

        NoOp ->
            ( model, Cmd.none )


type alias Config =
    { ripple : Bool
    , icon : Maybe String
    }


defaultConfig : Config
defaultConfig =
    { ripple = False
    , icon = Nothing
    }


type alias Property m =
    Options.Property Config m


icon : String -> Property m
icon name =
    Options.option (\config -> { config | icon = Just name })


iconClass : Property m
iconClass =
    cs "mdc-fab__icon"


mini : Property m
mini =
    cs "mdc-fab--mini"


extended : Property m
extended =
    cs "mdc-fab--extended"


label : Property m
label =
    cs "mdc-fab__label"


exited : Property m
exited =
    cs "mdc-fab--exited"


ripple : Property m
ripple =
    Options.option (\config -> { config | ripple = True })


fab : Index -> (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
fab domId lift model options nodes =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        rippleInterface =
            Ripple.view False domId (lift << RippleMsg) model.ripple []

        iconSpan =
            case config.icon of
                Just name ->
                    styled Html.i
                        [ iconClass
                        , cs "material-icons"
                        ]
                        [ text name ]

                Nothing ->
                    text ""
    in
    Options.apply summary
        Html.button
        [ cs "mdc-fab"
        , when config.ripple
            << Options.many
          <|
            [ rippleInterface.interactionHandler
            , rippleInterface.properties
            ]
        ]
        []
        (List.concat
            [ [ styled div
                  [ cs "mdc-fab__ripple" ]
                  []
              , iconSpan
              ]
            , nodes
            ]
        )


type alias Store s =
    { s | fab : Indexed Model }


getSet :
    { get : Index -> { a | fab : Indexed Model } -> Model
    , set :
        Index
        -> { a | fab : Indexed Model }
        -> Model
        -> { a | fab : Indexed Model }
    }
getSet =
    Component.indexed .fab (\x y -> { y | fab = x }) defaultModel


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    \lift domId ->
        Component.render getSet.get (fab domId) Internal.Msg.FabMsg lift domId


react :
    (Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.FabMsg (Component.generalise update)
