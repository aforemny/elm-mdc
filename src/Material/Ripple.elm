module Material.Ripple exposing
    ( Model
    , defaultModel
    , Msg
    , update
    , bounded
    , unbounded
    , accent
    , primary
    , react
    , view
    )

import DOM
import Html.Attributes as Html
import Html exposing (..)
import Json.Decode as Json exposing (Decoder, field, at)
import Material.Component as Component exposing (Indexed)
import Material.Helpers as Helpers
import Material.Internal.Options as Internal exposing (Property)
import Material.Internal.Ripple exposing (Msg(..), Geometry, defaultGeometry)
import Material.Msg exposing (Index)
import Material.Options as Options exposing (styled, cs, css, when)
import Platform.Cmd exposing (Cmd, none)


-- MODEL


type alias Model =
    { focus : Bool
    , active : Bool
    , animating : Bool
    , deactivation : Bool
    , geometry : Geometry
    , animation : Int
    }


defaultModel : Model
defaultModel =
    { focus = False
    , active = False
    , animating = False
    , deactivation = False
    , geometry = defaultGeometry
    , animation = 0
    }


-- ACTION, UPDATE


type alias Msg
    = Material.Internal.Ripple.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of

        Focus ->
            ( { model | focus = True }, Cmd.none )

        Blur ->
            ( { model | focus = False }, Cmd.none)

        Activate event active_ geometry ->
            let
                isVisible =
                    model.active || model.animating
            in
            if isVisible then
                ( { model
                      | active = False
                      , animating = False
                      , deactivation = True
                  }

                , Helpers.delay 83 (Activate event Nothing geometry)
                )
            else
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
                ,
                  Helpers.delay 300 (AnimationEnd event animation)
                )

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
                        _ -> False
            in
            if not sameEvent then
                ( model, Cmd.none )
            else
                ( { model | active = False }, Cmd.none )

        AnimationEnd event animation ->
            if not (model.geometry.event.type_ == event)
               || (animation /= model.animation) then
                ( model, Cmd.none )
            else
                ( { model | animating = False }, Cmd.none )


-- VIEW


bounded : (Material.Msg.Msg m -> m) -> Index -> Store s -> x -> y -> (Options.Property c m, Html m)
bounded lift index store options =
    Component.render get (view False) Material.Msg.RippleMsg lift index store options


unbounded : (Material.Msg.Msg m -> m) -> Index -> Store s -> x -> y -> (Options.Property c m, Html m)
unbounded lift index store options =
    Component.render get (view True) Material.Msg.RippleMsg lift index store options


accent : Property c m
accent =
    cs "mdc-ripple-surface--accent"


primary : Property c m
primary =
    cs "mdc-ripple-surface--primary"


view : Bool -> (Msg -> m) -> Model -> x -> y -> (Options.Property c m, Html m)
view isUnbounded lift model _ _ =
    let
        geometry =
            model.geometry

        surfaceWidth =
            toString geometry.frame.width ++ "px"

        surfaceHeight =
            toString geometry.frame.height ++ "px"

        fgSize =
            toString initialSize ++ "px"

        surfaceDiameter =
            sqrt ((geometry.frame.width^2) + (geometry.frame.height^2))

        maxRadius =
            surfaceDiameter + 10

        fgScale =
            toString (maxRadius / initialSize)

        maxDimension =
            Basics.max geometry.frame.width geometry.frame.height

        initialSize =
            maxDimension * 0.6

        startPoint =
            if wasActivatedByPointer && not isUnbounded then
                { x = geometry.event.pageX - geometry.frame.left - (initialSize / 2)
                , y = geometry.event.pageY - geometry.frame.top - (initialSize / 2)
                }
            else
                { x = (geometry.frame.width - initialSize) / 2
                , y = (geometry.frame.height - initialSize) / 2
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
          Internal.collect ()
          ( List.concat
            [ [ Internal.variable "--mdc-ripple-surface-width" surfaceWidth
              , Internal.variable "--mdc-ripple-surface-height" surfaceHeight
              , Internal.variable "--mdc-ripple-fg-size" fgSize
              , Internal.variable "--mdc-ripple-fg-scale" fgScale
              ]
            , if isUnbounded then
                  [ Internal.variable "--mdc-ripple-top" top
                  , Internal.variable "--mdc-ripple-left" left
                  ]
              else
                  [ Internal.variable "--mdc-ripple-fg-translate-start" translateStart
                  , Internal.variable "--mdc-ripple-fg-translate-end" translateEnd
                  ]
            ]
          )

        (selector, styleNode) =
            Internal.cssVariables summary

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
    in
    (
      Options.many
      [ focusOn "focus"
      , blurOn "blur"
      , Options.many <|
        List.map activateOn
        [ "keydown"
        , "mousedown"
        , "pointerdown"
        , "touchstart"
        ]
      , Options.many <|
        List.map deactivateOn
        [ "keyup"
        , "mouseup"
        , "pointerup"
        , "touchend"
        ]

      , cs "mdc-ripple-surface"
      , cs "mdc-ripple-upgraded"

      , when isUnbounded << Options.many <|
        [ cs "mdc-ripple-upgraded--unbounded"
        , css "overflow" "visible"
        , Options.data "data-mdc-ripple-is-unbounded" ""
        ]

      , when isVisible << Options.many <|
        [ cs "mdc-ripple-upgraded--background-active-fill"
        , cs "mdc-ripple-upgraded--foreground-activation"
        ]

      , when model.deactivation <|
        cs "mdc-ripple-upgraded--foreground-deactivation"

      , when model.focus <|
        cs "mdc-ripple-upgraded--background-focused"

      , -- CSS variable hack selector:
        when isVisible (cs selector)
      ]

    , if isVisible then
          styleNode
      else
          Html.node "style"
          [ Html.type_ "text/css"
          ]
          []
    )


type alias Store s =
    { s | ripple : Indexed Model
    }


( get, set ) =
    Component.indexed .ripple (\x y -> { y | ripple = x }) defaultModel


react : (Material.Msg.Msg m -> m) -> Msg -> Index -> Store s -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.RippleMsg (Component.generalise update)


decodeGeometry : String -> Decoder Geometry
decodeGeometry type_ =
    let
        traverseToContainer cont =
            Json.oneOf
            [ DOM.className
              |> Json.andThen (\ className ->
                     let
                        hasClass class =
                            String.contains (encaps class) << encaps

                        encaps str =
                            " " ++ str ++ " "
                     in
                     if hasClass "mdc-ripple-upgraded" className then
                         cont
                     else
                         Json.fail "Material.Ripple.decodeGeometry"
                 )
            , DOM.parentElement (Json.lazy (\_ -> traverseToContainer cont))
            ]
    in
    (
      ( Json.map2 (\pageX pageY -> { type_ = type_, pageX = pageX, pageY = pageY })
            (Json.at [ "pageX" ] Json.float)
            (Json.at [ "pageY" ] Json.float)
      )
      |> Json.andThen (\ event ->
            DOM.target          <| -- .mdc-ripple-upgraded [*]
            traverseToContainer <| -- .mdc-ripple-upgraded
            Json.map2
                (\isSurfaceDisabled frame ->
                    { event = event
                    , isSurfaceDisabled = isSurfaceDisabled
                    , frame = frame
                    }
                )
                ( Json.oneOf
                  [ Json.map (always True) (Json.at [ "disabled" ] Json.string)
                  , Json.succeed False
                  ]
                )
                ( DOM.boundingClientRect
                )
         )
     )
