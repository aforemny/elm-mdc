module Internal.Slider.Implementation exposing
    ( Property
    , disabled
    , discrete
    , max
    , min
    , onChange
    , react
    , step
    , trackMarkers
    , value
    , view
    )

import Browser.Dom as Dom
import Html as Html exposing (Html, text, div)
import Html.Attributes as Html
import Internal.Helpers exposing (delayedCmd)
import Internal.Component as Component exposing (Index, Indexed)
import Internal.GlobalEvents as GlobalEvents
import Internal.Msg
import Internal.Options as Options exposing (aria, cs, css, styled, when)
import Internal.Ripple.Implementation as Ripple
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

        RippleMsg msg_ ->
            let
                ( rippleState, rippleCmd ) =
                    Ripple.update msg_ model.ripple
            in
            ( Just { model | ripple = rippleState }
            , Cmd.map (lift << RippleMsg) rippleCmd
            )

        Focus ->
            ( Just { model | showThumbIndicator = True }, Cmd.none )

        Blur ->
            ( Just { model | showThumbIndicator = False }, Cmd.none )

        DragStart inputId change_handler clientX ->
            ( Just { model | dragStarted = True }
            , Cmd.batch
                [ cmd (change_handler clientX )
                , Task.attempt (\_ -> lift NoOp) (Dom.focus inputId)
                ]
            )

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

        Up ->
            -- Note: On mobile `Up` (tends to) fire before `Dragtart`.
            -- Note 2: not sure this still happens after the rewrite
            ( Nothing, delayedCmd 50 (lift ActualUp) )

        ActualUp ->
            ( Just { model | dragStarted = False }, Cmd.none )


cmd : msg -> Cmd msg
cmd m =
    Task.perform (always m) (Task.succeed ())


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



type alias Config m =
    { id_ : Index
    , value : Float
    , min : Float
    , max : Float
    , discrete : Bool
    , step : Float
    , onChange : Maybe (Float -> m)
    , trackMarkers : Bool
    , disabled : Bool
    , isRange : Bool
    }


defaultConfig : Config m
defaultConfig =
    { id_ = ""
    , value = 0
    , min = 0
    , max = 100
    , step = 1
    , discrete = False
    , onChange = Nothing
    , trackMarkers = False
    , disabled = False
    , isRange = False -- TODO implement range sliders
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



onChange : (Float -> m) -> Property m
onChange handler =
    Options.option (\config -> { config | onChange = Just handler })


step : Float -> Property m
step value_ =
    Options.option (\config -> { config | step = value_ })


trackMarkers : Property m
trackMarkers =
    Options.option (\config -> { config | trackMarkers = True })



slider : Index -> (Msg m -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
slider domId lift model options _ =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        clampedValue =
            config.value
                |> clamp config.min config.max

        range = config.max - config.min

        pctComplete = (clampedValue - config.min) / range

        rangePx = pctComplete * model.width

        number_of_tick_marks =
            ( range / config.step |> ceiling ) + 1

        active_marks =
            ( ( range / config.step) + 1 ) * pctComplete |> ceiling

        tickMark i =
            styled div
                [ element (if i <= active_marks then "tick-mark--active" else "tick-mark--inactive" ) ]
                []

        inputId = domId ++ "--input"

        thumbId = domId ++ "--thumb"

        rippleInterface =
            Ripple.view True thumbId (lift << RippleMsg) model.ripple [ ]

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

        configChanged =
            config.min /= model.min ||
            config.max /= model.max ||
            config.step /= model.step

    in
    Options.apply summary
        div
        [ Options.id config.id_
        , block
        , modifier "discrete" |> when config.discrete
        , modifier "disabled" |> when config.disabled
        , modifier "tick-marks" |> when config.trackMarkers
        , modifier "tick-marks" |> when config.trackMarkers

        , when (not model.initialized || configChanged) <|
            GlobalEvents.onTick <|
                Decode.succeed (lift <| Init config.id_ config.min config.max config.step)
        , GlobalEvents.onResize <|
            Decode.succeed (lift <| Resize config.id_ config.min config.max config.step)

        , when (not config.disabled) <|
            case config.onChange of
                Just on_change ->
                    Options.many <|
                        List.map
                            (\event ->
                                 Options.on event <|
                                     Decode.map
                                         (\clientX ->
                                              let
                                                  activeValue = mapClientXOnSliderScale model.left model.width config.min config.max config.step clientX
                                              in
                                                  lift ( DragStart inputId on_change activeValue)
                                         )
                                         decodeClientX
                            )
                            downs
                Nothing -> Options.nop
        , when model.dragStarted <|
            Options.many <|
                List.map
                    (\handler ->
                        handler <|
                            Decode.map
                                (\clientX ->
                                    let
                                        activeValue =
                                            mapClientXOnSliderScale model.left model.width config.min config.max config.step clientX
                                    in
                                    Maybe.map
                                        (\changeHandler -> changeHandler activeValue)
                                        config.onChange
                                        |> Maybe.withDefault (lift NoOp)
                                )
                                decodeClientX
                    )
                    moves
        , Options.many <|
            List.map
                (\handler ->
                    handler (Decode.succeed (lift Up))
                )
                ups
        ]
        []
        [ styled Html.input
              [ element "input"
              , Options.id inputId
              , Options.attribute (Html.type_ "range")
              , Options.attribute (Html.min <| String.fromFloat config.min)
              , Options.attribute (Html.max <| String.fromFloat config.max)
              , Options.attribute (Html.attribute "value" <| String.fromFloat clampedValue)
              , Options.attribute (Html.step <| String.fromFloat config.step)
              , Options.attribute (Html.disabled True) |> when config.disabled
              , Options.onFocus (lift Focus)
              , Options.onBlur (lift Blur)
              , when (not config.disabled) <|
                  case config.onChange of
                      Just on_change ->
                          Options.onChange (String.toFloat >> Maybe.withDefault 0 >> on_change)
                      Nothing ->
                          Options.nop
              ]
              []
        , styled div
            [ element "track"
            ]
            [ styled div [ element "track--inactive" ]
                  []
            , styled div [ element "track--active" ]
                [ styled div
                      [ element "track--active_fill"
                      , css "transform" ("scaleX(" ++ String.fromFloat pctComplete ++ ")")
                      ]
                      []
                ]
            , if config.discrete && config.trackMarkers then
                  -- TODO: add active and inactive markers
                  styled div [ element "tick-marks" ]
                      ( List.range 1 number_of_tick_marks
                            |> List.map tickMark
                      )
              else
                  text ""
            ]
        , styled div
            [ element "thumb"
            , element "thumb--with-indicator" |> when model.showThumbIndicator
            , Options.id thumbId
            , css "transform" ("translateX(" ++ String.fromFloat rangePx ++ "px)")
            , rippleInterface.interactionHandler
            , rippleInterface.properties
            ]
            [ if config.discrete then
                  styled div
                      [ element "value-indicator-container"
                      , aria "hidden" "true"
                      ]
                      [ styled div
                            [ element "value-indicator" ]
                            [ styled div
                                  [ element "value-indicator-text" ]
                                  [ text <| String.fromFloat clampedValue ]
                            ]
                      ]
              else
                  text ""
            , styled div
                  [ element "thumb-knob" ]
                  []
            ]
        ]



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


mapClientXOnSliderScale : Float -> Float -> Float -> Float -> Float -> Float -> Float
mapClientXOnSliderScale left width min_ max_ steps clientX =
    let
        xPos = clientX - left

        pctComplete = xPos / width

        -- Fit the percentage complete between the range [min,max]
        -- by remapping from [0, 1] to [min, min+(max-min)].
        value_ = min_ + pctComplete * (max_ - min_)

    in
        if value_ == max_ || value_ == min_ then
            value_
        else
            quantize steps value_


{- Calculates the quantized value based on step value.
-}
quantize : Float -> Float -> Float
quantize steps value_ =
    let
        numSteps = value_ / steps |> round |> toFloat
    in
        numSteps * steps


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
