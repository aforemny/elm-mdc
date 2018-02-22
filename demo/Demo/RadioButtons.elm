module Demo.RadioButtons exposing (Model,defaultModel,Msg(Mdl),update,view)

import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Material
import Material.Options as Options exposing (styled, cs, css, when)
import Material.RadioButton as RadioButton
import Platform.Cmd exposing (Cmd, none)


type alias Model =
    { mdl : Material.Model
    , radios : Dict String String
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , radios =
        Dict.fromList
        [
        ]
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
            "hero"

        isSelected isDef name =
          Dict.get group model.radios
          |> Maybe.map ((==) name)
          |> Maybe.withDefault isDef
      in
      Page.hero []
      [
        example []
        [ let
            idx =
                [0,0]

            name =
                "Default Radio 1"
          in
          styled Html.div
          [ cs "mdc-form-field"
          ]
          [ RadioButton.render (Mdl >> lift) idx model.mdl
            [ Options.onClick (lift (Set group name))
            , RadioButton.selected |> when (isSelected True name)
            , RadioButton.name group
            ]
            []
          ]

        , let
            idx =
                [0,1]

            name =
                "Default Radio 2"
          in
          styled Html.div
          [ cs "mdc-form-field"
          ]
          [ RadioButton.render (Mdl >> lift) idx model.mdl
            [ Options.onClick (lift (Set group name))
            , RadioButton.selected |> when (isSelected False name)
            , RadioButton.name group
            ]
            []
          ]
        ]
      ]

    ,
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
              [1,0]

          name =
              "Radio 1"
        in
        styled Html.div
        [ cs "mdc-form-field"
        ]
        [ RadioButton.render (Mdl >> lift) idx model.mdl
          [ Options.onClick (lift (Set group name))
          , RadioButton.selected |> when (isSelected True name)
          , RadioButton.name group
          ]
          []
        , Html.label [] [ text name ]
        ]

      , let
          idx =
              [1,1]

          name =
              "Radio 2"
        in
        styled Html.div
        [ cs "mdc-form-field"
        ]
        [ RadioButton.render (Mdl >> lift) idx model.mdl
          [ Options.onClick (lift (Set group name))
          , RadioButton.selected |> when (isSelected False name)
          , RadioButton.name group
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
                [3,0]

            name =
                "Radio 1"
          in
          styled Html.div
          [ cs "mdc-form-field"
          ]
          [ RadioButton.render (Mdl >> lift) idx model.mdl
            [ RadioButton.selected
            , RadioButton.disabled
            ]
            []
          , Html.label [] [ text "Disabled Radio 1" ]
          ]

        , let
            idx =
                [3,1]

            name =
                "Radio 2"
          in
          styled Html.div
          [ cs "mdc-form-field"
          ]
          [ RadioButton.render (Mdl >> lift) idx model.mdl
            [ RadioButton.disabled
            ]
            []
          , Html.label [] [ text "Disabled Radio 2" ]
          ]
        ]
      ]
    ]
