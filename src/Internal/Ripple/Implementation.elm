module Internal.Ripple.Implementation
    exposing
        ( Property
        , accent
        , bounded
        , primary
        , react
        , unbounded
        , update
        , view
        )

import Browser.Dom
import Char
import DOM
import Html exposing (Html, text)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Helpers as Helpers
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Internal.Ripple.Model
    exposing
        ( ActivateData
        , ActivatedData
        , AnimateDeactivationData
        , AnimationState(..)
        , ClientRect
        , Event
        , Model
        , Msg(..)
        , Point
        , activationEventTypes
        , cssClasses
        , defaultModel
        , numbers
        , pointerDeactivationEvents
        , strings
        )
import Json.Decode as Decode exposing (Decoder)
import MD5
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
        , style : Html m
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
        , style : Html m
        }
unbounded =
    \lift domId ->
        Component.render getSet.get (view True domId) Internal.Msg.RippleMsg lift domId


type alias Config =
    { color : Maybe String
    }


defaultConfig : Config
defaultConfig =
    { color = Nothing
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
        , style : Html m
        }
view isUnbounded domId lift model options =
    let
        { config } =
            Options.collect defaultConfig options

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
                                                activationEvent

                                            _ ->
                                                Nothing
                                    }
                                )
                            )
                    )
                    activationEventTypes

        deactivateHandler event =
            Options.many <|
                List.map
                    (\tipe ->
                        Options.on tipe (Decode.succeed (lift Deactivate))
                    )
                    pointerDeactivationEvents

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

        noStyle =
            Html.node "style" [ Html.type_ "text/css" ] []
    in
    case model.animationState of
        Idle ->
            let
                interactionHandler =
                    Options.many
                        [ baseInteractionHandler
                        , activateHandler
                        ]

                properties =
                    baseProperties

                style =
                    noStyle
            in
            { interactionHandler = interactionHandler
            , properties = properties
            , style = style
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
                        { fgSize = String.fromFloat activatedData.initialSize ++ "px"
                        , fgScale = activatedData.fgScale
                        , translateStart = activatedData.translateStart
                        , translateEnd = activatedData.translateEnd
                        , initialSize = activatedData.initialSize
                        , frame = activatedData.frame
                        }

                properties =
                    Options.many
                        [ baseProperties
                        , cs cssVars.className
                        , cs cssClasses.fgActivation
                        , when isUnbounded (Options.data "mdc-ripple-is-unbounded" "1")
                        ]

                style =
                    Html.node "style" [ Html.type_ "text/css" ] [ text cssVars.text ]
            in
            { interactionHandler = interactionHandler
            , properties = properties
            , style = style
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
                        , cs cssVars.className
                        , cs cssClasses.fgDeactivation
                        ]

                cssVars =
                    cssVariables isUnbounded
                        { fgSize = String.fromFloat activatedData.initialSize ++ "px"
                        , fgScale = activatedData.fgScale
                        , translateStart = activatedData.translateStart
                        , translateEnd = activatedData.translateEnd
                        , initialSize = activatedData.initialSize
                        , frame = activatedData.frame
                        }

                style =
                    Html.node "style" [ Html.type_ "text/css" ] [ text cssVars.text ]
            in
            { interactionHandler = interactionHandler
            , properties = properties
            , style = style
            }


cssVariables :
    Bool
    ->
        { fgSize : String
        , fgScale : Float
        , translateStart : String
        , translateEnd : String
        , initialSize : Float
        , frame : ClientRect
        }
    ->
        { className : String
        , text : String
        }
cssVariables isUnbounded { fgSize, fgScale, translateStart, translateEnd, initialSize, frame } =
    let
        className =
            (++) "mdc-ripple--" <|
                MD5.hex <|
                    String.concat <|
                        [ fgSize
                        , String.fromFloat fgScale
                        , String.fromFloat unboundedCoords.top
                        , String.fromFloat unboundedCoords.left
                        , translateStart
                        , translateEnd
                        ]

        unboundedCoords =
            if isUnbounded then
                { top = toFloat (round ((frame.height - initialSize) / 2))
                , left = toFloat (round ((frame.width - initialSize) / 2))
                }
            else
                { top = 0, left = 0 }

        text =
            (\someString -> "." ++ className ++ "{" ++ someString ++ "}") <|
                String.concat
                    << List.map
                        (\( key, value ) ->
                            key ++ ":" ++ value ++ " !important;"
                        )
                <|
                    List.concat
                        [ [ ( strings.varFgSize, fgSize )
                          , ( strings.varFgScale, String.fromFloat fgScale )
                          ]
                        , if isUnbounded then
                            [ ( strings.varTop
                              , String.fromFloat unboundedCoords.top ++ "px"
                              )
                            , ( strings.varLeft
                              , String.fromFloat unboundedCoords.left ++ "px"
                              )
                            ]
                          else
                            [ ( strings.varFgTranslateStart, translateStart )
                            , ( strings.varFgTranslateEnd, translateEnd )
                            ]
                        ]
    in
    { className = className
    , text = text
    }



--updateActivationTimerCallback : Model -> ( Model, Cmd Msg )
--updateActivationTimerCallback model =
--  runDeactivationUxLogicIfReady { model | activationAnimationHasEnded = True }
--        geometry =
--            model.geometry
--
--        surfaceWidth =
--            String.fromFloat geometry.frame.width ++ "px"
--
--        surfaceHeight =
--            String.fromFloat geometry.frame.height ++ "px"
--
--        fgSize =
--            String.fromFloat initialSize ++ "px"
--
--        surfaceDiameter =
--            sqrt ((geometry.frame.width ^ 2) + (geometry.frame.height ^ 2))
--
--        maxRadius =
--            if isUnbounded then
--                maxDimension
--            else
--                surfaceDiameter + 10
--
--        fgScale =
--            String.fromFloat (maxRadius / initialSize)
--
--        translateStart =
--            String.fromFloat startPoint.x ++ "px, " ++ String.fromFloat startPoint.y ++ "px"
--
--        translateEnd =
--            String.fromFloat endPoint.x ++ "px, " ++ String.fromFloat endPoint.y ++ "px"
--
--        wasActivatedByPointer =
--            List.member geometry.event.type_
--                [ "mousedown"
--                , "touchstart"
--                , "pointerdown"
--                ]
--
--        top =
--            String.fromFloat startPoint.y ++ "px"
--
--        left =
--            String.fromFloat startPoint.x ++ "px"
-- COMPONENT


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

        ( Activate0 domId activateData, Idle ) ->
            ( model
            , Task.attempt (Activate activateData) (Browser.Dom.getElement domId)
            )

        ( Activate0 domId activateData, _ ) ->
            ( model
            , Task.attempt (Reactivate activateData) (Browser.Dom.getElement domId)
            )

        ( Reactivate activateData element, _ ) ->
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
                    , activationEvent = Just activateData.event
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
                        { activatedData
                            | activationEvent = Nothing
                            , deactivated = True
                        }
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
            maxDim * numbers.initialOriginScale

        fgScale =
            maxRadius / initialSize
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
