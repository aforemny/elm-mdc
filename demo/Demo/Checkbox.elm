module Demo.Checkbox exposing (Model,defaultModel,Msg(Mdc),update,view)

import Dict exposing (Dict)
import Html exposing (Html, text)
import Json.Decode as Json
import Material
import Material.Button as Button
import Material.Checkbox as Checkbox
import Material.Options as Options exposing (styled, cs, css, when)
import Platform.Cmd exposing (Cmd, none)

import Demo.Page as Page exposing (Page)


type alias Model =
    { mdc : Material.Model
    , checkboxes : Dict (List Int) Checkbox
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    , checkboxes =
        Dict.singleton [2] { defaultCheckbox | checked = Nothing }
    }


type alias Checkbox =
    { checked : Maybe Bool
    , disabled : Bool
    }


defaultCheckbox : Checkbox
defaultCheckbox =
    { checked = Just False
    , disabled = False
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleIndeterminate (List Int)
    | ToggleDisabled (List Int)
    | ToggleChecked (List Int)


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleIndeterminate index ->
            let
              checkbox =
                Dict.get index model.checkboxes
                |> Maybe.withDefault defaultCheckbox
                |> \ checkbox ->
                   { checkbox | checked = Nothing }

              checkboxes =
                Dict.insert index checkbox model.checkboxes
            in
            ( { model | checkboxes = checkboxes }, Cmd.none )

        ToggleDisabled index ->
            let
              checkbox =
                Dict.get index model.checkboxes
                |> Maybe.withDefault defaultCheckbox
                |> \ checkbox ->
                   { checkbox | disabled = not checkbox.disabled }

              checkboxes =
                Dict.insert index checkbox model.checkboxes
            in
            ( { model | checkboxes = checkboxes }, Cmd.none )

        ToggleChecked index ->
            let
              checkbox =
                Dict.get index model.checkboxes
                |> Maybe.withDefault defaultCheckbox
                |> \ checkbox ->
                   { checkbox
                     | checked = Maybe.map not checkbox.checked
                   }

              checkboxes =
                Dict.insert index checkbox model.checkboxes
            in
            ( { model | checkboxes = checkboxes }, Cmd.none )


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

        checkbox index =
          let
            checkbox =
                Dict.get index model.checkboxes
                |> Maybe.withDefault defaultCheckbox
          in
          Checkbox.view (lift << Mdc) index model.mdc
          [ Options.on "click" (Json.succeed (lift (ToggleChecked index)))
          , when (checkbox.checked /= Nothing) <|
            Checkbox.checked (Maybe.withDefault False checkbox.checked)
          , Checkbox.disabled |> when checkbox.disabled
          ]
          []
    in
    page.body "Checkbox"
    [
      Page.hero []
      [
        styled Html.div
        [ cs "mdc-form-field"
        ]
        [ checkbox [0]
        , Html.label [] [ text "Checkbox" ]
        ]
      ]

    ,
      let
        checkbox index label =
          let
            checkbox =
                Dict.get index model.checkboxes
                |> Maybe.withDefault defaultCheckbox
          in
          styled Html.div []
          [
            styled Html.div
            [ cs "mdc-form-field"
            ]
            [ 
              Checkbox.view (lift << Mdc) index model.mdc
              [ Options.on "click" (Json.succeed (lift (ToggleChecked index)))
              , when (checkbox.checked /= Nothing) <|
                Checkbox.checked (Maybe.withDefault False checkbox.checked)
              , Checkbox.disabled |> when checkbox.disabled
              ]
              []
            ,
              Html.label [] [ text label ]
            ]
          ,
            styled Html.div
            [
            ]
            [
              Button.view (lift << Mdc) (index ++ [0]) model.mdc
              [ Options.on "click" (Json.succeed (lift (ToggleIndeterminate index)))
              ]
              [ text "Toggle "
              , Html.code [] [ text "indeterminate" ]
              ]
            ,
              Button.view (lift << Mdc) (index ++ [1]) model.mdc
              [ Options.on "click" (Json.succeed (lift (ToggleDisabled index)))
              ]
              [ text "TOGGLE "
              , Html.code [] [ text "disabled" ]
              ]
            ]
          ]
      in
      example []
      ( List.concat
        [
          [ styled Html.h2
            [ css "margin-left" "0"
            , css "margin-top" "0"
            ]
            [ text "Checkbox" ]
          ]
        ,
          [ ( [1], "Default checkbox" )
          , ( [2], "Indeterminate checkbox" )
--          , ( [3], "Custom colored checkbox (stroke, fill, ripple and focus)" )
--          , ( [4], "Custom colored checkbox (stroke and fill only)" )
          ]
          |> List.map (\ ( index, label ) ->
               checkbox index label
             )
        ]
      )
    ]
