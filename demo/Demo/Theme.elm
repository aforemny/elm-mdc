module Demo.Theme exposing (Model, defaultModel, Msg, update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.Button as Button
import Material.Options as Options exposing (when, styled, cs, css, div, span)
import Material.Theme as Theme
import Material.Typography as Typography


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


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    page.body "Theme"
    [
      Page.hero []
      [ Button.render (Mdl >> lift) [0] model.mdl
        [ Button.raised
        , Button.primary
        , css "margin" "24px"
        ]
        [ text "Primary"
        ]
      , Button.render (Mdl >> lift) [0] model.mdl
        [ Button.raised
        , Button.accent
        , css "margin" "24px"
        ]
        [ text "Secondary"
        ]
      ]
      
    , h2 []
      [ Html.text "Theme colors"
      ]
    , themeColorsAsText
    , themeColorsAsBackground

    , h2 []
      [ Html.text "Text colors for contrast"
      ]

    , example1
    ]


themeColorsAsText : Html m
themeColorsAsText =
    example []
    [ h3 []
      [ Html.text "Theme colors as text"
      ]
    , demoThemeColor []
      [
        demoThemeColorBlock
        [ Theme.primary
        ]
        [ Html.text "Primary"
        ]

      , demoThemeColorBlock
        [ Theme.primaryLight
        ]
        [ Html.text "Primary Light"
        ]

      , demoThemeColorBlock
        [ Theme.primaryDark
        ]
        [ Html.text "Primary Dark"
        ]
      ]
    , demoThemeColor []
      [
        demoThemeColorBlock
        [ Theme.secondary
        ]
        [ Html.text "Secondary"
        ]

      , demoThemeColorBlock
        [ Theme.secondaryLight
        ]
        [ Html.text "Secondary Light"
        ]

      , demoThemeColorBlock
        [ Theme.secondaryDark
        ]
        [ Html.text "Secondary Dark"
        ]
      ]
    ]


themeColorsAsBackground : Html m
themeColorsAsBackground =
    example []
    [ h3 []
      [ Html.text "Theme colors as background"
      ]
    , demoThemeColor []
      [
        demoThemeColorBlock
        [ Theme.primaryBg
        ]
        [ Html.text "Primary"
        ]

      , demoThemeColorBlock
        [ Theme.primaryLightBg
        ]
        [ Html.text "Primary Light"
        ]

      , demoThemeColorBlock
        [ Theme.primaryDarkBg
        ]
        [ Html.text "Primary Dark"
        ]
      ]
    , demoThemeColor []
      [
        demoThemeColorBlock
        [ Theme.secondaryBg
        ]
        [ Html.text "Secondary"
        ]

      , demoThemeColorBlock
        [ Theme.secondaryLightBg
        ]
        [ Html.text "Secondary Light"
        ]

      , demoThemeColorBlock
        [ Theme.secondaryDarkBg
        ]
        [ Html.text "Secondary Dark"
        ]
      ]
    , demoThemeColor []
      [
        demoThemeColorBlock
        [ Theme.background
        ]
        [ Html.text "Background"
        ]
      ]
    ]


demoThemeColor : List (Options.Property c m) -> List (Html m) -> Html m
demoThemeColor options =
    div
    ( cs "demo-theme__color"
    :: css "display" "inline-flex"
    :: css "flex-direction" "column"
    :: options
    )


demoThemeColorBlock : List (Options.Property c m) -> List (Html m) -> Html m
demoThemeColorBlock options =
    div
    ( cs "demo-theme__color__block"
    :: css "display" "inline-block"
    :: css "box-sizing" "border-box"
    :: css "width" "150px"
    :: css "height" "50px"
    :: css "line-height" "50px"
    :: css "text-align" "center"
    :: css "border" "1px solid #f0f0f0"
    :: options
    )


example1 : Html m
example1 =
    let
        demo background nodes =
            demoThemeTextStyles
            [ Typography.typography
            , Typography.body2
            , background
            ]
            ( let
                  options =
                      [ css "padding" "0 16px"
                      ]
              in
              nodes
              |> List.map (\node -> node options)
            )
    in
    example []
    [ h3 []
      [ Html.text "Text on background"
      ]

    , demo Theme.background
      [ \options -> span (Theme.textPrimaryOnBackground::options) [ Html.text "Primary" ]
      , \options -> span (Theme.textSecondaryOnBackground::options) [ Html.text "Secondary" ]
      , \options -> span (Theme.textHintOnBackground::options) [ Html.text "Hint" ]
      , \options -> span (Theme.textHintOnBackground::options) [ Html.text "Disabled" ]
      , \options -> Theme.textIconOnBackground options "favorite"
      ]

    , h3 []
      [ Html.text "Text on primary"
      ]

    , demo Theme.primaryBg
      [ \options -> span (Theme.textPrimaryOnPrimary::options) [ Html.text "Primary" ]
      , \options -> span (Theme.textSecondaryOnPrimary::options) [ Html.text "Secondary" ]
      , \options -> span (Theme.textHintOnPrimary::options) [ Html.text "Hint" ]
      , \options -> span (Theme.textHintOnPrimary::options) [ Html.text "Disabled" ]
      , \options -> Theme.textIconOnPrimary options "favorite"
      ]

    , h3 []
      [ Html.text "Text on secondary"
      ]

    , demo Theme.secondaryBg
      [ \options -> span (Theme.textPrimaryOnSecondary::options) [ Html.text "Primary" ]
      , \options -> span (Theme.textSecondaryOnSecondary::options) [ Html.text "Secondary" ]
      , \options -> span (Theme.textHintOnSecondary::options) [ Html.text "Hint" ]
      , \options -> span (Theme.textHintOnSecondary::options) [ Html.text "Disabled" ]
      , \options -> Theme.textIconOnSecondary options "favorite"
      ]

    , h3 []
      [ Html.text "Text on user-defined light background"
      ]

    , demo (css "background-color" "#dddddd")
      [ \options -> span (Theme.textPrimaryOnLight::options) [ Html.text "Primary" ]
      , \options -> span (Theme.textSecondaryOnLight::options) [ Html.text "Secondary" ]
      , \options -> span (Theme.textHintOnLight::options) [ Html.text "Hint" ]
      , \options -> span (Theme.textHintOnLight::options) [ Html.text "Disabled" ]
      , \options -> Theme.textIconOnLight options "favorite"
      ]

    , h3 []
      [ Html.text "Text on user-defined dark background"
      ]

    , demo (css "background-color" "#1d1d1d")
      [ \options -> span (Theme.textPrimaryOnDark::options) [ Html.text "Primary" ]
      , \options -> span (Theme.textSecondaryOnDark::options) [ Html.text "Secondary" ]
      , \options -> span (Theme.textHintOnDark::options) [ Html.text "Hint" ]
      , \options -> span (Theme.textHintOnDark::options) [ Html.text "Disabled" ]
      , \options -> Theme.textIconOnDark options "favorite"
      ]
    ]


demoThemeTextStyles : List (Options.Property c m) -> List (Html m) -> Html m
demoThemeTextStyles options =
    div
    ( cs "demo-theme__text--styles"
    :: css "display" "inline-flex"
    :: css "box-sizing" "border-box"
    :: css "padding" "16px"
    :: css "border" "1px solid #f0f0f0"
    :: css "align-items" "center"
    :: css "flex-direction" "row"
    :: options
    )


h2 : List (Options.Property () m) -> List (Html m) -> Html m
h2 options =
    styled Html.h2
    ( Typography.display1
    :: css "margin" "30px 0 30px 48px"
    :: options
    )


h3 : List (Options.Property () m) -> List (Html m) -> Html m
h3 options =
    styled Html.h2
    ( Typography.title
    :: options
    )


example : List (Options.Property () m) -> List (Html m) -> Html m
example options =
    styled Html.section
    ( css "margin" "24px"
    :: css "padding" "24px"
    :: options
    )
