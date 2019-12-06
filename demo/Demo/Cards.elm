module Demo.Cards exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Html.Attributes as Html
import Material
import Material.Button as Button
import Material.Card as Card
import Material.IconButton as IconButton
import Material.Options exposing (css, styled)
import Material.Ripple as Ripple
import Material.Theme as Theme
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd)


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


cardMedia : Html m
cardMedia =
    Card.media
        [ Card.aspect16To9
        , Card.backgroundImage "images/2.jpg"
        ]
        []


cardTitle : Html m
cardTitle =
    styled Html.div
        [ css "padding" "1rem"
        ]
        [ styled Html.h2
            [ Typography.headline6
            , css "margin" "0"
            ]
            [ text "Our Changing Planet"
            ]
        , styled Html.h3
            [ Typography.subtitle2
            , Theme.textSecondaryOnBackground
            , css "margin" "0"
            ]
            [ text "by Kurt Wagner"
            ]
        ]


cardBody : Html m
cardBody =
    styled Html.div
        [ css "padding" "0 1rem 0.5rem 1rem"
        , Typography.body2
        , Theme.textSecondaryOnBackground
        ]
        [ text """
            Visit ten places on our planet that are undergoing the biggest
            changes today.
          """
        ]


cardActions : (Msg m -> m) -> Material.Index -> Model m -> Html m
cardActions lift index model =
    Card.actions []
        [ Card.actionButtons []
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
        , Card.actionIcons []
            [ IconButton.view (lift << Mdc)
                (index ++ "-action-icon-favorite")
                model.mdc
                [ Card.actionIcon
                , IconButton.icon
                    { on = "favorite"
                    , off = "favorite_border"
                    }
                , IconButton.label
                    { on = "Remove from favorites"
                    , off = "Add to favorites"
                    }
                ]
                []
            , IconButton.view (lift << Mdc)
                (index ++ "-action-icon-share")
                model.mdc
                [ Card.actionIcon
                , IconButton.icon { on = "share", off = "share" }
                , IconButton.label { on = "Share", off = "Share" }
                ]
                []
            , IconButton.view (lift << Mdc)
                (index ++ "-action-icon-more-options")
                model.mdc
                [ Card.actionIcon
                , IconButton.icon { on = "more_vert", off = "more_vert" }
                , IconButton.label { on = "More options", off = "More options" }
                ]
                []
            ]
        ]


heroCard : (Msg m -> m) -> Material.Index -> Model m -> Html m
heroCard lift index model =
    let
        ripple =
            Ripple.bounded (lift << Mdc) (index ++ "-ripple") model.mdc []
    in
    Card.view
        [ css "width" "350px"
        ]
        [ Card.primaryAction
            [ ripple.properties
            , ripple.interactionHandler
            ]
            [ cardMedia
            , cardTitle
            , cardBody
            ]
        , cardActions lift index model
        ]


exampleCard1 : (Msg m -> m) -> Material.Index -> Model m -> Html m
exampleCard1 lift index model =
    let
        ripple =
            Ripple.bounded (lift << Mdc) (index ++ "-ripple") model.mdc []
    in
    Card.view
        [ css "margin" "48px 0"
        , css "width" "350px"
        ]
        [ Card.primaryAction
            [ ripple.properties
            , ripple.interactionHandler
            ]
            [ cardMedia
            , cardTitle
            , cardBody
            ]
        , cardActions lift index model
        ]


exampleCard2 : (Msg m -> m) -> Material.Index -> Model m -> Html m
exampleCard2 lift index model =
    let
        ripple =
            Ripple.bounded (lift << Mdc) (index ++ "-ripple") model.mdc []
    in
    Card.view
        [ css "margin" "48px 0"
        , css "width" "350px"
        ]
        [ Card.primaryAction
            [ ripple.properties
            , ripple.interactionHandler
            ]
            [ cardTitle
            , cardBody
            ]
        , cardActions lift index model
        ]


exampleCard3 : (Msg m -> m) -> Material.Index -> Model m -> Html m
exampleCard3 lift index model =
    let
        ripple =
            Ripple.bounded (lift << Mdc) (index ++ "-ripple") model.mdc []
    in
    Card.view
        [ css "margin" "48px 0"
        , css "width" "350px"
        , css "border-radius" "24px 8px"
        ]
        [ Card.primaryAction
            [ ripple.properties
            , ripple.interactionHandler
            ]
            [ cardTitle
            , cardBody
            ]
        , cardActions lift index model
        ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Card"
              , Hero.intro "Cards contain content and actions about a single subject."
              , Hero.component [] [ heroCard lift "card-hero-card" model ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "cards" "cards" "mdc-card"
        , Page.demos
            [ exampleCard1 lift "cards-example-card-1" model
            , exampleCard2 lift "cards-example-card-2" model
            , exampleCard3 lift "cards-example-card-3" model
            ]
        ]
