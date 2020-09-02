module Internal.Slider.Implementation exposing
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

import Browser.Dom as Dom
import Html as Html exposing (Html, text)
import Html.Attributes as Html
import Internal.Helpers exposing (delayedCmd)
import Internal.Component as Component exposing (Index, Indexed)
import Internal.GlobalEvents as GlobalEvents
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Internal.Slider.Model exposing (Model, Msg(..), defaultModel)
import Json.Decode as Decode exposing (Decoder)
import Svg
import Svg.Attributes as Svg
import Task


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

        RequestSliderDimensions id_ next clientX ->
            -- Get current slider dimensions before determining what value the user clicked
            ( Nothing
            , getElement lift id_ (GotSliderDimensions next clientX)
            )

        GotSliderDimensions next clientX el ->
            let
                new_model =
                    { model
                        | left = el.element.x
                        , width = el.element.width
                    }
            in
                update lift (next clientX) new_model

        InteractionStart clientX ->
            let
                activeValue =
                    valueFromClientX model model clientX
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

        ThumbContainerPointer clientX ->
            let
                activeValue =
                    valueFromClientX model model clientX
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

        Drag clientX ->
            if model.active then
                let
                    activeValue =
                        valueFromClientX model model clientX
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

        Init id_ min_ max_ step_ ->
            ( Just
                { model
                    | initialized = True
                    , min = min_
                    , max = max_
                    , step = step_
                }
            , getElement lift id_ GotElement
            )

        Resize id_ min_ max_ step_ ->
            update lift (Init id_ min_ max_ step_) model

        GotElement el ->
            ( Just { model
                       | left = el.element.x
                       , width = el.element.width
                   }
            , Cmd.none )

        KeyDown ->
            ( Just { model | focus = True }, Cmd.none )

        Up ->
            -- Note: On mobile `Up` (tends to) fire before `InteractionStart`.
            ( Nothing, delayedCmd 50 (lift ActualUp) )

        ActualUp ->
            ( Just { model | active = False, activeValue = Nothing }, Cmd.none )



{-| Attempt to retrieve the dimension of the given element.
-}
getElement : (Msg m -> m) -> String -> (Dom.Element -> Msg m) -> Cmd m
getElement lift id_ msg =
    Task.attempt
        (\result ->
             case result of
                 Ok r -> lift (msg r)
                 Err _ -> lift NoOp)
        (Dom.getElement id_)


{-| Computes the new value from the clientX position.

In order for this function to work the most current element left and width must be passed in.
-}
valueFromClientX : { a | min : Float, max : Float } -> { b | left : Float, width : Float } -> Float -> Float
valueFromClientX config rect clientX =
    let
        isRtl =
            False

        xPos =
            clientX - rect.left

        pctComplete =
            if isRtl then
                1 - (xPos / rect.width)

            else
                xPos / rect.width
    in
    config.min + pctComplete * (config.max - config.min)


valueForKey : Maybe String -> Int -> { a | step : Float, min : Float, max : Float, discrete : Bool } -> Float -> Maybe Float
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
                    geometry.step

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
    { id_ : Index
    , value : Float
    , min : Float
    , max : Float
    , discrete : Bool
    , step : Float
    , onInput : Maybe (Float -> m)
    , onChange : Maybe (Float -> m)
    , trackMarkers : Bool
    , disabled : Bool
    }


defaultConfig : Config m
defaultConfig =
    { id_ = ""
    , value = 0
    , min = 0
    , max = 100
    , step = 1
    , discrete = False
    , onInput = Nothing
    , onChange = Nothing
    , trackMarkers = False
    , disabled = False
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
    Options.option (\config -> { config | disabled = True })


slider : Index -> (Msg m -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
slider domId lift model options _ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        continuousValue =
            if model.active then
                model.activeValue
                    |> Maybe.withDefault config.value

            else
                config.value

        discreteValue =
            discretize config continuousValue

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
            c * model.width

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

        -- keep calculation in css for better rounding/subpixel behavior
        markerStyle min_ max_ step_ =
            let
                markerAmount = "((" ++ String.fromFloat max_ ++ " - " ++ String.fromFloat min_ ++ ") / " ++ String.fromFloat step_ ++ ")"
                markerWidth = "2px"
                markerBkgdImage = "linear-gradient(to right, currentColor " ++ markerWidth ++ ", transparent 0)"
                markerBkgdLayout = "0 center / calc((100% - " ++ markerWidth ++ ") / " ++ markerAmount ++ ") 100% repeat-x"
            in
                markerBkgdImage ++ " " ++ markerBkgdLayout


        configChanged =
            config.min /= model.min ||
            config.max /= model.max ||
            config.step /= model.step

    in
    Options.apply summary
        Html.div
        [ Options.id config.id_
        , block
        , modifier "focus" |> when model.focus
        , modifier "active" |> when model.active
        , modifier "off" |> when (discreteValue <= config.min)
        , modifier "discrete" |> when config.discrete
        , modifier "disabled" |> when config.disabled
        , modifier "in-transit" |> when model.inTransit
        , modifier "display-markers" |> when config.trackMarkers
        , Options.attribute (Html.tabindex 0)
        , Options.aria "disabled" "true" |> when config.disabled
        , Options.data "min" (String.fromFloat config.min)
        , Options.data "max" (String.fromFloat config.max)
        , Options.data "step" (String.fromFloat config.step)
        , Options.role "slider"
        , Options.aria "valuemin" (String.fromFloat config.min)
        , Options.aria "valuemax" (String.fromFloat config.max)
        , Options.aria "valuenow" (String.fromFloat discreteValue)
        , when (not model.initialized || configChanged) <|
            GlobalEvents.onTick <|
                Decode.succeed (lift <| Init config.id_ config.min config.max config.step)
        , GlobalEvents.onResize <|
            Decode.succeed (lift <| Resize config.id_ config.min config.max config.step)
        , Options.on "keydown" <|
            Decode.map lift <|
                Decode.map2
                    (\key keyCode ->
                        let
                            activeValue =
                                valueForKey key keyCode config config.value
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
                                        valueForKey key keyCode config config.value
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
        , when (config.onChange /= Nothing) <|
            Options.on "keydown" <|
                Decode.map2
                    (\key keyCode ->
                        let
                            activeValue =
                                valueForKey key keyCode config config.value
                                    |> Maybe.map (discretize config)
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
                                valueForKey key keyCode config config.value
                                    |> Maybe.map (discretize config)
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
        , Options.when (not config.disabled) <|
            Options.many <|
                List.map
                    (\event ->
                        Options.on event (Decode.map (lift << RequestSliderDimensions config.id_ InteractionStart) decodeClientX)
                    )
                    downs
        , when (config.onChange /= Nothing) <|
            Options.many <|
                List.map
                    (\event ->
                        Options.on event <|
                            Decode.map
                                (\clientX ->
                                    let
                                        activeValue =
                                            valueFromClientX config model clientX
                                                |> discretize config
                                    in
                                    Maybe.map
                                        (\changeHandler -> changeHandler activeValue)
                                        config.onChange
                                        |> Maybe.withDefault (lift NoOp)
                                )
                                decodeClientX
                    )
                    downs
        , when (config.onInput /= Nothing) <|
            Options.many <|
                List.map
                    (\event ->
                        Options.on event <|
                            Decode.map
                                (\clientX ->
                                    let
                                        activeValue =
                                            valueFromClientX config model clientX
                                                |> discretize config
                                    in
                                    Maybe.map
                                        (\inputHandler -> inputHandler activeValue)
                                        config.onInput
                                        |> Maybe.withDefault (lift NoOp)
                                )
                                decodeClientX
                    )
                    downs
        , Options.many <|
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
                                (\clientX ->
                                    let
                                        activeValue =
                                            valueFromClientX config model clientX
                                                |> discretize config
                                    in
                                    Maybe.map (\changeHandler -> changeHandler activeValue) config.onChange
                                        |> Maybe.withDefault (lift NoOp)
                                )
                                decodeClientX
                    )
                    ups
        , when ((config.onInput /= Nothing) && model.active) <|
            Options.many <|
                List.map
                    (\handler ->
                        handler <|
                            Decode.map
                                (\clientX ->
                                    let
                                        activeValue =
                                            valueFromClientX config model clientX
                                                |> discretize config
                                    in
                                    Maybe.map
                                        (\inputHandler -> inputHandler activeValue)
                                        config.onInput
                                        |> Maybe.withDefault (lift NoOp)
                                )
                                decodeClientX
                    )
                    ups
        , when model.active <|
            Options.many <|
                List.map
                    (\handler ->
                        handler (Decode.map (lift << RequestSliderDimensions config.id_ Drag) decodeClientX)
                    )
                    moves
        , when ((config.onInput /= Nothing) && model.active) <|
            Options.many <|
                List.map
                    (\handler ->
                        handler <|
                            Decode.map
                                (\clientX ->
                                    let
                                        activeValue =
                                            valueFromClientX config model clientX
                                                |> discretize config
                                    in
                                    Maybe.map
                                        (\inputHandler -> inputHandler activeValue)
                                        config.onInput
                                        |> Maybe.withDefault (lift NoOp)
                                )
                                decodeClientX
                    )
                    moves
        ]
        []
        [ styled Html.div
            [ element "track-container"
            ]
            [ styled Html.div
                  [ element "track"
                  , css "transform" ("scaleX(" ++ String.fromFloat trackScale ++ ")")
                  ]
                  []
            , if config.discrete then
                  styled Html.div
                      [ element "track-marker-container"
                      , css "background" <| markerStyle config.min config.max config.step
                      ]
                      []
              else
                  text ""
            ]
        , styled Html.div
            [ element "thumb-container"
            , Options.when (not config.disabled) <|
                Options.many
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
                                        (Decode.map (RequestSliderDimensions config.id_ ThumbContainerPointer) decodeClientX)
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
                        [ element "focus-ring"
                        ]
                        []
                  ]
                , if config.discrete then
                    [ styled Html.div
                        [ element "pin"
                        ]
                        [ styled Html.div
                            [ element "pin-value-marker"
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


type alias Store s =
    { s | slider : Indexed Model }


getSet :
    { get : Index -> { a | slider : Indexed Model } -> Model
    , set :
        Index
        -> { a | slider : Indexed Model }
        -> Model
        -> { a | slider : Indexed Model }
    }
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
    \lift domId store options ->
        Component.render getSet.get
            (slider domId)
            Internal.Msg.SliderMsg
            lift
            domId
            store
            (Options.internalId domId :: options)


discretize : { a | min : Float, max : Float, step : Float, discrete : Bool } -> Float -> Float
discretize geometry continuousValue =
    let
        continuous =
            not geometry.discrete

        steps =
            geometry.step
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


{- Get the appropriate clientX value.

NOTE: changedTouches is a property introduced by elm-mdc.js and only
valid for the globaltouchend event.
-}
decodeClientX : Decoder Float
decodeClientX =
    Decode.oneOf
        [ Decode.at [ "targetTouches", "0", "clientX" ] Decode.float
        , Decode.at [ "changedTouches", "0", "pageX" ] Decode.float
        , Decode.at [ "clientX" ] Decode.float
        ]


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


{- Make it easier to work with BEM conventions
-}
block : Property m
block =
    cs blockName

element : String -> Property m
element module_ =
    cs ( blockName ++ "__" ++ module_ )

modifier : String -> Property m
modifier modifier_ =
    cs ( blockName ++ "--" ++ modifier_ )

blockName : String
blockName =
    "mdc-slider"
