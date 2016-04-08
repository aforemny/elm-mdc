module Demo.Snackbar where

import Effects exposing (Effects, none)
import Html exposing (..)
import Html.Attributes exposing (class, style, key)
import Array exposing (Array)
import Time exposing (Time, millisecond)

import Material.Helpers exposing (map1st, map2nd, delay)
import Material.Color as Color
import Material.Style exposing (styled, cs, css)
import Material.Snackbar as Snackbar
import Material.Button as Button exposing (Action(..))
import Material.Grid exposing (..)
import Material.Elevation as Elevation
import Material 

import Demo.Page as Page


-- MODEL


type alias Mdl = 
  Material.Model Action


type Square' 
  = Appearing 
  | Idle
  | Disappearing


type alias Square = 
  (Int, Square')


type alias Model =
  { count : Int
  , squares : List Square
  , mdl : Mdl
  }


model : Model
model =
  { count = 0
  , squares = [] 
  , mdl = Material.model
  }


-- ACTION, UPDATE


type Action
  = AddSnackbar
  | AddToast
  | Appear Int
  | Disappear Int
  | Gone Int
  | MDL (Material.Action Action)


add : Model -> (Int -> Snackbar.Contents Action) -> (Model, Effects Action)
add model f =
  let 
    (mdl', fx) = 
      Snackbar.add (f model.count) snackbar model.mdl
    model' = 
      { model 
      | mdl = mdl'
      , count = model.count + 1
      , squares = (model.count, Appearing) :: model.squares
      }
  in 
    ( model'
    , Effects.batch 
        [ Effects.tick (always (Appear model.count))
        , fx 
        ]
    )


mapSquare : Int -> (Square' -> Square') -> Model -> Model
mapSquare k f model = 
  { model 
  | squares = 
      List.map 
        ( \((k', sq) as s) -> if k /= k' then s else (k', f sq) )
        model.squares
  }



update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    AddSnackbar ->
      add model 
        <| \k -> Snackbar.snackbar ("Snackbar message #" ++ toString k) "UNDO" (Disappear k)

    AddToast -> 
      add model
        <| \k -> Snackbar.toast <| "Toast message #" ++ toString k

    Appear k -> 
      ( model |> mapSquare k (always Idle)
      , none
      )

    Disappear k -> 
      ( model |> mapSquare k (always Disappearing)
      , delay transitionLength (Gone k) 
      )

    Gone k ->
      ({ model
       | squares = List.filter (fst >> (/=) k) model.squares
       }
      , none)

    MDL action' -> 
      Material.update MDL action' model.mdl
        |> map1st (\m -> { model | mdl = m })



-- VIEW


addSnackbarButton : Button.Instance Mdl Action 
addSnackbarButton = 
  Button.instance 0 MDL
    Button.raised (Button.model True)
    [ Button.fwdClick AddSnackbar ]


addToastButton : Button.Instance Mdl Action 
addToastButton = 
  Button.instance 1 MDL
    Button.raised (Button.model True)
    [ Button.fwdClick AddToast ]


-- TODO: Bad name
snackbar : Snackbar.Instance Mdl Action
snackbar = 
  Snackbar.instance MDL Snackbar.model 


boxHeight : String
boxHeight = "48px"


boxWidth : String
boxWidth = "64px"


transitionLength : Time 
transitionLength = 150 * millisecond


transitions : (String, String)
transitions = 
  ("transition"
  , "box-shadow 333ms ease-in-out 0s, " 
      ++ "width " ++ toString transitionLength ++ "ms, " 
      ++ "height " ++ toString transitionLength ++ "ms"
  )


clickView : Model -> Square -> Html
clickView model (k, square) =
  let
    color =
      Array.get ((k + 4) % Array.length Color.palette) Color.palette
        |> Maybe.withDefault Color.Teal
        |> flip Color.color Color.S500

    selected' =
      Snackbar.activeAction (snackbar.get model.mdl) == Just (Disappear k)

    (width, height, margin, selected) = 
      case square of 
        Idle -> 
          (boxWidth, boxHeight, "16px 16px", selected')      
        _ -> 
          ("0", "0", "16px 0", False)
  in
    div 
      [ style 
          [ ("height", boxHeight)
          , ("width", width)
          , ("position", "relative")
          , ("display", "inline-block")
          , ("margin", margin)
          , ("transition", 
                "width " ++ toString transitionLength ++ "ms ease-in-out 0s, "
                ++ "margin " ++ toString transitionLength ++ "ms ease-in-out 0s"
            )
          , ("z-index", "0")
          ]
      , key <| toString k
      ]
      [ styled div
          [ Color.background color
          , Color.text Color.primaryContrast
          , Elevation.shadow (if selected then 8 else 2)
          ] 
          [ style
              [ ("display", "inline-flex")
              , ("align-items", "center")
              , ("justify-content", "center")
              , ("height", height)
              , ("width", width)
              , ("border-radius", "2px")
              , transitions
              , ("overflow", "hidden")
              , ("box-sizing", "border-box")
              , ("flex", "0 0 auto")
              , ("position", "absolute")
              , ("bottom", "0")
              , ("left", "0")
              ]
          ]
          [ div [] [ text <| toString k ] ]
        ]



view : Signal.Address Action -> Model -> Html
view addr model =
  Page.body "Snackbar & Toast" srcUrl intro references
    [ p [] 
        [ text """Click the buttons below to activate the snackbar. Note that 
                  multiple activations are automatically queued."""
        ]
    , grid [ ] --css "margin-top" "32px" ]
        [ cell 
            [ size All 2, size Phone 2, align Top ]
            [ addToastButton.view addr model.mdl 
                [ Button.colored
                , css "margin" "16px"
                ] 
                [ text "Toast" ]
            ]
        , cell 
            [ size All 2, size Phone 2, align Top ]
            [ addSnackbarButton.view addr model.mdl 
                [ Button.colored
                , css "margin" "16px"
                ] 
                [ text "Snackbar" ]
            ]
        , cell
            [ size Desktop 7, offset Desktop 1 
            , size Tablet 3, offset Tablet 1
            , size Phone 4
            , align Top 
            ]
            (model.squares |> List.reverse |> List.map (clickView model))
        ]
    , snackbar.view addr model.mdl 
    ]


intro : Html
intro = 
  Page.fromMDL "https://www.getmdl.io/components/index.html#snackbar-section" """
> The Material Design Lite (MDL) __snackbar__ component is a container used to
> notify a user of an operation's status. It displays at the bottom of the
> screen. A snackbar may contain an action button to execute a command for the
> user. Actions should undo the committed action or retry it if it failed for
> example. Actions should not be to close the snackbar. By not providing an
> action, the snackbar becomes a __toast__ component.

""" 


srcUrl : String 
srcUrl =
  "https://github.com/debois/elm-mdl/blob/master/examples/Demo/Snackbar.elm"


references : List (String, String)
references = 
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Snackbar"
  , Page.mds "https://www.google.com/design/spec/components/snackbars-toasts.html"
  , Page.mdl "https://www.getmdl.io/components/index.html#snackbar-section"
  ]


