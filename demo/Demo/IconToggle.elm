module Demo.IconToggle exposing (Model,defaultModel,Msg(Mdl),update,view)

import Demo.Page exposing (Page)
import Dict
import Html.Attributes as Html
import Html exposing (Html, text)
import Material
import Material.Component exposing (Index, Indexed)
import Material.IconToggle as IconToggle
import Material.Options as Options
import Material.Options exposing (styled, cs, css, when)
import Material.Theme as Theme


type alias Model =
    { mdl : Material.Model
    , iconToggles : Indexed Bool
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , iconToggles = Dict.empty
    }


type Msg m
    = Mdl (Material.Msg m)
    | Toggle Index


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model
        Toggle idx ->
            let
                iconToggle =
                    Dict.get idx model.iconToggles
                    |> Maybe.withDefault False
                    |> not
            in
            { model | iconToggles = Dict.insert idx iconToggle model.iconToggles }
            ! []


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    let
        example options =
            styled Html.div
            ( cs "example"
            :: css "margin" "24px"
            :: css "padding" "24px"
            :: css "display" "flex"
            :: css "flex-flow" "row wrap"
            :: css "align-content" "left"
            :: css "justify-content" "left"
            :: options
            )

        title options =
            styled Html.h2
              ( css "margin-left" "0"
              :: css "margin-bottom" "0.8em"
              :: css "margin-top" "0.8em"
              :: css "font-size" "1.3em"
              :: options
              )

        toggleExample options =
            styled Html.div
            ( cs "toggle-example"
            :: css "min-width" "240px"
            :: css "padding" "24px"
            :: css "margin" "24px"
            :: options
            )

        iconToggle idx options =
            let
                isOn =
                    Dict.get idx model.iconToggles
                    |> Maybe.withDefault False
            in
            IconToggle.render (Mdl >> lift) idx model.mdl
            ( css "margin-left" "1rem"
            :: Options.onClick (lift (Toggle idx))
            :: when isOn IconToggle.on
            :: options
            )
    in
    page.body "Icon toggles"
    [
      Html.node "style"
      [ Html.type_ "text/css"
      ]
      [ text "@import url(\"https://opensource.keycdn.com/fontawesome/4.7.0/font-awesome.min.css\");" ]
    
    , example []
      [
        let
            isOn =
              Dict.get [0] model.iconToggles
              |> Maybe.withDefault False
        in
        toggleExample []
        [ title [] [ text "Using Material Icons" ]
        , iconToggle [0]
              [ IconToggle.label "Remove from Fravorites" "Add to Favorites"
              , IconToggle.icon  "favorite" "favorite_border"
              ]
              []
        , text <|
          if isOn then
              "Favorited? yes"
          else
              "Favorited? no"
        ]

      , toggleExample []
        [ title [] [ text "Using Font Awesome" ]
        , iconToggle [1]
              [ IconToggle.label "Unstar this Icon" "Star this Icon"
              , IconToggle.icon "fa-star" "fa-star-o"
              , IconToggle.inner "fa"
              ]
              []
        ]

      , toggleExample
        [ Theme.dark
        , css "background-color" "#333"
        ]
        [ title [ css "color" "#fff" ] [ text "Dark Theme" ]
        , iconToggle [2]
              [ IconToggle.label "Remove from Fravorites" "Add to Favorites"
              , IconToggle.icon  "favorite" "favorite_border"
              , IconToggle.primary
              ]
              []
        ]

      , toggleExample []
        [ title [] [ text "Primary Colored Icons" ]
        , iconToggle [3]
              [ IconToggle.label "Remove from Fravorites" "Add to Favorites"
              , IconToggle.icon  "favorite" "favorite_border"
              , IconToggle.primary
              ]
              []
        ]

      , toggleExample []
        [ title [] [ text "Accent Colored Icons" ]
        , iconToggle [4]
              [ IconToggle.label "Remove from Fravorites" "Add to Favorites"
              , IconToggle.icon  "favorite" "favorite_border"
              , IconToggle.accent
              ]
              []
        ]

      , toggleExample []
        [ title [] [ text "Disabled Icons" ]
        , iconToggle [5]
              [ IconToggle.label "Remove from Fravorites" "Add to Favorites"
              , IconToggle.icon  "favorite" "favorite_border"
              , IconToggle.disabled
              ]
              []
        , styled Html.div
          [ Theme.dark
          , css "background-color" "#303030"
          , css "padding-bottom" "1rem"
          ]
          [ iconToggle [6]
              [ IconToggle.label "Remove from Fravorites" "Add to Favorites"
              , IconToggle.icon  "favorite" "favorite_border"
              , IconToggle.disabled
              ]
              []
          ]
        ]

      , let
          demoColorCombo idx iconToggleOptions options nodes =
              styled Html.div
              ( cs "demo-color-combo"
              :: css "width" "250px"
              :: css "padding" "1rem"
              :: css "border-radius" "4px"
              :: css "display" "inline-flex"
              :: css "flex-direction" "column"
              :: css "align-items" "center"
              :: css "justify-content" "center"
              :: css "margin-right" "8px"
              :: options
              )
              ( List.concat
                [ [ let
                        isOn =
                            Dict.get idx model.iconToggles
                            |> Maybe.withDefault False
                    in
                    IconToggle.render (Mdl >> lift) idx model.mdl
                    ( Options.onClick (lift (Toggle idx))
                    :: when isOn IconToggle.on
                    :: IconToggle.label "Remove from Fravorites" "Add to Favorites"
                    :: IconToggle.icon  "favorite" "favorite_border"
                    :: options
                    )
                    []
                  ]
                , nodes
                ]
              )
        in
        toggleExample []
        [ title [] [ text "Additional Color Combinations" ]
        , styled Html.div
          [ cs "demo-color-combos"
          , css "display" "flex"
          , css "align-items" "center"
          , css "justify-content" "flex-start"
          ]
          [
            demoColorCombo [7]
            [ Theme.textPrimaryOnPrimary
            ]
            [ css "background-color" "#3e82f7"
            ]
            [ styled Html.p
              [ Theme.textPrimaryOnPrimary
              ]
              [ text "Light icon on background"
              ]
            ]

          , demoColorCombo [8]
            []
            [ css "background-color" "#00bcd6"
            ]
            [ Html.p []
              [ text "Light icon on background"
              ]
            ]

          , demoColorCombo [9]
            [ Theme.textPrimaryOnDark
            ]
            [ Theme.dark
            , css "background-color" "#303030"
            ]
            [ styled Html.p
              [ Theme.textPrimaryOnDark
              ]
              [ text "Light icon on background"
              ]
            ]
          ]
        ]
      ]
    ]
