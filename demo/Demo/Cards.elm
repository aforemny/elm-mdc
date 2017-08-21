module Demo.Cards exposing (Model, defaultModel, Msg(Mdl), update, view)

import Demo.Page as Page exposing (Page)
import Html as Html_
import Html.Attributes as Html
import Html exposing (Html, text)
import Material
import Material.Button as Button
import Material.Card as Card
import Material.Checkbox as Checkbox
import Material.Options as Options exposing (styled, cs, css, when)
import Platform.Cmd exposing (Cmd, none)


type alias Model =
    { rtl : Bool
    , mdl : Material.Model
    }


defaultModel : Model
defaultModel =
    { rtl = False
    , mdl = Material.defaultModel
    }


type Msg m
    = Mdl (Material.Msg m)
    | ToggleRtl


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model
        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )


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
            :: css "justify-content" "left"
            :: cs "mdc-typography"
            :: options
            )
                << List.map (\card -> Html.div [] [ card ])


        demoCard options =
            Card.view
            (  css "margin" "24px"
            :: css "min-width" "320px"
            :: css "max-width" "21.875rem"
            :: options
            )


        demoSupportingText =
            Card.supportingText []
            [ text "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor."
            ]


        card0 model =
            demoCard
            [
            ]
            [ Card.media
              [ css "background-image" "url(images/16-9.jpg)"
              , css "background-size" "cover"
              , css "height" "12.313rem"
              ]
              [
              ]
            , demoSupportingText
            ]


        demoMedia options =
            Card.media
            ( css "background-size" "cover"
            :: css "height" "12.313rem"
            :: options
            )


        demoActions model options =
            Card.actions
            options
            [
              Button.render (Mdl >> lift) [1,1,0] model.mdl
              [ Button.compact
              ]
              [ text "Action 1"
              ]
            , Button.render (Mdl >> lift) [1,1,1] model.mdl
              [ Button.compact
              ]
              [ text "Action 2"
              ]
            ]


        demoTitle0 =
            Card.title [ Card.large ] [ text "Title" ]


        demoSubtitle0 =
            Card.subtitle [] [ text "Subehead" ]


        demoTitle1 =
            Card.title [ Card.large ] [ text "Title goes here" ]


        demoSubtitle1 =
            Card.subtitle [] [ text "Subtitle here" ]


        demoTitle2 =
            Card.title [ Card.large ] [ text "Title" ]


        demoPrimary options =
            Card.primary
            (  css "position" "relative"
            :: options
            )
            [ Options.div
                  [ css "position" "absolute"
                  , css "background" "#bdbdbd"
                  , css "height" "2.5rem"
                  , css "width" "2.5rem"
                  , css "border-radius" "50%"
                  ]
                  []
            , Card.title
              [ if model.rtl then
                    css "margin-right" "56px"
                else
                    css "margin-left" "56px"
              ]
              [ text "Title"
              ]
            , Card.subtitle
              [ if model.rtl then
                    css "margin-right" "56px"
                else
                    css "margin-left" "56px"
              ]
              [ text "Subhead"
              ]
            ]


        card1 model =
            demoCard []
            [ demoPrimary []
            , demoMedia
              [ css "background-image" "url(images/16-9.jpg)"
              ]
              []
            , demoSupportingText
            , demoActions model []
            ]


        card2 model =
            demoCard []
            [ demoPrimary []
            , demoMedia
              [ css "background-image" "url(images/16-9.jpg)"
              ]
              []
            , demoActions model [ Card.vertical ]
            ]


        demoPrimary2 options =
            Card.primary
            (  css "position" "relative"
            :: options
            )
            [ demoTitle1
            , demoSubtitle1
            ]

        card3 model =
            demoCard []
            [ demoMedia
              [ css "background-image" "url(images/16-9.jpg)"
              ]
              []
            , demoPrimary2 []
            , demoActions model []
            ]


        card4 model =
            demoCard []
            [ Card.primary
              [ css "position" "relative"
              ]
              [ demoTitle1
              , demoSubtitle1
              ]
            , Card.supportingText []
              [ text "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."
              ]
            , demoActions model []
            ]


        card5 model =
            demoCard
            [ Card.darkTheme
            , css "background-image" "url(images/1-1.jpg"
            , css "background-size" "cover"
            , css "height" "21.875rem"
            ]
            [ demoPrimary2
              [ css "background" "rgba(0,0,0,0.4)"
              ]
            , Card.actions
              [ css "background" "rgba(0,0,0,0.4)"
              ]
              [ Button.render (Mdl >> lift) [1,1,0] model.mdl
                [ Button.compact
                , Button.darkTheme
                ]
                [ text "Action 1"
                ]
              , Button.render (Mdl >> lift) [1,1,1] model.mdl
                [ Button.compact
                , Button.darkTheme
                ]
                [ text "Action 2"
                ]
              ]
            ]


        card6 model =
            demoCard []
            [ demoMedia
              [ css "background-image" "url(images/1-1.jpg)"
              ]
              [ Card.title [ Card.large ] [ text "Title" ]
              ]
            , Card.actions []
              [ Button.render (Mdl >> lift) [1,6,0] model.mdl
                [ Button.compact
                ]
                [ text "Action 1"
                ]
              ]
            ]


        mediaItem options =
            Card.mediaItem options
            [ Html.img
              [ Html.src "images/1-1.jpg"
              , Html.style
                [ ("width", "auto")
                , ("height", "100%")
                ]
              ]
              []
            ]


        demoPrimary3 options =
            Card.primary
            (  css "position" "relative"
            :: options
            )
            [ demoTitle3
            , demoSubtitle3
            ]


        demoTitle3 =
            Card.title [ Card.large ] [ text "Title here" ]


        demoSubtitle3 =
            Card.subtitle [] [ text "Subtitle here" ]


        card7 model =
            demoCard []
            [ Card.horizontalBlock []
              [ demoPrimary3 []
              , mediaItem []
              ]
            , demoActions model []
            ]


        card8 model =
            demoCard []
            [ Card.horizontalBlock []
              [ demoPrimary3 []
              , mediaItem [ Card.x1dot5 ]
              ]
            , demoActions model []
            ]


        card9 model =
            demoCard []
            [ Card.horizontalBlock []
              [ demoPrimary3 []
              , mediaItem [ Card.x2 ]
              ]
            , demoActions model []
            ]


        card10 model =
            demoCard
            [
            ]
            [ Card.horizontalBlock []
              [ mediaItem [ Card.x3 ]
              , Card.actions
                [ Card.vertical
                ]
                [ Button.render (Mdl >> lift) [1,10,0] model.mdl
                  [ Button.compact
                  ]
                  [ text "A 1"
                  ]
                , Button.render (Mdl >> lift) [1,10,1] model.mdl
                  [ Button.compact
                  ]
                  [ text "A 2"
                  ]
                ]
              ]
            ]
    in
    page.body "Card"
    [
      Page.hero
      [ css "min-height" "480px"
      ]
      [ demoCard
        [ css "background-color" "white"
        ]
        [ demoMedia
          [ css "background-image" "url(images/16-9.jpg)"
          ]
          []
        , demoPrimary2 []
        , demoActions model []
        ]
      ]

    , example []
      [ styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Checkbox.render (Mdl >> lift) [0] model.mdl
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
      [ Html.dir "rtl"
        |> when model.rtl << Options.attribute
      ]
      [ card0 model
      , card1 model
      , card2 model
      , card3 model
      , card4 model
      , card5 model
      , card6 model
      , card7 model
      , card8 model
      , card9 model
      , card10 model
      ]
    ]
