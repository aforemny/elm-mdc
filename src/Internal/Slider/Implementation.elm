module Internal.Slider.Implementation
    exposing
        ( Property
        , disabled
        , discrete
        , max
        , min
        , onChange
        , onInput
        , react
        , step
        , trackMarkers
        , value
        , view
        )

import DOM
import Html as Html exposing (Html, text)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.GlobalEvents as GlobalEvents
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Internal.Slider.Model exposing (Geometry, Model, Msg(..), defaultGeometry, defaultModel)
import Json.Decode as Decode exposing (Decoder)
import Svg
import Svg.Attributes as Svg
import Task exposing (Task)


update : (Msg m -> m) -> Msg m -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    case msg of
        NoOp ->
            ( Nothing, Cmd.none )

        Focus ->
            if not model.preventFocus then
                ( Just { model | focus = True }, Cmd.none )
            else
                ( Nothing, Cmd.none )

        Blur ->
            ( Just
                { model
                    | focus = False
                    , preventFocus = False
                }
            , Cmd.none
            )

        TransitionEnd ->
            ( Just { model | inTransit = False }, Cmd.none )

        InteractionStart _ { pageX } ->
            let
                geometry =
                    Maybe.withDefault defaultGeometry model.geometry

                activeValue =
                    valueFromPageX geometry pageX
            in
            ( Just
                { model
                    | active = True
                    , inTransit = True
                    , activeValue = Just activeValue
                    , preventFocus = True
                }
            , Cmd.none
            )

        ThumbContainerPointer _ { pageX } ->
            let
                geometry =
                    Maybe.withDefault defaultGeometry model.geometry

                activeValue =
                    valueFromPageX geometry pageX
            in
            ( Just
                { model
                    | active = True
                    , inTransit = False
                    , activeValue = Just activeValue
                    , preventFocus = True
                }
            , Cmd.none
            )

        Drag { pageX } ->
            if model.active then
                let
                    geometry =
                        Maybe.withDefault defaultGeometry model.geometry

                    activeValue =
                        valueFromPageX geometry pageX
                in
                ( Just
                    { model
                        | inTransit = False
                        , activeValue = Just activeValue
                    }
                , Cmd.none
                )
            else
                ( Nothing, Cmd.none )

        Init geometry ->
            ( Just
                { model
                    | geometry = Just geometry
                }
            , Cmd.none
            )

        Resize geometry ->
            update lift (Init geometry) model

        KeyDown ->
            ( Just { model | focus = True }, Cmd.none )

        Up ->
            -- Note: In some instances `Up` fires before `InteractionStart`.
            -- (TODO)
            ( Just model, Task.perform lift (Task.succeed ActualUp) )

        ActualUp ->
            ( Just { model | active = False, activeValue = Nothing }, Cmd.none )


valueFromPageX : Geometry -> Float -> Float
valueFromPageX geometry pageX =
    let
        isRtl =
            False

        xPos =
            pageX - geometry.rect.left

        pctComplete =
            if isRtl then
                1 - (xPos / geometry.rect.width)
            else
                xPos / geometry.rect.width
    in
    geometry.min + pctComplete * (geometry.max - geometry.min)


valueForKey : Maybe String -> Int -> Geometry -> Float -> Maybe Float
valueForKey key keyCode geometry currentValue =
    let
        isRtl =
            False

        delta =
            (if isRtl && (isArrowLeft || isArrowRight) then
                (*) -1
             else
                identity
            )
            <|
                if geometry.discrete then
                    Maybe.withDefault 1 geometry.step
                else
                    (geometry.max - geometry.min) / 100

        isArrowLeft =
            key == Just "ArrowLeft" || keyCode == 37

        isArrowRight =
            key == Just "ArrowRight" || keyCode == 39

        isArrowUp =
            key == Just "ArrowUp" || keyCode == 38

        isArrowDown =
            key == Just "ArrowDown" || keyCode == 40

        isHome =
            key == Just "Home" || keyCode == 36

        isEnd =
            key == Just "End" || keyCode == 35

        isPageUp =
            key == Just "PageUp" || keyCode == 33

        isPageDown =
            key == Just "PageDown" || keyCode == 34

        pageFactor =
            4
    in
    Maybe.map (clamp geometry.min geometry.max) <|
        if isArrowLeft || isArrowDown then
            Just (currentValue - delta)
        else if isArrowRight || isArrowUp then
            Just (currentValue + delta)
        else if isHome then
            Just geometry.min
        else if isEnd then
            Just geometry.max
        else if isPageUp then
            Just (currentValue + delta * pageFactor)
        else if isPageDown then
            Just (currentValue - delta * pageFactor)
        else
            Nothing


type alias Config m =
    { value : Float
    , min : Float
    , max : Float
    , discrete : Bool
    , step : Float
    , onInput : Maybe (Float -> m)
    , onChange : Maybe (Float -> m)
    , trackMarkers : Bool
    }


defaultConfig : Config m
defaultConfig =
    { value = 0
    , min = 0
    , max = 100
    , step = 1
    , discrete = False
    , onInput = Nothing
    , onChange = Nothing
    , trackMarkers = False
    }


type alias Property m =
    Options.Property (Config m) m


value : Float -> Property m
value value_ =
    Options.option (\config -> { config | value = value_ })


min : Int -> Property m
min value_ =
    Options.option (\config -> { config | min = toFloat value_ })


max : Int -> Property m
max value_ =
    Options.option (\config -> { config | max = toFloat value_ })


discrete : Property m
discrete =
    Options.option (\config -> { config | discrete = True })


disabled : Property m
disabled =
    Options.many
        [ cs "mdc-slider--disabled"
        , Options.attribute <| Html.disabled True
        ]


slider : (Msg m -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
slider lift model options _ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        continuousValue =
            if model.active then
                model.activeValue
                    |> Maybe.withDefault config.value
            else
                config.value

        geometry =
            Maybe.withDefault defaultGeometry model.geometry

        discreteValue =
            discretize geometry continuousValue

        translateX =
            let
                v =
                    discreteValue
                        |> clamp config.min config.max

                c =
                    if (config.max - config.min) /= 0 then
                        (v - config.min)
                            / (config.max - config.min)
                            |> clamp 0 1
                    else
                        0
            in
            c * geometry.rect.width

        downs =
            [ "mousedown"
            , "pointerdown"
            , "touchstart"
            ]

        ups =
            [ GlobalEvents.onMouseUp
            , GlobalEvents.onPointerUp
            , GlobalEvents.onTouchEnd
            ]

        moves =
            [ GlobalEvents.onMouseMove
            , GlobalEvents.onTouchMove
            , GlobalEvents.onPointerMove
            ]

        trackScale =
            if config.max - config.min == 0 then
                0
            else
                (discreteValue - config.min) / (config.max - config.min)

        stepChanged =
            Just config.step /= Maybe.andThen .step model.geometry
    in
    styled Html.div
        [ cs "elm-mdc-slider-wrapper"
        , Options.onWithOptions "keydown"
            (Decode.map
                (\message ->
                    { message = message
                    , preventDefault = True
                    , stopPropagation = False
                    }
                )
                (Decode.map lift <|
                    Decode.andThen identity <|
                        Decode.map2
                            (\key keyCode ->
                                let
                                    activeValue =
                                        valueForKey key keyCode geometry config.value
                                in
                                if activeValue /= Nothing then
                                    Decode.succeed NoOp
                                else
                                    Decode.fail ""
                            )
                            (Decode.oneOf
                                [ Decode.map Just (Decode.at [ "key" ] Decode.string)
                                , Decode.succeed Nothing
                                ]
                            )
                            (Decode.at [ "keyCode" ] Decode.int)
                )
            )
        ]
        [ Options.apply summary
            Html.div
            [ cs "mdc-slider"
            , cs "mdc-slider--focus" |> when model.focus
            , cs "mdc-slider--active" |> when model.active
            , cs "mdc-slider--off" |> when (discreteValue <= config.min)
            , cs "mdc-slider--discrete" |> when config.discrete
            , cs "mdc-slider--in-transit" |> when model.inTransit
            , cs "mdc-slider--display-markers" |> when config.trackMarkers
            , Options.attribute (Html.tabindex 0)
            , Options.data "min" (String.fromFloat config.min)
            , Options.data "max" (String.fromFloat config.max)
            , Options.data "step" (String.fromFloat config.step)
            , Options.role "slider"
            , Options.aria "valuemin" (String.fromFloat config.min)
            , Options.aria "valuemax" (String.fromFloat config.min)
            , Options.aria "valuenow" (String.fromFloat discreteValue)
            , when ((model.geometry == Nothing) || stepChanged) <|
                GlobalEvents.onTick <|
                    Decode.map (lift << Init) decodeGeometry
            , GlobalEvents.onResize <| Decode.map (lift << Resize) decodeGeometry
            , Options.on "keydown" <|
                Decode.map lift <|
                    Decode.map2
                        (\key keyCode ->
                            let
                                activeValue =
                                    valueForKey key keyCode geometry config.value
                            in
                            if activeValue /= Nothing then
                                KeyDown
                            else
                                NoOp
                        )
                        (Decode.oneOf
                            [ Decode.map Just (Decode.at [ "key" ] Decode.string)
                            , Decode.succeed Nothing
                            ]
                        )
                        (Decode.at [ "keyCode" ] Decode.int)
            , when (config.onChange /= Nothing) <|
                Options.on "keydown" <|
                    Decode.map2
                        (\key keyCode ->
                            let
                                activeValue =
                                    valueForKey key keyCode geometry config.value
                                        |> Maybe.map (discretize geometry)
                            in
                            Maybe.map2 (<|) config.onChange activeValue
                                |> Maybe.withDefault (lift NoOp)
                        )
                        (Decode.oneOf
                            [ Decode.map Just (Decode.at [ "key" ] Decode.string)
                            , Decode.succeed Nothing
                            ]
                        )
                        (Decode.at [ "keyCode" ] Decode.int)
            , when (config.onInput /= Nothing) <|
                Options.on "keydown" <|
                    Decode.map2
                        (\key keyCode ->
                            let
                                activeValue =
                                    valueForKey key keyCode geometry config.value
                                        |> Maybe.map (discretize geometry)
                            in
                            Maybe.map2 (<|) config.onInput activeValue
                                |> Maybe.withDefault (lift NoOp)
                        )
                        (Decode.oneOf
                            [ Decode.map Just (Decode.at [ "key" ] Decode.string)
                            , Decode.succeed Nothing
                            ]
                        )
                        (Decode.at [ "keyCode" ] Decode.int)
            , Options.on "focus" (Decode.succeed (lift Focus))
            , Options.on "blur" (Decode.succeed (lift Blur))
            , Options.many <|
                List.map
                    (\event ->
                        Options.on event (Decode.map (lift << InteractionStart event) decodePageX)
                    )
                    downs
            , when (config.onChange /= Nothing) <|
                Options.many <|
                    List.map
                        (\event ->
                            Options.on event <|
                                Decode.map
                                    (\{ pageX } ->
                                        let
                                            activeValue =
                                                valueFromPageX geometry pageX
                                                    |> discretize geometry
                                        in
                                        Maybe.map
                                            (\changeHandler -> changeHandler activeValue)
                                            config.onChange
                                            |> Maybe.withDefault (lift NoOp)
                                    )
                                    decodePageX
                        )
                        downs
            , when (config.onInput /= Nothing) <|
                Options.many <|
                    List.map
                        (\event ->
                            Options.on event <|
                                Decode.map
                                    (\{ pageX } ->
                                        let
                                            activeValue =
                                                valueFromPageX geometry pageX
                                                    |> discretize geometry
                                        in
                                        Maybe.map
                                            (\inputHandler -> inputHandler activeValue)
                                            config.onInput
                                            |> Maybe.withDefault (lift NoOp)
                                    )
                                    decodePageX
                        )
                        downs
            , -- Note: In some instances `Up` fires before `InteractionStart`.
              -- (TODO)
              Options.many <|
                List.map
                    (\handler ->
                        handler (Decode.succeed (lift Up))
                    )
                    ups
            , when ((config.onChange /= Nothing) && model.active) <|
                Options.many <|
                    List.map
                        (\handler ->
                            handler <|
                                Decode.map
                                    (\{ pageX } ->
                                        let
                                            activeValue =
                                                valueFromPageX geometry pageX
                                                    |> discretize geometry
                                        in
                                        Maybe.map (\changeHandler -> changeHandler activeValue) config.onChange
                                            |> Maybe.withDefault (lift NoOp)
                                    )
                                    decodePageX
                        )
                        ups
            , when ((config.onInput /= Nothing) && model.active) <|
                Options.many <|
                    List.map
                        (\handler ->
                            handler <|
                                Decode.map
                                    (\{ pageX } ->
                                        let
                                            activeValue =
                                                valueFromPageX geometry pageX
                                                    |> discretize geometry
                                        in
                                        Maybe.map
                                            (\inputHandler -> inputHandler activeValue)
                                            config.onInput
                                            |> Maybe.withDefault (lift NoOp)
                                    )
                                    decodePageX
                        )
                        ups
            , when model.active <|
                Options.many <|
                    List.map
                        (\handler ->
                            handler (Decode.map (lift << Drag) decodePageX)
                        )
                        moves
            , when ((config.onInput /= Nothing) && model.active) <|
                Options.many <|
                    List.map
                        (\handler ->
                            handler <|
                                Decode.map
                                    (\{ pageX } ->
                                        let
                                            activeValue =
                                                valueFromPageX geometry pageX
                                                    |> discretize geometry
                                        in
                                        Maybe.map
                                            (\inputHandler -> inputHandler activeValue)
                                            config.onInput
                                            |> Maybe.withDefault (lift NoOp)
                                    )
                                    decodePageX
                        )
                        moves
            ]
            []
            [ styled Html.div
                [ cs "mdc-slider__track-container"
                ]
                (List.concat
                    [ [ styled Html.div
                            [ cs "mdc-slider__track"
                            , css "transform" ("scaleX(" ++ String.fromFloat trackScale ++ ")")
                            ]
                            []
                      ]
                    , if config.discrete then
                        [ styled Html.div
                            [ cs "mdc-slider__track-marker-container"
                            ]
                            (List.repeat (round ((config.max - config.min) / config.step)) <|
                                styled Html.div
                                    [ cs "mdc-slider__track-marker"
                                    ]
                                    []
                            )
                        ]
                      else
                        []
                    ]
                )
            , styled Html.div
                [ cs "mdc-slider__thumb-container"
                , Options.many
                    (downs
                        |> List.map
                            (\event ->
                                Options.onWithOptions event
                                    (Decode.map
                                        (\message ->
                                            { message = lift message
                                            , stopPropagation = True
                                            , preventDefault = False
                                            }
                                        )
                                        (Decode.map (ThumbContainerPointer event) decodePageX)
                                    )
                            )
                    )
                , Options.on "transitionend" (Decode.succeed (lift TransitionEnd))
                , css "transform" <|
                    "translateX("
                        ++ String.fromFloat translateX
                        ++ "px) translateX(-50%)"
                ]
                (List.concat
                    [ [ Svg.svg
                            [ Svg.class "mdc-slider__thumb"
                            , Svg.width "21"
                            , Svg.height "21"
                            ]
                            [ Svg.circle
                                [ Svg.cx "10.5"
                                , Svg.cy "10.5"
                                , Svg.r "7.875"
                                ]
                                []
                            ]
                      , styled Html.div
                            [ cs "mdc-slider__focus-ring"
                            ]
                            []
                      ]
                    , if config.discrete then
                        [ styled Html.div
                            [ cs "mdc-slider__pin"
                            ]
                            [ styled Html.div
                                [ cs "mdc-slider__pin-value-marker"
                                ]
                                [ text (String.fromFloat discreteValue)
                                ]
                            ]
                        ]
                      else
                        []
                    ]
                )
            ]
        ]


type alias Store s =
    { s | slider : Indexed Model }


getSet =
    Component.indexed .slider (\x y -> { y | slider = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.SliderMsg update


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render getSet.get slider Internal.Msg.SliderMsg


discretize : Geometry -> Float -> Float
discretize geometry continuousValue =
    let
        continuous =
            not geometry.discrete

        steps =
            geometry.step
                |> Maybe.withDefault 1
                |> (\steps_ ->
                        if steps_ == 0 then
                            1
                        else
                            steps_
                   )
    in
    clamp geometry.min geometry.max <|
        if continuous then
            continuousValue
        else
            let
                numSteps =
                    round (continuousValue / steps)

                quantizedVal =
                    toFloat numSteps * steps
            in
            quantizedVal


decodePageX : Decoder { pageX : Float }
decodePageX =
    Decode.map (\pageX -> { pageX = pageX }) <|
        Decode.oneOf
            [ Decode.at [ "targetTouches", "0", "pageX" ] Decode.float
            , Decode.at [ "changedTouches", "0", "pageX" ] Decode.float
            , Decode.at [ "pageX" ] Decode.float
            ]


decodeGeometry : Decoder Geometry
decodeGeometry =
    let
        traverseToContainer decoder =
            hasClass "mdc-slider"
                |> Decode.andThen
                    (\doesHaveClass ->
                        if doesHaveClass then
                            decoder
                        else
                            DOM.parentElement (Decode.lazy (\_ -> traverseToContainer decoder))
                    )
    in
    DOM.target <|
        traverseToContainer <|
            Decode.map6
                (\offsetWidth offsetLeft decodedDiscrete decodedMin decodedMax decodedStep ->
                    { rect = { width = offsetWidth, left = offsetLeft }
                    , discrete = decodedDiscrete
                    , min = decodedMin
                    , max = decodedMax
                    , step = decodedStep
                    }
                )
                DOM.offsetWidth
                DOM.offsetLeft
                (hasClass "mdc-slider--discrete")
                (data "min" (Decode.map (String.toFloat >> Maybe.withDefault 1) Decode.string))
                (data "max" (Decode.map (String.toFloat >> Maybe.withDefault 1) Decode.string))
                (Decode.oneOf
                    [ data "step" (Decode.map String.toFloat Decode.string)
                    , Decode.succeed Nothing
                    ]
                )


data : String -> Decoder a -> Decoder a
data key decoder =
    Decode.at [ "dataset", key ] decoder


hasClass : String -> Decoder Bool
hasClass class =
    Decode.map
        (\className ->
            String.contains (" " ++ class ++ " ") (" " ++ className ++ " ")
        )
        (Decode.at [ "className" ] Decode.string)


onChange : (Float -> m) -> Property m
onChange handler =
    Options.option (\config -> { config | onChange = Just handler })


onInput : (Float -> m) -> Property m
onInput handler =
    Options.option (\config -> { config | onInput = Just handler })


step : Float -> Property m
step value_ =
    Options.option (\config -> { config | step = value_ })


trackMarkers : Property m
trackMarkers =
    Options.option (\config -> { config | trackMarkers = True })
