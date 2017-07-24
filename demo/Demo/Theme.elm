module Demo.Theme exposing (model, Model, update, view, Msg)

import Html exposing (Html)
import Material
import Material.Options exposing (Style, when, styled, cs, css, div, span)
import Material.Theme as Theme
import Material.Typography as Typography


-- MODEL


type alias Model =
    { mdl : Material.Model
    }


model : Model
model =
    { mdl = Material.model
    }


type Msg
    = Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model


-- VIEW


view : Model -> Html Msg
view model =
    div
    []
    [ styled Html.h2
      [ Typography.display1
      ]
      [ Html.text "Theme colors"
      ]
    , example0

    , styled Html.h2
      [ Typography.display1
      ]
      [ Html.text "Text colors for contrast"
      ]
    , example1
    ]


example0 : Html Msg
example0 =
    styled Html.section
    [ cs "example"
    ]
    [ styled Html.h3
      [ Typography.title
      ]
      [ Html.text "Theme colors as text"
      ]
    , demoThemeColor []
      [ demoThemeColorLabel []
        [ Html.text "Primary"
        ]
      , demoThemeColorBlock
        [ Typography.typography
        , Theme.primary
        , Typography.body2
        ]
        [ Html.text "Lorem ipsum"
        ]
      ]
    , demoThemeColor []
      [ demoThemeColorLabel []
        [ Html.text "Accent"
        ]
      , demoThemeColorBlock
        [ Typography.typography
        , Theme.accent
        , Typography.body2
        ]
        [ Html.text "Lorem ipsum"
        ]
      ]

    , styled Html.h3
      [ Typography.title
      ]
      [ Html.text "Theme colors as background"
      ]
    , demoThemeColor []
      [ demoThemeColorLabel []
        [ Html.text "Primary"
        ]
      , demoThemeColorBlock
        [ Typography.typography
        , Theme.primaryBg
        , Typography.body2
        ]
        []
      ]
    , demoThemeColor []
      [ demoThemeColorLabel []
        [ Html.text "Accent"
        ]
      , demoThemeColorBlock
        [ Typography.typography
        , Theme.accentBg
        , Typography.body2
        ]
        []
      ]
    , demoThemeColor []
      [ demoThemeColorLabel []
        [ Html.text "Background"
        ]
      , demoThemeColorBlock
        [ Typography.typography
        , Theme.background
        , Typography.body2
        ]
        []
      ]
    ]


demoThemeColor : List (Style m) -> List (Html m) -> Html m
demoThemeColor options =
    div
    ( cs "demo-theme__color"
    :: css "display" "inline-flex"
    :: css "flex-direction" "column"
    :: options
    )


demoThemeColorLabel : List (Style m) -> List (Html m) -> Html m
demoThemeColorLabel options =
    div
    ( cs "demo-theme__color__label"
    :: css "display" "inline-block"
    :: css "box-sizing" "border-box"
    :: css "width" "130px"
    :: css "marign-bottom" "1rem"
    :: options
    )


demoThemeColorBlock : List (Style m) -> List (Html m) -> Html m
demoThemeColorBlock options =
    div
    ( cs "demo-theme__color__block"
    :: css "display" "inline-block"
    :: css "box-sizing" "border-box"
    :: css "width" "130px"
    :: css "height" "50px"
    :: css "line-height" "50px"
    :: css "text-align" "center"
    :: css "border" "1px solid #f0f0f0"
    :: options
    )


example1 : Html Msg
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
                      [ Typography.typography
                      , Typography.body2
                      , css "padding" "0 16px"
                      ]
              in
              nodes
              |> List.map (\node -> node options)
            )
    in
    styled Html.section
    [ cs "example"
    ]
    [ styled Html.h3
      [ Typography.title
      ]
      [ Html.text "Text on background"
      ]

    , demo Theme.background
      [ \options -> span (Theme.textPrimaryOnBackground::options) [ Html.text "Primary" ]
      , \options -> span (Theme.textSecondaryOnBackground::options) [ Html.text "Secondary" ]
      , \options -> span (Theme.textHintOnBackground::options) [ Html.text "Hint" ]
      , \options -> span (Theme.textHintOnBackground::options) [ Html.text "Disabled" ]
      , \options -> Theme.textIconOnBackground options "favorite"
      ]

    , styled Html.h3
      [ Typography.title
      ]
      [ Html.text "Text on primary"
      ]

    , demo Theme.primaryBg
      [ \options -> span (Theme.textPrimaryOnPrimary::options) [ Html.text "Primary" ]
      , \options -> span (Theme.textSecondaryOnPrimary::options) [ Html.text "Secondary" ]
      , \options -> span (Theme.textHintOnPrimary::options) [ Html.text "Hint" ]
      , \options -> span (Theme.textHintOnPrimary::options) [ Html.text "Disabled" ]
      , \options -> Theme.textIconOnPrimary options "favorite"
      ]

    , styled Html.h3
      [ Typography.title
      ]
      [ Html.text "Text on accent"
      ]

    , demo Theme.accentBg
      [ \options -> span (Theme.textPrimaryOnAccent::options) [ Html.text "Primary" ]
      , \options -> span (Theme.textSecondaryOnAccent::options) [ Html.text "Secondary" ]
      , \options -> span (Theme.textHintOnAccent::options) [ Html.text "Hint" ]
      , \options -> span (Theme.textHintOnAccent::options) [ Html.text "Disabled" ]
      , \options -> Theme.textIconOnAccent options "favorite"
      ]

    , styled Html.h3
      [ Typography.title
      ]
      [ Html.text "Text on user-defined light background"
      ]

    , demo (css "background-color" "#dddddd")
      [ \options -> span (Theme.textPrimaryOnLight::options) [ Html.text "Primary" ]
      , \options -> span (Theme.textSecondaryOnLight::options) [ Html.text "Secondary" ]
      , \options -> span (Theme.textHintOnLight::options) [ Html.text "Hint" ]
      , \options -> span (Theme.textHintOnLight::options) [ Html.text "Disabled" ]
      , \options -> Theme.textIconOnLight options "favorite"
      ]

    , styled Html.h3
      [ Typography.title
      ]
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


demoThemeTextStyles : List (Style m) -> List (Html m) -> Html m
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
