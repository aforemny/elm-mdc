{- This file re-implements the Elm Counter example (many counters) with
   elm-mdl. Look at this file if you have a dynamic number of elm-mdl components
   and are unsure how to choose proper indices.

   If you are looking for a starting point, you want `Counter.elm` rather than
   this file.
-}


module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Array exposing (Array)
import Material
import Material.Scheme
import Material.Button as Button
import Material.Options as Options exposing (css)
import Material.Helpers exposing (pure)


-- MODEL


type alias Model =
    { counters : Array Int
    , mdl : Material.Model
    }


model : Model
model =
    { counters = Array.empty
    , mdl = Material.model
    }



-- ACTION, UPDATE


type Msg
    = Increase Int
    | Reset Int
    | Add
    | Remove
    | Mdl (Material.Msg Msg)


map : Int -> (a -> a) -> Array a -> Array a
map k f a =
    Array.get k a
        |> Maybe.map (\x -> Array.set k (f x) a)
        |> Maybe.withDefault a


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increase k ->
            pure { model | counters = map k ((+) 1) model.counters }

        Reset k ->
            pure { model | counters = map k (always 0) model.counters }

        Add ->
            pure { model | counters = Array.push 0 model.counters }

        Remove ->
            pure { model | counters = Array.slice 0 (Array.length model.counters - 1) model.counters }

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


type alias Mdl =
    Material.Model


view1 : Int -> Int -> Html Msg
view1 idx val =
    div
        [ style [ ( "padding", "2rem" ) ] ]
        [ text ("Current count: " ++ toString val)
        , Button.render Mdl
            [ 0, idx ]
            {- Crucial bit: We don't know how many elements are going to be in
               model.counters, but we still have to come up with _unique_ indices
               for the two buttons for the idx'th element. We exploit that indices
               are lists, and adopt the convention that "increase buttons" have
               index [0,idx]; "reset buttons" index [1,idx] and so forth.
            -}
            model.mdl
            [ Options.onClick (Increase idx)
            , css "margin" "0 24px"
            ]
            [ text "Increase" ]
        , Button.render Mdl
            [ 1, idx ]
            model.mdl
            [ Options.onClick (Reset idx) ]
            [ text "Reset" ]
        ]


view : Model -> Html Msg
view model =
    let
        counters =
            model.counters
                |> Array.toList
                |> List.indexedMap view1
    in
        List.concatMap identity
            [ [ Button.render Mdl
                    [ 2 ]
                    model.mdl
                    [ Options.onClick Add ]
                    [ text "Add counter" ]
              ]
            , [ Button.render Mdl
                    [ 4 ]
                    model.mdl
                    [ Options.onClick Remove ]
                    [ text "Remove counter" ]
              ]
            , counters
            ]
            |> div []
            |> Material.Scheme.top


main : Program Never Model Msg
main =
    Html.program
        { init = ( model, Cmd.none )
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }
