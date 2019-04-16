module Demo.Menus exposing (Model, Msg(..), defaultModel, subscriptions, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, text, div)
import Html.Attributes as Html
import Html.Events as Html
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.List as Lists
import Material.Menu as Menu
import Material.Options as Options exposing (cs, css, nop, styled, when)
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    }


type Msg m
    = Mdc (Material.Msg m)


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model


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
    page.body "Menu"
        "Menus display a list of choices on a transient sheet of material."
        [ Hero.view [] [ heroMenu lift model ]
        , styled Html.h2
            [ Typography.headline6
            , css "border-bottom" "1px solid rgba(0,0,0,.87)"
            ]
            [ text "Resources"
            ]
        , ResourceLink.view
            { link = "https://material.io/go/design-menus"
            , title = "Material Design Guidelines"
            , icon = "images/material.svg"
            , altText = "Material Design Guidelines icon"
            }
        , ResourceLink.view
            { link = "https://material.io/components/web/catalog/menus/"
            , title = "Documentation"
            , icon = "images/ic_drive_document_24px.svg"
            , altText = "Documentation icon"
            }
        , ResourceLink.view
            { link = "https://github.com/material-components/material-components-web/tree/master/packages/mdc-menu"
            , title = "Source Code (Material Components Web)"
            , icon = "images/ic_code_24px.svg"
            , altText = "Source Code"
            }
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
                    (Menu.ul []
                        [ Menu.li [] [ text "Passionfruit" ]
                        , Menu.li [] [ text "Orange" ]
                        , Menu.li [] [ text "Guava" ]
                        , Menu.li [] [ text "Pitaya" ]
                        , Menu.divider [] []
                        , Menu.li [] [ text "Pineapple" ]
                        , Menu.li [] [ text "Mango" ]
                        , Menu.li [] [ text "Papaya" ]
                        , Menu.li [] [ text "Lychee" ]
                        ]
                    )
                ]
            ]
        ]
