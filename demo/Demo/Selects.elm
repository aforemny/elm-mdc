module Demo.Selects exposing (Model, defaultModel, Msg(Mdl), update, view, subscriptions)

import Dict
import Html exposing (Html, text)
import Html.Attributes as Html
import Json.Decode as Json
import Material
import Material.Checkbox as Checkbox
import Material.Component exposing (Index, Indexed)
import Material.List as Lists
import Material.Menu as Menu
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Select as Select
import Material.Typography as Typography
import Material.Theme as Theme
import Demo.Page exposing (Page)


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
        (selectedIndex, selectedText) =
            Dict.get [0] model.selects
            |> Maybe.withDefault (0, "Pick a food group")
    in
    page.body "Select"
    [
      styled Html.section
      [ cs "example"
      ]
      [ styled Html.h2 [ Typography.title ] [ text "Fully-Featured Component" ]
      , styled Html.section
        [ cs "demo-wrapper"
        , when model.darkTheme <|
          Options.many
          [ Theme.dark
          , css "background-color" "#303030"
          ]
        , when model.rtl <|
          Options.attribute (Html.attribute "dir" "rtl")
        ]
        [ Select.render (Mdl >> lift) [0] model.mdl
          [ Select.selectedText selectedText
          , Select.index selectedIndex
          , Select.disabled |> when model.disabled
          ]
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
                   [ Menu.onSelect (Json.succeed (lift (Select [0] index label)))
                   -- TODO: disabled
                   -- Menu.disabled |> when ((index == 0) || (index == 3))
                   ]
                   [ text label ]
               )
          )
        ]

      , Html.p []
        [ text "Currently selected:"
        , Html.span [] [ text (selectedText ++ " at index " ++ toString selectedIndex) ]
        ]

      , Html.div
        []
        [ Checkbox.render (Mdl >> lift) [1] model.mdl
          [ Options.onClick (lift ToggleDarkTheme)
          , Checkbox.checked |> when model.darkTheme
          ]
          []
        , Html.label [] [ text "Dark theme" ]
        ]

      , Html.div
        []
        [ Checkbox.render (Mdl >> lift) [2] model.mdl
          [ Options.onClick (lift ToggleRtl)
          , Checkbox.checked |> when model.rtl
          ]
          []
        , Html.label [] [ text "RTL" ]
        ]

      , Html.div
        []
        [ Checkbox.render (Mdl >> lift) [3] model.mdl
          [ Options.onClick (lift ToggleDisabled)
          , Checkbox.checked |> when model.disabled
          ]
          []
        , Html.label [] [ text "Disabled" ]
        ]
      ]
    ]


subscriptions : (Msg m -> m) -> Model -> Sub m
subscriptions lift model =
    Select.subs (Mdl >> lift) model.mdl
