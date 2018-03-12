module Demo.Selects exposing (Model, defaultModel, Msg(Mdc), update, view, subscriptions)

import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html.Attributes as Html
import Html.Events as Html
import Html exposing (Html, text)
import Material
import Material.Menu as Menu
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Select as Select
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m
    , selects : Dict (List Int) Select
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , selects = Dict.empty
    }


type alias Select =
    { value : Maybe ( Int, String )
    , rtl : Bool
    , disabled : Bool
    }


defaultSelect : Select
defaultSelect =
    { value = Nothing
    , rtl = False
    , disabled = False
    }


type Msg m
    = Mdc (Material.Msg.Msg m)
    | Pick (List Int) ( Int, String )
    | ToggleRtl (List Int)
    | ToggleDisabled (List Int)


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        Pick index value ->
            let
                select =
                    Dict.get index model.selects
                    |> Maybe.withDefault defaultSelect
                    |> \ select -> { select | value = Just value }

                selects =
                    Dict.insert index select model.selects
            in
            ( { model | selects = selects }, Cmd.none )

        ToggleRtl index ->
            let
                select =
                    Dict.get index model.selects
                    |> Maybe.withDefault defaultSelect
                    |> \ select -> { select | rtl = not select.rtl }

                selects =
                    Dict.insert index select model.selects
            in
            ( { model | selects = selects }, Cmd.none )

        ToggleDisabled index ->
            let
                select =
                    Dict.get index model.selects
                    |> Maybe.withDefault defaultSelect
                    |> \ select -> { select | disabled = not select.disabled }

                selects =
                    Dict.insert index select model.selects
            in
            ( { model | selects = selects }, Cmd.none )


heroSelect
    : (Msg m -> m)
    -> List Int
    -> Model m
    -> List (Select.Property m)
    -> List (Html m)
    -> Html m
heroSelect lift id model options _ =
    Select.view (lift << Mdc) id model.mdc
    ( css "width" "377px"
    :: options
    )
    ( [ "Bread, Cereal, Rice, and Pasta"
      , "Vegetables"
      , "Fruit"
      , "Milk, Yogurt, and Cheese"
      , "Meat, Poultry, Fish, Dry Beans, Eggs, and Nuts"
      , "Fats, Oils, and Sweets"
      ]
      |> List.indexedMap (\index label ->
             Menu.li
             [ Menu.onSelect (lift (Pick id ( index, label )))
             -- TODO:
             -- , Menu.disabled |> when ((index == 0) || (index == 3))
             ]
             [ text label ]
         )
    )


example : List (Options.Property c m) -> List (Html m) -> Html m
example options =
    styled Html.section
      ( cs "example"
      :: css "margin" "24px"
      :: css "padding" "24px"
      :: css "max-width" "400px"
      :: options
      )


select
    : (Msg m -> m)
    -> List Int
    -> Model m
    -> List (Select.Property m)
    -> List (Html m)
    -> List (Html m)
select lift id model options _ =
    let
        state =
            Dict.get id model.selects
            |> Maybe.withDefault defaultSelect

        index =
            Maybe.map Tuple.first state.value

        selectedText =
            Maybe.map Tuple.second state.value
    in
    [
      styled Html.section
      [ cs "demo-wrapper"
      , css "padding-top" "4px"
      , css "padding-bottom" "4px"
      , Options.attribute (Html.attribute "dir" "rtl") |> when state.rtl
      ]
      [
        Select.view (lift << Mdc) id model.mdc
        ( Select.label "Food Group"
        :: when (index /= Nothing)
              (Select.index (Maybe.withDefault -1 index))
        :: when (selectedText /= Nothing)
              (Select.selectedText (Maybe.withDefault "" selectedText))
        :: when state.disabled Select.disabled
        :: css "width" "140px"
        :: options
        )
        ( [ "Fruit Roll Ups"
          , "Candy (cotton)"
          , "Vegetables"
          , "Noodles"
          ]
          |> List.indexedMap (\index label ->
                 Menu.li
                 [ Menu.onSelect (lift (Pick id ( index, label )))
                 -- TODO:
                 -- , Menu.disabled |> when ((index == 0) || (index == 3))
                 ]
                 [ text label ]
             )
        )
      ]
    ,
      Html.p []
      [ text "Currently selected: "
      , Html.span []
        [ if index /= Nothing then
            text (Maybe.withDefault "" selectedText ++ " at index " ++ toString (Maybe.withDefault -1 index) ++ " with value " ++ toString (Maybe.withDefault "" selectedText))
          else
            text "(none)"
        ]
      ]
    ,
      Html.div []
      [ Html.label []
        [ Html.input
          [ Html.type_ "checkbox"
          , Html.onClick (lift (ToggleRtl id))
          , Html.checked state.rtl
          ]
          []
        , text " RTL"
        ]
      ]
    ,
      Html.div []
      [ Html.label []
        [ Html.input
          [ Html.type_ "checkbox"
          , Html.onClick (lift (ToggleDisabled id))
          , Html.checked state.disabled
          ]
          []
        , text " Disabled"
        ]
      ]
    ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body "Select"
    [
      let
          state =
              Dict.get [0] model.selects
              |> Maybe.withDefault defaultSelect

          index =
              Maybe.map Tuple.first state.value

          selectedText =
              Maybe.map Tuple.second state.value
      in
      Page.hero []
      [ heroSelect lift [0] model
        [ Select.label "Pick a food group"
        , Select.index (Maybe.withDefault -1 index) |> when (index /= Nothing)
        , Select.selectedText (Maybe.withDefault "" selectedText) |> when (selectedText /= Nothing)
        , Select.disabled |> when state.disabled
        ]
        []
      ]
    ,
      example []
      ( List.concat
        [ [ styled Html.h2
            [ Typography.title
            ]
            [ text "Select"
            ]
          ]
        , select lift [1] model [] []
        ]
      )
    ,
      example []
      ( List.concat
        [ [ styled Html.h2
            [ Typography.title
            ]
            [ text "Select box"
            ]
          ]
        , select lift [2] model [ Select.box ] []
        ]
      )
    ]


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Select.subs (lift << Mdc) model.mdc
