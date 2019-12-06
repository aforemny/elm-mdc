module Demo.Lists exposing (Model, Msg, defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Html.Attributes as Html
import Material
import Material.Checkbox as Checkbox
import Material.Icon as Icon
import Material.List as Lists
import Material.Options as Options exposing (css, styled, when)
import Material.RadioButton as RadioButton
import Material.Typography as Typography
import Set exposing (Set)


type alias Model m =
    { mdc : Material.Model m
    , selectedListItem : Dict String Int
    , selectedCheckboxes : Set Int
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , selectedListItem =
        Dict.empty
            |> Dict.insert "activated-item-list" 1
            |> Dict.insert "shaped-activated-item-list" 1
            |> Dict.insert "lists-list-with-radio-buttons" 4
    , selectedCheckboxes = Set.empty
    }


type Msg m
    = Mdc (Material.Msg m)
    | SelectListItem Material.Index Int


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        SelectListItem list index ->
            let
                selectedListItem =
                    Dict.insert list index model.selectedListItem

                selectedCheckboxes =
                    if list == "lists-list-with-checkbox" then
                        let
                            corrected_index =
                                if index >= 2 then
                                    index - 1

                                else
                                    index

                            present =
                                Set.member corrected_index model.selectedCheckboxes
                        in
                        if present then
                            Set.remove corrected_index model.selectedCheckboxes

                        else
                            Set.insert corrected_index model.selectedCheckboxes

                    else
                        model.selectedCheckboxes
            in
            ( { model | selectedListItem = selectedListItem, selectedCheckboxes = selectedCheckboxes }, Cmd.none )


demoList : (Msg m -> m) -> Model m -> Material.Index -> List (Lists.Property m)
demoList lift model index =
    let
        selected =
            Dict.get index model.selectedListItem
    in
    [ css "max-width" "600px"
    , css "border" "1px solid rgba(0,0,0,.1)"
    , Lists.onSelectListItem (lift << SelectListItem index)
    , case selected of
        Just i ->
            Lists.selectedIndex i

        Nothing ->
            Options.nop
    ]


heroList : (Msg m -> m) -> Model m -> Material.Index -> Html m
heroList lift model index =
    Lists.ul (lift << Mdc)
        index
        model.mdc
        (css "background" "#fff" :: demoList lift model index)
        (List.repeat 3 <| Lists.li [] [ text "Line item" ])


singleLineList : (Msg m -> m) -> Model m -> Material.Index -> Html m
singleLineList lift model index =
    Lists.ul (lift << Mdc)
        index
        model.mdc
        (demoList lift model index)
        (List.repeat 3 <| Lists.li [] [ text "Line item" ])


twoLineList : (Msg m -> m) -> Model m -> Material.Index -> Html m
twoLineList lift model index =
    Lists.ul (lift << Mdc)
        index
        model.mdc
        (Lists.twoLine :: demoList lift model index)
        (List.repeat 3 <|
            Lists.li []
                [ Lists.text []
                    [ Lists.primaryText [] [ text "Line item" ]
                    , Lists.secondaryText [] [ text "Secondary text" ]
                    ]
                ]
        )


leadingIconList : (Msg m -> m) -> Model m -> Material.Index -> Html m
leadingIconList lift model index =
    Lists.ul (lift << Mdc)
        index
        model.mdc
        (demoList lift model index)
        [ Lists.li [] [ Lists.graphicIcon [] "wifi", text "Line item" ]
        , Lists.li [] [ Lists.graphicIcon [] "bluetooth", text "Line item" ]
        , Lists.li [] [ Lists.graphicIcon [] "data_usage", text "Line item" ]
        ]


trailingIconList : (Msg m -> m) -> Model m -> Material.Index -> Html m
trailingIconList lift model index =
    Lists.ul (lift << Mdc)
        index
        model.mdc
        (demoList lift model index)
        (List.repeat 3 <| Lists.li [] [ text "Line item", Lists.metaIcon [] "info" ])


activatedItemList : (Msg m -> m) -> Model m -> Material.Index -> Html m
activatedItemList lift model index =
    Lists.ul (lift << Mdc)
        index
        model.mdc
        (Lists.useActivated :: Lists.singleSelection :: demoList lift model index)
        [ Lists.li [] [ Lists.graphicIcon [] "inbox", text "Inbox" ]
        , Lists.li [] [ Lists.graphicIcon [] "star", text "Star" ]
        , Lists.li [] [ Lists.graphicIcon [] "send", text "Sent" ]
        , Lists.li [] [ Lists.graphicIcon [] "drafts", text "Drafts" ]
        ]


shapedActivatedItemList : (Msg m -> m) -> Model m -> Material.Index -> Html m
shapedActivatedItemList lift model index =
    Lists.ul (lift << Mdc)
        index
        model.mdc
        (Lists.useActivated :: Lists.singleSelection :: demoList lift model index)
        [ Lists.li [] [ Lists.graphicIcon [] "inbox", text "Inbox" ]
        , Lists.li
            [ css "border-radius" "0 32px 32px 0" ]
            [ Lists.graphicIcon [] "star", text "Star" ]
        , Lists.li [] [ Lists.graphicIcon [] "send", text "Sent" ]
        , Lists.li [] [ Lists.graphicIcon [] "drafts", text "Drafts" ]
        ]


demoIcon : List (Icon.Property m)
demoIcon =
    [ css "background" "rgba(0,0,0,.3)"
    , css "border-radius" "50%"
    , css "color" "#fff"
    ]


folderList : (Msg m -> m) -> Model m -> Material.Index -> Html m
folderList lift model index =
    Lists.ul (lift << Mdc)
        index
        model.mdc
        (Lists.twoLine :: Lists.avatarList :: demoList lift model index)
        [ Lists.li []
            [ Lists.graphicIcon demoIcon "folder"
            , Lists.text []
                [ Lists.primaryText [] [ text "Dog Photos" ]
                , Lists.secondaryText [] [ text "9 Jan 2018" ]
                ]
            , Lists.metaIcon [] "info"
            ]
        , Lists.li []
            [ Lists.graphicIcon demoIcon "folder"
            , Lists.text []
                [ Lists.primaryText [] [ text "Cat Photos" ]
                , Lists.secondaryText [] [ text "22 Dec 2017" ]
                ]
            , Lists.metaIcon [] "info"
            ]
        , Lists.divider [] []
        , Lists.li []
            [ Lists.graphicIcon demoIcon "folder"
            , Lists.text []
                [ Lists.primaryText [] [ text "Potatoes" ]
                , Lists.secondaryText [] [ text "30 Noc 2017" ]
                ]
            , Lists.metaIcon [] "info"
            ]
        , Lists.li []
            [ Lists.graphicIcon demoIcon "folder"
            , Lists.text []
                [ Lists.primaryText [] [ text "Carrots" ]
                , Lists.secondaryText [] [ text "17 Oct 2017" ]
                ]
            , Lists.metaIcon [] "info"
            ]
        ]


listWithTrailing : (Msg m -> m) -> Model m -> Material.Index -> List (Lists.Property m) -> (Int -> Html m) -> Html m
listWithTrailing lift model index options metaControl =
    Lists.ul (lift << Mdc)
        index
        model.mdc
        (demoList lift model index ++ options)
        [ Lists.li []
            [ text "Dog Photos"
            , metaControl 0
            ]
        , Lists.li []
            [ text "Cat Photos"
            , metaControl 1
            ]
        , Lists.divider [] []
        , Lists.li []
            [ text "Potatoes"
            , metaControl 2
            ]
        , Lists.li []
            [ text "Carrots"
            , metaControl 3
            ]
        ]


listWithTrailingCheckbox : (Msg m -> m) -> Material.Index -> Model m -> Html m
listWithTrailingCheckbox lift index model =
    listWithTrailing lift
        model
        index
        []
        (\n ->
            let
                selected =
                    Set.member n model.selectedCheckboxes
            in
            Checkbox.view (lift << Mdc)
                (index ++ "-checkbox-" ++ String.fromInt n)
                model.mdc
                [ Checkbox.checked selected
                , Lists.metaClass
                ]
                []
        )


listWithTrailingRadioButton : (Msg m -> m) -> Material.Index -> Model m -> Html m
listWithTrailingRadioButton lift index model =
    let
        selected =
            Maybe.withDefault 0 (Dict.get index model.selectedListItem)

        really_selected =
            if selected < 2 then
                selected

            else
                selected - 1
    in
    listWithTrailing lift
        model
        index
        [ Lists.radioGroup ]
        (\n ->
            RadioButton.view (lift << Mdc)
                (index ++ "-radio-button-" ++ String.fromInt n)
                model.mdc
                [ RadioButton.selected |> when (really_selected == n)
                , Lists.metaClass
                ]
                []
        )


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "List"
              , Hero.intro "Lists present multiple line items vertically as a single continuous element."
              , Hero.component [] [ heroList lift model "hero-list" ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "lists" "lists" "mdc-list"
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Single-Line" ]
            , singleLineList lift model "single-line-list"
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Two-Line" ]
            , twoLineList lift model "two-line-list"
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Leading Icon" ]
            , leadingIconList lift model "leading-icon-line-list"
            , styled Html.h3 [ Typography.subtitle1 ] [ text "List with activated item" ]
            , activatedItemList lift model "activated-item-list"
            , styled Html.h3 [ Typography.subtitle1 ] [ text "List with shaped activated item" ]
            , shapedActivatedItemList lift model "shaped-activated-item-list"
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Trailing Icon" ]
            , trailingIconList lift model "trailing-icon-item-list"
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Two-Line with Leading and Trailing Icon and Divider" ]
            , folderList lift model "folder-list"
            , styled Html.h3 [ Typography.subtitle1 ] [ text "List with Trailing Checkbox" ]
            , listWithTrailingCheckbox lift "lists-list-with-checkbox" model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "List with Trailing Radio Buttons" ]
            , listWithTrailingRadioButton lift "lists-list-with-radio-buttons" model
            ]
        ]
