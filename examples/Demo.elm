import StartApp
import Html exposing (..)
import Html.Attributes exposing (href, class, style)
import Signal exposing (Signal)
import Effects exposing (..)
import Task
import Signal
import Task exposing (Task)
import Array exposing (Array)

import Material.Layout as Layout exposing (defaultLayoutModel)
import Material

import Demo.Buttons
import Demo.Grid
import Demo.Textfields


-- MODEL


type alias Model =
  { layout : Layout.Model
  , buttons : Demo.Buttons.Model
  , textfields : Demo.Textfields.Model
  }


layoutModel : Layout.Model
layoutModel =
  { defaultLayoutModel
  | state = Layout.initState (List.length tabs)
  }


model : Model
model =
  { layout = layoutModel
  , buttons = Demo.Buttons.model
  , textfields = Demo.Textfields.model
  }


-- ACTION, UPDATE


type Action
  = LayoutAction Layout.Action
  | ButtonsAction Demo.Buttons.Action
  | TextfieldAction Demo.Textfields.Action


update : Action -> Model -> (Model, Effects.Effects Action)
update action model =
  case action of
    LayoutAction a ->
      let
        (l, e) = Layout.update a model.layout
      in
        ({ model | layout = l }, Effects.map LayoutAction e)

    ButtonsAction a ->
      let
        (b, e) = Demo.Buttons.update a model.buttons
      in
        ({ model | buttons = b }, Effects.map ButtonsAction e)

    TextfieldAction a ->
      ({ model | textfields = Demo.Textfields.update a model.textfields }
      , Effects.none
      )


-- VIEW


type alias Addr = Signal.Address Action



drawer : List Html
drawer =
  [ Layout.title "Example drawer"
  , Layout.navigation
    [ Layout.link
      [href "https://github.com/debois/elm-mdl"]
      [text "github"]
    , Layout.link
      [href "http://package.elm-lang.org/packages/debois/elm-mdl/1.0.0/"]
      [text "elm-package"]
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
    , Layout.link
      [ href "https://www.google.com/design/spec/material-design/introduction.html"]
      [ text "Material Design"]
    ]
  ]


tabs : List (String, Addr -> Model -> List Html)
tabs =
  [ ("Buttons", \addr model ->
      [Demo.Buttons.view (Signal.forwardTo addr ButtonsAction) model.buttons])
  , ("Textfields", \addr model ->
      [Demo.Textfields.view (Signal.forwardTo addr TextfieldAction) model.textfields])
  , ("Grid", \addr model -> Demo.Grid.view)
  ]


tabViews : Array (Addr -> Model -> List Html)
tabViews = List.map snd tabs |> Array.fromList


tabTitles : List Html
tabTitles = List.map (fst >> text) tabs


view : Signal.Address Action -> Model -> Html
view addr model =
  let top =
        div
          [ style
            [ ("margin", "auto")
            , ("width", "90%")
            ]
          ]
          ((Array.get model.layout.selectedTab tabViews
           |> Maybe.withDefault (\addr model ->
             [div [] [text "This can't happen."]]
           )
          ) addr model)

  in
    Layout.view (Signal.forwardTo addr LayoutAction) model.layout
      { header = Just header
      , drawer = Just drawer
      , tabs = Just tabTitles
      , main = [ top ]
      }
    {- The following line is not needed when you manually set up
       your html, as done with page.html. Removing it will then
       fix the flicker you see on load.
    -}
    |> Material.topWithColors Material.Teal Material.Red


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
