module Demo.Ripple exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.Elevation as Elevation
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Ripple as Ripple
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


demoBox : (Msg m -> m) -> Material.Index -> Model m -> String -> String -> Html m
demoBox lift index model className label =
    let
        ripple =
            Ripple.bounded (lift << Mdc) index model.mdc []
    in
    styled Html.div
        [ cs "mdc-ripple-surface"
        , cs className |> when (className /= "")
        , css "display" "flex"
        , css "align-items" "center"
        , css "justify-content" "center"
        , css "width" "200px"
        , css "height" "100px"
        , css "padding" "1rem"
        , css "cursor" "pointer"
        , css "user-select" "none"
        , css "background-color" "#fff"
        , css "overflow" "hidden"
        , Elevation.z2
        , Options.tabindex 0
        , ripple.interactionHandler
        , ripple.properties
        ]
        [ text label
        ]


demoIcon : (Msg m -> m) -> Material.Index -> Model m -> String -> Html m
demoIcon lift index model icon =
    let
        ripple =
            Ripple.unbounded (lift << Mdc) index model.mdc []
    in
    styled Html.div
        [ cs "mdc-ripple-surface"
        , cs "material-icons"
        , css "width" "24px"
        , css "height" "24px"
        , css "padding" "12px"
        , css "border-radius" "50%"
        , ripple.interactionHandler
        , ripple.properties
        ]
        [ text icon
        ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Ripple"
              , Hero.intro "Ripples are visual representations used to communicate the status of a component or interactive element."
              , Hero.component [] [ demoBox lift "ripple-hero-ripple" model "" "Click here!" ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "interaction/states" "ripples" "mdc-ripple"
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Bounded Ripple" ]
            , demoBox lift "ripple-bounded-ripple" model "" "Interact with me!"
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Unbounded Ripple" ]
            , demoIcon lift "ripple-unbounded-ripple" model "favorite"
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Theme Colors: Primary" ]
            , demoBox lift "ripple-primary-theme-color" model "ripple-demo-box--primary" "Primary"
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Theme Colors: Secondary" ]
            , demoBox lift "ripple-secondary-theme-color" model "ripple-demo-box--secondary" "Secondary"
            ]
        ]
