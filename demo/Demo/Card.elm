module Demo.Card exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)

import Material.Card as Card
import Material

import Demo.Page as Page


-- VIEW


view : Html a
view =
  [ div
      []
      [
      ]
  ]
  |> Page.body2 "Card" srcUrl intro references


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
