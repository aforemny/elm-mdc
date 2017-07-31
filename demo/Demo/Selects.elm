module Demo.Selects exposing (Model, model, Msg(..), update, view)

import Dict
import Html exposing (Html, text)
import Html.Attributes as Html
import Json.Decode as Json
import Material
import Material.Toggles as Checkbox
import Material.Component exposing (Index, Indexed)
import Material.List as Lists
import Material.Menu as Menu
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Select as Select
import Material.Typography as Typography
import Material.Theme as Theme


-- MODEL


type alias Model =
    { mdl : Material.Model
    , selects : Indexed (Int, String)
    , darkTheme : Bool
    , rtl : Bool
    , disabled : Bool
    }


model : Model
model =
    { mdl = Material.model
    , selects = Dict.empty
    , darkTheme = False
    , rtl = False
    , disabled = False
    }


type Msg
    = Mdl (Material.Msg.Msg Msg)
    | Select Index Int String
    | ToggleDarkTheme
    | ToggleRtl
    | ToggleDisabled


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model

        Select idx index value ->
            { model | selects = Dict.insert idx (index, value) model.selects } ! []

        ToggleDarkTheme ->
            { model | darkTheme = not model.darkTheme } ! []

        ToggleRtl ->
            { model | rtl = not model.rtl } ! []

        ToggleDisabled ->
            { model | disabled = not model.disabled } ! []


-- VIEW

view : Model -> Html Msg
view model =
    let
        (selectedIndex, selectedText) =
            Dict.get [0] model.selects
            |> Maybe.withDefault (0, "Pick a food group")
    in
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
      [ Select.render Mdl [0] model.mdl
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
                 [ Menu.onSelect (Json.succeed (Select [0] index label))
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
      [ Checkbox.checkbox Mdl [1] model.mdl
        [ Options.onClick ToggleDarkTheme
        , Checkbox.value model.darkTheme
        ]
        []
      , Html.label [] [ text "Dark theme" ]
      ]

    , Html.div
      []
      [ Checkbox.checkbox Mdl [2] model.mdl
        [ Options.onClick ToggleRtl
        , Checkbox.value model.rtl
        ]
        []
      , Html.label [] [ text "RTL" ]
      ]

    , Html.div
      []
      [ Checkbox.checkbox Mdl [3] model.mdl
        [ Options.onClick ToggleDisabled
        , Checkbox.value model.disabled
        ]
        []
      , Html.label [] [ text "Disabled" ]
      ]
    ]

--  <p>Currently selected: <span id="currently-selected">(none)</span></p>
--  <div>
--    <input id="dark-theme" type="checkbox">
--    <label for="dark-theme">Dark Theme</label>
--  </div>
--  <div>
--    <input id="rtl" type="checkbox">
--    <label for="rtl">RTL</label>
--  </div>
--  <div>
--    <input id="disabled" type="checkbox">
--    <label for="disabled">Disabled</label>
--  </div>
--</section>
