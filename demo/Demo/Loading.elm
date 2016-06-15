module Demo.Loading exposing (..)

import Html exposing (Html, text)
import Html.Attributes as Attr

import Material.Options as Options exposing (div, css)
import Material.Progress as Loading
import Material.Spinner as Loading
import Material.Grid as Grid

import Material.Button as Button
import Material
import Material.Helpers as Helpers

import Demo.Code as Code
import Demo.Page as Page

type alias Mdl = Material.Model

type alias Model =
  { mdl : Material.Model
  , started : Bool
  , currentProgress : Float
  }

model : Model
model =
  { mdl = Material.model
  , started = False
  , currentProgress = 0
  }

type Msg
  = Tick
  | Start
  | Mdl Material.Msg


-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
      -- 'Simulate' a process that takes some time
    Tick ->
      let
        nextProgress = model.currentProgress + 1
        progress = if nextProgress > 100 then
                     0
                   else
                     nextProgress

        finishedLoading = nextProgress > 100

        command = if not finishedLoading then
                    Helpers.delay 100 Tick
                  else
                    Cmd.none
      in
        ({ model | currentProgress = progress
         , started = not finishedLoading }, command)

    Start ->
      if model.started then
        (model, Cmd.none)
      else
        ({ model | started = True}, Helpers.delay 200 Tick)

    Mdl action' ->
      Material.update Mdl action' model

-- VIEW

demoBars : List (Grid.Cell a)
demoBars =
  [ (Loading.progress 44, Code.code "Loading.progress 44")
  , (Loading.indeterminate, Code.code "Loading.indeterminate")
  , (Loading.buffered 33 87, Code.code "Loading.buffered 33 87")

  , (,) (Loading.spinner [ Loading.active True ])
    (Code.code "Loading.spinner [ Loading.active True ]")
  , (,) (Loading.spinner [ Loading.active True, Loading.singleColor True ])
    (Code.code """Loading.spinner [ Loading.active True
                , Loading.singleColor True ]""")

  ] |> List.map demoContainer


view : Model -> Html Msg
view model =
  [ div
    []
      [ Grid.grid []
          (List.append
             [Grid.cell
                [Grid.size Grid.All 12]
                [ Html.p [] [text "Example use:"]
                , Code.code """
                             import Material.Spinner as Loading
                             import Material.Progress as Loading
                             """]
             ]
             demoBars)
      , Grid.grid []
        [ Grid.cell [ Grid.size Grid.All 12]
            [ Html.p [] [text "Interactive demos"] ]
        , Grid.cell
            [ Grid.size Grid.All 4]
            [ Loading.progress model.currentProgress
            -- NOTE: Just a padding component to position the code blocks
            , div [Options.css "padding-top" "30px"] []
            , Code.code "Progress bar that updates while loading"
            , div []
              [ Button.render Mdl [4] model.mdl
                  [ Button.raised
                  , Button.colored
                  , Button.ripple
                  , if model.started then Button.disabled else Options.nop
                  , Button.onClick (Start)]
                  [text "Start loading"]
              ]
            ]
        , Grid.cell
            [ Grid.size Grid.All 4 ]
            [ Loading.spinner [ Loading.active model.started ]
            , Code.code "Spinner that shows while loading"
            , div []
              [ Button.render Mdl [4] model.mdl
                  [ Button.raised
                  , Button.colored
                  , Button.ripple
                  , if model.started then Button.disabled else Options.nop
                  , Button.onClick (Start)]
                  [text "Start loading"]
              ]
            ]
        ]
      ]
  ]
  |> Page.body2 "Loading" srcUrl intro references


demoContainer : (Html m, Html m) -> (Grid.Cell m)
demoContainer (html, code) =
  Grid.cell
  [Grid.size Grid.All 4]
  [ html
  , code
  ]

intro : Html m
intro =
  Page.fromMDL "https://www.getmdl.io/components/index.html#loading-section" """
> The Material Design Lite (MDL) progress component is a visual indicator of
> background activity in a web page or application. A progress indicator
> consists of a (typically) horizontal bar containing some animation that
> conveys a sense of motion. While some progress devices indicate an
> approximate or specific percentage of completion, the MDL progress component
> simply communicates the fact that an activity is ongoing and is not yet
> complete.

> Progress indicators are an established but non-standardized feature in user
> interfaces, and provide users with a visual clue to an application's status.
> Their design and use is therefore an important factor in the overall user
> experience. See the progress component's Material Design specifications page
> for details.
"""


srcUrl : String
srcUrl =
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Loading.elm"


references : List (String, String)
references =
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Loading"
  , Page.mds "https://www.google.com/design/spec/components/Loading.html"
  , Page.mdl "https://www.getmdl.io/components/index.html#Loading"
  ]
