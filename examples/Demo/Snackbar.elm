module Demo.Snackbar where

import Effects exposing (Effects, none)
import Html exposing (..)
import Html.Attributes exposing (class, style, key)
import Array exposing (Array)

import Markdown

import Material.Color as Color
import Material.Style exposing (styled, cs)
import Material.Snackbar as Snackbar
import Material.Button as Button exposing (Action(..))
import Material.Grid exposing (..)
import Material exposing (lift, lift')


-- MODEL


type alias Model =
  { count : Int
  , clicked : List Int
  , snackbar : Snackbar.Model Action
  , toastButton : Button.Model
  , snackbarButton : Button.Model
  }


model : Model
model =
  { count = 0
  , clicked = []
  , snackbar = Snackbar.model
  , toastButton = Button.model True
  , snackbarButton = Button.model True
  }


-- ACTION, UPDATE


type Action
  = Undo Int
  -- Components
  | SnackbarAction (Snackbar.Action Action)
  | ToastButtonAction Button.Action
  | SnackbarButtonAction Button.Action


snackbar : Int -> Snackbar.Contents Action
snackbar k =
  Snackbar.snackbar
    ("Snackbar message #" ++ toString k)
    "UNDO"
    (Undo k)


toast : Int -> Snackbar.Contents Action
toast k =
  Snackbar.toast
    <| "Toast message #" ++ toString k


add : (Int -> Snackbar.Contents Action) -> Model -> (Model, Effects Action)
add f model =
  let
    (snackbar', effects) =
      Snackbar.update (Snackbar.Add (f model.count)) model.snackbar
  in
    ({ model
     | snackbar = snackbar'
     , count = model.count + 1
     , clicked = model.count :: model.clicked
     }
    , Effects.map SnackbarAction effects)



update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    SnackbarButtonAction Click ->
      add snackbar model

    ToastButtonAction Click ->
      add toast model

    Undo k ->
      ({ model
         | clicked = List.filter ((/=) k) model.clicked
       }
      , none)

    SnackbarAction (Snackbar.Action action')
      -> update action' model

    SnackbarAction       action' -> lift .snackbar       (\m x -> {m|snackbar      =x}) SnackbarAction       Snackbar.update action' model
    ToastButtonAction    action' -> lift .toastButton    (\m x -> {m|toastButton   =x}) ToastButtonAction    Button.update   action' model
    SnackbarButtonAction action' -> lift .snackbarButton (\m x -> {m|snackbarButton=x}) SnackbarButtonAction Button.update   action' model


-- VIEW


clickView : Model -> Int -> Html
clickView model k =
  let
    color =
      Array.get ((k + 4) % Array.length Color.palette) Color.palette
        |> Maybe.withDefault Color.Teal
        |> flip Color.color Color.S500

    selected =
      (k == model.snackbar.seq - 1) &&
        (Snackbar.isActive model.snackbar /= Nothing)
  in
    styled div
      [ Color.background color
      , Color.text Color.primaryContrast
      -- TODO. Should have shadow styles someplace. 
      , cs <| "mdl-shadow--" ++ if selected then "8dp" else "2dp"
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
  div []
    [ intro
    , grid []
        -- TODO. Buttons should be centered. Desperately need to be able
        -- to add css/classes to top-level element of components (div
        -- in grid, button in button, div in textfield etc.)
        [ cell [ size All 2, size Phone 2, align Top ]
            [ Button.raised
                (Signal.forwardTo addr ToastButtonAction)
                model.toastButton 
                []
                [ text "Toast" ]
            ]
        , cell [ size All 2, size Phone 2, align Top ]
            [ Button.raised
                (Signal.forwardTo addr SnackbarButtonAction)
                model.snackbarButton
                []
                [ text "Snackbar" ]
            ]
        , cell
            [ size Desktop 7, size Tablet 3, size Phone 12, align Top ]
            (model.clicked |> List.reverse |> List.map (clickView model))
        ]
    , Snackbar.view (Signal.forwardTo addr SnackbarAction) model.snackbar
    ]


introStyle : String
introStyle = """
  blockquote:before { content: none; }
  blockquote:after { content: none; }
  blockquote {
    border-left-style: solid;
    border-width: 3px;
    padding-left: 1.3ex;
    border-color: rgb(255,82,82);
      /* TODO: Really need a way to specify "secondary color" in
         inline css.
       */
  }
"""


introBody : Html
introBody = """
# Snackbars & toasts

From the
[Material Design Lite documentation](https://www.getmdl.io/components/index.html#snackbar-section).

> The Material Design Lite (MDL) __snackbar__ component is a container used to
> notify a user of an operation's status. It displays at the bottom of the
> screen. A snackbar may contain an action button to execute a command for the
> user. Actions should undo the committed action or retry it if it failed for
> example. Actions should not be to close the snackbar. By not providing an
> action, the snackbar becomes a __toast__ component.

#### See also

 - [Demo source code](https://github.com/debois/elm-mdl/blob/master/examples/Demo/Snackbar.elm)
 - [elm-mdl package documentation](http://package.elm-lang.org/packages/debois/elm-mdl/1.0.1/Material-Snackbar)
 - [Material Design Specification](https://www.google.com/design/spec/components/snackbars-toasts.html)
 - [Material Design Lite documentation](https://www.getmdl.io/components/index.html#snackbar-section).

#### Demo

""" |> Markdown.toHtml


intro : Html
intro =
  div []
    [ node "style" [] [ text introStyle ]
    , introBody
    ]
