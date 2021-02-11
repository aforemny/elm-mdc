module Demo.Banners exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Html exposing (Html, text, br)
import Material
import Material.Banner as Banner
import Material.Button as Button
import Material.Options exposing (css, styled)
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
              [ Hero.header "Banner"
              , Hero.intro "A banner displays an important, succinct message, and provides actions for users to address (or dismiss the banner). It requires a user action to be dismissed."
              , Hero.component []
                  [ viewHeroBanner lift model
                  ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "banners" "banners" "mdc-banner"
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Centered" ]
            , br [] []
            , viewCenteredBanner lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "With graphic" ]
            , br [] []
            , viewBannerWithGraphic lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "With two actions" ]
            , br [] []
            , viewBannerWithTwoActions lift model
            ]
        ]


viewABanner : (Msg m -> m) -> Model m -> List (Banner.Property m) -> List (Html m) -> Html m
viewABanner lift model options actions =
    Banner.view ( css "display" "block" :: options )
        [ Banner.graphicTextWrapper []
              [ Banner.text [] [ text "There was a problem processing a transaction on your credit card." ]
              ]
        , Banner.actions [] actions
        ]

primaryAction lift prefix model =
    Button.view (lift << Mdc)
        (prefix ++ "-primary-action")
        model.mdc
        [ Button.ripple
        , Banner.primaryAction
        ]
        [ text "Fix it"
        ]


secondaryAction lift prefix model =
    Button.view (lift << Mdc)
        (prefix ++ "-secondary-action")
        model.mdc
        [ Button.ripple
        , Banner.secondaryAction
        ]
        [ text "Learn more"
        ]


viewHeroBanner lift model =
    viewABanner lift model [ ] [ primaryAction lift "hero-banner" model ]


viewCenteredBanner lift model =
    viewABanner lift model [ Banner.centered ] [ primaryAction lift "centered-banner" model ]


viewBannerWithGraphic : (Msg m -> m) -> Model m -> Html m
viewBannerWithGraphic lift model =
    Banner.view [ css "display" "block", css "margin-top" "2em" ]
        [ Banner.graphicTextWrapper []
              [ Banner.graphic []
                  [ Banner.icon "error_outline" ]
              , Banner.text []
                  [ text "There was a problem processing a transaction on your credit card." ]
              ]
        , Banner.actions []
            [ primaryAction lift "graphics-banner"  model
            ]
        ]


viewBannerWithTwoActions lift model =
    viewABanner lift model
        [ css "margin-top" "2em" ]
        [ secondaryAction lift "two-actions-banner" model
        , primaryAction lift "two-actions-banner" model
        ]
