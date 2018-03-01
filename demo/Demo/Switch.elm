module Demo.Switch exposing (Model,defaultModel,Msg(Mdc),update,view)

import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Material
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Switch as Switch
import Platform.Cmd exposing (Cmd, none)


type alias Model =
    { mdc : Material.Model
    , switches : Dict (List Int) Bool
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    , switches = Dict.empty
    }


type Msg m
    = Mdc (Material.Msg m)
    | Toggle (List Int)


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (Mdc >> lift) msg_ model

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


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    let
        example options =
            styled Html.div
            ( cs "example"
            :: css "display" "block"
            :: css "margin" "16px"
            :: css "padding" "40px"
            :: options
            )
    in
    page.body "Switches"
    [
      Page.hero []
      [ styled Html.div
        [ cs "mdc-form-field"
        ]
        [ let
              index =
                  [0]

              on =
                  Dict.get index model.switches
                  |> Maybe.withDefault False
          in
          Switch.render (Mdc >> lift) index model.mdc
          [ Options.onClick (lift (Toggle index))
          , Switch.on |> when on
          ]
          [
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
        [ text "Enabled" ]
      ,
        styled Html.div
        [ cs "mdc-form-field"
        ]
        [ let
              index =
                  [1]

              on =
                  Dict.get index model.switches
                  |> Maybe.withDefault False
          in
          Switch.render (Mdc >> lift) index model.mdc
          [ Options.onClick (lift (Toggle index))
          , Switch.on |> when on
          ]
          [
          ]
        ,
          styled Html.label
          [ css "font-size" "16px"
          ]
          [ text "off/on"
          ]
        ]
      ]
    ,
      example
      [ css "background-color" "#eee"
      ]
      [ styled Html.h2
        [ css "margin-left" "0"
        , css "margin-top" "0"
        ]
        [ text "Disabled"
        ]
      , styled Html.div
        [ cs "mdc-form-field"
        ]
        [ let
              index =
                  [2]

              on =
                  Dict.get index model.switches
                  |> Maybe.withDefault False
          in
          Switch.render (Mdc >> lift) index model.mdc
          [ Options.onClick (lift (Toggle index))
          , Switch.disabled
          ]
          [
          ]
        ,
          styled Html.label
          [ css "font-size" "16px"
          ]
          [ text "off/on"
          ]
        ]
      ]
    ]
