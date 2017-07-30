module Demo.Loading exposing (..)

import Html exposing (Html, text)
import Material.Options as Options exposing (div, css, cs, when)
import Material
import Material.Helpers as Helpers exposing (map2nd)
--import Material.Typography as Typography


type alias Model =
    { mdl : Material.Model
    , running : Bool
    , progress : Float
    }


model : Model
model =
    { mdl = Material.model
    , running = False
    , progress = 14
    }


type Msg
    = Tick
    | Toggle
    | Mdl (Material.Msg Msg)



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        -- 'Simulate' a process that takes some time
        Tick ->
            let
                nextProgress =
                    model.progress + 1

                progress =
                    if nextProgress > 100 then
                        0
                    else
                        nextProgress

                finishedLoading =
                    nextProgress > 100
            in
                ( { model
                    | progress = progress
                    , running = model.running && not finishedLoading
                  }
                , if model.running && not finishedLoading then
                    Helpers.delay 100 Tick
                  else
                    Cmd.none
                )

        Toggle ->
            ( { model | running = not model.running }
            , if model.running == False then
                Helpers.delay 200 Tick
              else
                Cmd.none
            )

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


view : Model -> Html Msg
view model =
    div [] []
