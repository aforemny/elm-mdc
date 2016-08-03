module Demo.Menus exposing (model, Model, view, update, Msg(MDL))

import Html exposing (Html, text, p, a)
import Html.Attributes exposing (href)
import Platform.Cmd exposing (Cmd)

import Material
import Material.Color as Color
import Material.Elevation as Elevation
import Material.Grid as Grid
import Material.Menu as Menu exposing (..)
import Material.Options as Options exposing (cs, css, div)
import Material.Textfield as Textfield

import Demo.Page as Page


-- MODEL


type alias Mdl =
  Material.Model


type alias Model =
  { mdl : Material.Model
  , selected : Maybe String
  , icon : String
  }


model : Model
model =
  { mdl = Material.model
  , selected = Nothing
  , icon = "more_vert"
  }


-- ACTION, UPDATE


type Msg
  = MenuMsg Int Menu.Msg
  | MDL (Material.Msg Msg)
  | Select String
  | SetIcon String


update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of
    MDL action' ->
      Material.update action' model

    MenuMsg idx action ->
      (model, Cmd.none)

    Select n -> 
      ( { model | selected = Just n }
      , Cmd.none
      )

    SetIcon s -> 
      ( { model | icon = s } 
      , Cmd.none
      )


-- VIEW


menus : List (String, Menu.Property m)
menus =
  [ ("Bottom left", Menu.bottomLeft)
  , ("Bottom right", Menu.bottomRight)
  , ("Top left", Menu.topLeft)
  , ("Top right", Menu.topRight)
  ] 


items : List (Menu.Item Msg)
items =
  [ Menu.item
    [ Menu.onSelect (Select "Some Msg") ]
    [ text "Some Msg" ]
  , Menu.item
    [ Menu.divider, Menu.onSelect (Select "Another Msg") ]
    [ text "Another Msg" ]
  , Menu.item
    [ Menu.disabled, Menu.onSelect (Select "Disabled Msg") ]
    [ text "Disabled Msg" ]
  , Menu.item
    [ Menu.onSelect (Select "Yet Another Msg") ]
    [ text "Yet Another Msg" ]
  ]


view : Model -> Html Msg
view model =
  let 
    demo1 = 
      menus
      |> List.indexedMap (\idx m ->
           Grid.cell
             [ Grid.size Grid.All 6 ]
             [ container model idx m items ]
         )
      |> Grid.grid []

    demo2 = 
      [ Grid.grid 
          []
          [ Grid.cell 
              [ Grid.size Grid.All 4 
              ] 
              [ model.selected 
                  |> Maybe.map (\i -> "You chose item '" ++ i ++ "'")
                  |> Maybe.withDefault ""
                  |> text
              ]
          , Grid.cell
              [ Grid.size Grid.All 4
              , Grid.offset Grid.Desktop 4
              ]
              [ Textfield.render MDL [2] model.mdl 
                  [ Textfield.label "Menu icon"
                  , Textfield.floatingLabel
                  , Textfield.value model.icon
                  , Textfield.onInput SetIcon
                  ]
              , Options.styled p [ css "margin-top" "1rem" ] 
                  [ text "Try 'list' or 'menu', or refer to " 
                  , a [ href "https://design.google.com/icons/" ]
                      [ text " the Material Icon library" ]
                  , text " for possible values. Replace spaces (' ') with underscores ('_')."
                  ]
              ]
          ]
      ]

  in
    Page.body1' "Menus" srcUrl intro references [demo1] demo2


container
  : Model
  -> Int
  -> (String, Menu.Property Msg)
  -> List (Menu.Item Msg)
  -> Html Msg
container model idx (description, options) items =
  let
    bar idx rightAlign =
      div
        [ cs "bar"
        , css "box-sizing" "border-box"
        , css "width" "100%"
        , css "padding" "16px"
        , css "height" "64px"
        , Color.background Color.accent
        , Color.text Color.accentContrast
        ]
        [ div
            [ cs "wrapper"
            , css "box-sizing" "border-box"
            , css "position" "absolute"
            , css (if rightAlign then "right" else "left") "16px"
            ]
            [ Menu.render MDL [idx] model.mdl 
                [ options
                , Menu.icon model.icon
                , Menu.ripple
                ] 
                items
            ]
        ]

    background =
      div
        [ cs "background"
        , css "height" "148px"
        , css "width" "100%"
        , Color.background Color.white
        ]
        []
  in
    div []
      [ div
          [ Elevation.e2
          , css "position" "relative"
          , css "width" "200px"
          , css "margin" "0 auto"
          , css "margin-bottom" "40px"
          ]
          ( if idx > 1 then
              [ background
              , bar idx (idx % 2 == 1)
              ]
            else
              [ bar idx (idx % 2 == 1)
              , background
              ]
          )
      , div
          [ css "margin" "0 auto"
          , css "width" "200px"
          , css "text-align" "center"
          , css "height" "48px"
          , css "line-height" "48px"
          , css "margin-bottom" "40px"
          ]
          [ text description ]
      ]


intro : Html m
intro =
  Page.fromMDL "https://www.getmdl.io/components/#menus-section" """

> The Material Design Lite (MDL) menu component is a user interface element
> that allows users to select one of a number of options. The selection
> typically results in an action initiation, a setting change, or other
> observable effect. Menu options are always presented in sets of two or more,
> and options may be programmatically enabled or disabled as required. The menu
> appears when the user is asked to choose among a series of options, and is
> usually dismissed after the choice is made.
>
> Menus are an established but non-standardized feature in user interfaces, and
> allow users to make choices that direct the activity, progress, or
> characteristics of software. Their design and use is an important factor in
> the overall user experience. See the menu component's <a href="http://www.google.com/design/spec/components/menus.html">Material Design
> specifications page</a> for details.

"""


srcUrl : String
srcUrl =
  "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Menus.elm"


references : List (String, String)
references =
  [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-menu"
  , Page.mds "https://www.google.com/design/spec/components/menus.html"
  , Page.mdl "https://www.getmdl.io/components/#menus-section"
  ]
