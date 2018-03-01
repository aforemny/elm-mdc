module Demo.Cards exposing (Model, defaultModel, Msg(Mdc), update, view)

import Demo.Page as Page exposing (Page)
import Html.Attributes as Html
import Html exposing (Html, text)
import Material
import Material.Button as Button
import Material.Card as Card
import Material.Checkbox as Checkbox
import Material.Icon as Icon
import Material.IconToggle as IconToggle
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model =
    { mdc : Material.Model
    , rtl : Bool
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    , rtl = False
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleRtl


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (Mdc >> lift) msg_ model
        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )


heroCard : (Msg m -> m) -> List Int -> Model -> Html m
heroCard lift index model =
  Card.view
  [ css "width" "350px"
  , css "margin" "48px"
  ]
  [
    Card.media
    [ Card.aspect16To9
    , Card.backgroundImage "images/16-9.jpg"
    ]
    []
  ,
    styled Html.div
    [ css "padding" "1rem"
    ]
    [
      styled Html.h2
      [ Typography.title
      , css "margin" "0"
      ]
      [ text "Our Changing Planet"
      ]

    ,
      styled Html.h3
      [ Typography.subheading1
      , css "margin" "0"
      ]
      [ text "by Kurt Wagner"
      ]
    ]
  ,
    styled Html.div
    [ css "padding" "0 1rem 8px 1rem"
    , css "color" "rgba(0, 0, 0, 0.54)"
    , css "color" "var(--mdc-theme-text-secondary-on-background, rgba(0, 0, 0, 0.54))"
    , Typography.body1
    ]
    [ text
      """
Visit ten places on our planet that are undergoing the biggest changes today.
      """
    ]
  ,
    Card.actions
    [
    ]
    [
      Card.actionButtons
      [
      ]
      [
        Button.render (lift << Mdc) (index ++ [0]) model.mdc
        [ Card.actionButton
        , Button.ripple
        ]
        [ text "Read"
        ]
      ,
        Button.render (lift << Mdc) (index ++ [1]) model.mdc
        [ Card.actionButton
        , Button.ripple
        ]
        [ text "Bookmark"
        ]
      ]
    ,
      Card.actionIcons
      [
      ]
      [
        IconToggle.render (lift << Mdc) (index ++ [2]) model.mdc
        [ Card.actionIcon
        , IconToggle.icon "favorite" "favorite_border"
        , IconToggle.label "Remove from favorites" "Add to favorites"
        ]
        []
      ,
        IconToggle.render (lift << Mdc) (index ++ [3]) model.mdc
        [ Card.actionIcon
        , IconToggle.icon "share" "share"
        , IconToggle.label "Share" "Share"
        ]
        []
      ,
        IconToggle.render (lift << Mdc) (index ++ [4]) model.mdc
        [ Card.actionIcon
        , IconToggle.icon "more_vert" "more_vert"
        , IconToggle.label "More options" "More options"
        ]
        []
      ]
    ]
  ]


headlinesCard : (Msg m -> m) -> List Int -> Model -> Html m
headlinesCard lift index model =
    let
      listDivider =
        styled Html.hr [ cs "mdc-list-divider" ] []

      article title body =
          styled Html.a
          [ css "padding" "16px"
          ]
          [ styled Html.h2
            [ Typography.headline
            , css "margin" "0 0 4px 0"
            ]
            [ text title
            ]
          , styled Html.p
            [ Typography.body1
            , css "color" "rgba(0, 0, 0, 0.54)"
            , css "color" "var(--mdc-theme-text-secondary-on-light, rgba(0, 0, 0, 0.54))"
            , css "margin" "0"
            ]
            [ text title
            ]
          ]
    in
    Card.view
    [ Card.stroked
    , css "margin" "48px"
    ]
    (
      List.intersperse listDivider
      [
        styled Html.div
        [ Typography.subheading2
        , css "color" "rgba(0, 0, 0, 0.54)"
        , css "color" "var(--mdc-theme-text-secondary-on-light, rgba(0, 0, 0, 0.54))"
        , css "padding" "8px 16px"
        ]
        [ text "Headlines"
        ]
      ,
        article
            "Copper on the rise"
            "Copper price soars amid global market optimism and increased demand."
      ,
        article
            "U.S. tech startups rebound"
            "Favorable business conditions have allowed startups to secure more fundraising deals compared to last year."
      ,
        article
            "Asia's clean energy ambitions"
            "China plans to invest billions of dollars for the development of over 300 clean energy projects in Southeast Asia."
      ,
        Card.actions
        [ Card.fullBleed
        ]
        [ Button.render (lift << Mdc) (index ++ [0]) model.mdc
          [ Button.ripple
          , Card.actionButton
          , css "width" "100%"
          , css "justify-content" "space-between"
          , css "padding" "8px 16px"
          , css "height" "auto"
          ]
          [ text "All Business Headlines"
          , Icon.view [] "arrow_forward"
          ]
        ]
      ]
    )


photosCard : (Msg m -> m) -> List Int -> Model -> Html m
photosCard lift index model =
    Card.view
    [ css "width" "200px"
    , css "margin" "48px"
    ]
    [
      Card.media
      [ Card.square
      , Card.backgroundImage "images/1-1.jpg"
      ]
      [ Card.mediaContent
        [ css "display" "flex"
        , css "flex-flow" "column"
        , css "justify-content" "flex-end"
        , css "color" "#fff"
        ]
        [ styled Html.div
          [ Typography.subheading2
          , css "background-image" "linear-gradient(to bottom, transparent 0%, rgba(0, 0, 0, 0.5) 100%)"
          , css "padding" "8px 16px"
          ]
          [ text "Vacation Photos"
          ]
        ]
      ]
    ,
      Card.actions
      [
      ]
      [ Card.actionIcons []
        [
          IconToggle.render (lift << Mdc) (index ++ [0]) model.mdc
          [ Card.actionIcon
          , IconToggle.icon "favorite" "favorite_border"
          , IconToggle.label "Remove from favorites" "Add to favorites"
          ]
          []
        ,
          IconToggle.render (lift << Mdc) (index ++ [1]) model.mdc
          [ Card.actionIcon
          , IconToggle.icon "bookmark" "bookmark_border"
          , IconToggle.label "Remove bookmark" "Add bookmark"
          ]
          []
        ,
          IconToggle.render (lift << Mdc) (index ++ [2]) model.mdc
          [ Card.actionIcon
          , IconToggle.icon "share" "share"
          , IconToggle.label "Share" "Share"
          ]
          []
        ]
      ]
    ]


albumCard : (Msg m -> m) -> List Int -> Model -> Html m
albumCard lift index model =
    Card.view
    [ css "border-radius" "24px 4px"
    , css "margin" "48px"
    ]
    [ styled Html.div
      [ css "display" "flex"
      , css "border-top-left-radius" "inherit"
      ]
      [
        Card.media
        [ Card.square
        , Card.backgroundImage "images/1-1.jpg"
        , css "width" "110px"
        ]
        []
      ,
        styled Html.div
        [ css "padding" "8px 16px"
        ]
        [
          styled Html.div
          [ Typography.headline
          ]
          [ text "Rozes"
          ]
        ,
          styled Html.div
          [ Typography.body1
          ]
          [ text "Under the Grave"
          ]
        ,
          styled Html.div
          [ Typography.body1
          ]
          [ text "(2016)"
          ]
        ]
      ]
    ,
      styled Html.hr [ cs "mdc-list-divider" ] []
    ,
      Card.actions []
      [ Card.actionButtons []
        [ text "Rate this album"
        ]
      ,
        Card.actionIcons []
        ( List.range 1 5
          |> List.map (\ n ->
               IconToggle.render (lift << Mdc) (index ++ [n]) model.mdc
               [ Card.actionIcon
               , IconToggle.icon "star_border" "star_border"
               , IconToggle.label (toString n ++ " stars") (toString n ++ " stars")
               ]
               []
             )
        )
      ]
    ]

--<div class="mdc-card demo-card demo-card--music">
--          <div class="demo-card__music-row">
--            <div class="mdc-card__media mdc-card__media--square demo-card__media demo-card__media--music"></div>
--            <div class="demo-card__music-info">
--              <div class="demo-card__music-title mdc-typography--headline">Rozes</div>
--              <div class="demo-card__music-artist mdc-typography--body1">Under the Grave</div>
--              <div class="demo-card__music-year mdc-typography--body1">(2016)</div>
--            </div>


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    let
        example options =
            styled Html.div
            ( css "margin" "24px"
            :: css "padding" "24px"
            :: options
            )

        demoWrapper options =
            Options.div
            ( css "display" "flex"
            :: css "margin" "24px"
            :: css "flex-flow" "row wrap"
            :: css "align-content" "left"
            :: css "justify-content" "center"
            :: cs "mdc-typography"
            :: options
            )
                << List.map (\card -> Html.div [] [ card ])
    in
    page.body "Card"
    [
      Page.hero
      [ css "height" "auto"
      ]
      [
        heroCard lift [0] model
      ]

    , example
      [ css "text-align" "center"
      ]
      [ styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Checkbox.render (Mdc >> lift) [0] model.mdc
          [ Options.onClick (lift ToggleRtl)
          , Checkbox.checked |> when model.rtl
          ]
          [
          ]
        , Html.label []
          [ text "Toggle RTL"
          ]
        ]
      ]
    
    , demoWrapper
      [ Options.attribute (Html.dir "rtl") |> when model.rtl
      ]
      [
        headlinesCard lift [1] model
      ,
        photosCard lift [2] model
      ,
        albumCard lift [3] model
      ]
    ]
