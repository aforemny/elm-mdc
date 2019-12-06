module Demo.Fabs exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page, subheader)
import Html exposing (Html, i, span, text)
import Material
import Material.Fab as Fab
import Material.Options exposing (cs, css, styled)


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
            Fab.view (lift << Mdc) idx model.mdc (Fab.ripple :: Fab.icon "favorite_border" :: options) []

        extendedFab idx options nodes =
            Fab.view (lift << Mdc) idx model.mdc (Fab.ripple :: Fab.extended :: options) nodes
    in
    page.body
        [ Hero.view
              [ Hero.header "Floating Action Button"
              , Hero.intro "Floating action buttons represents the primary action in an application. Only one floating action button is recommended per screen to represent the most common action."
              , Hero.component [] [ fab "fabs-hero-fab" [] ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "buttons-floating-action-button" "buttons/floating-action-buttons" "mdc-fab"
        , Page.demos
            [ subheader "Standard Floating Action Button"
            , fab "fabs-standard-fab" []
            , subheader "Mini Floating Action Button"
            , fab "fabs-mini-fab" [ Fab.mini ]
            , subheader "Extended FAB"
            , extendedFab "fabs-extended-fab" [ Fab.icon "add" ] [ styled span [ Fab.label ] [ text "Create" ] ]
            , subheader "Extended FAB (Text label followed by icon)"
            , extendedFab "fabs-extended-swapped-fab"
                []
                [ styled span [ Fab.label ] [ text "Create" ]
                , styled i [ Fab.iconClass, cs "material-icons" ] [ text "add" ]
                ]
            , subheader "FAB (Shaped)"
            , fab "fabs-shaped-1-fab"
                [ css "border-radius" "50% 0", css "margin-right" "24px" ]
            , fab "fabs-shaped-2-fab"
                [ Fab.mini, css "border-radius" "8px", css "margin-right" "24px" ]
            , extendedFab "fabs-shaped-3-fab"
                [ Fab.icon "add", css "border-radius" "12px" ]
                [ styled span [ Fab.label ] [ text "Create" ]
                ]
            ]
        ]
