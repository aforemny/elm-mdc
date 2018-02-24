module Material.Slider
    exposing
        ( -- VIEW
          view
        , Property
        , disabled
        , value
        , min
        , max
        , discrete
        , steps
        , trackMarkers
        , onChange
        , onInput
        , targetValue
        
          -- TEA
        , Model
        , defaultModel
        , Msg
        , update
          
          -- Featured render
        , render
        , Store
        , react
        )

{-|
## Design and API Documentation

- [Material Design guidelines: Sliders](https://material.io/guidelines/components/sliders.html)
- [Demo](https://aforemny.github.io/elm-mdc/slider)

## View
@docs view


## Properties
@docs Property
@docs disabeld
@docs value, min, max
@docs discrete, steps, trackMarkers
@docs onChange, onInput, targetValue

## TEA
@docs Model, defaultModel, Msg, update

## Featured render
@docs render
@docs Store, react
-}

import DOM
import Html as Html_
import Html as Html exposing (Html, text)
import Html.Attributes as Html
import Json.Decode as Json exposing (Decoder)
import Material.Component as Component exposing (Index, Indexed)
import Material.Helpers as Helpers
import Material.Internal.Options as Internal
import Material.Internal.Slider exposing (Msg(..), Geometry, defaultGeometry)
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)
import Svg
import Svg.Attributes as Svg


type alias Model =
    { focus : Bool
    , active : Bool
    , geometry : Maybe Geometry
    , value : Maybe Float
    , inTransit : Bool
    , preventFocus : Bool
    }


defaultModel : Model
defaultModel =
    { focus = False
    , active = False
    , geometry = Nothing
    , value = Nothing
    , inTransit = False
    , preventFocus = False
    }


type alias Msg m =
    Material.Internal.Slider.Msg m


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Dispatch ms ->
            ( model, Cmd.batch (List.map Helpers.cmd ms) )

        Focus ->
            if not model.preventFocus then
                ( { model | focus = True }, Cmd.none )
            else
                ( model, Cmd.none )

        Blur ->
            (
              { model
                | focus = False
                , active = False
                , preventFocus = False
              }
            ,
              Cmd.none
            )

        Tick ->
            ( { model | inTransit = False }, Cmd.none )

        Activate inTransit geometry ->
            ( { model
                | active = True
                , geometry = Just geometry
                , inTransit = inTransit
                , value = Just (computeValue geometry)
                , preventFocus = True
              }
            ,
              Cmd.none
            )

        Drag geometry ->
            if model.active then
                ( { model
                    | geometry = Just geometry
                    , inTransit = False
                    , value = Just (computeValue geometry)
                  }
                ,
                  Cmd.none
                )
            else
                ( model, Cmd.none )

        Init geometry ->
            ( { model
                | geometry = Just geometry
                , value = Just (computeValue geometry)
              }
            ,
              Cmd.none
            )

        Up ->
            ( { model | active = False }, Cmd.none )


type alias Config m =
    { value : Float
    , min : Float
    , max : Float
    , discrete : Bool
    , steps : Int
    , onInput : Maybe (Decoder m)
    , onChange : Maybe (Decoder m)
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


{-| TODO
-}
value : Float -> Property m
value =
    Internal.option << (\value config -> { config | value = value })


{-| TODO
-}
min : Int -> Property m
min =
    Internal.option << (\min config -> { config | min = toFloat min })


{-| TODO
-}
max : Int -> Property m
max =
    Internal.option << (\max config -> { config | max = toFloat max })


{-| TODO
-}
discrete : Property m
discrete =
    Internal.option (\config -> { config | discrete = True })

 
{-| TODO
-}
disabled : Property m
disabled =
    Options.many
    [ cs "mdc-slider--disabled"
    , Internal.attribute <| Html.disabled True
    ]


view : (Msg m -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        continuousValue =
            if model.active then
                model.value
                |> Maybe.withDefault config.value
            else
                config.value

        value =
            if config.discrete then
                discretize config.steps continuousValue
            else
                continuousValue

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
                model.geometry
                |> Maybe.map .width
                |> Maybe.map ((*) c)
                |> Maybe.withDefault 0

        activateOn event =
            Options.on event (Json.map (Activate True >> lift) decodeGeometry)

        initOn event =
            Options.on event (Json.map (Init >> lift) decodeGeometry)

        upOn event =
            Options.on event (Json.succeed (lift Up))

        dragOn event =
            Options.on event (Json.map (Drag >> lift) decodeGeometry)

        inputOn event =
            Options.on event (Maybe.withDefault (Json.succeed (lift NoOp)) config.onInput)

        changeOn event =
            Options.on event (Maybe.withDefault (Json.succeed (lift NoOp)) config.onChange)

        ups =
          [ "ElmMdcMouseUp"
          , "ElmMdcPointerUp"
          , "ElmMdcTouchEnd"
          ]

        downs =
            [ "mousedown"
            , "pointerdown"
            , "touchstart"
            ]

        moves =
          [ "ElmMdcMouseMove"
          , "ElmMdcTouchMove"
          , "ElmMdcPointerMove"
          ]

        activateOn_ event =
            Options.onWithOptions event
                { stopPropagation = True
                , preventDefault = False
                }
                (Json.map (Activate False >> lift) decodeGeometry)

        trackScale =
            if config.max - config.min == 0 then
                0
            else
                (value - config.min) / (config.max - config.min)
    in
        Internal.apply summary Html.div
        [ cs "mdc-slider"
        , cs "mdc-slider--focus" |> when model.focus
        , cs "mdc-slider--active" |> when model.active
        , cs "mdc-slider--off" |> when (value <= config.min)
        , cs "mdc-slider--discrete" |> when config.discrete
        , cs "mdc-slider--in-transit" |> when model.inTransit
        , cs "mdc-slider--display-markers" |> when config.trackMarkers
        , Options.attribute (Html.tabindex 0)
        , Options.on "focus" (Json.succeed (lift Focus))
        , Options.on "blur" (Json.succeed (lift Blur))
        , Options.data "min" (toString config.min)
        , Options.data "max" (toString config.max)
        , Options.data "steps" (toString config.steps)
          |> when config.discrete

        , initOn "ElmMdcInit"

        , List.map activateOn downs
          |> Options.many

        , when model.active <|
          Options.many << List.concat <|
          [ (List.map upOn (List.concat [ups, ["blur"]]))
          , (List.map dragOn moves)
          ]

        , when (config.onChange /= Nothing) <|
          if model.active then
              Options.many (List.map changeOn ups)
          else
              Options.nop

        , when (config.onInput /= Nothing) <|
          if model.active then
              Options.many (List.map inputOn (List.concat [downs, ups, moves]))
          else
              Options.many (List.map inputOn downs)
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
                    [
                    ]
                  )
                ]
              else
                []
            ]
          )
        ,
          styled Html.div
          [ cs "mdc-slider__thumb-container"
          , Options.many (List.map activateOn_ downs)
          , css "transform" ("translateX(" ++ toString translateX ++ "px) translateX(-50%)")
          , Options.on "transitionend" (Json.succeed (lift Tick))
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



-- COMPONENT


type alias Store s =
    { s | slider : Indexed Model }


( get, set ) =
    Component.indexed .slider (\x y -> { y | slider = x }) defaultModel


{-| Component react function (update variant). Internal use only.
-}
react :
    (Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react lift msg idx store =
    update lift msg (get idx store)
        |> Helpers.map1st (set idx store >> Just)

        -- TODO: ^^^^^ react


{-|
-}
render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render lift index store options =
    Component.render get view Material.Msg.SliderMsg lift index store
        (Internal.dispatch lift :: options)


targetValue : Decoder Float
targetValue =
    Json.map
       (\ geometry ->
            if geometry.discrete then
                discretize (Maybe.withDefault 1 geometry.steps) (computeValue geometry)
            else
                computeValue geometry
       )
       decodeGeometry


discretize : Int -> Float -> Float
discretize steps continuousValue =
    toFloat (steps * round (continuousValue / toFloat steps))


computeValue : Geometry -> Float
computeValue geometry =
    let
        c =
            if geometry.width /= 0 then
                (geometry.x - geometry.left) / geometry.width
            else
                0
            |> clamp 0 1

    in
    geometry.min + c * (geometry.max - geometry.min)
    |> clamp geometry.min geometry.max


decodeGeometry : Decoder Geometry
decodeGeometry =
    Json.oneOf
    [ Json.at [ "pageX" ] Json.float
    , Json.succeed 0
    ]
    |> Json.andThen (\ x ->
          DOM.target <|
          traverseToContainer <|
          Json.map6
              ( \offsetWidth offsetLeft discrete min max steps ->
                  { width = offsetWidth
                  , left = offsetLeft
                  , x = x
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
          )


data : String -> Decoder a -> Decoder a
data key decoder =
    Json.at [ "dataset", key ] decoder


traverseToContainer : Decoder a -> Decoder a
traverseToContainer decoder =
    hasClass "mdc-slider"
    |> Json.andThen (\ doesHaveClass ->
        if doesHaveClass then
            decoder
        else
            DOM.parentElement (Json.lazy (\_ -> traverseToContainer decoder))
    )


hasClass : String -> Decoder Bool
hasClass class =
    Json.map
      ( \className ->
          String.contains (" " ++ class ++ " ") (" " ++ className ++ " ")
      )
      ( Json.at [ "className" ] Json.string )


onChange : Decoder m -> Property m
onChange =
    Internal.option << (\ decoder config -> { config | onChange = Just decoder } )


onInput : Decoder m -> Property m
onInput =
    Internal.option << (\ decoder config -> { config | onInput = Just decoder } )


steps : Int -> Property m
steps =
    Internal.option << (\ steps config -> { config | steps = steps } )


trackMarkers : Property m
trackMarkers =
    Internal.option (\ config -> { config | trackMarkers = True } )
