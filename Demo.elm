import StartApp
import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Signal exposing (Signal)
import Effects exposing (..)
import Task
import Signal
import Task exposing (Task)
import Dict exposing (Dict)

import Material.Textfield as Textfield
import Material.Grid as Grid exposing (Device(..))
import Material.Layout as Layout

import Buttons


-- MODEL


type alias Model =
  { layout : Layout.Model
  , buttons : Buttons.Model
  , t0 : Textfield.Model
  , t1 : Textfield.Model
  , t2 : Textfield.Model
  , t3 : Textfield.Model
  , t4 : Textfield.Model
  }


layoutModel : Layout.Model
layoutModel =
  { selectedTab = "Buttons"
  , isDrawerOpen = False
  , state = Layout.initState ["Buttons", "Grid", "Textfields"]
  }


model : Model
model =
  let t0 = Textfield.model in
  { layout = layoutModel
  , buttons = Buttons.model
  , t0 = t0
  , t1 = { t0 | label = Just { text = "Labelled", float = False } }
  , t2 = { t0 | label = Just { text = "Floating label", float = True }}
  , t3 = { t0
         | label = Just { text = "Disabled", float = False }
         , isDisabled = True
         }
  , t4 = { t0
           | label = Just { text = "With error and value", float = False }
           , error = Just "The input is wrong!"
           , value = "Incorrect input"
           }
  }


-- ACTION, UPDATE


type Action
  = LayoutAction Layout.Action
  | ButtonsAction Buttons.Action
  | T0 Textfield.Action
  | T1 Textfield.Action
  | T2 Textfield.Action
  | T3 Textfield.Action
  | T4 Textfield.Action


update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case action of
    LayoutAction a ->
      let
        (l, e) = Layout.update a model.layout
      in
        ({ model | layout = l }, Effects.map LayoutAction e)

    ButtonsAction a ->
      let (b, e) = Buttons.update a model.buttons
      in
        ({ model | buttons = b }, Effects.map ButtonsAction e)

    T0 a ->
      ({ model | t0 = Textfield.update a model.t0 }, Effects.none)

    T1 a ->
      ({ model | t1 = Textfield.update a model.t1 }, Effects.none)

    T2 a ->
      ({ model | t2 = Textfield.update a model.t2 }, Effects.none)

    T3 a ->
      ({ model | t3 = Textfield.update a model.t3 }, Effects.none)

    T4 a ->
      ({ model | t4 = Textfield.update a model.t4 }, Effects.none)


-- VIEW


type alias Addr = Signal.Address Action


layoutConfig : Layout.Config
layoutConfig = Layout.defaultConfig


drawer : List Html
drawer =
  [ Layout.title "elm-mdl"
  , Layout.navigation
    [ Layout.link [] [text "Dead Link 1"]
    , Layout.link [] [text "Dead Link 2"]
    , Layout.link [] [text "Dead Link 3"]
    ]
  ]


header : List Html
header =
  [ Layout.title "elm-mdl"
  , Layout.spacer
  , Layout.navigation
    [ Layout.link
      [ href "https://www.getmdl.io/components/index.html" ]
      [ text "MDL" ]
    ]
  ]


tabGrid : Addr -> Model -> List Html
tabGrid addr model =
  [ Grid.grid
      [ Grid.cell [ Grid.col All 4 ]
          [ h4 [] [text "Cell 1"] ]
      , Grid.cell [ Grid.offset All 2, Grid.col All 4 ]
          [ h4 [] [text "Cell 2"], p [] [text "This cell is offset by 2"] ]
      , Grid.cell [ Grid.col All 6 ]
          [ h4 [] [text "Cell 3"] ]
      , Grid.cell [ Grid.col Tablet 6, Grid.col Desktop 12, Grid.col Phone 2 ]
          [ h4 [] [text "Cell 4"], p [] [text "Size varies with device"] ]
      ]
  ]


tabButtons : Addr -> Model -> List Html
tabButtons addr model =
  [ Buttons.view (Signal.forwardTo addr ButtonsAction) model.buttons ]


tabTextfields : Addr -> Model -> List Html
tabTextfields addr model   =
  let fwd = Signal.forwardTo addr in
  [ Textfield.view (fwd T0) model.t0
  , Textfield.view (fwd T1) model.t1
  , Textfield.view (fwd T2) model.t2
  , Textfield.view (fwd T3) model.t3
  , Textfield.view (fwd T4) model.t4
  ]
  |> List.map (\elem -> Grid.cell [ Grid.col All 4 ] [elem])
  |> (\content -> [Grid.grid content])



tabs : Dict String (Addr -> Model -> List Html)
tabs =
  Dict.fromList
    [ ("Buttons", tabButtons)
    , ("Textfields", tabTextfields)
    , ("Grid", tabGrid)
    ]


view : Signal.Address Action -> Model -> Html
view addr model =
  let contents =
        Dict.get model.layout.selectedTab tabs
        |> Maybe.withDefault tabGrid

      top =
        div
          [ style
            [ ("margin", "auto")
            , ("width", "90%")
            ]
          ]
          <| contents addr model

      addr' = Signal.forwardTo addr LayoutAction

  in
    Layout.view addr'
      layoutConfig model.layout
      (Just drawer, Just header)
      [ top ]


init : (Model, Effects.Effects Action)
init = (model, Effects.none)


inputs : List (Signal.Signal Action)
inputs =
  [ Layout.setupSizeChangeSignal LayoutAction
  ]


app : StartApp.App Model
app =
    StartApp.start
      { init = init
      , view = view
      , update = update
      , inputs = inputs
      }

main : Signal Html
main =
    app.html


-- PORTS


port tasks : Signal (Task.Task Never ())
port tasks =
    app.tasks
