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

import Dict
import DOM
import Html.Attributes as Html
import Html exposing (..)
import Json.Decode as Json exposing (Decoder, field, at)
import Material.Component as Component exposing (Indexed)
import Material.Internal.Options as Internal exposing (Property)
import Material.Internal.Ripple exposing (Msg(..), Geometry, defaultGeometry)
import Material.Msg exposing (Index)
import Material.Options as Options exposing (styled, cs, css, when)
import Platform.Cmd exposing (Cmd, none)


-- MODEL


type alias Model =
    { focus : Bool
    , activated : Bool
    , geometry : Geometry
    }


defaultModel : Model
defaultModel =
    { focus = False
    , activated = False
    , geometry = defaultGeometry
    }


-- ACTION, UPDATE


type alias Msg
    = Material.Internal.Ripple.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of

        Focus geometry ->
            { model
                | focus = True
                , geometry =
                    if model.activated then
                        model.geometry
                    else
                        geometry
            }
                ! []

        Blur ->
            { model
                | focus = False
            }
                ! []

        Activate geometry ->
            { model
                | activated = True
                , geometry = geometry
            }
                ! []

        Deactivate ->
            { model
                | activated = False
                , focus = False
            }
                ! []


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
    in
    (
      Options.many
      [ Options.on "focus" (Json.map (Focus >> lift) (decodeGeometry "focus"))
      , Options.on "blur" (Json.succeed (lift Blur))
      , Options.on "keydown" (Json.map (Activate >> lift) (decodeGeometry "keydown"))
      , Options.on "keyup" (Json.succeed (lift Deactivate))
      , Options.on "mousedown" (Json.map (Activate >> lift) (decodeGeometry "mousedown"))
      , Options.on "mouseup" (Json.succeed (lift Deactivate))
      , Options.on "pointerdown" (Json.map (Activate >> lift) (decodeGeometry "pointerdown"))
      , Options.on "pointerup" (Json.succeed (lift Deactivate))
      , Options.on "touchstart" (Json.map (Activate >> lift) (decodeGeometry "touchstart"))
      , Options.on "touchend" (Json.succeed (lift Deactivate))

      , cs "mdc-ripple-surface"
      , cs "mdc-ripple-upgraded"
      , Options.attribute (Html.tabindex 0)

      , when isUnbounded << Options.many <|
        [ cs "mdc-ripple-upgraded--unbounded"
        , css "overflow" "visible"
        , Options.data "data-mdc-ripple-is-unbounded" ""
        ]

      , when model.activated << Options.many <|
        [ cs "mdc-ripple-upgraded--background-active-fill"
        , cs "mdc-ripple-upgraded--foreground-activation"
        ]

      , when model.focus <|
        cs "mdc-ripple-upgraded--background-focused"

      , -- CSS variable hack selector:
        cs selector
      ]

    , styleNode
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
    Json.map3
        (\isSurfaceDisabled event frame ->
            { isSurfaceDisabled = isSurfaceDisabled
            , event = event
            , frame = frame
            }
        )
        ( DOM.target <|
          Json.oneOf
          [ Json.map (always True) (Json.at [ "disabled" ] Json.string)
          , Json.succeed False
          ]
        )
        ( Json.map2 (\pageX pageY -> { type_ = type_, pageX = pageX, pageY = pageY })
              (Json.at [ "pageX" ] Json.float)
              (Json.at [ "pageY" ] Json.float)
        )
        ( DOM.target DOM.boundingClientRect
        )
