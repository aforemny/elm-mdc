module Demo.Chips exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.Attributes as Html

import Material.Chip as Chip
import Material.Icon as Icon
import Material.Grid as Grid
import Material.Color as Color
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
  [ Grid.size Grid.All 6 ]
  [ Options.div
      [ css "text-align" "center" ]
      [ html ]
  , Code.code
      [ css "margin" "32px 0" ]
        code
  ]


demoChips : List (Grid.Cell m)
demoChips =
  [ ( Chip.chip []
        [ Chip.text []
            [ text "Basic Chip" ]
        ]
    , """
      Chip.chip []
        [ Chip.text []
            [ text "Basic Chip" ]
        ]
       """
    )
  , ( Chip.chip
        [ Chip.deletable ]
        [ Chip.text []
            [ text "Deletable Chip" ]
        , Chip.actionButton []
            [ Icon.view "cancel" [] ]
        ]
    , """
      Chip.chip
        [ Chip.deletable ]
        [ Chip.text []
            [ text "Deletable Chip" ]
        , Chip.actionButton []
            [ Icon.view "cancel" [] ]
        ]
       """
    )
  , ( Chip.chip' Html.button
        [ Options.type' "button" ]
        [ Chip.text []
            [ text "Button Chip" ]
        ]
    , """
      Chip.chip' Html.button
        [ Options.type' "button" ]
        [ Chip.text []
            [ text "Button Chip" ]
        ]
       """
    )
  ,  ( Chip.chip
          [ Chip.contact ]
          [ Chip.contactItem
              [ Color.background Color.primary
              , Color.text Color.white 
              ]
              [ text "A" ]
          , Chip.text []
              [ text "Contact Chip" ]
          ]
     , """
        Chip.chip
          [ Chip.contact ]
          [ Chip.contactItem
              [ Color.background Color.primary
              , Color.text Color.white
              ]
              [ text "A" ]
          , Chip.text []
              [ text "Contact Chip" ]
          ]
        """
     )
  , ( Chip.chip
        [ Chip.contact
        , Chip.deletable
        ]
        [ Chip.contactItem
            [ Color.background Color.primary
            , Color.text Color.white
            ]
            [ text "A" ]
        , Chip.text []
            [ text "Deletable Contact Chip" ]
        , Chip.action Html.a
            [ Options.attribute <| Html.href "#chips" ]
            [ Icon.view "cancel" [] ]
        ]
    , """
      Chip.chip
        [ Chip.contact
        , Chip.deletable
        ]
        [ Chip.contactItem
            [ Color.background Color.primary
            , Color.text Color.white
            ]
            [ text "A" ]
        , Chip.text []
            [ text "Deletable Contact Chip" ]
        , Chip.action Html.a
            [ Options.attribute <| Html.href "#chips" ]
            [ Icon.view "cancel" [] ]
        ]
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
