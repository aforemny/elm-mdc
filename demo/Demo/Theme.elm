module Demo.Theme exposing (Model, Msg, defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, text, div, fieldset, h2, h3, legend)
import Material
import Material.Button as Button
import Material.Options as Options exposing (cs, css, styled)
import Material.Theme as Theme
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
    page.body
        [ Hero.view
              [ Hero.header "Theme"
              , Hero.intro "Color in Material Design is inspired by bold hues juxtaposed with muted environments, deep shadows, and bright highlights."
              , Hero.component []
                  [ Button.view (lift << Mdc)
                        "theme-button-text"
                        model.mdc
                        [ ]
                        [ text "Text"
                        ]
                  , Button.view (lift << Mdc)
                        "theme-button-raised"
                        model.mdc
                        [ Button.raised
                        , css "padding-left" "16px"
                        , css "padding-right" "16px"
                        ]
                        [ text "Raised"
                        ]
                  , Button.view (lift << Mdc)
                        "theme-button-outlined"
                        model.mdc
                        [ Button.outlined
                        , css "padding-left" "15px"
                        , css "padding-right" "15px"
                        ]
                        [ text "Outlined"
                        ]
                  ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "color/applying-color-to-ui" "theme" "mdc-theme"
        , Page.demos [
               styled div
                   [ cs "theme-demo"
                   , css "padding" "24px"
                   ]
                   [ styled h2 [ Typography.headline4 ]
                         [ text "Baseline Colors"
                         ]
                   , styled h3 [ Typography.headline5 ]
                       [ text "CSS classes"
                       ]
                   , styled div [ cs "demo-theme-color-section" ]
                       [ styled div
                             [ cs "demo-theme-color-section__row" ]
                             [ themeColorsAsText
                             , themeColorsAsBackground
                             ]
                       ]
                   ]
            ]
        ]


themeColorsAsText : Html m
themeColorsAsText =
    styled fieldset [ cs "demo-fieldset--color" ]
        [ styled legend
              [ cs "mdc-typography--subtitle1" ]
              [ text "Theme colors as text"
              ]
        , styled div
              [ cs "demo-theme-color-group" ]
              [ swatch [ cs "mdc-theme--primary", Typography.body2 ]
                    [ text "Primary" ]
              , swatch [ cs "mdc-theme--secondary", Typography.body2 ]
                    [ text "Secondary" ]
              ]
        ]


themeColorsAsBackground : Html m
themeColorsAsBackground =
    styled fieldset [ cs "demo-fieldset--color" ]
        [ styled legend
              [ cs "mdc-typography--subtitle1" ]
              [ text "Theme colors as background"
              ]
        , styled div
              [ cs "demo-theme-color-group" ]
              [ swatch [ cs "mdc-theme--primary-bg mdc-theme--on-primary", Typography.body2 ]
                    [ text "Primary" ]
              , swatch [ cs "mdc-theme--secondary-bg mdc-theme--on-secondary", Typography.body2 ]
                    [ text "Secondary" ]
              , swatch [ cs "theme--background mdc-theme--text-primary-on-background", Typography.body2 ]
                    [ text "Background" ]
              ]
        ]


swatch options nodes =
    styled div
        [ cs "demo-theme-color-swatches" ]
        [ styled div
              ( cs "demo-theme-color-swatch demo-theme-color-swatch--elevated" :: options )
              nodes
        ]
