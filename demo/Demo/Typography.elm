module Demo.Typography exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.Options exposing (cs, css, styled)
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
              [ Hero.header "Typography"
              , Hero.intro "Roboto is the standard typeface on Android and Chrome."
              , Hero.component []
                  [ styled Html.h1 [ Typography.headline1 ] [ text "Typography" ] ]
              ]
        ,  ResourceLink.links (lift << Mdc) model.mdc "typography/the-type-system" "typography" "mdc-typography"
        , styled Html.h2
            [ Typography.headline6
            , css "border-bottom" "1px solid rgba(0,0,0,.87)"
            ]
              [ text "Demos"
              ]
        , example
        ]


example : Html m
example =
    styled Html.section
        [ cs "demo-typography--section"
        , Typography.typography
        ]
        [ styled Html.h1 [ Typography.headline1 ] [ text "Headline 1" ]
        , styled Html.h2 [ Typography.headline2 ] [ text "Headline 2" ]
        , styled Html.h3 [ Typography.headline3 ] [ text "Headline 3" ]
        , styled Html.h4 [ Typography.headline4 ] [ text "Headline 4" ]
        , styled Html.h5 [ Typography.headline5 ] [ text "Headline 5" ]
        , styled Html.h6 [ Typography.headline6 ] [ text "Headline 6" ]
        , styled Html.h6 [ Typography.subtitle1 ] [ text "Subtitle 1" ]
        , styled Html.h6 [ Typography.subtitle2 ] [ text "Subtitle 2" ]
        , styled Html.p
            [ Typography.body1
            ]
            [ text "Body 1. Lorem ipsum dolor sit amet, consectetur adipisicing elit. Quos blanditiis tenetur unde suscipit, quam beatae rerum inventore consectetur, neque doloribus, cupiditate numquam dignissimos laborum fugiat deleniti? Eum quasi quidem quibusdam."
            ]
        , styled Html.p
            [ Typography.body2
            ]
            [ text "Body 2. Lorem ipsum dolor sit amet consectetur adipisicing elit. Cupiditate aliquid ad quas sunt voluptatum officia dolorum cumque, possimus nihil molestias sapiente necessitatibus dolor saepe inventore, soluta id accusantium voluptas beatae."
            ]
        , styled Html.div
            [ Typography.button
            ]
            [ text "Button text"
            ]
        , styled Html.div
            [ Typography.caption
            ]
            [ text "Caption text"
            ]
        , styled Html.div
            [ Typography.overline
            ]
            [ text "Overline text"
            ]
        ]
