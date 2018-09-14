module Demo.Ripple exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.Elevation as Elevation
import Material.Options as Options exposing (cs, css, styled)
import Material.Ripple as Ripple


-- MODEL


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



-- VIEW


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    let
        demoSurface =
            Options.many
                [ cs "demo-surface"
                , cs "mdc-ripple-surface"
                , css "display" "flex"
                , css "align-items" "center"
                , css "justify-content" "center"
                , css "width" "200px"
                , css "height" "100px"
                , css "padding" "1rem"
                , css "cursor" "pointer"
                , css "user-select" "none"
                , css "-webkit-user-select" "none"
                , cs "mdc-ripple-surface"
                , Options.tabindex 0
                ]

        example options =
            styled Html.section
                (cs "example"
                    :: css "display" "flex"
                    :: css "flex-flow" "column"
                    :: css "margin" "24px"
                    :: css "padding" "24px"
                    :: options
                )
    in
    page.body "Ripple"
        [ Page.hero []
            [ let
                ripple =
                    Ripple.bounded (lift << Mdc) "ripple-hero-ripple" model.mdc []
              in
              styled Html.div
                [ css "width" "100%"
                , css "height" "100%"
                , cs "mdc-ripple-surface"
                , ripple.interactionHandler
                , ripple.properties
                ]
                [ ripple.style
                ]
            ]
        , example []
            [ Html.h2 [] [ text "Bounded" ]
            , let
                ripple =
                    Ripple.bounded (lift << Mdc) "ripple-bounded-ripple" model.mdc []
              in
              styled Html.div
                [ demoSurface
                , Elevation.z2
                , ripple.interactionHandler
                , ripple.properties
                ]
                [ text "Interact with me!"
                , ripple.style
                ]
            ]
        , example []
            [ Html.h2 [] [ text "Unbounded" ]
            , let
                ripple =
                    Ripple.unbounded (lift << Mdc) "ripple-unbounded-ripple" model.mdc []
              in
              styled Html.div
                [ cs "material-icons"
                , css "width" "24px"
                , css "height" "24px"
                , css "padding" "12px"
                , css "border-radius" "50%"
                , demoSurface
                , ripple.interactionHandler
                , ripple.properties
                ]
                [ text "favorite"
                , ripple.style
                ]
            ]
        , example []
            [ Html.h2 [] [ text "Theme Styles" ]
            , let
                ripple =
                    Ripple.bounded (lift << Mdc) "ripple-primary-ripple" model.mdc [ Ripple.primary ]
              in
              styled Html.div
                [ demoSurface
                , Elevation.z2
                , ripple.interactionHandler
                , ripple.properties
                ]
                [ text "Primary"
                , ripple.style
                ]
            , let
                ripple =
                    Ripple.bounded (lift << Mdc) "ripple-accent-ripple" model.mdc [ Ripple.accent ]
              in
              styled Html.div
                [ demoSurface
                , Elevation.z2
                , ripple.interactionHandler
                , ripple.properties
                ]
                [ text "Accent"
                , ripple.style
                ]
            ]
        ]
