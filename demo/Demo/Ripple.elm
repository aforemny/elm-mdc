module Demo.Ripple exposing (Model, defaultModel, Msg(Mdl), update, view)

import Html exposing (Html, text)
import Material
import Material.Elevation as Elevation
import Material.Options as Options exposing (styled, cs, css)
import Material.Ripple as Ripple
import Demo.Page exposing (Page)


-- MODEL


type alias Model =
    { mdl : Material.Model
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    }


type Msg m
    = Mdl (Material.Msg m)


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model


-- VIEW


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    let
        demoSurface =
            Options.many
            [ cs "demo-surface"
            , css "display" "flex"
            , css "align-items" "center"
            , css "justify-content" "center"
            , css "width" "200px"
            , css "height" "100px"
            , css "padding" "1rem"
            , css "cursor" "pointer"
            , css "user-select" "none"
            , css "-webkit-user-select" "none"
            ]

        example options =
            styled Html.section
            ( cs "example"
            :: css "display" "flex"
            :: css "flex-flow" "column"
            :: css "margin" "24px"
            :: css "padding" "24px"
            :: options
            )
    in
    page.body "Ripple"
    [
      example []
      [ Html.h2 [] [ text "Bounded" ]
      , let
            (rippleOptions, rippleStyles) =
                Ripple.bounded (Mdl >> lift) [0] model.mdl () ()
        in
        styled Html.div
        [ demoSurface
        , Elevation.elevation 2
        , rippleOptions
        ]
        [ text "Interact with me!"
        , rippleStyles
        ]
      ]

    , example []
      [ Html.h2 [] [ text "Unbounded" ]
      , let
            (rippleOptions, rippleStyles) =
                Ripple.unbounded (Mdl >> lift) [1] model.mdl () ()
        in
        styled Html.div
        [ cs "material-icons"
        , css "width" "40px"
        , css "height" "40px"
        , css "padding" "0"
        , css "border-radius" "50%"
        , demoSurface
        , rippleOptions
        ]
        [ text "favorite"
        , rippleStyles
        ]
      ]

    , example []
      [ Html.h2 [] [ text "Theme Styles" ]
      , let
            (rippleOptions, rippleStyles) =
                Ripple.bounded (Mdl >> lift) [2] model.mdl () ()
        in
        styled Html.div
        [ demoSurface
        , Elevation.elevation 2
        , rippleOptions
        , Ripple.primary
        ]
        [ text "Primary"
        , rippleStyles
        ]
      , let
            (rippleOptions, rippleStyles) =
                Ripple.bounded (Mdl >> lift) [3] model.mdl () ()
        in
        styled Html.div
        [ demoSurface
        , Elevation.elevation 2
        , rippleOptions
        , Ripple.accent
        ]
        [ text "Accent"
        , rippleStyles
        ]
      ]
    ]
