module Demo.Radio exposing (Model,defaultModel,Msg(Mdl),update,view)

import Dict exposing (Dict)
import Html exposing (Html, text)
import Material
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Radio as Radio
import Material.Theme as Theme
import Platform.Cmd exposing (Cmd, none)
import Demo.Page exposing (Page)


type alias Model =
    { mdl : Material.Model
    , radios : Dict String String
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , radios = Dict.empty
    }


type Msg m
    = Mdl (Material.Msg m)
    | Set String String


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model
        Set group value ->
            let
                radio =
                    Dict.get group model.radios
                    |> Maybe.withDefault ""
            in
            { model
                | radios = Dict.insert group value model.radios
            }
                ! []


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    let
        example options =
            styled Html.div
            ( cs "example"
            :: css "display" "block"
            :: css "margin" "24px"
            :: css "padding" "24px"
            :: options
            )
    in
    page.body "Radio buttons"
    [
      let
        group =
            "ex0"

        isSelected isDef name =
          Dict.get group model.radios
          |> Maybe.map ((==) name)
          |> Maybe.withDefault isDef
      in
      example []
      [ styled Html.h2
        [ css "margin-left" "0"
        , css "margin-top" "0"
        ]
        [ text "Radio" ]

      , let
          idx =
              [0]

          name =
              "Radio 1"
        in
        styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Radio.render (Mdl >> lift) idx model.mdl
          [ Options.onClick (lift (Set group name))
          , Radio.selected |> when (isSelected True name)
          , Radio.name group
          ]
          []
        , Html.label [] [ text name ]
        ]

      , let
          idx =
              [0]

          name =
              "Radio 2"
        in
        styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Radio.render (Mdl >> lift) idx model.mdl
          [ Options.onClick (lift (Set group name))
          , Radio.selected |> when (isSelected False name)
          , Radio.name group
          ]
          []
        , Html.label [] [ text name ]
        ]
      ]

    , let
        group =
            "ex1"

        isSelected isDef name =
          Dict.get group model.radios
          |> Maybe.map ((==) name)
          |> Maybe.withDefault isDef
      in
      example
      [ Theme.dark
      , css "background-color" "#333"
      ]
      [ styled Html.h2
        [ css "margin-left" "0"
        , css "margin-top" "0"
        , css "color" "#fff"
        ]
        [ text "Dark Theme" ]

      , let
          idx =
              [2]

          name =
              "Radio 1"
        in
        styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Radio.render (Mdl >> lift) idx model.mdl
          [ Options.onClick (lift (Set group name))
          , Radio.selected |> when (isSelected True name)
          , Radio.name group
          ]
          []
        , Html.label [] [ text name ]
        ]

      , let
          idx =
              [3]

          name =
              "Radio 2"
        in
        styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Radio.render (Mdl >> lift) idx model.mdl
          [ Options.onClick (lift (Set group name))
          , Radio.selected |> when (isSelected False name)
          , Radio.name group
          ]
          []
        , Html.label [] [ text name ]
        ]
      ]

    , example
      []
      [ styled Html.h2
        [ css "margin-left" "0"
        , css "margin-top" "0"
        ]
        [ text "Disabled" ]

      , Html.div
        []
        [ let
            idx =
                [4]

            name =
                "Radio 1"
          in
          styled Html.div
          [ cs "mdc-form-field"
          ]
          [ Radio.render (Mdl >> lift) idx model.mdl
            [ Radio.selected
            , Radio.disabled
            ]
            []
          , Html.label [] [ text "Disabled Radio 2" ]
          ]

        , let
            idx =
                [5]

            name =
                "Radio 2"
          in
          styled Html.div
          [ cs "mdc-form-field"
          ]
          [ Radio.render (Mdl >> lift) idx model.mdl
            [ Radio.disabled
            ]
            []
          , Html.label [] [ text "Disabled Radio 2" ]
          ]
        ]

      , styled Html.div
        [ Theme.dark
        , css "background-color" "#333"
        ]
        [ let
            idx =
                [5]

            name =
                "Radio 1"
          in
          styled Html.div
          [ cs "mdc-form-field"
          ]
          [ Radio.render (Mdl >> lift) idx model.mdl
            [ Radio.selected
            , Radio.disabled
            ]
            []
          , Html.label [] [ text "Disabled Radio 2" ]
          ]

        , let
            idx =
                [6]

            name =
                "Radio 2"
          in
          styled Html.div
          [ cs "mdc-form-field"
          ]
          [ Radio.render (Mdl >> lift) idx model.mdl
            [ Radio.disabled
            ]
            []
          , Html.label [] [ text "Disabled Radio 2" ]
          ]
        ]
      ]
    ]
