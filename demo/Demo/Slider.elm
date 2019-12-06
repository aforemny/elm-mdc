module Demo.Slider exposing (Model, Msg(..), defaultModel, subscriptions, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Html.Attributes as Html
import Html.Events as Html
import Material
import Material.Options exposing (styled)
import Material.Slider as Slider
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)


type alias Model m =
    { mdc : Material.Model m
    , sliders : Dict Material.Index Float
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , sliders =
        Dict.fromList
            [ ( "slider-hero-slider", 50 )
            , ( "slider-continuous-slider", 50 )
            , ( "slider-discrete-slider", 50 )
            , ( "slider-discrete-slider-with-tick-marks", 50 )
            ]
    }


type Msg m
    = Mdc (Material.Msg m)
    | Change Material.Index Float


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        Change index value ->
            ( { model | sliders = Dict.insert index value model.sliders }, Cmd.none )


subscriptions : (Msg m -> m) -> Model m -> Sub m
subscriptions lift model =
    Material.subscriptions (lift << Mdc) model


heroSlider : (Msg m -> m) -> Model m -> Html m
heroSlider lift model =
    let
        index =
            "slider-hero-slider"
    in
    Slider.view (lift << Mdc)
        index
        model.mdc
        [ Slider.value (Maybe.withDefault 0 (Dict.get index model.sliders))
        , Slider.onChange (lift << Change index)
        ]
        []


continuousSlider : (Msg m -> m) -> Model m -> Html m
continuousSlider lift model =
    let
        index =
            "slider-continuous-slider"
    in
    Slider.view (lift << Mdc)
        index
        model.mdc
        [ Slider.value (Maybe.withDefault 0 (Dict.get index model.sliders))
        , Slider.onChange (lift << Change index)
        , Slider.min 0
        , Slider.max 100
        ]
        []


discreteSlider : (Msg m -> m) -> Model m -> Html m
discreteSlider lift model =
    let
        index =
            "slider-discrete-slider"
    in
    Slider.view (lift << Mdc)
        index
        model.mdc
        [ Slider.value (Maybe.withDefault 0 (Dict.get index model.sliders))
        , Slider.onChange (lift << Change index)
        , Slider.discrete
        , Slider.min 0
        , Slider.max 100
        , Slider.step 1
        ]
        []


discreteSliderWithTickMarks : (Msg m -> m) -> Model m -> Html m
discreteSliderWithTickMarks lift model =
    let
        index =
            "slider-discrete-slider-with-tick-marks"
    in
    Slider.view (lift << Mdc)
        index
        model.mdc
        [ Slider.value (Maybe.withDefault 0 (Dict.get index model.sliders))
        , Slider.onChange (lift << Change index)
        , Slider.discrete
        , Slider.min 0
        , Slider.max 100
        , Slider.step 1
        , Slider.trackMarkers
        ]
        []


disabledSlider : (Msg m -> m) -> Model m -> Html m
disabledSlider lift model =
    let
        index =
            "slider-disabled-slider"
    in
    Slider.view (lift << Mdc)
        index
        model.mdc
        [ Slider.value (Maybe.withDefault 0 (Dict.get index model.sliders))
        , Slider.onChange (lift << Change index)
        , Slider.min 0
        , Slider.max 100
        , Slider.value 50
        , Slider.disabled
        ]
        []


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Slider"
              , Hero.intro "Sliders let users select from a range of values by moving the slider thumb."
              , Hero.component [] [ heroSlider lift model ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "sliders" "input-controls/sliders" "mdc-slider"
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Continuous" ]
            , continuousSlider lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Discrete" ]
            , discreteSlider lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Discrete with Tick Marks" ]
            , discreteSliderWithTickMarks lift model
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Disabled" ]
            , disabledSlider lift model
            ]
        ]
