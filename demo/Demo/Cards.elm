module Demo.Cards exposing (model, update, view, Model, Msg)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)

import Material.Card exposing (..)
import Material.Grid as Grid
import Material.Button as Button exposing (..)
import Material.Icon as Icon
import Material.Elevation exposing(..)
import Material.Color as Color
import Material.Options exposing (css)
import Material

import Demo.Page as Page


-- MODEL


type alias Model =
  { mdl : Material.Model
  }


model : Model
model =
  { mdl = Material.model
  }


-- ACTION/UPDATE


type Msg
  = Mdl Material.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Mdl action' ->
      Material.update Mdl action' model


-- VIEW

view : Model -> Html Msg
view model =
  [ Grid.grid []
    [ Grid.cell []
      [ card [ e2 ]
        [ Title [] "Welcome"
        , SupportingText []
          [ text """
Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Mauris sagittis pellentesque lacus eleifend lacinia...
"""
          ]
        , Actions [ border ]
          [ Button.render Mdl [0] model.mdl
            [ Button.colored
            , Button.ripple
            ]
            [ text "Get started" ]
          ]
        , Menu []
          [ Button.render Mdl [1] model.mdl
            [ Button.icon
            , Button.ripple
            ]
            [ Icon.i "share"]
          ]
        ]
      ]
    , Grid.cell []
      [ card
        [ e2
        , width "256px"
        , height "256px"
        , css "background" "url('../assets/elm.png') center / cover"
        ]
        [ Title [ expand ] ""
        , Actions
          [ css "background" "rgba(0, 0, 0, 0.2)"
          , css "font-weight" "bold"
          , css "font-size" "14px"
          , Color.text Color.white
          ]
          [ text "elm.png"
          ]
        ]
      ]
    ]
  ]
  |> Page.body2 "Cards" srcUrl intro references


intro : Html m
intro =
  Page.fromMDL "https://getmdl.io/components/#cards-section" """
> The Material Design Lite (MDL) card component is a user interface element
> representing a virtual piece of paper that contains related data — such as a
> photo, some text, and a link — that are all about a single subject.
>
> Cards are a convenient means of coherently displaying related content that is
> composed of different types of objects. They are also well-suited for presenting
> similar objects whose size or supported actions can vary considerably, like
> photos with captions of variable length. Cards have a constant width and a
> variable height, depending on their content.
>
> Cards are a fairly new feature in user interfaces, and allow users an access
> point to more complex and detailed information. Their design and use is an
> important factor in the overall user experience. See the card component's
> Material Design specifications page for details.
"""


srcUrl : String
srcUrl =
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Card.elm"


references : List (String, String)
references =
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Card"
  , Page.mds "https://material.google.com/components/cards.html"
  , Page.mdl "https://getmdl.io/components/#cards-section"
  ]
