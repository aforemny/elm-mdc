module Demo.Snackbar exposing (model, Model, update, view, Msg)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Array exposing (Array)
import Time exposing (Time, millisecond)
import Material.Helpers exposing (map1st, map2nd, delay, pure, cssTransitionStep)
import Material.Color as Color
import Material.Options as Options exposing (cs, css, Style, nop)
import Material.Snackbar as Snackbar
import Material.Elevation as Elevation
import Material


-- MODEL


type Square_
    = Appearing
    | Growing
    | Waiting
    | Active
    | Idle
    | Disappearing


type alias Square =
    ( Int, Square_ )


type alias Model =
    { count : Int
    , squares : List Square
    , snackbar : Snackbar.Model Int
    , mdl : Material.Model
    }


model : Model
model =
    { count = 0
    , squares = []
    , snackbar = Snackbar.model
    , mdl = Material.model
    }



-- ACTION, UPDATE


type Msg
    = AddSnackbar
    | AddToast
    | Appear Int
    | Grown Int
    | Gone Int
    | Snackbar (Snackbar.Msg Int)
    | Mdl (Material.Msg Msg)


add : (Int -> Snackbar.Contents Int) -> Model -> ( Model, Cmd Msg )
add f model =
    let
        ( snackbar_, effect ) =
            Snackbar.add (f model.count) model.snackbar
                |> map2nd (Cmd.map Snackbar)

        model_ =
            { model
                | snackbar = snackbar_
                , count = model.count + 1
                , squares = ( model.count, Appearing ) :: model.squares
            }
    in
        ( model_
        , Cmd.batch
            [ cssTransitionStep (Appear model.count)
            , effect
            ]
        )


mapSquare : Int -> (Square_ -> Square_) -> Model -> Model
mapSquare k f model =
    { model
        | squares =
            List.map
                (\(( k_, sq ) as s) ->
                    if k /= k_ then
                        s
                    else
                        ( k_, f sq )
                )
                model.squares
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        AddSnackbar ->
            add (\k -> Snackbar.snackbar k ("Snackbar message #" ++ toString k) "UNDO") model

        AddToast ->
            add (\k -> Snackbar.toast k <| "Toast message #" ++ toString k) model

        Appear k ->
            ( model
                |> mapSquare k
                    (\sq ->
                        if sq == Appearing then
                            Growing
                        else
                            sq
                    )
            , delay transitionLength (Grown k)
            )

        Grown k ->
            model
                |> mapSquare k
                    (\sq ->
                        if sq == Growing then
                            Waiting
                        else
                            sq
                    )
                |> pure

        Snackbar (Snackbar.Begin k) ->
            model |> mapSquare k (always Active) |> pure

        Snackbar (Snackbar.End k) ->
            model
                |> mapSquare k
                    (\sq ->
                        if sq /= Disappearing then
                            Idle
                        else
                            sq
                    )
                |> pure

        Snackbar (Snackbar.Click k) ->
            ( model |> mapSquare k (always Disappearing)
            , delay transitionLength (Gone k)
            )

        Gone k ->
            ( { model
                | squares = List.filter (Tuple.first >> (/=) k) model.squares
              }
            , none
            )

        Snackbar msg_ ->
            Snackbar.update msg_ model.snackbar
                |> map1st (\s -> { model | snackbar = s })
                |> map2nd (Cmd.map Snackbar)

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


boxHeight : String
boxHeight =
    "48px"


boxWidth : String
boxWidth =
    "64px"


transitionLength : Time
transitionLength =
    150 * millisecond


transitionInner : Style a
transitionInner =
    css "transition" <|
        "box-shadow 333ms ease-in-out 0s, "
            ++ "width "
            ++ toString transitionLength
            ++ "ms, "
            ++ "height "
            ++ toString transitionLength
            ++ "ms, "
            ++ "background-color "
            ++ toString transitionLength
            ++ "ms"


transitionOuter : Style a
transitionOuter =
    css "transition" <|
        "width "
            ++ toString transitionLength
            ++ "ms ease-in-out 0s, "
            ++ "margin "
            ++ toString transitionLength
            ++ "ms ease-in-out 0s"


clickView : Model -> Square -> Html a
clickView model ( k, square ) =
    let
        hue =
            Array.get ((k + 4) % Array.length Color.hues) Color.hues
                |> Maybe.withDefault Color.Teal

        shade =
            case square of
                Idle ->
                    Color.S100

                _ ->
                    Color.S500

        color =
            Color.color hue shade

        ( width, height, margin, selected ) =
            if square == Appearing || square == Disappearing then
                ( "0", "0", "16px 0", False )
            else
                ( boxWidth, boxHeight, "16px 16px", square == Active )
    in
        {- In order to get the box appearance and disappearance animations
           to start in the lower-left corner, we render boxes as an outer div (which
           animates only width, to cause reflow of surrounding boxes), and an
           absolutely positioned inner div (to force animation to start in the
           lower-left corner.
        -}
        Options.div
            [ css "height" boxHeight
            , css "width" width
            , css "position" "relative"
            , css "display" "inline-block"
            , css "margin" margin
            , css "z-index" "0"
            , transitionOuter
            ]
            [ Options.div
                [ Color.background color
                , Color.text Color.primaryContrast
                , if selected then
                    Elevation.elevation 8
                  else
                    Elevation.elevation 2
                  -- Center contents
                , css "display" "inline-flex"
                , css "align-items" "center"
                , css "justify-content" "center"
                , css "flex" "0 0 auto"
                  -- Sizing
                , css "height" height
                , css "width" width
                , css "border-radius" "2px"
                , css "box-sizing" "border-box"
                  -- Force appearance/disapparenace to be from/to lower-left corner.
                , css "position" "absolute"
                , css "bottom" "0"
                , css "left" "0"
                  -- Transitions
                , transitionInner
                ]
                [ div [] [ text <| toString k ] ]
            ]


view : Model -> Html Msg
view model =
    div [] []
