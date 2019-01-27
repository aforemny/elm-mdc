module Demo.Slider exposing (Model, Msg(..), defaultModel, subscriptions, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Html.Attributes as Html
import Html.Events as Html
import Json.Decode as Json exposing (Decoder)
import Material
import Material.Options as Options exposing (cs, css, styled, when)
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


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body "Slider"
        "Sliders let users select from a range of values by moving the slider thumb."
        [ Hero.view [] [ heroSlider lift model ]
        , styled Html.h2
            [ Typography.headline6
            , css "border-bottom" "1px solid rgba(0,0,0,.87)"
            ]
            [ text "Resources"
            ]
        , ResourceLink.view
            { link = "https://material.io/go/design-sliders"
            , title = "Material Design Guidelines"
            , icon = "images/material.svg"
            , altText = "Material Design Guidelines icon"
            }
        , ResourceLink.view
            { link = "https://material.io/components/web/catalog/input-controls/sliders/"
            , title = "Documentation"
            , icon = "images/ic_drive_document_24px.svg"
            , altText = "Documentation icon"
            }
        , ResourceLink.view
            { link = "https://github.com/material-components/material-components-web/tree/master/packages/mdc-slider"
            , title = "Source Code (Material Components Web)"
            , icon = "images/ic_code_24px.svg"
            , altText = "Source Code"
            }
        , styled Html.h3 [ Typography.subtitle1 ] [ text "Continuous" ]
        , continuousSlider lift model
        , styled Html.h3 [ Typography.subtitle1 ] [ text "Discrete" ]
        , discreteSlider lift model
        , styled Html.h3 [ Typography.subtitle1 ] [ text "Discrete with Tick Marks" ]
        , discreteSliderWithTickMarks lift model
        ]
