module Demo.Fabs exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Html.Attributes as Html
import Html.Events as Html
import Material
import Material.Fab as Fab
import Material.Options as Options exposing (cs, css, styled, when)
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


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    let
        fab idx options =
            Fab.view (lift << Mdc) idx model.mdc (Fab.ripple :: options) "favorite_border"
    in
    page.body "Floating Action Button"
        "Floating action buttons represents the primary action in an application. Only one floating action button is recommended per screen to represent the most common action."
        [ Hero.view [] [ fab "fabs-hero-fab" [] ]
        , styled Html.h2
            [ Typography.headline6
            , css "border-bottom" "1px solid rgba(0,0,0,.87)"
            ]
            [ text "Resources"
            ]
        , ResourceLink.view
            { link = "https://material.io/go/design-fab"
            , title = "Material Design Guidelines"
            , icon = "images/material.svg"
            , altText = "Material Design Guidelines icon"
            }
        , ResourceLink.view
            { link = "https://material.io/components/web/catalog/buttons/floating-action-buttons/"
            , title = "Documentation"
            , icon = "images/ic_drive_document_24px.svg"
            , altText = "Documentation icon"
            }
        , ResourceLink.view
            { link = "https://github.com/material-components/material-components-web/blob/master/packages/mdc-fab/"
            , title = "Source Code (Material Components Web)"
            , icon = "images/ic_code_24px.svg"
            , altText = "Source Code"
            }
        , Page.demos
            [ styled Html.h3
                [ Typography.subtitle1 ]
                [ text "Standard Floating Action Button" ]
            , fab "fabs-standard-fab" []
            , styled Html.h3
                [ Typography.subtitle1 ]
                [ text "Mini Floating Action Button" ]
            , fab "fabs-mini-fab" []
            ]
        ]
