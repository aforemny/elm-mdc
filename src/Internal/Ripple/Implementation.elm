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

import Char
import DOM
import Html exposing (Html, text)
import Html.Attributes as Html
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Helpers as Helpers
import Internal.Msg
import Internal.Options as Options exposing (cs, css, styled, when)
import Internal.Ripple.Model exposing (Geometry, Model, Msg(..), defaultGeometry, defaultModel)
import Json.Decode as Json exposing (Decoder, at, field)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Focus ->
            ( { model | focus = True }, Cmd.none )

        Blur ->
            ( { model | focus = False }, Cmd.none )

        Activate event active_ geometry ->
            let
                isVisible =
                    model.active || model.animating
            in
            if not isVisible then
                let
                    active =
                        active_
                            |> Maybe.withDefault model.active

                    animation =
                        model.animation + 1
                in
                ( { model
                    | active = active
                    , animating = True
                    , geometry = geometry
                    , deactivation = False
                    , animation = animation
                  }
                , Helpers.delayedCmd 300 (AnimationEnd event animation)
                )
            else
                ( model, Cmd.none )

        Deactivate event ->
            let
                sameEvent =
                    case model.geometry.event.type_ of
                        "keydown" ->
                            event == "keyup"

                        "mousedown" ->
                            event == "mouseup"

                        "pointerdown" ->
                            event == "pointerup"

                        "touchstart" ->
                            event == "touchend"

                        _ ->
                            False
            in
            if sameEvent then
                ( { model | active = False }, Cmd.none )
            else
                ( model, Cmd.none )

        AnimationEnd event animation ->
            if (model.geometry.event.type_ == event) && (animation == model.animation) then
                ( { model | animating = False }, Cmd.none )
            else
                ( model, Cmd.none )


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
    Component.render get (view False) Internal.Msg.RippleMsg


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
    Component.render get (view True) Internal.Msg.RippleMsg


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
    -> (Msg -> m)
    -> Model
    -> List (Property m)
    ->
        { interactionHandler : Options.Property c m
        , properties : Options.Property c m
        , style : Html m
        }
view isUnbounded lift model options =
    let
        { config } =
            Options.collect defaultConfig options

        geometry =
            model.geometry

        surfaceWidth =
            toString geometry.frame.width ++ "px"

        surfaceHeight =
            toString geometry.frame.height ++ "px"

        fgSize =
            toString initialSize ++ "px"

        surfaceDiameter =
            sqrt ((geometry.frame.width ^ 2) + (geometry.frame.height ^ 2))

        maxRadius =
            if isUnbounded then
                maxDimension
            else
                surfaceDiameter + 10

        fgScale =
            toString (maxRadius / initialSize)

        maxDimension =
            Basics.max geometry.frame.width geometry.frame.height

        initialSize =
            maxDimension * 0.6

        startPoint =
            if wasActivatedByPointer && not isUnbounded then
                { x = geometry.event.pageX - (initialSize / 2)
                , y = geometry.event.pageY - (initialSize / 2)
                }
            else
                { x = toFloat (round ((geometry.frame.width - initialSize) / 2))
                , y = toFloat (round ((geometry.frame.height - initialSize) / 2))
                }

        endPoint =
            { x = (geometry.frame.width - initialSize) / 2
            , y = (geometry.frame.height - initialSize) / 2
            }

        translateStart =
            toString startPoint.x ++ "px, " ++ toString startPoint.y ++ "px"

        translateEnd =
            toString endPoint.x ++ "px, " ++ toString endPoint.y ++ "px"

        wasActivatedByPointer =
            List.member geometry.event.type_
                [ "mousedown"
                , "touchstart"
                , "pointerdown"
                ]

        top =
            toString startPoint.y ++ "px"

        left =
            toString startPoint.x ++ "px"

        summary =
            Options.collect ()

        cssVariableHack =
            let
                className =
                    (++) "mdc-ripple-style-hack--" <|
                        String.fromList
                            << List.filter Char.isDigit
                            << String.toList
                            << String.concat
                        <|
                            [ fgSize
                            , fgScale
                            , top
                            , left
                            , translateStart
                            , translateEnd
                            ]

                text =
                    flip (++) "}"
                        << (++) ("." ++ className ++ "{")
                    <|
                        String.concat
                            << List.map
                                (\( k, v ) ->
                                    "--mdc-ripple-" ++ k ++ ":" ++ v ++ " !important;"
                                )
                        <|
                            List.concat
                                [ [ ( "fg-size", fgSize )
                                  , ( "fg-scale", fgScale )
                                  ]
                                , if isUnbounded then
                                    [ ( "top", top )
                                    , ( "left", left )
                                    ]
                                  else
                                    [ ( "fg-translate-start", translateStart )
                                    , ( "fg-translate-end", translateEnd )
                                    ]
                                ]
            in
            { className = className
            , text = text
            }

        focusOn event =
            Options.on event (Json.succeed (lift Focus))

        blurOn event =
            Options.on event (Json.succeed (lift Blur))

        activateOn event =
            Options.on event <|
                Json.map (lift << Activate event (Just True)) (decodeGeometry event)

        deactivateOn event =
            Options.on event (Json.succeed (lift (Deactivate event)))

        isVisible =
            model.active || model.animating

        interactionHandler =
            Options.many
                [ focusOn "focus"
                , blurOn "blur"
                , Options.many <|
                    List.map activateOn
                        [ -- "keydown"
                          "mousedown"
                        , "pointerdown"
                        , "touchstart"
                        ]
                , Options.many <|
                    List.map deactivateOn
                        [ -- "keyup"
                          "mouseup"
                        , "pointerup"
                        , "touchend"
                        ]
                ]

        properties =
            Options.many
                [ cs "mdc-ripple-upgraded"

                -- Note: Buttons can't have mdc-ripple-surface.
                -- , cs "mdc-ripple-surface"
                , when (config.color == Just "primary") <|
                    cs "mdc-ripple-surface--primary"
                , when (config.color == Just "accent") <|
                    cs "mdc-ripple-surface--accent"
                , when isUnbounded
                    << Options.many
                  <|
                    [ cs "mdc-ripple-upgraded--unbounded"
                    , Options.data "data-mdc-ripple-is-unbounded" ""
                    ]
                , when isVisible
                    << Options.many
                  <|
                    [ cs "mdc-ripple-upgraded--background-active-fill"
                    , cs "mdc-ripple-upgraded--foreground-activation"
                    ]
                , when model.deactivation <|
                    cs "mdc-ripple-upgraded--foreground-deactivation"
                , when model.focus <|
                    cs "mdc-ripple-upgraded--background-focused"
                , when isVisible <|
                    cs cssVariableHack.className
                ]

        style =
            Html.node "style"
                [ Html.type_ "text/css"
                ]
                [ if isVisible then
                    text cssVariableHack.text
                  else
                    text ""
                ]
    in
    { interactionHandler = interactionHandler
    , properties = properties
    , style = style
    }


type alias Store s =
    { s
        | ripple : Indexed Model
    }


( get, set ) =
    Component.indexed .ripple (\x y -> { y | ripple = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Internal.Msg.RippleMsg (Component.generalise update)


decodeGeometry : String -> Decoder Geometry
decodeGeometry type_ =
    let
        windowPageOffset =
            Json.map2 (\x y -> { x = x, y = y })
                (Json.at [ "pageXOffset" ] Json.float)
                (Json.at [ "pageYOffset" ] Json.float)

        isSurfaceDisabled =
            Json.oneOf
                [ Json.map (always True) (Json.at [ "disabled" ] Json.string)
                , Json.succeed False
                ]

        boundingClientRect pageOffset =
            DOM.boundingClientRect
                |> Json.map
                    (\{ top, left, width, height } ->
                        { top = top - pageOffset.y
                        , left = left
                        , width = width
                        , height = height
                        }
                    )

        normalizeCoords pageOffset clientRect { pageX, pageY } =
            let
                documentX =
                    pageOffset.x + clientRect.left

                documentY =
                    pageOffset.y + clientRect.top

                x =
                    pageX - documentX

                y =
                    pageY - documentY
            in
            { x = x, y = y }

        changedTouches =
            Json.at [ "changedTouches" ] (Json.list changedTouch)

        changedTouch =
            Json.map2 (\pageX pageY -> { pageX = pageX, pageY = pageY })
                (Json.at [ "pageX" ] Json.float)
                (Json.at [ "pageY" ] Json.float)

        currentTarget =
            Json.at [ "currentTarget" ]

        view =
            Json.at [ "view" ]
    in
    Json.map4
        (\coords pageOffset clientRect isSurfaceDisabled ->
            let
                { x, y } =
                    normalizeCoords pageOffset clientRect coords

                event =
                    { type_ = type_
                    , pageX = x
                    , pageY = y
                    }
            in
            { event = event
            , isSurfaceDisabled = isSurfaceDisabled
            , frame = clientRect
            }
        )
        (if type_ == "touchstart" then
            changedTouches
                |> Json.map List.head
                |> Json.map (Maybe.withDefault { pageX = 0, pageY = 0 })
         else
            Json.map2 (\pageX pageY -> { pageX = pageX, pageY = pageY })
                (Json.at [ "pageX" ] Json.float)
                (Json.at [ "pageY" ] Json.float)
        )
        (view windowPageOffset)
        (view windowPageOffset
            |> Json.andThen (currentTarget << boundingClientRect)
        )
        (currentTarget isSurfaceDisabled)
