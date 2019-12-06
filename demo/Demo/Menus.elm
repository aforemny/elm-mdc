module Demo.Menus exposing (Model, Msg(..), defaultModel, subscriptions, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, div, text)
import Html.Attributes as Html
import Html.Events as Html
import Material
import Material.Button as Button
import Material.Icon as Icon
import Material.Menu as Menu
import Material.Options exposing (cs, styled, when)
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m
    , spaceBeforeParagraph : Float
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , spaceBeforeParagraph = 1
    }


type Msg m
    = Mdc (Material.Msg m)
    | Select Float


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        Select value ->
            ( { model | spaceBeforeParagraph = value }, Cmd.none )


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model


heroMenu : (Msg m -> m) -> Model m -> Html m
heroMenu lift model =
    Menu.view (lift << Mdc)
        "menus-hero-menu"
        model.mdc
        [ cs "mdc-menu-surface--open"
        ]
        (Menu.ul []
            [ Menu.li [] [ text "A Menu Item" ]
            , Menu.li [] [ text "Another Menu Item" ]
            ]
        )


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Menu"
              , Hero.intro "Menus display a list of choices on a transient sheet of material."
              , Hero.component [] [ heroMenu lift model ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "menus" "menus" "mdc-menu"
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Anchored menu" ]
            , Button.view (lift << Mdc)
                "menus-button"
                model.mdc
                [ Menu.attach (lift << Mdc) "menus-menu" ]
                [ text "Open menu" ]
            , styled div
                [ Menu.surfaceAnchor ]
                [ Menu.view (lift << Mdc)
                    "menus-menu"
                    model.mdc
                    []
                    basicMenu
                ]
            , Button.view (lift << Mdc)
                "menus-button"
                model.mdc
                [ Menu.attach (lift << Mdc) "menus-selection-group-menu" ]
                [ text "Open selection group menu" ]
            , styled div
                [ Menu.surfaceAnchor ]
                [ Menu.view (lift << Mdc)
                    "menus-selection-group-menu"
                    model.mdc
                    []
                    ( selectionGroupMenu lift model )
                ]
            ]
        ]


basicMenu =
    Menu.ul []
        [ Menu.li [ Menu.selected ] [ text "Passionfruit" ]
        , Menu.li [] [ text "Orange" ]
        , Menu.li [] [ text "Guava" ]
        , Menu.li [] [ text "Pitaya" ]
        , Menu.divider [] []
        , Menu.li [] [ text "Pineapple" ]
        , Menu.li [] [ text "Mango" ]
        , Menu.li [] [ text "Papaya" ]
        , Menu.li [] [ text "Lychee" ]
        ]


selectionGroupMenu lift model =
    let
        options = [ ("Single", 1), ("1.15" ,1.15), ("Double", 2) ]

        li (description, value) =
            Menu.li
                [ Menu.selected |> when (model.spaceBeforeParagraph == value)
                , Menu.onSelect (lift (Select value)) ]
                [ Menu.selectionGroupIcon [] [ Icon.view [ Icon.span ] "check" ]
                , Menu.text [] [ text description ]
                    ]
    in
    Menu.ul []
        [ Menu.selectionGroup []
              ( List.map li options )
        , Menu.divider [] []
        , Menu.li []
            [ text "Add space before paragraph" ]
        ]
