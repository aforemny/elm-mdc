module Internal.Ripple.Implementation exposing
    ( Property
    , accent
    , bounded
    , none
    , primary
    , react
    , unbounded
    , update
    , view
    )

import Browser.Dom
import DOM
import Html exposing (Html, text)
import Internal.Component as Component exposing (Index, Indexed)
import Internal.GlobalEvents as GlobalEvents
import Internal.Msg
import Internal.Options as Options exposing (cs, css, when)
import Internal.Ripple.Model
    exposing
        ( AnimationState(..)
        , ClientRect
        , Event
        , Model
        , Msg(..)
        , activationEventTypes
        , cssClasses
        , defaultModel
        , numbers
        , strings
        )
import Json.Decode as Decode exposing (Decoder)
import Process
import Task


bounded :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    ->
        { interactionHandler : Options.Property c m
        , properties : Options.Property c m
        }
bounded =
    \lift domId ->
        Component.render getSet.get (view False domId) Internal.Msg.RippleMsg lift domId


unbounded :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    ->
        { interactionHandler : Options.Property c m
        , properties : Options.Property c m
        }
unbounded =
    \lift domId ->
        Component.render getSet.get (view True domId) Internal.Msg.RippleMsg lift domId


type alias Config =
    { color : Maybe String
    }


primary : Property m
primary =
    Options.option (\config -> { config | color = Just "primary" })


accent : Property m
accent =
    Options.option (\config -> { config | color = Just "accent" })


type alias Property m =
    Options.Property Config m


view :
    Bool
    -> Index
    -> (Msg -> m)
    -> Model
    -> List (Property m)
    ->
        { interactionHandler : Options.Property c m
        , properties : Options.Property c m
        }
view isUnbounded domId lift model options =
    let
        focusHandler =
            Options.on "focus" (Decode.succeed (lift Focus))

        blurHandler =
            Options.on "blur" (Decode.succeed (lift Blur))

        baseInteractionHandler =
            Options.many
                [ focusHandler
                , blurHandler
                ]

        activateHandler =
            Options.many <|
                List.map
                    (\tipe ->
                        Options.on tipe
                            (Decode.map lift
                                (decodeActivate
                                    { domId = domId
                                    , isUnbounded =
                                        isUnbounded
                                    , isActivated =
                                        case model.animationState of
                                            Activated activationState ->
                                                not activationState.deactivated

                                            _ ->
                                                False
                                    , previousActivationEvent =
                                        case model.animationState of
                                            Activated { activationEvent } ->
                                                Just activationEvent

                                            _ ->
                                                Nothing
                                    }
                                )
                            )
                    )
                    activationEventTypes

        deactivateHandler event =
            -- Note: We would like to subscribe to pointerDeactivationEvents on
            -- the `document`, but since `Browser.Events` does not expose
            -- `touchend`, or `pointerup`, we use `GlobalEvents`.
            let
                deactivate =
                    Decode.succeed (lift Deactivate)
            in
            Options.many <|
                [ GlobalEvents.onTouchEnd deactivate
                , GlobalEvents.onMouseUp deactivate
                , GlobalEvents.onPointerUp deactivate
                ]

        baseProperties =
            Options.many
                [ Options.id domId
                , cs cssClasses.root
                , when isUnbounded (cs cssClasses.unbounded)
                , if model.focused then
                    cs cssClasses.bgFocused

                  else
                    Options.nop
                ]

    in
    case model.animationState of
        Idle ->
            let
                interactionHandler =
                    Options.many
                        [ baseInteractionHandler
                        , activateHandler
                        ]

                cssVars =
                    case model.clientRect of
                        Just clientRect ->
                            let
                                { fgScale, initialSize } =
                                    layoutInternal isUnbounded clientRect
                            in
                            cssVariables isUnbounded
                                { fgScale = fgScale
                                , translateStart = "0px"
                                , translateEnd = "0px"
                                , initialSize = initialSize
                                , frame = clientRect
                                }

                        Nothing ->
                            []

                properties =
                    Options.many
                        [ baseProperties
                        , Options.many cssVars
                        , when (model.clientRect == Nothing) <|
                            GlobalEvents.onTick <|
                                Decode.map (lift << SetCssVariables isUnbounded) <|
                                    decodeClientRect
                        ]
            in
            { interactionHandler = interactionHandler
            , properties = properties
            }

        Activated activatedData ->
            let
                interactionHandler =
                    Options.many
                        [ baseInteractionHandler
                        , activateHandler
                        , deactivateHandler activatedData.activationEvent
                        ]

                cssVars =
                    cssVariables isUnbounded
                        { fgScale = activatedData.fgScale
                        , translateStart = activatedData.translateStart
                        , translateEnd = activatedData.translateEnd
                        , initialSize = activatedData.initialSize
                        , frame = activatedData.frame
                        }

                properties =
                    Options.many
                        [ baseProperties
                        , Options.many cssVars
                        , cs cssClasses.fgActivation
                        , when isUnbounded (Options.data "mdc-ripple-is-unbounded" "1")
                        ]
            in
            { interactionHandler = interactionHandler
            , properties = properties
            }

        Deactivated activatedData ->
            let
                interactionHandler =
                    Options.many
                        [ baseInteractionHandler
                        , activateHandler
                        ]

                properties =
                    Options.many
                        [ baseProperties
                        , Options.many cssVars
                        , cs cssClasses.fgDeactivation
                        ]

                cssVars =
                    cssVariables isUnbounded
                        { fgScale = activatedData.fgScale
                        , translateStart = activatedData.translateStart
                        , translateEnd = activatedData.translateEnd
                        , initialSize = activatedData.initialSize
                        , frame = activatedData.frame
                        }
            in
            { interactionHandler = interactionHandler
            , properties = properties
            }


none :
    { interactionHandler : Options.Property c m
    , properties : Options.Property c m
    }
none =
    { interactionHandler = Options.nop
    , properties = Options.nop
    }


cssVariables :
    Bool
    ->
        { fgScale : Float
        , translateStart : String
        , translateEnd : String
        , initialSize : Int
        , frame : ClientRect
        }
    -> List (Options.Property c m)
cssVariables isUnbounded { fgScale, translateStart, translateEnd, initialSize, frame } =
    let
        fgSize =
            String.fromInt initialSize ++ "px"

        unboundedCoords =
            if isUnbounded then
                { left = toFloat (round ((frame.width - toFloat initialSize) / 2))
                , top = toFloat (round ((frame.height - toFloat initialSize) / 2))
                }

            else
                { top = 0, left = 0 }

        variables =
            List.concat
                [ [ css strings.varFgSize fgSize
                  , css strings.varFgScale (String.fromFloat fgScale)
                  ]
                , if isUnbounded then
                    [ css strings.varTop (String.fromFloat unboundedCoords.top ++ "px")
                    , css strings.varLeft (String.fromFloat unboundedCoords.left ++ "px")
                    ]

                  else
                    [ css strings.varFgTranslateStart translateStart
                    , css strings.varFgTranslateEnd translateEnd
                    ]
                ]
    in
    variables


type alias Store s =
    { s
        | ripple : Indexed Model
    }


getSet =
    Component.indexed .ripple (\x y -> { y | ripple = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.RippleMsg (Component.generalise update)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.animationState ) of
        ( Focus, _ ) ->
            ( { model | focused = True }, Cmd.none )

        ( Blur, _ ) ->
            ( { model | focused = False }, Cmd.none )

        ( SetCssVariables isUnbounded clientRect, _ ) ->
            ( { model | clientRect = Just clientRect }, Cmd.none )

        ( Activate0 domId activateData, Idle ) ->
            ( model
            , Task.attempt (Activate activateData) (Browser.Dom.getElement domId)
            )

        ( Activate0 domId activateData, _ ) ->
            ( model
            , Task.attempt (Reactivate activateData) (Browser.Dom.getElement domId)
            )

        ( Reactivate activateData element, Activated { activationEvent } ) ->
            if activateData.event.eventType == activationEvent.eventType then
                ( { model | animationState = Idle }
                , Task.perform (\_ -> Activate activateData element) (Task.succeed ())
                )

            else
                ( model, Cmd.none )

        ( Reactivate activateData element, Deactivated { activationEvent } ) ->
            if activateData.event.eventType == activationEvent.eventType then
                ( { model | animationState = Idle }
                , Task.perform (\_ -> Activate activateData element) (Task.succeed ())
                )

            else
                ( model, Cmd.none )

        ( Reactivate activateData element, Idle ) ->
            ( { model | animationState = Idle }
            , Task.perform (\_ -> Activate activateData element) (Task.succeed ())
            )

        ( Activate activateData (Err _), _ ) ->
            ( model, Cmd.none )

        ( Activate activateData (Ok { element, viewport }), _ ) ->
            let
                activatedData =
                    { frame =
                        { top = element.y
                        , left = element.x
                        , width = element.width
                        , height = element.height
                        }
                    , wasElementMadeActive = activateData.wasElementMadeActive
                    , activationEvent = activateData.event
                    , fgScale = fgScale
                    , initialSize = initialSize
                    , translateStart = translateStart
                    , translateEnd = translateEnd
                    , activationHasEnded = False
                    , deactivated = False
                    }

                { fgScale, initialSize } =
                    layoutInternal activateData.isUnbounded element

                { translateStart, translateEnd } =
                    animateActivation
                        activateData.isUnbounded
                        element
                        viewport
                        activateData.event

                newAnimationCounter =
                    model.animationCounter + 1
            in
            ( { model
                | animationState = Activated activatedData
                , animationCounter = newAnimationCounter

                -- , clientRect = Just activatedData.frame
              }
            , Task.perform (\_ -> ActivationEnded newAnimationCounter)
                (Process.sleep numbers.deactivationTimeoutMs)
            )

        ( ActivationEnded animationCount, Activated activatedData ) ->
            if animationCount == model.animationCounter then
                if activatedData.deactivated then
                    ( { model | animationState = Deactivated activatedData }
                    , Task.perform (\_ -> DeactivationEnded model.animationCounter)
                        (Process.sleep numbers.tapDelayMs)
                    )

                else
                    let
                        newActivatedData =
                            { activatedData | activationHasEnded = True }
                    in
                    ( { model | animationState = Activated newActivatedData }, Cmd.none )

            else
                ( model, Cmd.none )

        ( Deactivate, Activated activatedData ) ->
            if activatedData.activationHasEnded then
                ( { model | animationState = Deactivated activatedData }
                , Task.perform (\_ -> DeactivationEnded model.animationCounter)
                    (Process.sleep numbers.tapDelayMs)
                )

            else
                let
                    newActivatedData =
                        { activatedData | deactivated = True }
                in
                ( { model | animationState = Activated newActivatedData }, Cmd.none )

        ( DeactivationEnded animationCount, Deactivated _ ) ->
            if animationCount == model.animationCounter then
                ( { model | animationState = Idle }, Cmd.none )

            else
                ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


layoutInternal isUnbounded frame =
    let
        maxDim =
            max frame.width frame.height

        hypotenuse =
            sqrt ((frame.width ^ 2) + (frame.height ^ 2))

        boundedRadius =
            hypotenuse + numbers.padding

        maxRadius =
            if isUnbounded then
                maxDim

            else
                boundedRadius

        initialSize =
            floor (maxDim * numbers.initialOriginScale)

        fgScale =
            maxRadius / toFloat initialSize
    in
    { fgScale = fgScale
    , initialSize = initialSize
    }


animateActivation isUnbounded frame windowPageOffset activationEvent =
    let
        wasActivatedByPointer =
            True

        { startPoint, endPoint } =
            fgTranslationCoords
                isUnbounded
                { frame = frame
                , windowPageOffset = windowPageOffset
                , activationEvent = activationEvent
                , wasActivatedByPointer = wasActivatedByPointer
                }

        translateStart =
            if isUnbounded then
                ""

            else
                String.fromFloat startPoint.x
                    ++ "px, "
                    ++ String.fromFloat startPoint.y
                    ++ "px"

        translateEnd =
            if isUnbounded then
                ""

            else
                String.fromFloat endPoint.x
                    ++ "px, "
                    ++ String.fromFloat endPoint.y
                    ++ "px"
    in
    { translateStart = translateStart
    , translateEnd = translateEnd
    }


fgTranslationCoords isUnbounded { frame, activationEvent, windowPageOffset, wasActivatedByPointer } =
    let
        maxDimension =
            max frame.width frame.height

        initialSize =
            maxDimension * 0.6

        startPoint =
            let
                { x, y } =
                    normalizedEventCoords activationEvent windowPageOffset frame
            in
            { x = x - (initialSize / 2)
            , y = y - (initialSize / 2)
            }

        endPoint =
            { x = (frame.width - initialSize) / 2
            , y = (frame.height - initialSize) / 2
            }
    in
    { startPoint = startPoint, endPoint = endPoint }


decodeActivate :
    { domId : String
    , isUnbounded : Bool
    , isActivated : Bool
    , previousActivationEvent : Maybe Event
    }
    -> Decoder Msg
decodeActivate { domId, isUnbounded, isActivated, previousActivationEvent } =
    let
        decodeIsSurfaceDisabled =
            Decode.oneOf
                [ Decode.map (always True) (Decode.at [ "disabled" ] Decode.string)
                , Decode.succeed False
                ]

        decodeEventType =
            Decode.at [ "type" ] Decode.string

        decodeIsSameInteraction =
            case previousActivationEvent of
                Nothing ->
                    Decode.succeed False

                Just event ->
                    Decode.map ((==) event.eventType) decodeEventType

        decodeEvent =
            decodeEventType
                |> Decode.andThen
                    (\eventType ->
                        case eventType of
                            "touchstart" ->
                                Decode.map (Event eventType) firstChangedTouch

                            _ ->
                                Decode.map (Event eventType) decodePagePoint
                    )

        firstChangedTouch =
            Decode.at [ "changedTouches" ]
                (Decode.list decodePagePoint)
                |> Decode.andThen
                    (\changedTouches ->
                        case List.head changedTouches of
                            Just pagePoint ->
                                Decode.succeed pagePoint

                            Nothing ->
                                Decode.fail ""
                    )

        decodePagePoint =
            Decode.map2
                (\pageX pageY ->
                    { pageX = pageX, pageY = pageY }
                )
                (Decode.at [ "pageX" ] Decode.float)
                (Decode.at [ "pageY" ] Decode.float)
    in
    Decode.map3
        (\isSurfaceDisabled isSameInteraction event ->
            if isActivated || isSurfaceDisabled || isSameInteraction then
                Nothing

            else
                Just <|
                    Activate0 domId
                        { event = event
                        , isSurfaceDisabled = False
                        , wasElementMadeActive = False
                        , isUnbounded = isUnbounded
                        }
        )
        decodeIsSurfaceDisabled
        decodeIsSameInteraction
        decodeEvent
        |> Decode.andThen
            (Maybe.map Decode.succeed
                >> Maybe.withDefault (Decode.fail "")
            )


normalizedEventCoords event pageOffset clientRect =
    let
        { x, y } =
            pageOffset

        documentX =
            x + clientRect.x

        documentY =
            x + clientRect.y

        { pageX, pageY } =
            event.pagePoint
    in
    { x = pageX - documentX
    , y = pageY - documentY
    }


decodeClientRect : Decoder ClientRect
decodeClientRect =
    DOM.target <| Decode.map4 ClientRect DOM.offsetTop DOM.offsetLeft DOM.offsetWidth DOM.offsetHeight
