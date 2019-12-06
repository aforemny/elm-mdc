module Demo.RadioButtons exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Html.Attributes as Html
import Material
import Material.FormField as FormField
import Material.Options as Options exposing (css, styled, when)
import Material.RadioButton as RadioButton
import Material.Typography as Typography
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
            [ ( "hero", "radio-buttons-hero-radio-1" )
            , ( "example", "radio-buttons-example-radio-1" )
            ]
    }


type Msg m
    = Mdc (Material.Msg m)
    | Set String String


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        Set group index ->
            ( { model | radios = Dict.insert group index model.radios }, Cmd.none )


isSelected : String -> Material.Index -> Model m -> Bool
isSelected group index model =
    Dict.get group model.radios
        |> Maybe.map ((==) index)
        |> Maybe.withDefault False


heroRadio : (Msg m -> m) -> Model m -> String -> Material.Index -> Html m
heroRadio lift model group index =
    RadioButton.view (lift << Mdc)
        index
        model.mdc
        [ Options.onClick (lift (Set group index))
        , RadioButton.selected |> when (isSelected group index model)
        , css "margin" "0 10px"
        ]
        []


heroRadioGroup : (Msg m -> m) -> Model m -> Html m
heroRadioGroup lift model =
    Html.div []
        [ heroRadio lift model "hero" "radio-buttons-hero-radio-1"
        , heroRadio lift model "hero" "radio-buttons-hero-radio-2"
        ]


radio : (Msg m -> m) -> Model m -> String -> Material.Index -> String -> Html m
radio lift model group index label =
    FormField.view [ css "margin" "0 10px" ]
        [ RadioButton.view (lift << Mdc)
            index
            model.mdc
            [ Options.onClick (lift (Set group index))
            , RadioButton.selected |> when (isSelected group index model)
            ]
            []
        , Html.label [ Html.for index ] [ text label ]
        ]


exampleRadioGroup : (Msg m -> m) -> Model m -> Html m
exampleRadioGroup lift model =
    Html.div []
        [ radio lift model "example" "radio-buttons-example-radio-1" "Radio 1"
        , radio lift model "example" "radio-buttons-example-radio-2" "Radio 2"
        ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Radio Button"
              , Hero.intro "Buttons communicate an action a user can take. They are typically placed throughout your UI, in places like dialogs, forms, cards, and toolbars."
              , Hero.component [] [ heroRadioGroup lift model ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "buttons" "buttons" "mdc-button"
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Radio Buttons" ]
            , exampleRadioGroup lift model
            ]
        ]
