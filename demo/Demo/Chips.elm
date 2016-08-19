module Demo.Chips exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.Attributes as Html
import Html.Events as Html

import Material.Chip as Chip
import Material.Icon as Icon
import Material.Grid as Grid
import Material.Color as Color
import Material.Options as Options exposing (css, cs)
import Material
import Material.Textfield as Textfield
import Material.Helpers as Helpers
import Material.Card as Card

import Demo.Page as Page
import Demo.Code as Code

import Dict exposing (Dict)

import Json.Decode as Json

-- MODEL


type alias Model =
  { mdl : Material.Model
  , chips : Dict Int String
  , value : String
  }


model : Model
model =
  { mdl = Material.model
  , chips = Dict.fromList [(0, "Chip 0")]
  , value = ""
  }


-- ACTION, UPDATE


type Msg
  = Mdl (Material.Msg Msg)
  | AddChip Int String
  | RemoveChip Int
  | NoOp
  | KeyUp Int
  | Input String
  | ChipClick Int



lastIndex : Dict Int b -> Int
lastIndex dict =
  Dict.keys dict
    |> List.reverse
    |> List.head
    |> Maybe.withDefault 0

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    NoOp ->
        (model, Cmd.none)

    Input value ->
      ( { model | value = value }, Cmd.none )

    KeyUp keyCode ->
      let
        -- _ = Debug.log "KeyUp" keyCode

        cmds =
          if keyCode == 13 then
            [ Helpers.cmd (AddChip ((lastIndex model.chips) + 1) model.value)
            , Helpers.cmd (Input "")
            ]
          else
            []
      in
        (model, Cmd.batch cmds)

    Mdl action' ->
      Material.update action' model

    ChipClick index ->
      let
        _ = Debug.log "CLICKED" index
      in
        (model, Cmd.none)

    AddChip index content ->
      let
        -- _ = Debug.log "Adding chip" index
        -- _ = Debug.log "Content" content

        model' =
          { model | chips = Dict.insert index content model.chips }
      in
        (model', Cmd.none)

    RemoveChip index ->
      let
        _ = Debug.log "Removing chip" index

        model' =
          { model | chips = Dict.remove index model.chips }

      in
        (model', Cmd.none)


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
  [ ( Chip.chipSpan []
        [ Chip.content []
            [ text "Basic Chip" ]
        ]
    , """
      Chip.chipSpan []
        [ Chip.content []
            [ text "Basic Chip" ]
        ]
       """
    )
  , ( Chip.chipSpan
        [ Chip.deleteIcon "cancel" ]
        [ Chip.content []
            [ text "Deletable Chip" ]
        ]
    , """
      Chip.chipSpan
        [ Chip.deleteIcon "cancel" ]
        [ Chip.content []
            [ text "Deletable Chip" ]
        ]
       """
    )
  , ( Chip.chipButton []
        [ Chip.content []
            [ text "Button Chip" ]
        ]
    , """
      Chip.chipButton []
        [ Chip.content []
            [ text "Button Chip" ]
        ]
       """
    )
  ,  ( Chip.chipSpan []
          [ Chip.contact Html.span
              [ Color.background Color.primary
              , Color.text Color.white
              ]
              [ text "A" ]
          , Chip.content []
              [ text "Contact Chip" ]
          ]
     , """
        Chip.chipSpan []
          [ Chip.contact Html.span
              [ Color.background Color.primary
              , Color.text Color.white
              ]
              [ text "A" ]
          , Chip.content []
              [ text "Contact Chip" ]
          ]
        """
     )
  , ( Chip.chipSpan
        [ Chip.deleteLink "#chips"]
        [ Chip.contact Html.span
            [ Color.background Color.primary
            , Color.text Color.white
            ]
            [ text "A" ]
        , Chip.text []
            "Deletable Contact Chip"
        ]
    , """
      Chip.chipSpan
        [ Chip.deleteLink "#chips"
        ]
        [ Chip.contact Html.span
            [ Color.background Color.primary
            , Color.text Color.white
            ]
            [ text "A" ]
        , Chip.content []
            [ text "Deletable Contact Chip" ]
        ]
       """
    )
  , ( Chip.chipSpan []
        [ Chip.contact Html.img
            [ Options.css "background-image" "url('assets/images/elm.png')"
            , Options.css "background-size" "cover"
            ]
            [ text "" ]
        , Chip.content []
            [ text "Chip with image" ]
        ]
    , """
      Chip.chipSpan []
        [ Chip.contact Html.img
            [ Options.css "background-image"
                "url('assets/images/elm.png')"
            , Options.css "background-size"
                "cover"
            ]
            [ text "" ]
        , Chip.content []
            [ text "Chip with image" ]
        ]
       """
    )
  ] |> List.map demoContainer


view : Model -> Html Msg
view model  =
  let
    examples =
      [ Html.div []
          [ Html.p [] [text "Example use:"]
          , Grid.grid [] <|
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

    interactive =
      [ Options.styled Html.div
          [ Color.background Color.white
          ]
          ((Dict.toList model.chips
            |> List.map (\ (index, value) ->
                           Chip.chipSpan
                             [ Options.css "margin" "17.5px 0"
                             , Chip.onClick (ChipClick index)
                             , Chip.deleteClick (RemoveChip index)
                             ]
                             [ Chip.contact Html.img
                                 [ Options.css "background-image" "url('assets/images/elm.png')"
                                 , Options.css "background-size" "cover"
                                 ]
                                 [ text "" ]
                             , Chip.content []
                                 [ text value ]
                             ]
                        )
          ) ++
             [ Textfield.render Mdl [0] model.mdl
                 [ Textfield.label "Search"
                 , Options.css "margin-left" "20px"
                 , Textfield.on "keyup" (Json.map KeyUp Html.keyCode)
                 , Textfield.onInput Input
                 , Textfield.value model.value
                 ]
             ]
          )
      ]
  in
    Page.body1' "Chips" srcUrl intro references
      examples
      interactive


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
