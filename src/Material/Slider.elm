module Material.Slider exposing
    ( disabled
    , discrete
    , max
    , min
    , Model
    , onChange
    , onInput
    , Property
    , react
    , steps
    , trackMarkers
    , value
    , view
    )

{-|
Slider provides an implementation of the Material Design slider component.

Note that vertical sliders and range (multi-thumb) sliders are not supported,
due to their absence from the material design spec.

Slider uses custom `onChage` and `onInput` event handlers.


# Resources

- [Material Design guidelines: Sliders](https://material.io/guidelines/components/sliders.html)
- [Demo](https://aforemny.github.io/elm-mdc/slider)


# Example

```elm
import Material.Slider as Slider

Slider.view Mdc [0] model.mdc
    [ Slider.value 40
    , Slider.onChange Change
    ]
    []
```


# Usage


## Slider

@docs Property
@docs view
@docs value, min, max
@docs disabled
@docs onChange, onInput

## Discrete Slider

@docs discrete
@docs steps
@docs trackMarkers


# Internal

@docs Model
@docs react
-}

import DOM
import Html as Html_
import Html as Html exposing (Html, text)
import Html.Attributes as Html
import Json.Decode as Json exposing (Decoder)
import Material.Component as Component exposing (Index, Indexed)
import Material.GlobalEvents as GlobalEvents
import Material.Internal.Options as Internal
import Material.Internal.Slider exposing (Msg(..), Geometry, defaultGeometry)
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)
import Svg
import Svg.Attributes as Svg


{-| Slider model.

Internal use only.
-}
type alias Model =
    { focus : Bool
    , active : Bool
    , geometry : Maybe Geometry
    , activeValue : Maybe Float
    , inTransit : Bool
    , preventFocus : Bool
    }


defaultModel : Model
defaultModel =
    { focus = False
    , active = False
    , geometry = Nothing
    , activeValue = Nothing
    , inTransit = False
    , preventFocus = False
    }


type alias Msg m =
    Material.Internal.Slider.Msg m


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
            (
              Just
              { model
                | focus = False
                , preventFocus = False
              }
            ,
              Cmd.none
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
            ,
              Cmd.none
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
            ,
              Cmd.none
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
                ,
                  Cmd.none
                )
            else
                ( Nothing, Cmd.none )

        Init geometry ->
            ( Just
              { model
                | geometry = Just geometry
              }
            ,
              Cmd.none
            )

        Resize geometry ->
            update lift (Init geometry) model

        KeyDown ->
            ( Just { model | focus = True }, Cmd.none )

        Up ->
            ( Just { model | active = False, activeValue = Nothing }, Cmd.none )


valueFromPageX : Geometry -> Float -> Float
valueFromPageX geometry pageX =
    let
        isRtl =
            False -- TODO

        { max, min } =
            geometry

        xPos =
            pageX - geometry.rect.left

        pctComplete =
            if isRtl then
                1 - (xPos / geometry.rect.width)
            else
                xPos / geometry.rect.width
    in
    min + pctComplete * (max - min)


valueForKey : Maybe String -> Int -> Geometry -> Float -> Maybe Float
valueForKey key keyCode geometry value =
    let
        isRtl =
            False -- TODO

        { max, min, steps, discrete } =
            geometry

        delta =
            ( if isRtl && (isArrowLeft || isArrowRight) then
                  (*) -1
              else
                  identity
            ) <|
            ( if discrete then
                  Maybe.withDefault 1 (Maybe.map toFloat steps)
              else
                  (max - min) / 100
            )

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
    Maybe.map (clamp min max) <|
    if isArrowLeft || isArrowDown then
        Just (value - delta)
    else if isArrowRight || isArrowUp then
        Just (value + delta)
    else if isHome then
        Just min
    else if isEnd then
        Just max
    else if isPageUp then
        Just (value + delta * pageFactor)
    else if isPageDown then
        Just (value - delta * pageFactor)
    else
        Nothing


type alias Config m =
    { value : Float
    , min : Float
    , max : Float
    , discrete : Bool
    , steps : Int
    , onInput : Maybe (Float -> m)
    , onChange : Maybe (Float -> m)
    , trackMarkers : Bool
    }


defaultConfig : Config m
defaultConfig =
    { value = 0
    , min = 0
    , max = 100
    , steps = 1
    , discrete = False
    , onInput = Nothing
    , onChange = Nothing
    , trackMarkers = False
    }


{-| Properties for Slider options.
-}
type alias Property m =
    Options.Property (Config m) m


{-| Specify the slider's value.

This will be clamped between `min` and `max`.
-}
value : Float -> Property m
value =
    Internal.option << (\value config -> { config | value = value })


{-| Specify the minimum value.
-}
min : Int -> Property m
min =
    Internal.option << (\min config -> { config | min = toFloat min })


{-| Specify the maximum value.
-}
max : Int -> Property m
max =
    Internal.option << (\max config -> { config | max = toFloat max })


{-| Make the slider only take integer values.
-}
discrete : Property m
discrete =
    Internal.option (\config -> { config | discrete = True })

 
{-| Disable the slider.
-}
disabled : Property m
disabled =
    Options.many
    [ cs "mdc-slider--disabled"
    , Internal.attribute <| Html.disabled True
    ]


slider : (Msg m -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
slider lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        continuousValue =
            if model.active then
                model.activeValue
                |> Maybe.withDefault config.value
            else
                config.value

        geometry =
            Maybe.withDefault defaultGeometry model.geometry

        value =
            discretize geometry continuousValue

        translateX =
            let
                v =
                    value
                    |> clamp config.min config.max

                c =
                    if (config.max - config.min) /= 0 then
                        (v - config.min) / (config.max - config.min)
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
                (value - config.min) / (config.max - config.min)
    in
    styled Html.div
    [ cs "elm-mdc-slider-wrapper"
    , Options.onWithOptions "keydown"
      { preventDefault = True
      , stopPropagation = False
      } <|
      Json.map lift <| Json.andThen identity <|
      Json.map2
          (\ key keyCode ->
             let
                 activeValue =
                     valueForKey key keyCode geometry config.value
             in
             if activeValue /= Nothing then
                 Json.succeed NoOp
             else
                 Json.fail ""
          )
          ( Json.oneOf
            [ Json.map Just (Json.at ["key"] Json.string)
            , Json.succeed Nothing
            ]
          )
          (Json.at ["keyCode"] Json.int)
    ]
    [
        Internal.apply summary Html.div
        [ cs "mdc-slider"
        , cs "mdc-slider--focus" |> when model.focus
        , cs "mdc-slider--active" |> when model.active
        , cs "mdc-slider--off" |> when (value <= config.min)
        , cs "mdc-slider--discrete" |> when config.discrete
        , cs "mdc-slider--in-transit" |> when model.inTransit
        , cs "mdc-slider--display-markers" |> when config.trackMarkers
        , Options.attribute (Html.tabindex 0)

        , Options.data "min" (toString config.min)
        , Options.data "max" (toString config.max)
        , Options.data "steps" (toString config.steps)
          |> when config.discrete

        , when (model.geometry == Nothing) <|
          GlobalEvents.onTick <| Json.map (lift << Init) decodeGeometry

        , GlobalEvents.onResize <| Json.map (lift << Resize) decodeGeometry

        , Options.on "keydown" <|
          Json.map lift <|
          Json.map2
              (\ key keyCode ->
                 let
                     activeValue =
                         valueForKey key keyCode geometry config.value
                 in
                 if activeValue /= Nothing then
                     KeyDown
                 else
                     NoOp
              )
              ( Json.oneOf
                [ Json.map Just (Json.at ["key"] Json.string)
                , Json.succeed Nothing
                ]
              )
              (Json.at ["keyCode"] Json.int)

        , when (config.onChange /= Nothing) <|
          Options.on "keydown" <|
          Json.map2
              (\ key keyCode ->
                 let
                     activeValue =
                         valueForKey key keyCode geometry config.value
                         |> Maybe.map (discretize geometry)
                 in
                 Maybe.map2 (<|) config.onChange activeValue
                 |> Maybe.withDefault (lift NoOp)
              )
              ( Json.oneOf
                [ Json.map Just (Json.at ["key"] Json.string)
                , Json.succeed Nothing
                ]
              )
              (Json.at ["keyCode"] Json.int)

        , when (config.onInput /= Nothing) <|
          Options.on "keydown" <|
          Json.map2
              (\ key keyCode ->
                 let
                     activeValue =
                         valueForKey key keyCode geometry config.value
                         |> Maybe.map (discretize geometry)
                 in
                 Maybe.map2 (<|) config.onInput activeValue
                 |> Maybe.withDefault (lift NoOp)
              )
              ( Json.oneOf
                [ Json.map Just (Json.at ["key"] Json.string)
                , Json.succeed Nothing
                ]
              )
              (Json.at ["keyCode"] Json.int)

        , Options.on "focus" (Json.succeed (lift Focus))
        , Options.on "blur" (Json.succeed (lift Blur))

        , Options.many <|
          ( List.map (\ event ->
                    Options.on event (Json.map (lift << InteractionStart event) decodePageX)
                )
                downs
          )

        , when (config.onChange /= Nothing) <|
          Options.many <|
          ( List.map (\ event ->
                    Options.on event <|
                    Json.map (\ { pageX } ->
                            let
                                activeValue =
                                    valueFromPageX geometry pageX
                                    |> discretize geometry
                            in
                            Maybe.map (flip (<|) activeValue) config.onChange
                            |> Maybe.withDefault (lift NoOp)
                        )
                        decodePageX
                )
                downs
          )

        , when (config.onInput /= Nothing) <|
          Options.many <|
          ( List.map (\ event ->
                    Options.on event <|
                    Json.map (\ { pageX } ->
                            let
                                activeValue =
                                    valueFromPageX geometry pageX
                                    |> discretize geometry
                            in
                            Maybe.map (flip (<|) activeValue) config.onInput
                            |> Maybe.withDefault (lift NoOp)
                        )
                        decodePageX
                )
                downs
          )

        , when model.active <|
          Options.many <|
          List.map (\ handler ->
                  handler (Json.succeed (lift Up))
              )
              ups

        , when ((config.onChange /= Nothing) && model.active) <|
          Options.many <|
          List.map (\ handler ->
                  handler <|
                  Json.map (\ { pageX } ->
                          let
                              activeValue =
                                  valueFromPageX geometry pageX
                                  |> discretize geometry
                          in
                          Maybe.map (flip (<|) activeValue) config.onChange
                          |> Maybe.withDefault (lift NoOp)
                      )
                      decodePageX
              )
              ups

        , when ((config.onInput /= Nothing) && model.active) <|
          Options.many <|
          List.map (\ handler ->
                  handler <|
                  Json.map (\ { pageX } ->
                          let
                              activeValue =
                                  valueFromPageX geometry pageX
                                  |> discretize geometry
                          in
                          Maybe.map (flip (<|) activeValue) config.onInput
                          |> Maybe.withDefault (lift NoOp)
                      )
                      decodePageX
              )
              ups

        , when model.active <|
          Options.many <|
          List.map (\ handler ->
                  handler (Json.map (lift << Drag) decodePageX)
              )
              moves

        , when ((config.onInput /= Nothing) && model.active) <|
          Options.many <|
          List.map (\ handler ->
                  handler <|
                  Json.map (\ { pageX } ->
                          let
                              activeValue =
                                  valueFromPageX geometry pageX
                                  |> discretize geometry
                          in
                          Maybe.map (flip (<|) activeValue) config.onInput
                          |> Maybe.withDefault (lift NoOp)
                      )
                      decodePageX
              )
              moves
        ]
        []
        [
          styled Html.div
          [ cs "mdc-slider__track-container"
          ]
          ( List.concat
            [
              [ styled Html.div
                [ cs "mdc-slider__track"
                , css "transform" ("scaleX(" ++ toString trackScale ++ ")")
                ]
                []
              ]
            ,
              if config.discrete then
                [
                  styled Html.div
                  [ cs "mdc-slider__track-marker-container"
                  ]
                  ( List.repeat ((round (config.max  - config.min)) // config.steps) <|
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
        ,
          styled Html.div
          [ cs "mdc-slider__thumb-container"
          , Options.many
            ( downs
              |> List.map (\ event ->
                     Options.onWithOptions event
                     { stopPropagation = True
                     , preventDefault = False
                     }
                     (Json.map (lift << ThumbContainerPointer event) decodePageX)
                 )
            )
          , Options.on "transitionend" (Json.succeed (lift TransitionEnd))
          , css "transform" <|
            "translateX(" ++ toString translateX ++ "px) translateX(-50%)"
          ]
          ( List.concat
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
              ,
                styled Html.div
                [ cs "mdc-slider__focus-ring"
                ]
                []
              ]
            ,
              if config.discrete then
                  [
                    styled Html.div
                    [ cs "mdc-slider__pin"
                    ]
                    [
                      styled Html.div
                      [ cs "mdc-slider__pin-value-marker"
                      ]
                      [ text (toString value)
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


( get, set ) =
    Component.indexed .slider (\x y -> { y | slider = x }) defaultModel


{-| Slider react.

Internal use only.
-}
react :
    (Material.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.SliderMsg update


{-| Slider view.
-}
view :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view lift index store options =
    Component.render get slider Material.Msg.SliderMsg lift index store
        (Internal.dispatch lift :: options)


discretize : Geometry -> Float -> Float
discretize geometry continuousValue =
    let
        { discrete, min, max } =
            geometry

        steps =
            geometry.steps
            |> Maybe.map toFloat
            |> Maybe.withDefault 1
            |> \ steps ->
               if steps == 0 then
                   1
               else
                   steps
    in
    clamp min max <|
    if not discrete then
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
    Json.map (\ pageX -> { pageX = pageX }) <|
    Json.oneOf
    [ Json.at [ "targetTouches", "0", "pageX" ] Json.float
    , Json.at [ "changedTouches", "0", "pageX" ] Json.float
    , Json.at ["pageX"] Json.float
    ]


decodeGeometry : Decoder Geometry
decodeGeometry =
    let
        traverseToContainer decoder =
            hasClass "mdc-slider"
            |> Json.andThen (\ doesHaveClass ->
                if doesHaveClass then
                    decoder
                else
                    DOM.parentElement (Json.lazy (\_ -> traverseToContainer decoder))
    )
    in
    DOM.target <|
    traverseToContainer <|
    Json.map6
        ( \offsetWidth offsetLeft discrete min max steps ->
            { rect = { width = offsetWidth, left = offsetLeft }
            , discrete = discrete
            , min = min
            , max = max
            , steps = steps
            }
        )
        DOM.offsetWidth
        DOM.offsetLeft
        ( hasClass "mdc-slider--discrete" )
        ( data "min" (Json.map (String.toFloat >> Result.withDefault 1) Json.string) )
        ( data "max" (Json.map (String.toFloat >> Result.withDefault 1) Json.string) )
        ( Json.oneOf
          [ data "steps" (Json.map (Result.toMaybe << String.toInt) Json.string)
          , Json.succeed Nothing
          ]
        )


data : String -> Decoder a -> Decoder a
data key decoder =
    Json.at [ "dataset", key ] decoder


hasClass : String -> Decoder Bool
hasClass class =
    Json.map
      ( \className ->
          String.contains (" " ++ class ++ " ") (" " ++ className ++ " ")
      )
      ( Json.at [ "className" ] Json.string )


{-| Slider `onChange` event listener.
-}
onChange : (Float -> m) -> Property m
onChange =
    Internal.option << (\ decoder config -> { config | onChange = Just decoder } )


{-| Slider `onInput` event listener.
-}
onInput : (Float -> m) -> Property m
onInput =
    Internal.option << (\ decoder config -> { config | onInput = Just decoder } )


{-| Specify a number of steps that value will be a multiple of.

Defaults to 1.
-}
steps : Int -> Property m
steps =
    Internal.option << (\ steps config -> { config | steps = steps } )


{-| Add track markers to the Slider every `step`.
-}
trackMarkers : Property m
trackMarkers =
    Internal.option (\ config -> { config | trackMarkers = True } )
