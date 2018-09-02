module Demo.Cards exposing (Model, Msg(Mdc), defaultModel, update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Html.Attributes as Html
import Material
import Material.Button as Button
import Material.Card as Card
import Material.Checkbox as Checkbox
import Material.FormField as FormField
import Material.Icon as Icon
import Material.IconToggle as IconToggle
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , rtl : Bool
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , rtl = False
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleRtl


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )


heroCard : (Msg m -> m) -> Material.Index -> Model m -> Html m
heroCard lift index model =
    Card.view
        [ css "width" "350px"
        , css "margin" "48px"
        ]
        [ Card.media
            [ Card.aspect16To9
            , Card.backgroundImage "images/16-9.jpg"
            ]
            []
        , styled Html.div
            [ css "padding" "1rem"
            ]
            [ styled Html.h2
                [ Typography.title
                , css "margin" "0"
                ]
                [ text "Our Changing Planet"
                ]
            , styled Html.h3
                [ Typography.subheading1
                , css "margin" "0"
                ]
                [ text "by Kurt Wagner"
                ]
            ]
        , styled Html.div
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
        , Card.actions
            []
            [ Card.actionButtons
                []
                [ Button.view (lift << Mdc)
                    (index ++ "-action-button-read")
                    model.mdc
                    [ Card.actionButton
                    , Button.ripple
                    ]
                    [ text "Read"
                    ]
                , Button.view (lift << Mdc)
                    (index ++ "-action-button-bookmark")
                    model.mdc
                    [ Card.actionButton
                    , Button.ripple
                    ]
                    [ text "Bookmark"
                    ]
                ]
            , Card.actionIcons
                []
                [ IconToggle.view (lift << Mdc)
                    (index ++ "-action-icon-favorite")
                    model.mdc
                    [ Card.actionIcon
                    , IconToggle.icon
                        { on = "favorite"
                        , off = "favorite_border"
                        }
                    , IconToggle.label
                        { on = "Remove from favorites"
                        , off = "Add to favorites"
                        }
                    ]
                    []
                , IconToggle.view (lift << Mdc)
                    (index ++ "-action-icon-share")
                    model.mdc
                    [ Card.actionIcon
                    , IconToggle.icon { on = "share", off = "share" }
                    , IconToggle.label { on = "Share", off = "Share" }
                    ]
                    []
                , IconToggle.view (lift << Mdc)
                    (index ++ "-action-icon-more-options")
                    model.mdc
                    [ Card.actionIcon
                    , IconToggle.icon { on = "more_vert", off = "more_vert" }
                    , IconToggle.label { on = "More options", off = "More options" }
                    ]
                    []
                ]
            ]
        ]


headlinesCard : (Msg m -> m) -> Material.Index -> Model m -> Html m
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
        (List.intersperse listDivider
            [ styled Html.div
                [ Typography.subheading2
                , css "color" "rgba(0, 0, 0, 0.54)"
                , css "color" "var(--mdc-theme-text-secondary-on-light, rgba(0, 0, 0, 0.54))"
                , css "padding" "8px 16px"
                ]
                [ text "Headlines"
                ]
            , article
                "Copper on the rise"
                "Copper price soars amid global market optimism and increased demand."
            , article
                "U.S. tech startups rebound"
                "Favorable business conditions have allowed startups to secure more fundraising deals compared to last year."
            , article
                "Asia's clean energy ambitions"
                "China plans to invest billions of dollars for the development of over 300 clean energy projects in Southeast Asia."
            , Card.actions
                [ Card.fullBleed
                ]
                [ Button.view (lift << Mdc)
                    (index ++ "-action-button")
                    model.mdc
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


photosCard : (Msg m -> m) -> Material.Index -> Model m -> Html m
photosCard lift index model =
    Card.view
        [ css "width" "200px"
        , css "margin" "48px"
        ]
        [ Card.media
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
        , Card.actions
            []
            [ Card.actionIcons []
                [ IconToggle.view (lift << Mdc)
                    (index ++ "-action-icon-favorite")
                    model.mdc
                    [ Card.actionIcon
                    , IconToggle.icon { on = "favorite", off = "favorite_border" }
                    , IconToggle.label { on = "Remove from favorites", off = "Add to favorites" }
                    ]
                    []
                , IconToggle.view (lift << Mdc)
                    (index ++ "-action-icon-bookmark")
                    model.mdc
                    [ Card.actionIcon
                    , IconToggle.icon { on = "bookmark", off = "bookmark_border" }
                    , IconToggle.label { on = "Remove bookmark", off = "Add bookmark" }
                    ]
                    []
                , IconToggle.view (lift << Mdc)
                    (index ++ "-action-icon-share")
                    model.mdc
                    [ Card.actionIcon
                    , IconToggle.icon { on = "share", off = "share" }
                    , IconToggle.label { on = "Share", off = "Share" }
                    ]
                    []
                ]
            ]
        ]


albumCard : (Msg m -> m) -> Material.Index -> Model m -> Html m
albumCard lift index model =
    Card.view
        [ css "border-radius" "24px 4px"
        , css "margin" "48px"
        ]
        [ styled Html.div
            [ css "display" "flex"
            , css "border-top-left-radius" "inherit"
            ]
            [ Card.media
                [ Card.square
                , Card.backgroundImage "images/1-1.jpg"
                , css "width" "110px"
                ]
                []
            , styled Html.div
                [ css "padding" "8px 16px"
                ]
                [ styled Html.div
                    [ Typography.headline
                    ]
                    [ text "Rozes"
                    ]
                , styled Html.div
                    [ Typography.body1
                    ]
                    [ text "Under the Grave"
                    ]
                , styled Html.div
                    [ Typography.body1
                    ]
                    [ text "(2016)"
                    ]
                ]
            ]
        , styled Html.hr [ cs "mdc-list-divider" ] []
        , Card.actions []
            [ Card.actionButtons []
                [ text "Rate this album"
                ]
            , Card.actionIcons []
                (List.range 1 5
                    |> List.map
                        (\n ->
                            IconToggle.view (lift << Mdc)
                                (index ++ "-action-icon-star-" ++ toString n)
                                model.mdc
                                [ Card.actionIcon
                                , IconToggle.icon { on = "star_border", off = "star_border" }
                                , IconToggle.label
                                    { on = toString n ++ " stars"
                                    , off = toString n ++ " stars"
                                    }
                                ]
                                []
                        )
                )
            ]
        ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    let
        example options =
            styled Html.div
                (css "margin" "24px"
                    :: css "padding" "24px"
                    :: options
                )

        demoWrapper options =
            styled Html.div
                (css "display" "flex"
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
        [ Page.hero
            [ css "height" "auto"
            ]
            [ heroCard lift "card-hero-card" model
            ]
        , example
            [ css "text-align" "center"
            ]
            [ FormField.view []
                [ Checkbox.view (lift << Mdc)
                    "cards-toggle-rtl"
                    model.mdc
                    [ Options.onClick (lift ToggleRtl)
                    , Checkbox.checked model.rtl
                    ]
                    []
                , Html.label []
                    [ text "Toggle RTL"
                    ]
                ]
            ]
        , demoWrapper
            [ Options.attribute (Html.dir "rtl") |> when model.rtl
            ]
            [ headlinesCard lift "cards-headlines-card" model
            , photosCard lift "cards-photos-card" model
            , albumCard lift "cards-album-cards" model
            ]
        ]
