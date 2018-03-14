module Material.Internal.Fab.Implementation exposing
    ( exited
    , mini
    , Property
    , react
    , ripple
    , view
    )

import Html exposing (Html, text)
import Material.Internal.Component as Component exposing (Indexed, Index)
import Material.Internal.Fab.Model exposing (Model, defaultModel, Msg(..))
import Material.Internal.Msg
import Material.Internal.Options as Options exposing (styled, cs, css, when)
import Material.Internal.Options.Internal as Internal
import Material.Internal.Ripple.Implementation as Ripple


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RippleMsg msg_ ->
            let
                ( ripple, effects ) =
                    Ripple.update msg_ model.ripple
            in
            ( { model | ripple = ripple }, Cmd.map RippleMsg effects )

        NoOp ->
            ( model, Cmd.none )


type alias Config =
    { ripple : Bool
    }


defaultConfig : Config
defaultConfig =
    { ripple = False
    }


type alias Property m =
    Options.Property Config m


mini : Property m
mini =
    cs "mdc-fab--mini"


exited : Property m
exited =
    cs "mdc-fab--exited"


ripple : Property m
ripple =
    Internal.option (\config -> { config | ripple = True })


fab : (Msg -> m) -> Model -> List (Property m) -> String -> Html m
fab lift model options icon =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        ripple =
            Ripple.view False (lift << RippleMsg) model.ripple []
    in
        Internal.apply summary
            Html.button
            [ cs "mdc-fab"
            , cs "material-icons"
            , when config.ripple << Options.many <|
              [ ripple.interactionHandler
              , ripple.properties
              ]
            ]
            []
            ( List.concat
              [ [ styled Html.span
                  [ cs "mdc-fab__icon"
                  ]
                  [ text icon
                  ]
                ]
              ,
                if config.ripple then
                    [ ripple.style ]
                else
                    []
              ]
            )


type alias Store s =
    { s | fab : Indexed Model }


( get, set ) =
    Component.indexed .fab (\x y -> { y | fab = x }) defaultModel


view :
    (Material.Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> String
    -> Html m
view =
    Component.render get fab Material.Internal.Msg.FabMsg


react :
    (Material.Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Internal.Msg.FabMsg (Component.generalise update)
