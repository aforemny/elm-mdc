module Demo.Loading exposing (..)

import Html exposing (Html, text)

import Material.Options as Options exposing (div, css)
import Material.Progress as Loading
import Material.Spinner as Loading
import Material.Grid as Grid

import Material.Button as Button

import Demo.Code as Code
import Demo.Page as Page


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


view : Html m
view =
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
