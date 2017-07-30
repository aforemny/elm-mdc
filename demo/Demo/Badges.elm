module Demo.Badges exposing (..)

import Html exposing (..)
import Platform.Cmd exposing (Cmd)
import Material.Helpers as Helpers
import Material
import Demo.Code as Code


type Msg
    = Increase
    | Decrease
    | SetCode String
    | CodeBox Code.Msg
    | Mdl (Material.Msg Msg)


type alias Model =
    { unread : Int
    , mdl : Material.Model
    , code : Maybe String
    , codebox : Code.Model
    }


model : Model
model =
    { unread = 1
    , mdl = Material.model
    , code = Nothing
    , codebox = Code.model
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        Decrease ->
            ( { model | unread = model.unread - 1 }
            , List.range 0 7
                |> List.map toFloat
                |> List.map (\i -> Helpers.delay (2 ^ i * 20 + 750) Increase)
                |> Cmd.batch
            )

        Increase ->
            ( { model | unread = model.unread + 1 }
            , Cmd.none
            )

        SetCode code ->
            Code.update (Code.Set code) model.codebox
                |> Helpers.map1st (\codebox -> { model | codebox = codebox })
                |> Helpers.map2nd (Cmd.map CodeBox)

        CodeBox msg_ ->
            Code.update msg_ model.codebox
                |> Helpers.map1st (\codebox -> { model | codebox = codebox })
                |> Helpers.map2nd (Cmd.map CodeBox)



-- VIEW


view : Model -> Html Msg
view model =
    div [] []
