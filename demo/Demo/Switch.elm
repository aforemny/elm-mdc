module Demo.Switch exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Material
import Material.FormField as FormField
import Material.Options as Options exposing (for, styled, when)
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
    page.body
        [ Hero.view
              [ Hero.header "Switch"
              , Hero.intro "Switches communicate an action a user can take. They are typically placed throughout your UI, in places like dialogs, forms, cards, and toolbars."
              , Hero.component [] [ heroSwitch lift model ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "selection-controls.html#switches" "input-controls/switches" "mdc-switch"
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Switch" ]
            , exampleSwitch lift model
            ]
        ]
