module Demo.Chips exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.Attributes as Html

import Material.Chip as Chip
import Material.Icon as Icon
import Material.Grid as Grid
import Material.Options as Options exposing (css, cs)
import Material

import Demo.Page as Page
import Demo.Code as Code


-- MODEL


type alias Model =
  { mdl : Material.Model
  }


model : Model
model =
  { mdl = Material.model
  }


-- ACTION, UPDATE


type Msg
  = Mdl (Material.Msg Msg)


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    Mdl action' ->
      Material.update action' model


-- VIEW

demoContainer : (Html m, String) -> (Grid.Cell m)
demoContainer (html, code) =
  Grid.cell
  [ Grid.size Grid.All 4 ]
  [ Options.div
      [ css "text-align" "center" ]
      [ html ]
  , Code.code
      [ css "margin" "32px 0" ]
        code
  ]


demoChips : List (Grid.Cell m)
demoChips =
  [ ( Options.styled Html.span
        [ Chip.chip
        ]
        [ Options.styled Html.span
            [ Chip.text ]
            [ text "Basic Chip" ]
        ]
    , """
       Examples
       """
    )
  , ( Options.styled Html.span
        [ Chip.chip
        , Chip.deletable
        ]
        [ Options.styled Html.span
            [ Chip.text ]
            [ text "Deletable Chip" ]
        , Options.styled' Html.button
          [ Chip.action ]
          [ Html.type' "button" ]
          [ Icon.view "cancel"
              []
          ]
        ]
    , """
       Example
       """
    )
  , ( Options.styled' Html.button
        [ Chip.chip ]
        [ Html.type' "button" ]
        [ Options.styled Html.span
            [ Chip.text ]
            [ text "Button Chip" ]
        ]
    , """
       Examples
       """
    )
  ,  ( Options.styled Html.span
          [ Chip.chip
          , Chip.contact
          ]
          [ Options.styled Html.span
              [ Chip.contactItem
              , Options.cs "mdl-color--teal "
              , Options.cs "mdl-color-text--white"
              ]
              [ text "A" ]
          , Options.styled Html.span
              [ Chip.text ]
              [ text "Contact Chip" ]
          ]
     , """
        Example
        """
     )
  , ( Options.styled Html.span
        [ Chip.chip
        , Chip.contact
        , Chip.deletable
        ]
        [ Options.styled Html.span
            [ Chip.contactItem
            , Options.cs "mdl-color--teal "
            , Options.cs "mdl-color-text--white"
            ]
            [ text "A" ]
        , Options.styled Html.span
          [ Chip.text ]
          [ text "Deletable Contact Chip" ]

        , Options.styled' Html.button
          [ Chip.action ]
          [ Html.type' "button" ]
          [ Icon.view "cancel"
              []
          ]
        ]
    , """
       Example
       """
    )
  ] |> List.map demoContainer


view : Model -> Html Msg
view model  =
  [ Html.div []
      [ Html.p [] [text "Example use:"]
      , Grid.grid []
          ( Grid.cell
              [ Grid.size Grid.All 12]
              [ Code.code [ css "margin" "24px 0" ]
                  """
                   import Material.Chip as Chip
                   """
              ]
          :: demoChips)
      ]

  ]
  |> Page.body2 "Chips" srcUrl intro references


intro : Html m
intro =
  Page.fromMDL "https://www.getmdl.io/components/index.html#chips-section" """
> The Material Design Lite (MDL) chip component is a small, interactive element.
> Chips are commonly used for contacts, text, rules, icons, and photos.
"""


srcUrl : String
srcUrl =
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Chips.elm"


references : List (String, String)
references =
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Chip"
  , Page.mds "https://www.google.com/design/spec/components/chips.html"
  , Page.mdl "https://www.getmdl.io/components/index.html#chips-section"
  ]
