module Demo.IconToggle exposing (Model,defaultModel,Msg(Mdc),update,view)

import Demo.Page as Page exposing (Page)
import Dict
import Html.Attributes as Html
import Html exposing (Html, text)
import Material
import Material.Component exposing (Index, Indexed)
import Material.IconToggle as IconToggle
import Material.Options as Options
import Material.Options exposing (styled, cs, css, when)


type alias Model =
    { mdc : Material.Model
    , iconToggles : Indexed Bool
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    , iconToggles = Dict.empty
    }


type Msg m
    = Mdc (Material.Msg m)
    | Toggle Index


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model
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
            IconToggle.view (lift << Mdc) idx model.mdc
            ( Options.onClick (lift (Toggle idx))
            :: when isOn IconToggle.on
            :: options
            )
    in
    page.body "Icon toggles"
    [
      Page.hero []
      [
        let
            isOn =
              Dict.get [0] model.iconToggles
              |> Maybe.withDefault False
        in
        toggleExample []
        [ iconToggle [0]
              [ IconToggle.label
                { on = "Remove from Fravorites"
                , off =  "Add to Favorites"
                }
              , IconToggle.icon
                { on = "favorite"
                , off = "favorite_border"
                }
              ]
              []
        ]
      ]

    ,
      Html.node "style"
      [ Html.type_ "text/css"
      ]
      [ text "@import url(\"https://opensource.keycdn.com/fontawesome/4.7.0/font-awesome.min.css\");" ]
    
    , example []
      [
        let
            isOn =
              Dict.get [1] model.iconToggles
              |> Maybe.withDefault False
        in
        toggleExample []
        [ title [] [ text "Using Material Icons" ]
        , styled Html.div
          [ css "margin-left" "1rem"
          ]
          [ iconToggle [1]
              [ IconToggle.label
                { on = "Remove from Fravorites"
                , off = "Add to Favorites"
                }
              , IconToggle.icon
                { on = "favorite"
                , off = "favorite_border"
                }
              ]
              []
          ]
        , styled Html.p
          [ css "margin-top" "20px"
          , css "margin-bottom" "20px"
          ]
          [ text <|
            if isOn then
                "Favorited? yes"
            else
                "Favorited? no"
          ]
        ]

      , toggleExample []
        [ title [] [ text "Using Font Awesome" ]
        , styled Html.div
          [ css "margin-left" "1rem"
          ]
          [
            iconToggle [2]
                [ IconToggle.label
                  { on = "Unstar this Icon"
                  , off = "Star this Icon"
                  }
                , IconToggle.icon
                  { on = "fa-star"
                  , off = "fa-star-o"
                  }
                , IconToggle.className "fa"
                ]
                []
          ]
        ]

      , toggleExample []
        [ title [] [ text "Disabled Icons" ]
        , styled Html.div
          [ css "margin-left" "1rem"
          ]
          [
            iconToggle [3]
              [ IconToggle.label
                { on = "Remove from Fravorites"
                , off = "Add to Favorites"
                }
              , IconToggle.icon
                { on = "favorite"
                , off = "favorite_border"
                }
              , IconToggle.disabled
              ]
              []
          ]
        ]
      ]
    ]
