module Demo.RadioButtons exposing (Model, Msg(Mdc), defaultModel, update, view)

import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Html.Attributes as Html
import Material
import Material.FormField as FormField
import Material.Options as Options exposing (cs, css, styled, when)
import Material.RadioButton as RadioButton
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , radios : Dict String String
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , radios =
        Dict.fromList
            []
    }


type Msg m
    = Mdc (Material.Msg m)
    | Set String String


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

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


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    let
        example options =
            styled Html.div
                (cs "example"
                    :: css "display" "block"
                    :: css "margin" "24px"
                    :: css "padding" "24px"
                    :: options
                )
    in
    page.body "Radio buttons"
        [ let
            group =
                "hero"

            isSelected isDef id =
                Dict.get group model.radios
                    |> Maybe.map ((==) id)
                    |> Maybe.withDefault isDef
          in
          Page.hero []
            [ example []
                [ let
                    id =
                        "radio-buttons-hero-radio-1"
                  in
                  FormField.view []
                    [ RadioButton.view (lift << Mdc)
                        id
                        model.mdc
                        [ Options.onClick (lift (Set group id))
                        , RadioButton.selected |> when (isSelected True id)
                        ]
                        []
                    ]
                , let
                    id =
                        "radio-buttons-hero-radio-2"
                  in
                  FormField.view []
                    [ RadioButton.view (lift << Mdc)
                        id
                        model.mdc
                        [ Options.onClick (lift (Set group id))
                        , RadioButton.selected |> when (isSelected False id)
                        ]
                        []
                    ]
                ]
            ]
        , let
            group =
                "ex0"

            isSelected isDef id =
                Dict.get group model.radios
                    |> Maybe.map ((==) id)
                    |> Maybe.withDefault isDef
          in
          example []
            [ styled Html.h2
                [ css "margin-left" "0"
                , css "margin-top" "0"
                ]
                [ text "Radio" ]
            , let
                id =
                    "radio-buttons-default-radio-1"
              in
              FormField.view []
                [ RadioButton.view (lift << Mdc)
                    id
                    model.mdc
                    [ Options.onClick (lift (Set group id))
                    , RadioButton.selected |> when (isSelected True id)
                    ]
                    []
                , Html.label [ Html.for id ] [ text "Radio 1" ]
                ]
            , let
                id =
                    "radio-buttons-default-radio-2"
              in
              FormField.view []
                [ RadioButton.view (lift << Mdc)
                    id
                    model.mdc
                    [ Options.onClick (lift (Set group id))
                    , RadioButton.selected |> when (isSelected False id)
                    ]
                    []
                , Html.label [ Html.for id ] [ text "Radio 2" ]
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
                    id =
                        "radio-buttons-disabled-radio-1"
                  in
                  FormField.view []
                    [ RadioButton.view (lift << Mdc)
                        id
                        model.mdc
                        [ RadioButton.selected
                        , RadioButton.disabled
                        ]
                        []
                    , Html.label [ Html.for id ] [ text "Disabled Radio 1" ]
                    ]
                , let
                    id =
                        "radio-buttons-disabled-radio-2"
                  in
                  FormField.view []
                    [ RadioButton.view (lift << Mdc)
                        id
                        model.mdc
                        [ RadioButton.disabled
                        ]
                        []
                    , Html.label [ Html.for id ] [ text "Disabled Radio 2" ]
                    ]
                ]
            ]
        ]
