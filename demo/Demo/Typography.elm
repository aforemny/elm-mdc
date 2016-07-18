module Demo.Typography exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.Attributes as Html exposing (class, classList)

import Material.Typography as Typo
import Material
import Material.Grid as Grid

import Demo.Page as Page
import Demo.Code as Code


-- MODEL


type alias Mdl =
  Material.Model


type alias Model =
  { mdl : Material.Model
  }


model : Model
model =
  { mdl = Material.model
  }


-- ACTION, UPDATE


type Msg
  = TypographyMsg
  | Mdl Material.Msg


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    TypographyMsg ->
      (model, Cmd.none)

    Mdl action' ->
      Material.update Mdl action' model



typoDemo : (Html m, String) -> Grid.Cell m
typoDemo (html, code) =
  Grid.cell [Grid.size Grid.All 4]
    [ div [] [ html ]
    , Code.code code
    ]



typoRow : (Html m, String) -> Html m
typoRow (html, code) =
  tr []
    [ td [ Html.style [("padding-right", "40px")]] [Code.code code]
    , td [ Html.style [("padding-left", "40px")]] [html]
    ]

-- VIEW


view : Model -> Html Msg
view model  =
  [ Grid.grid []
      [ Grid.cell [Grid.size Grid.All 12]
          [ p [] [text "Example use: "]
          , Code.code """
                       import Material.Typography as Typo
                       """
          ]


      , Grid.cell [ Grid.size Grid.All 12 ]
        [ table []
            [ tbody []
                [ typoRow
                   ( p [ Typo.display4 ] [text "Light 112px"]
                   , """
                      p [ Typo.display4 ]
                        [ text "Light 112px" ]
                      """
                   )

                , typoRow
                      ( p [ Typo.display3 ] [text "Regular 56px" ]
                      , """
                        p [ Typo.display3 ]
                          [text "Regular 56px" ]
                        """
                      )

                , typoRow
                      ( p [ Typo.display2 ] [text "Regular 45px"]
                      , """
                        p [ Typo.display2 ]
                          [text "Regular 45px"]
                        """
                      )

                 , typoRow
                   ( p [ Typo.display1 ] [text "Regular 34px"]
                   , """
                      p [ Typo.display1 ]
                        [ text "Regular 34px" ]
                      """
                   )

                 , typoRow
                   ( p [ Typo.headline ] [text "Regular 24px"]
                   , """
                      p [ Typo.headline ]
                        [text "Regular 24px"]
                      """
                   )

                 , typoRow
                   ( p [ Typo.title ] [text "Medium 20px"]
                   , """
                      p [ Typo.title ]
                        [text "Medium 20px"]
                      """
                   )

                 , typoRow
                   ( p [ Typo.subheading ] [text "Regular 16px (Device), Regular 15px (Desktop)"]
                   , """
                      p [ Typo.subheading ]
                        [text "Regular 16px (Device), Regular 15px (Desktop)"]
                      """
                   )

                 , typoRow
                   ( p [ Typo.body2 ] [text "Medium 14px (Device), Medium 13px (Desktop)"]
                   , """
                      p [ Typo.body2 ]
                        [text "Medium 14px (Device), Medium 13px (Desktop)"]
                      """
                   )

                 , typoRow
                   ( p [ Typo.body1 ] [text "Regular 14px (Device), Regular 13px (Desktop)"]
                   , """
                      p [ Typo.body1 ]
                        [text "Regular 14px (Device), Regular 13px (Desktop)"]
                      """
                   )

                 , typoRow
                   ( p [ Typo.caption ] [text "Regular 12px"]
                   , """
                      p [ Typo.caption ]
                        [text "Regular 12px"]
                      """
                   )

                 , typoRow
                   ( p [ Typo.button ] [text "Medium (All Caps) 14px"]
                   , """
                      p [ Typo.button ]
                        [text "Medium (All Caps) 14px"]
                      """
                   )

                 , typoRow
                   ( p [ Typo.menu ] [text "Medium 14px (Device), Medium 13px (Desktop)"]
                   , """
                      p [ Typo.menu ]
                        [text "Medium 14px (Device), Medium 13px (Desktop)"]
                      """
                   )
                ]
            ]
        ]
      ]
  ]
  |> Page.body2 "Typography" srcUrl intro references


intro : Html m
intro =
  Page.fromMDL "https://www.getmdl.io/components/index.html#Typography-section" """
> ...
"""


srcUrl : String
srcUrl =
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Typography.elm"


references : List (String, String)
references =
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Typography"
  , Page.mds "https://www.google.com/design/spec/components/Typography.html"
  , Page.mdl "https://www.getmdl.io/components/index.html#Typography"
  ]
