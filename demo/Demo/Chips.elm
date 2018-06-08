module Demo.Chips exposing (Model, Msg(Mdc), defaultModel, update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Html.Attributes as Html
import Material
import Material.Chip as Chip
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m
    , selectedIndex : Maybe Int
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , selectedIndex = Nothing
    }


type Msg m
    = Mdc (Material.Msg m)
    | ChipClick Int


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ChipClick index ->
            ( { model | selectedIndex = Just index }, Cmd.none )


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    let
        selected index =
            Maybe.map
                (\i ->
                    if i == index then
                        Chip.selected
                    else
                        Options.nop
                )
                model.selectedIndex
                |> Maybe.withDefault Options.nop
    in
    page.body "Chips"
        [ Page.hero []
            [ Chip.view (lift << Mdc)
                [ 0, 0 ]
                model.mdc
                [ Chip.ripple
                , css "margin-right" "32px"
                ]
                [ text "Example"
                ]
            ]
        , styled Html.div
            [ cs "demo-wrapper"
            ]
            [ styled Html.h1
                [ Typography.display2
                , css "padding-left" "36px"
                , css "padding-top" "64px"
                , css "padding-bottom" "8px"
                ]
                [ text "Choice Chips"
                ]
            , styled Html.div
                [ css "padding" "0 24px 16px"
                ]
                [ Chip.chipset
                    [ Chip.view (lift << Mdc)
                        [ 0 ]
                        model.mdc
                        [ Chip.ripple
                        , Options.onClick (lift <| ChipClick 0)
                        , Options.attribute (Html.tabindex 0)
                        , selected 0
                        ]
                        [ text "Extra Small" ]
                    , Chip.view (lift << Mdc)
                        [ 1 ]
                        model.mdc
                        [ Chip.ripple
                        , Options.onClick (lift <| ChipClick 1)
                        , Options.attribute (Html.tabindex 1)
                        , selected 1
                        ]
                        [ text "Small" ]
                    , Chip.view (lift << Mdc)
                        [ 2 ]
                        model.mdc
                        [ Chip.ripple
                        , Options.onClick (lift <| ChipClick 2)
                        , Options.attribute (Html.tabindex 2)
                        , selected 2
                        ]
                        [ text "Medium" ]
                    , Chip.view (lift << Mdc)
                        [ 3 ]
                        model.mdc
                        [ Chip.ripple
                        , Options.onClick (lift <| ChipClick 3)
                        , Options.attribute (Html.tabindex 3)
                        , selected 3
                        ]
                        [ text "Large" ]
                    , Chip.view (lift << Mdc)
                        [ 4 ]
                        model.mdc
                        [ Chip.ripple
                        , Options.onClick (lift <| ChipClick 4)
                        , Options.attribute (Html.tabindex 4)
                        , selected 4
                        ]
                        [ text "Extra Large" ]
                    ]
                , styled Html.div
                    [ Typography.title
                    , css "padding" "48px 16px 24px"
                    ]
                    [ text "With leading icon"
                    ]
                , Chip.chipset
                    [ Chip.view (lift << Mdc)
                        [ 5 ]
                        model.mdc
                        [ Chip.ripple
                        , Options.attribute (Html.tabindex 5)
                        , Chip.leadingIcon "event"
                        ]
                        [ text "Add to calendar" ]
                    , Chip.view (lift << Mdc)
                        [ 6 ]
                        model.mdc
                        [ Chip.ripple
                        , Options.attribute (Html.tabindex 6)
                        , Chip.leadingIcon "bookmark"
                        ]
                        [ text "Bookmark" ]
                    ]
                , styled Html.div
                    [ Typography.title
                    , css "padding" "48px 16px 24px"
                    ]
                    [ text "With trailing icon"
                    ]
                , Chip.chipset
                    [ Chip.view (lift << Mdc)
                        [ 7 ]
                        model.mdc
                        [ Chip.ripple
                        , Options.attribute (Html.tabindex 7)
                        , Chip.trailingIcon "cancel"
                        ]
                        [ text "Anna" ]
                    , Chip.view (lift << Mdc)
                        [ 8 ]
                        model.mdc
                        [ Chip.ripple
                        , Options.attribute (Html.tabindex 8)
                        , Chip.trailingIcon "cancel"
                        ]
                        [ text "Bob" ]
                    ]
                ]
            ]
        ]
