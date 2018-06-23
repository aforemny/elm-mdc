module Demo.Chips exposing (Model, Msg(Mdc), defaultModel, update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.Chip as Chip
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Typography as Typography
import Set exposing (Set)


type alias Model m =
    { mdc : Material.Model m
    , selectedChips : Set Material.Index
    , choiceChip : Material.Index
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , selectedChips =
        Set.fromList
            [ "chips-choice-medium"
            , "chips-filter-chips-tops"
            , "chips-filter-chips-bottoms"
            , "chips-filter-chips-alice"
            ]
    , choiceChip = "chips-choice-medium"
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleChip ChipType Material.Index


type ChipType
    = Choice
    | Filter
    | Action


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleChip chipType index ->
            case chipType of
                Choice ->
                    ( { model | choiceChip = index }, Cmd.none )

                _ ->
                    let
                        selectedChips =
                            model.selectedChips
                                |> (if Set.member index model.selectedChips then
                                        Set.remove index
                                    else
                                        Set.insert index
                                   )
                    in
                    ( { model | selectedChips = selectedChips }, Cmd.none )


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body "Chips"
        [ Page.hero []
            [ heroChips lift model
            ]
        , styled Html.div
            [ cs "demo-wrapper"
            , css "padding" "48px"
            ]
            (List.concat
                [ choiceChips lift model
                , filterChips lift model
                , actionChips lift model
                ]
            )
        ]


heroChips : (Msg m -> m) -> Model m -> Html m
heroChips lift model =
    Chip.chipset []
        [ Chip.view (lift << Mdc)
            "chips-hero-one"
            model.mdc
            []
            [ text "Chip One"
            ]
        , Chip.view (lift << Mdc)
            "chips-hero-two"
            model.mdc
            []
            [ text "Chip Two"
            ]
        , Chip.view (lift << Mdc)
            "chips-hero-three"
            model.mdc
            []
            [ text "Chip Three"
            ]
        , Chip.view (lift << Mdc)
            "chips-hero-four"
            model.mdc
            []
            [ text "Chip Four"
            ]
        ]


choiceChips : (Msg m -> m) -> Model m -> List (Html m)
choiceChips lift model =
    let
        chip index label =
            Chip.view (lift << Mdc)
                index
                model.mdc
                [ Chip.onClick (lift (ToggleChip Choice index))
                , when (index == model.choiceChip) Chip.selected
                ]
                [ text label
                ]
    in
    [ styled Html.h2
        [ Typography.subheading1
        ]
        [ text "Choice Chips"
        ]
    , Chip.chipset
        [ Chip.choice
        ]
        [ chip "chips-choice-extra-small" "Extra Small"
        , chip "chips-choice-small" "Small"
        , chip "chips-choice-medium" "Medium"
        , chip "chips-choice-large" "Large"
        , chip "chips-choice-extra-large" "Extra Large"
        ]
    ]


filterChips : (Msg m -> m) -> Model m -> List (Html m)
filterChips lift model =
    [ styled Html.h2
        [ Typography.subheading1
        ]
        [ text "Filter Chips"
        ]
    , styled Html.h3
        [ Typography.body2 ]
        [ text "No leading icon" ]
    , let
        chip index label =
            Chip.view (lift << Mdc)
                index
                model.mdc
                [ Chip.onClick (lift (ToggleChip Filter index))
                , when (Set.member index model.selectedChips) Chip.selected
                ]
                [ text label
                ]
      in
      Chip.chipset
        [ Chip.filter
        ]
        [ chip "chips-filter-chips-tops" "Tops"
        , chip "chips-filter-chips-bottoms" "Bottoms"
        , chip "chips-filter-chips-shoes" "Shoes"
        , chip "chips-filter-chips-accessories" "Accessories"
        ]
    , styled Html.h3
        [ Typography.body2 ]
        [ text "With leading icon" ]
    , let
        chip index label =
            Chip.view (lift << Mdc)
                index
                model.mdc
                [ Chip.onClick (lift (ToggleChip Filter index))
                , Chip.leadingIcon "face"
                , Chip.checkmark
                , when (Set.member index model.selectedChips) Chip.selected
                ]
                [ text label
                ]
      in
      Chip.chipset []
        [ chip "chips-filter-chips-alice" "Alice"
        , chip "chips-filter-chips-bob" "Bob"
        , chip "chips-filter-chips-charlie" "Charlie"
        , chip "chips-filter-chips-danielle" "Danielle"
        ]
    ]


actionChips : (Msg m -> m) -> Model m -> List (Html m)
actionChips lift model =
    let
        chip index ( leadingIcon, label ) =
            Chip.view (lift << Mdc)
                index
                model.mdc
                [ Chip.onClick (lift (ToggleChip Action index))
                , Chip.leadingIcon leadingIcon
                ]
                [ text label
                ]
    in
    [ styled Html.h2
        [ Typography.subheading1
        ]
        [ text "Action Chips"
        ]
    , Chip.chipset []
        [ chip "chips-action-chips-add-to-calendar" ( "event", "Add to calendar" )
        , chip "chips-action-chips-bookmark" ( "bookmark", "Bookmark" )
        , chip "chips-action-chips-set-alarm" ( "alarm", "Set alarm" )
        , chip "chips-action-chips-get-directions" ( "directions", "Get directions" )
        ]
    ]
