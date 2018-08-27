module Demo.Switch exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Material
import Material.FormField as FormField
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Switch as Switch
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , switches : Dict Material.Index Bool
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , switches = Dict.empty
    }


type Msg m
    = Mdc (Material.Msg m)
    | Toggle Material.Index


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        Toggle index ->
            let
                switch =
                    Dict.get index model.switches
                        |> Maybe.withDefault False
                        |> not

                switches =
                    Dict.insert index switch model.switches
            in
            ( { model | switches = switches }, Cmd.none )


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    let
        example options =
            styled Html.div
                (cs "example"
                    :: css "display" "block"
                    :: css "margin" "16px"
                    :: css "padding" "40px"
                    :: options
                )
    in
    page.body "Switches"
        [ Page.hero []
            [ FormField.view []
                [ let
                    index =
                        "switch-hero-switch"

                    on =
                        Dict.get index model.switches
                            |> Maybe.withDefault False
                  in
                  Switch.view (lift << Mdc)
                    index
                    model.mdc
                    [ Options.onClick (lift (Toggle index))
                    , Switch.on |> when on
                    ]
                    []
                ]
            ]
        , example
            [ css "background-color" "#eee"
            ]
            [ styled Html.h2
                [ css "margin-left" "0"
                , css "margin-top" "0"
                ]
                [ text "Enabled" ]
            , let
                id =
                    "switch-default-switch"

                on =
                    Dict.get id model.switches
                        |> Maybe.withDefault False
              in
              FormField.view []
                [ Switch.view (lift << Mdc)
                    id
                    model.mdc
                    [ Options.onClick (lift (Toggle id))
                    , Switch.on |> when on
                    ]
                    []
                , styled Html.label
                    [ Options.for id
                    , css "font-size" "16px"
                    ]
                    [ text "off/on"
                    ]
                ]
            ]
        , example
            [ css "background-color" "#eee"
            ]
            [ styled Html.h2
                [ css "margin-left" "0"
                , css "margin-top" "0"
                ]
                [ text "Disabled"
                ]
            , let
                id =
                    "switch-disabled-switch"

                on =
                    Dict.get id model.switches
                        |> Maybe.withDefault False
              in
              FormField.view []
                [ Switch.view (lift << Mdc)
                    id
                    model.mdc
                    [ Options.onClick (lift (Toggle id))
                    , Switch.disabled
                    ]
                    []
                , styled Html.label
                    [ Options.for "id"
                    , css "font-size" "16px"
                    ]
                    [ text "off/on"
                    ]
                ]
            ]
        ]
