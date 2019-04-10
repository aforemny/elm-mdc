module Demo.Switch exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Material
import Material.FormField as FormField
import Material.Options as Options exposing (cs, css, for, styled, when)
import Material.Switch as Switch
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , switches : Dict Material.Index Bool
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , switches = Dict.fromList [ ( "switch-hero-switch", True ) ]
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
                switches =
                    Dict.update index
                        (\state ->
                            Just <|
                                case state of
                                    Just True ->
                                        False

                                    _ ->
                                        True
                        )
                        model.switches
            in
            ( { model | switches = switches }, Cmd.none )


isOn : Material.Index -> Model m -> Bool
isOn index model =
    Dict.get index model.switches
        |> Maybe.withDefault False


heroSwitch : (Msg m -> m) -> Model m -> Html m
heroSwitch lift model =
    let
        index =
            "switch-hero-switch"
    in
    FormField.view []
        [ Switch.view (lift << Mdc)
            index
            model.mdc
            [ Options.onClick (lift (Toggle index))
            , Switch.on |> when (isOn index model)
            ]
            []
        , styled Html.label [ Options.for index ] [ text "off/on" ]
        ]


exampleSwitch : (Msg m -> m) -> Model m -> Html m
exampleSwitch lift model =
    let
        index =
            "switch-example-switch"
    in
    FormField.view []
        [ Switch.view (lift << Mdc)
            index
            model.mdc
            [ Options.onClick (lift (Toggle index))
            , Switch.on |> when (isOn index model)
            ]
            []
        , styled Html.label [ Options.for index ] [ text "off/on" ]
        ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body "Switch"
        "Switches communicate an action a user can take. They are typically placed throughout your UI, in places like dialogs, forms, cards, and toolbars."
        [ Hero.view [] [ heroSwitch lift model ]
        , styled Html.h2
            [ Typography.headline6
            , css "border-bottom" "1px solid rgba(0,0,0,.87)"
            ]
            [ text "Resources"
            ]
        , ResourceLink.view
            { link = "https://material.io/go/design-switches"
            , title = "Material Design Guidelines"
            , icon = "images/material.svg"
            , altText = "Material Design Guidelines icon"
            }
        , ResourceLink.view
            { link = "https://material.io/components/web/catalog/input-controls/switches/"
            , title = "Documentation"
            , icon = "images/ic_drive_document_24px.svg"
            , altText = "Documentation icon"
            }
        , ResourceLink.view
            { link = "https://github.com/material-components/material-components-web/tree/master/packages/mdc-switch"
            , title = "Source Code (Material Components Web)"
            , icon = "images/ic_code_24px.svg"
            , altText = "Source Code"
            }
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Switch" ]
            , exampleSwitch lift model
            ]
        ]
