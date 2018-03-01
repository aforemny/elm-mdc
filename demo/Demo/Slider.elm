module Demo.Slider exposing (Model, defaultModel, Msg(Mdc), update, view, subscriptions)

import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html.Attributes as Html
import Html.Events as Html
import Html exposing (Html, text)
import Json.Decode as Json exposing (Decoder)
import Material
import Material.Component exposing (Index)
import Material.Options as Options exposing (styled, cs, css, when)
import Material.Slider as Slider
import Material.Theme as Theme
import Platform.Cmd exposing (Cmd, none)


type alias Model =
    { mdc : Material.Model
    , values : Dict Index Float
    , inputs : Dict Index Float
    , min : Int
    , max : Int
    , steps : Int
    , darkTheme : Bool
    , disabled : Bool
    , customBg : Bool
    , rtl : Bool
    }


defaultModel : Model
defaultModel =
    { mdc = Material.defaultModel
    , values =
        Dict.fromList
        [ ([0], 20)
        , ([1], 20)
        , ([2], 20)
        , ([3], 20)
        ]
    , inputs =
        Dict.empty
    , min = 0
    , max = 50
    , steps = 1
    , darkTheme = False
    , disabled = False
    , customBg = False
    , rtl = False
    }


type Msg m
    = Mdc (Material.Msg m)
    | Change Index Float
    | Input Index Float
    | SetMin Int
    | SetMax Int
    | SetSteps Int
    | ToggleDarkTheme
    | ToggleDisabled
    | ToggleCustomBg
    | ToggleRtl


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (Mdc >> lift) msg_ model

        Change idx value ->
            ( { model | values = Dict.insert idx value model.values }, Cmd.none )

        Input idx value ->
            ( { model | inputs = Dict.insert idx value model.inputs }, Cmd.none )

        SetMin min ->
            ( { model | min = min }, Cmd.none )

        SetMax max ->
            ( { model | max = max }, Cmd.none )

        SetSteps steps ->
            ( { model | steps = steps }, Cmd.none )

        ToggleDarkTheme ->
            ( { model | darkTheme = not model.darkTheme }, Cmd.none )

        ToggleDisabled ->
            ( { model | disabled = not model.disabled }, Cmd.none )

        ToggleCustomBg ->
            ( { model | customBg = not model.customBg }, Cmd.none )

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    let
        example options =
            styled Html.section
            ( cs "example"
            :: css "margin" "24px"
            :: css "padding" "24px"
            :: options
            )

        sliderWrapper options =
          styled Html.div
          ( ( when model.darkTheme << Options.many <|
              [ Theme.dark
              , css "background-color" "#333"
              , css "--mdc-theme-primary" "#64dd17" -- TODO
              ]
            )
          :: ( when model.customBg << Options.many <|
               [ css "background-color" "#eee"
               , css "--mdc-slider-bg-color-behind-component" "#eee" -- TODO
               ]
             )
          :: when model.rtl (Options.attribute (Html.attribute "dir" "rtl"))
          :: css "padding" "0 16px"
          :: options
          )
    in
    page.body "Slider"
    [
      Page.hero []
      [
        styled Html.div
        [ css "margin" "0 auto"
        , css "width" "100%"
        , css "max-width" "600px"
        , css "--mdc-slider-bg-color-behind-component" "#f2f2f2"
        ]
        [ let
              idx =
                  [0]
          in
          Slider.render (Mdc >> lift) idx model.mdc
          [ Slider.value (Maybe.withDefault 0 (Dict.get idx model.values))
          , Slider.onInput (Json.map (Input idx >> lift) Slider.targetValue)
          , Slider.onChange (Json.map (Change idx >> lift) Slider.targetValue)
          ]
          []
        ]
      ]

    , example []
      [
        Html.em []
        [ text "Note that in browsers that support custom properties, we alter theme's primary color when using the dark theme toggle so that the slider appears more visible"
        ]
      ]

    , let
          idx =
              [1]
      in
      example []
      [
        Html.h2 [] [ text "Continuous Slider" ]
      , Html.div []
        [ Html.p []
          [ text "Select Value:"
          ]
        ]

      , sliderWrapper []
        [ Slider.render (Mdc >> lift) idx model.mdc
          [ Slider.value (Maybe.withDefault 0 (Dict.get idx model.values))
          , Slider.onInput (Json.map (Input idx >> lift) Slider.targetValue)
          , Slider.onChange (Json.map (Change idx >> lift) Slider.targetValue)
          , Slider.min model.min
          , Slider.max model.max
          , Slider.disabled |> when model.disabled
          ]
          []
        ]

      , Html.p []
        [ text "Value from Slider.onInput: "
        , Html.span []
          [ text (toString (Maybe.withDefault 0 (Dict.get idx model.inputs)))
          ]
        ]

      , Html.p []
        [ text "Value from Slider.onChange: "
        , Html.span []
          [ text (toString (Maybe.withDefault 0 (Dict.get idx model.values)))
          ]
        ]
      ]

    , let
          idx =
              [2]
      in
      example []
      [
        Html.h2 [] [ text "Discrete Slider" ]
      , Html.div []
        [ Html.p []
          [ text "Select Value:"
          ]
        ]

      , sliderWrapper []
        [ Slider.render (Mdc >> lift) idx model.mdc
          [ Slider.value (Maybe.withDefault 0 (Dict.get idx model.values))
          , Slider.onInput (Json.map (Input idx >> lift) Slider.targetValue)
          , Slider.onChange (Json.map (Change idx >> lift) Slider.targetValue)
          , Slider.discrete
          , Slider.min model.min
          , Slider.max model.max
          , Slider.steps model.steps
          , Slider.disabled |> when model.disabled
          ]
          []
        ]

      , Html.p []
        [ text "Value from Slider.onInput: "
        , Html.span []
          [ text (toString (Maybe.withDefault 0 (Dict.get idx model.inputs)))
          ]
        ]

      , Html.p []
        [ text "Value from Slider.onChange: "
        , Html.span []
          [ text (toString (Maybe.withDefault 0 (Dict.get idx model.values)))
          ]
        ]
      ]

    , let
          idx =
              [3]
      in
      example []
      [
        Html.h2 [] [ text "Discrete Slider with Tick Marks" ]
      , Html.div []
        [ Html.p []
          [ text "Select Value:"
          ]
        ]

      , sliderWrapper []
        [ Slider.render (Mdc >> lift) idx model.mdc
          [ Slider.value (Maybe.withDefault 0 (Dict.get idx model.values))
          , Slider.onInput (Json.map (Input idx >> lift) Slider.targetValue)
          , Slider.onChange (Json.map (Change idx >> lift) Slider.targetValue)
          , Slider.discrete
          , Slider.min model.min
          , Slider.max model.max
          , Slider.steps model.steps
          , Slider.trackMarkers
          , Slider.disabled |> when model.disabled
          ]
          []
        ]

      , Html.p []
        [ text "Value from Slider.onInput: "
        , Html.span []
          [ text (toString (Maybe.withDefault 0 (Dict.get idx model.inputs)))
          ]
        ]

      , Html.p []
        [ text "Value from Slider.onChange: "
        , Html.span []
          [ text (toString (Maybe.withDefault 0 (Dict.get idx model.values)))
          ]
        ]
      ]

    , example []
      [
        Html.div []
        [ Html.label []
          [ text "Min: "
          , Html.input
            [ Html.type_ "number"
            , Html.min "0"
            , Html.max "100"
            , Html.defaultValue "0"
            , Html.on "input" (Json.map (String.toInt >> Result.toMaybe >> Maybe.withDefault 0 >> SetMin >> lift) (Html.targetValue))
            ]
            []
          ]
        ]

      , Html.div []
        [ Html.label []
          [ text "Max: "
          , Html.input
            [ Html.type_ "number"
            , Html.min "0"
            , Html.max "100"
            , Html.defaultValue "100"
            , Html.on "input" (Json.map (String.toInt >> Result.toMaybe >> Maybe.withDefault 100 >> SetMax >> lift) (Html.targetValue))
            ]
            []
          ]
        ]

      , Html.div []
        [ Html.label []
          [ text "Step: "
          , Html.input
            [ Html.type_ "number"
            , Html.min "0"
            , Html.max "100"
            , Html.defaultValue "1"
            , Html.on "input" (Json.map (String.toInt >> Result.toMaybe >> Maybe.withDefault 1 >> SetSteps >> lift) (Html.targetValue))
            ]
            []
          ]
        ]

      , Html.div []
        [ Html.label []
          [ text "Dark Theme: "
          , Html.input
            [ Html.type_ "checkbox"
            , Html.checked model.darkTheme
            , Html.on "change" (Json.succeed (lift ToggleDarkTheme))
            ]
            []
          ]
        ]

      , Html.div []
        [ Html.label []
          [ text "Disabled: "
          , Html.input
            [ Html.type_ "checkbox"
            , Html.checked model.disabled
            , Html.on "change" (Json.succeed (lift ToggleDisabled))
            ]
            []
          ]
        ]

      , Html.div []
        [ Html.label []
          [ text "Use Custom BG Color: "
          , Html.input
            [ Html.type_ "checkbox"
            , Html.checked model.customBg
            , Html.on "change" (Json.succeed (lift ToggleCustomBg))
            ]
            []
          ]
        ]

      , Html.div []
        [ Html.label []
          [ text "RTL: "
          , Html.input
            [ Html.type_ "checkbox"
            , Html.checked model.rtl
            , Html.on "change" (Json.succeed (lift ToggleRtl))
            ]
            []
          ]
        ]
      ]
    ]


subscriptions : (Msg m -> m) -> Model -> Sub m
subscriptions lift model =
    Material.subscriptions (Mdc >> lift) model
