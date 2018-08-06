module Demo.Theme exposing (Model, Msg, defaultModel, update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.Button as Button
import Material.Options as Options exposing (cs, css, styled, when)
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
    page.body "Theme"
        [ Page.hero []
            [ Button.view (lift << Mdc)
                "theme-button-primary"
                model.mdc
                [ Button.raised
                , css "margin" "24px"
                ]
                [ text "Primary"
                ]
            , Button.view (lift << Mdc)
                "theme-button-secondary"
                model.mdc
                [ Button.raised
                , css "margin" "24px"
                ]
                [ text "Secondary"
                ]
            ]
        , h2 []
            [ text "Theme colors"
            ]
        , themeColorsAsText
        , themeColorsAsBackground
        , h2 []
            [ text "Text colors for contrast"
            ]
        , example1
        ]


themeColorsAsText : Html m
themeColorsAsText =
    example []
        [ h3 []
            [ text "Theme colors as text"
            ]
        , demoThemeColor []
            [ demoThemeColorBlock
                [ Theme.primary
                ]
                [ text "Primary"
                ]
            , demoThemeColorBlock
                [ Theme.primaryLight
                ]
                [ text "Primary Light"
                ]
            , demoThemeColorBlock
                [ Theme.primaryDark
                ]
                [ text "Primary Dark"
                ]
            ]
        , demoThemeColor []
            [ demoThemeColorBlock
                [ Theme.secondary
                ]
                [ text "Secondary"
                ]
            , demoThemeColorBlock
                [ Theme.secondaryLight
                ]
                [ text "Secondary Light"
                ]
            , demoThemeColorBlock
                [ Theme.secondaryDark
                ]
                [ text "Secondary Dark"
                ]
            ]
        ]


themeColorsAsBackground : Html m
themeColorsAsBackground =
    example []
        [ h3 []
            [ text "Theme colors as background"
            ]
        , demoThemeColor []
            [ demoThemeColorBlock
                [ Theme.primaryBg
                ]
                [ text "Primary"
                ]
            , demoThemeColorBlock
                [ Theme.primaryLightBg
                ]
                [ text "Primary Light"
                ]
            , demoThemeColorBlock
                [ Theme.primaryDarkBg
                ]
                [ text "Primary Dark"
                ]
            ]
        , demoThemeColor []
            [ demoThemeColorBlock
                [ Theme.secondaryBg
                ]
                [ text "Secondary"
                ]
            , demoThemeColorBlock
                [ Theme.secondaryLightBg
                ]
                [ text "Secondary Light"
                ]
            , demoThemeColorBlock
                [ Theme.secondaryDarkBg
                ]
                [ text "Secondary Dark"
                ]
            ]
        , demoThemeColor []
            [ demoThemeColorBlock
                [ Theme.background
                ]
                [ text "Background"
                ]
            ]
        ]


demoThemeColor : List (Options.Property c m) -> List (Html m) -> Html m
demoThemeColor options =
    styled Html.div
        (cs "demo-theme__color"
            :: css "display" "inline-flex"
            :: css "flex-direction" "column"
            :: options
        )


demoThemeColorBlock : List (Options.Property c m) -> List (Html m) -> Html m
demoThemeColorBlock options =
    styled Html.div
        (cs "demo-theme__color__block"
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
                (let
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
            [ text "Text on background"
            ]
        , demo Theme.background
            [ \options -> styled Html.span (Theme.textPrimaryOnBackground :: options) [ text "Primary" ]
            , \options -> styled Html.span (Theme.textSecondaryOnBackground :: options) [ text "Secondary" ]
            , \options -> styled Html.span (Theme.textHintOnBackground :: options) [ text "Hint" ]
            , \options -> styled Html.span (Theme.textHintOnBackground :: options) [ text "Disabled" ]
            , \options -> styled Html.span (Theme.textIconOnBackground :: options) [ text "favorite" ]
            ]
        , h3 []
            [ text "Text on primary"
            ]
        , demo Theme.primaryBg
            [ \options -> styled Html.span (Theme.textPrimaryOnPrimary :: options) [ text "Primary" ]
            , \options -> styled Html.span (Theme.textSecondaryOnPrimary :: options) [ text "Secondary" ]
            , \options -> styled Html.span (Theme.textHintOnPrimary :: options) [ text "Hint" ]
            , \options -> styled Html.span (Theme.textHintOnPrimary :: options) [ text "Disabled" ]
            , \options -> styled Html.span (Theme.textIconOnPrimary :: options) [ text "favorite" ]
            ]
        , h3 []
            [ text "Text on secondary"
            ]
        , demo Theme.secondaryBg
            [ \options -> styled Html.span (Theme.textPrimaryOnSecondary :: options) [ text "Primary" ]
            , \options -> styled Html.span (Theme.textSecondaryOnSecondary :: options) [ text "Secondary" ]
            , \options -> styled Html.span (Theme.textHintOnSecondary :: options) [ text "Hint" ]
            , \options -> styled Html.span (Theme.textHintOnSecondary :: options) [ text "Disabled" ]
            , \options -> styled Html.span (Theme.textIconOnSecondary :: options) [ text "favorite" ]
            ]
        , h3 []
            [ text "Text on user-defined light background"
            ]
        , demo (css "background-color" "#dddddd")
            [ \options -> styled Html.span (Theme.textPrimaryOnLight :: options) [ text "Primary" ]
            , \options -> styled Html.span (Theme.textSecondaryOnLight :: options) [ text "Secondary" ]
            , \options -> styled Html.span (Theme.textHintOnLight :: options) [ text "Hint" ]
            , \options -> styled Html.span (Theme.textHintOnLight :: options) [ text "Disabled" ]
            , \options -> styled Html.span (Theme.textIconOnLight :: options) [ text "favorite" ]
            ]
        , h3 []
            [ text "Text on user-defined dark background"
            ]
        , demo (css "background-color" "#1d1d1d")
            [ \options -> styled Html.span (Theme.textPrimaryOnDark :: options) [ text "Primary" ]
            , \options -> styled Html.span (Theme.textSecondaryOnDark :: options) [ text "Secondary" ]
            , \options -> styled Html.span (Theme.textHintOnDark :: options) [ text "Hint" ]
            , \options -> styled Html.span (Theme.textHintOnDark :: options) [ text "Disabled" ]
            , \options -> styled Html.span (Theme.textIconOnDark :: options) [ text "favorite" ]
            ]
        ]


demoThemeTextStyles : List (Options.Property c m) -> List (Html m) -> Html m
demoThemeTextStyles options =
    styled Html.div
        (cs "demo-theme__text--styles"
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
        (Typography.display1
            :: css "margin" "30px 0 30px 48px"
            :: options
        )


h3 : List (Options.Property () m) -> List (Html m) -> Html m
h3 options =
    styled Html.h2
        (Typography.title
            :: options
        )


example : List (Options.Property () m) -> List (Html m) -> Html m
example options =
    styled Html.section
        (css "margin" "24px"
            :: css "padding" "24px"
            :: options
        )
