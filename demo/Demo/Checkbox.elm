module Demo.Checkbox exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Html.Attributes as Html
import Material
import Material.Checkbox as Checkbox
import Material.Options as Options exposing (css, styled)
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , checkboxes : Dict Material.Index (Maybe Bool)
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , checkboxes =
        Dict.fromList
            [ ( "checkbox-checked-hero-checkbox", Just True )
            , ( "checkbox-unchecked-hero-checkbox", Just False )
            , ( "checkbox-unchecked-checkbox", Just False )
            , ( "checkbox-checked-checkbox", Just True )
            ]
    }


type Msg m
    = Mdc (Material.Msg m)
    | Click Material.Index


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        Click index ->
            let
                checkboxes =
                    Dict.update index
                        (\state ->
                            Just <|
                                case Maybe.withDefault Nothing state of
                                    Just True ->
                                        Just False

                                    _ ->
                                        Just True
                        )
                        model.checkboxes
            in
            ( { model | checkboxes = checkboxes }, Cmd.none )


checkbox :
    (Msg m -> m)
    -> Material.Index
    -> Model m
    -> List (Checkbox.Property m)
    -> Html m
checkbox lift index model options =
    let
        checked =
            Dict.get index model.checkboxes
                |> Maybe.withDefault Nothing
                |> Maybe.map Checkbox.checked
                |> Maybe.withDefault Options.nop

        clickHandler =
            Options.onClick (lift (Click index))
    in
    Checkbox.view (lift << Mdc) index model.mdc (checked :: clickHandler :: options) []


heroComponent lift model =
    [ checkbox lift
          "checkbox-checked-hero-checkbox"
          model
          [ css "margin" "8px" ]
    , checkbox lift
        "checkbox-unchecked-hero-checkbox"
            model
            [ css "margin" "8px" ]
    ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Checkbox"
              , Hero.intro "Checkboxes allow the user to select multiple options from a set."
              , Hero.component [] ( heroComponent lift model )
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "selection-controls.html#checkboxes" "input-controls/checkboxes" "mdc-checkbox"
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Unchecked" ]
            , checkbox lift "checkbox-unchecked-checkbox" model []
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Indeterminate" ]
            , checkbox lift "checkbox-indeterminate-checkbox" model []
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Checked" ]
            , checkbox lift "checkbox-checked-checkbox" model []
            ]
        ]
