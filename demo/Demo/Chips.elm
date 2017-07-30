module Demo.Chips exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)


--import Html.Events as Html

import Material
import Dict exposing (Dict)


-- MODEL


type alias Model =
    { mdl : Material.Model
    , chips : Dict Int String
    , value : String
    , details : String
    }


model : Model
model =
    { mdl = Material.model
    , chips = Dict.fromList [ ( 1, "Amazing Chip 1" ) ]
    , value = ""
    , details = ""
    }



-- ACTION, UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | AddChip String
    | RemoveChip Int
    | ChipClick Int


lastIndex : Dict Int b -> Int
lastIndex dict =
    Dict.keys dict
        |> List.reverse
        |> List.head
        |> Maybe.withDefault 0


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        ChipClick index ->
            let
                details =
                    Maybe.withDefault ""
                        (Dict.get index model.chips)
            in
                ( { model | details = details }, Cmd.none )

        AddChip content ->
            let
                index =
                    1 + lastIndex model.chips

                model_ =
                    { model | chips = Dict.insert index (content ++ " " ++ toString index) model.chips }
            in
                ( model_, Cmd.none )

        RemoveChip index ->
            let
                d_ =
                    Maybe.withDefault ""
                        (Dict.get index model.chips)

                details =
                    if d_ == model.details then
                        ""
                    else
                        model.details

                model_ =
                    { model
                        | chips = Dict.remove index model.chips
                        , details = details
                    }
            in
                ( model_, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [] []
