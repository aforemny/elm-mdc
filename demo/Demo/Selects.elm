module Demo.Selects exposing (Model, defaultModel, Msg(Mdl), update, view, subscriptions)

import Demo.Page as Page exposing (Page)
import Dict
import Html.Attributes as Html
import Html.Events as Html
import Html exposing (Html, text)
import Material
import Material.Component exposing (Index, Indexed)
import Material.List as Lists
import Material.Menu as Menu
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Select as Select
import Material.Theme as Theme
import Material.Typography as Typography


type alias Model =
    { mdl : Material.Model
    , selects : Indexed (Int, String)
    , darkTheme : Bool
    , rtl : Bool
    , disabled : Bool
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , selects = Dict.empty
    , darkTheme = False
    , rtl = False
    , disabled = False
    }


type Msg m
    = Mdl (Material.Msg.Msg m)
    | Select Index Int String
    | ToggleDarkTheme
    | ToggleRtl
    | ToggleDisabled


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model

        Select idx index value ->
            { model | selects = Dict.insert idx (index, value) model.selects } ! []

        ToggleDarkTheme ->
            { model | darkTheme = not model.darkTheme } ! []

        ToggleRtl ->
            { model | rtl = not model.rtl } ! []

        ToggleDisabled ->
            { model | disabled = not model.disabled } ! []


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    let
        exampleSelect id options _ =
            Select.render (Mdl >> lift) id model.mdl options
            ( [ "Pick a food group"
              , "Bread, Cereal, Rice, and Pasta"
              , "Vegetables"
              , "Fruit"
              , "Milk, Yogurt, and Cheese"
              , "Meat, Poultry, Fish, Dry Beans, Eggs, and Nuts"
              , "Fats, Oils, and Sweets"
              ]
              |> List.indexedMap (\index label ->
                     Menu.li Lists.li
                     [ Menu.onSelect (lift (Select id index label))
                     -- TODO:
                     -- , Menu.disabled |> when ((index == 0) || (index == 3))
                     ]
                     [ text label ]
                 )
            )
    in
    page.body "Select"
    [
      let
          (selectedIndex, selectedText) =
              Dict.get [0] model.selects
              |> Maybe.withDefault (0, "Pick a food group")
      in
      Page.hero []
      [ exampleSelect [0]
        [ Select.selectedText selectedText
        , Select.index selectedIndex
        , Select.disabled |> when model.disabled
        ]
        []
      ]

    , let
          (selectedIndex, selectedText) =
              Dict.get [1] model.selects
              |> Maybe.withDefault (0, "Pick a food group")
      in
      styled Html.section
      [ cs "example"
      , css "margin" "24px"
      , css "padding" "24px"
      ]
      [ styled Html.h2 [ Typography.title ] [ text "Select" ]
      , styled Html.section
        [ cs "demo-wrapper"
        , css "padding-top" "4px"
        , css "padding-bottom" "4px"
        , when model.darkTheme <|
          Options.many
          [ Theme.dark
          , css "background-color" "#303030"
          ]
        , when model.rtl <|
          Options.attribute (Html.attribute "dir" "rtl")
        ]
        [
          exampleSelect [1]
              [ Select.selectedText selectedText
              , Select.index selectedIndex
              , Select.disabled |> when model.disabled
              ]
              []
        ]

      , Html.p []
        [ text "Currently selected:"
        , Html.span [] [ text (selectedText ++ " at index " ++ toString selectedIndex) ]
        ]

      , Html.div
        []
        [ Html.label []
          [ Html.input
            [ Html.type_ "checkbox"
            , Html.onClick (lift ToggleDarkTheme)
            , Html.checked model.darkTheme
            ]
            []
          , text " Dark theme"
          ]
        ]

      , Html.div
        []
        [ Html.label []
          [ Html.input
            [ Html.type_ "checkbox"
            , Html.onClick (lift ToggleRtl)
            , Html.checked model.rtl
            ]
            []
          , text " RTL"
          ]
        ]

      , Html.div
        []
        [ Html.label []
          [ Html.input
            [ Html.type_ "checkbox"
            , Html.onClick (lift ToggleDisabled)
            , Html.checked model.disabled
            ]
            []
          , text " Disabled"
          ]
        ]
      ]
    ]


subscriptions : (Msg m -> m) -> Model -> Sub m
subscriptions lift model =
    Select.subs (Mdl >> lift) model.mdl
