module Demo.Toggles exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Array
import Bitwise
import Material.Helpers as Helpers
import Material


-- MODEL


type alias Model =
    { mdl : Material.Model
    , toggles : Array.Array Bool
    , radios : Int
    , counter : Int
    , counting : Bool
    }


model : Model
model =
    { mdl = Material.model
    , toggles = Array.fromList [ True, False ]
    , radios = 2
    , counter = 0
    , counting = False
    }



-- ACTION, UPDATE


type Msg
    = Mdl (Material.Msg Msg)
    | Switch Int
    | Radio Int
    | Inc
    | Update (Model -> Model)
    | ToggleCounting
    | AutoCount


get : Int -> Model -> Bool
get k model =
    Array.get k model.toggles |> Maybe.withDefault False


delay : Float
delay =
    150


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Switch k ->
            ( { model
                | toggles = Array.set k (get k model |> not) model.toggles
              }
            , none
            )

        Radio k ->
            ( { model | radios = k }, none )

        Inc ->
            ( { model | counter = model.counter + 1 }
            , Cmd.none
            )

        AutoCount ->
            ( { model | counter = model.counter + 1 }
            , if model.counting then
                Helpers.delay delay AutoCount
              else
                Cmd.none
            )

        Update f ->
            ( f model, Cmd.none )

        ToggleCounting ->
            ( { model | counting = not model.counting }
            , if not model.counting then
                Helpers.delay delay AutoCount
              else
                Cmd.none
            )

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


readBit : Int -> Int -> Bool
readBit k n =
    0 /= (Bitwise.and 0x01 (Bitwise.shiftRightBy n k))


setBit : Bool -> Int -> Int -> Int
setBit x k n =
    if x then
        Bitwise.or (Bitwise.shiftLeftBy 0x01 k) n
    else
        Bitwise.and (Bitwise.complement (Bitwise.shiftLeftBy 0x01 k)) n


flipBit : Int -> Int -> Int
flipBit k n =
    setBit (not (readBit k n)) k n


view : Model -> Html Msg
view model =
    div [] []
