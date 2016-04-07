module Demo.Snackbar where

import Effects exposing (Effects, none)
import Html exposing (..)
import Html.Attributes exposing (class, style, key)
import Array exposing (Array)

import Material.Helpers exposing (map1st, map2nd)
import Material.Color as Color
import Material.Style exposing (styled, cs)
import Material.Snackbar as Snackbar
import Material.Button as Button exposing (Action(..))
import Material.Grid exposing (..)
import Material.Elevation as Elevation
import Material 

import Demo.Page as Page


-- MODEL


type alias Mdl = 
  Material.Model Action


type alias Model =
  { count : Int
  , clicked : List Int
  , mdl : Mdl
  }


model : Model
model =
  { count = 0
  , clicked = []
  , mdl = Material.model
  }


-- ACTION, UPDATE


type Action
  = Undo Int
  | AddSnackbar
  | AddToast
  | MDL (Material.Action Action)


add : Model -> (Int -> Snackbar.Contents Action) -> (Model, Effects Action)
add model f =
  let 
    (mdl', fx) = 
      Snackbar.add (f model.count) snackbarComponent model.mdl
    model' = 
      { model 
      | mdl = mdl'
      , count = model.count + 1
      , clicked = model.count :: model.clicked
      }
  in 
    (model', fx)


update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    AddSnackbar ->
      add model 
        <| \k -> Snackbar.snackbar ("Snackbar message #" ++ toString k) "UNDO" (Undo k)

    AddToast -> 
      add model
        <| \k -> Snackbar.toast <| "Toast message #" ++ toString k

    Undo k ->
      ({ model
         | clicked = List.filter ((/=) k) model.clicked
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


snackbarComponent : Snackbar.Instance Mdl Action
snackbarComponent = 
  Snackbar.instance MDL Snackbar.model 


clickView : Model -> Int -> Html
clickView model k =
  let
    color =
      Array.get ((k + 4) % Array.length Color.palette) Color.palette
        |> Maybe.withDefault Color.Teal
        |> flip Color.color Color.S500

    sbmodel = 
      snackbarComponent.get model.mdl

    selected =
      (k == sbmodel.seq - 1) &&
        (Snackbar.isActive sbmodel /= Nothing)
  in
    styled div
      [ Color.background color
      , Color.text Color.primaryContrast
      -- TODO. Should have shadow styles someplace. 
      , Elevation.shadow (if selected then 8 else 2)
      ] 
      [ style
          [ ("margin-right", "3ex")
          , ("margin-bottom", "3ex")
          , ("padding", "1.5ex")
          , ("width", "4ex")
          , ("border-radius", "2px")
          , ("display", "inline-block")
          , ("text-align", "center")
          , ("transition", "box-shadow 333ms ease-in-out 0s")
          ]
      , key (toString k)
      ]
      [ text <| toString k ]



view : Signal.Address Action -> Model -> Html
view addr model =
  Page.body "Snackbar & Toast" srcUrl intro references
    [ grid []
        -- TODO. Buttons should be centered. Desperately need to be able
        -- to add css/classes to top-level element of components (div
        -- in grid, button in button, div in textfield etc.)
        [ cell [ size All 2, size Phone 2, align Top ]
            [ addToastButton.view addr model.mdl [] [ text "Toast" ]
            ]
        , cell 
            [ size All 2, size Phone 2, align Top ]
            [ addSnackbarButton.view addr model.mdl [] [ text "Snackbar" ]
            ]
        , cell
            [ size Desktop 7, size Tablet 3, size Phone 12, align Top ]
            (model.clicked |> List.reverse |> List.map (clickView model))
        ]
    , snackbarComponent.view addr model.mdl 
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


