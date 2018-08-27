module Demo.Selects exposing (Model, Msg(..), defaultModel, subscriptions, update, view)

import Array
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Html.Attributes as Html
import Html.Events as Html
import Material
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Select as Select
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m
    , selects : Dict Material.Index Select
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , selects = Dict.empty
    }


type alias Select =
    { value : Maybe String
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
    = Mdc (Material.Msg m)
    | Pick Material.Index String
    | ToggleRtl Material.Index
    | ToggleDisabled Material.Index


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        Pick index value ->
            let
                selects =
                    Dict.get index model.selects
                        |> Maybe.withDefault defaultSelect
                        |> (\selectState ->
                                Dict.insert index
                                    { selectState | value = Just value }
                                    model.selects
                           )
            in
            ( { model | selects = selects }, Cmd.none )

        ToggleRtl index ->
            let
                selects =
                    Dict.get index model.selects
                        |> Maybe.withDefault defaultSelect
                        |> (\selectState ->
                                Dict.insert index
                                    { selectState | rtl = not selectState.rtl }
                                    model.selects
                           )
            in
            ( { model | selects = selects }, Cmd.none )

        ToggleDisabled index ->
            let
                selects =
                    Dict.get index model.selects
                        |> Maybe.withDefault defaultSelect
                        |> (\selectState ->
                                Dict.insert index
                                    { selectState | disabled = not selectState.disabled }
                                    model.selects
                           )
            in
            ( { model | selects = selects }, Cmd.none )


heroSelect :
    (Msg m -> m)
    -> Material.Index
    -> Model m
    -> List (Select.Property m)
    -> List (Html m)
    -> Html m
heroSelect lift id model options _ =
    Select.view (lift << Mdc)
        id
        model.mdc
        options
        ([ "Bread, Cereal, Rice, and Pasta"
         , "Vegetables"
         , "Fruit"
         , "Milk, Yogurt, and Cheese"
         , "Meat, Poultry, Fish, Dry Beans, Eggs, and Nuts"
         , "Fats, Oils, and Sweets"
         ]
            |> List.indexedMap
                (\index label ->
                    Select.option
                        [ Select.value (String.fromInt index)
                        ]
                        [ text label ]
                )
        )


example : List (Options.Property c m) -> List (Html m) -> Html m
example options =
    styled Html.section
        (cs "example"
            :: css "margin" "24px"
            :: css "padding" "24px"
            :: css "max-width" "400px"
            :: options
        )


select :
    (Msg m -> m)
    -> Material.Index
    -> Model m
    -> Maybe Int
    -> List (Select.Property m)
    -> List (Html m)
    -> List (Html m)
select lift id model selectedIndex options _ =
    let
        state =
            Dict.get id model.selects
                |> Maybe.withDefault defaultSelect

        fruits =
            Array.fromList
                [ "Fruit Roll Ups"
                , "Candy (cotton)"
                , "Vegetables"
                , "Noodles"
                ]

        selectedValue =
            case state.value of
                Nothing ->
                    case selectedIndex of
                        Nothing ->
                            Nothing

                        Just i ->
                            Array.get i fruits

                Just v ->
                    state.value
    in
    [ styled Html.section
        [ cs "demo-wrapper"
        , css "padding-top" "4px"
        , css "padding-bottom" "4px"
        , Options.attribute (Html.attribute "dir" "rtl") |> when state.rtl
        ]
        [ Select.view (lift << Mdc)
            id
            model.mdc
            ([ Select.label "Food Group"
             , Options.onChange (lift << Pick id)
             , Select.preselected |> when (selectedIndex /= Nothing)
             , Select.disabled |> when state.disabled
             ]
                ++ options
            )
            (fruits
                |> Array.toList
                |> List.indexedMap
                    (\index label ->
                        Select.option
                            [ Select.value label
                            , when
                                (case selectedIndex of
                                    Nothing ->
                                        False

                                    Just i ->
                                        index == i
                                )
                                Select.selected
                            ]
                            [ text label ]
                    )
            )
        ]
    , Html.p []
        [ text "Currently selected: "
        , Html.span []
            [ if selectedValue /= Nothing then
                text (Maybe.withDefault "" selectedValue)
              else
                text "(none)"
            ]
        ]
    , Html.div []
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
    , Html.div []
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
        [ let
            state =
                Dict.get "selects-hero-select" model.selects
                    |> Maybe.withDefault defaultSelect
          in
          Page.hero []
            [ heroSelect lift
                "selects-hero-select"
                model
                [ Select.label "Pick a food group"
                , Select.disabled |> when state.disabled
                ]
                []
            ]
        , example []
            (List.concat
                [ [ styled Html.h2
                        [ Typography.title
                        ]
                        [ text "Select"
                        ]
                  ]
                , select lift "selects-select" model (Just 2) [] []
                ]
            )
        , example []
            (List.concat
                [ [ styled Html.h2
                        [ Typography.title
                        ]
                        [ text "Select box"
                        ]
                  ]
                , select lift "selects-box-select" model Nothing [ Select.box ] []
                ]
            )
        ]


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model
