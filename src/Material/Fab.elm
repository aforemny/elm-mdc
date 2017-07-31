module Material.Fab
    exposing
        ( Model
        , defaultModel
        , Msg
        , update
        , view
        , mini
        , plain
        , disabled
        , Property
        , render
        , react
        )

import Html.Attributes exposing (..)
import Html exposing (..)
import Material.Component as Component exposing (Indexed, Index)
import Material.Internal.Fab exposing (Msg(..))
import Material.Internal.Options as Internal
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)

-- MODEL


{-|
-}
type alias Model =
    {}


{-|
-}
defaultModel : Model
defaultModel =
    {}



-- ACTION, UPDATE

{-|
-}
type alias Msg =
    Material.Internal.Fab.Msg


{-| Component update.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    model ! []



-- VIEW


type alias Config =
    { disabled : Bool
    }


defaultConfig : Config
defaultConfig =
    { disabled = False
    }


{-| Properties for Button options.
-}
type alias Property m =
    Options.Property Config m


{-| TODO
-}
plain : Property m
plain =
    cs "mdc-fab--plain"


{-| TODO
-}
mini : Property m
mini =
    cs "mdc-fab--mini"


{-| TODO
-}
disabled : Property m
disabled =
    (\options -> { options | disabled = True })
        |> Internal.option


{-| Component view function.
-}
view : (Msg -> m) -> Model -> List (Property m) -> String -> Html m
view lift model options icon =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options
    in
        Internal.apply summary
            Html.button
            [ cs "mdc-fab"
            , cs "material-icons"
            , Internal.attribute (Html.Attributes.disabled True)
                |> when config.disabled
            , cs "mdc-fab--disabled"
                |> when config.disabled
            ]
            []
            [ styled Html.span
              [ cs "mdc-fab__icon"
              ]
              [ text icon
              ]
            ]


-- COMPONENT


type alias Store s =
    { s | fab : Indexed Model }


( get, set ) =
    Component.indexed .fab (\x y -> { y | fab = x }) defaultModel


{-| Component react function (update variant). Internal use only.
-}
react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.FabMsg (Component.generalise update)


{-| TODO
-}
render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> String
    -> Html m
render =
    Component.render get view Material.Msg.FabMsg
