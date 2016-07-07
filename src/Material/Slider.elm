module Material.Slider exposing (..)

{-| From the [Material Design Lite documentation](https://material.google.com/components/sliders.html):

> The Material Design Lite (MDL) slider component is an enhanced version of the
> new HTML5 `<input type="range">` element. A slider consists of a horizontal line
> upon which sits a small, movable disc (the thumb) and, typically, text that
> clearly communicates a value that will be set when the user moves it.
>
> Sliders are a fairly new feature in user interfaces, and allow users to choose a
> value from a predetermined range by moving the thumb through the range (lower
> values to the left, higher values to the right). Their design and use is an
> important factor in the overall user experience. See the slider component's
> [Material Design specifications](https://material.google.com/components/sliders.html) page for details.
>
> The enhanced slider component may be initially or programmatically disabled.

See also the
[Material Design Specification](https://material.google.com/components/sliders.html).

Refer to [this site](http://debois.github.io/elm-mdl#/sliders)
for a live demo.

@docs Model, model, Msg, update
@docs view

# Component support

@docs Container, Observer, Instance, instance, fwdTemplate
-}

-- TEMPLATE. Copy this to a file for your component, then update.

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.Attributes as Html
import Html.Events as Html
import Parts exposing (Indexed)
import Material.Options as Options exposing (cs, css, when)
import Material.Options.Internal as Internal
import Material.Helpers as Helpers
import Json.Decode as Json
import DOM


-- MODEL


{-| Component model.
-}
type alias Model =
  {}


{-| Default component model constructor.
-}
defaultModel : Model
defaultModel =
  {}



-- ACTION, UPDATE


{-| Component action.
-}
type Msg
  = MyMsg


{-| Component update.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
  ( model, none )



-- PROPERTIES


type alias Config m =
  { value : Float
  , min : Float
  , max : Float
  , step : Float
  , listener : Maybe (Float -> m)
  , disabled : Bool
  }


defaultConfig : Config m
defaultConfig =
  { value = 50
  , min = 0
  , max = 100
  , step = 1
  , listener = Nothing
  , disabled = False
  }


type alias Property m =
  Options.Property (Config m) m


{-| Sets current value
-}
value : Float -> Property m
value v =
  Options.set (\options -> { options | value = v })


{-| Sets the step. Defaults to 0
-}
min : Float -> Property m
min v =
  Options.set (\options -> { options | min = v })


{-| Sets the step. Defaults to 100
-}
max : Float -> Property m
max v =
  Options.set (\options -> { options | max = v })


{-| Sets the step. Defaults to 1
-}
step : Float -> Property m
step v =
  Options.set (\options -> { options | step = v })


{-| Disables the slider
-}
disabled : Property m
disabled =
  Options.set (\options -> { options | disabled = True })


{-| onChange listener for slider values
-}
onChange : (Float -> m) -> Property m
onChange l =
  Options.set (\options -> { options | listener = Just l })


-- VIEW


floatVal : Json.Decoder Float
floatVal =
  Debug.log "JSON" (Json.at [ "target", "valueAsNumber" ] Json.float)


{-| Component view.
-}
view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options elems =
  let
    summary =
      Options.collect defaultConfig options

    config =
      summary.config

    fraction =
      (config.value - config.min) / (config.max - config.min)

    lower =
      (toString fraction) ++ " 1 0%"

    upper =
      (toString (1 - fraction)) ++ " 1 0%"

    -- NOTE: does not work with IE yet. needs mdl-slider__ie-container
    -- and some additional logic
    background =
      Options.styled Html.div
        [ cs "mdl-slider__background-flex" ]
        [ Options.styled Html.div
            [ cs "mdl-slider__background-lower"
            , css "flex" lower
            ]
            []
        , Options.styled Html.div
            [ cs "mdl-slider__background-upper"
            , css "flex" upper
            ]
            []
        ]


    attr : String -> String -> Property m
    attr a v =
      (Html.attribute a v) |> Internal.attribute

    onchange =
      case config.listener of
        Nothing ->
          Options.nop

        Just fun ->
          Internal.attribute <| Html.on "change" (Json.map fun floatVal)

    oninput =
      case config.listener of
        Nothing ->
          Options.nop

        Just fun ->
          Internal.attribute <| Html.on "input" (Json.map fun floatVal)
  in
    Options.styled Html.div
      [ cs "mdl-slider__container"
      ]
      [ Options.styled' Html.input
          [ cs "mdl-slider"
          , cs "mdl-js-slider"
          , cs "is-upgraded"
          , cs "is-lowest-value" `when` (fraction == 0)
          , onchange
          , oninput
          , if config.disabled then
              attr "disabled" ""
            else
              Options.nop
          ]
          [ Html.type' "range"
          , Html.max (toString config.max)
          , Html.min (toString config.min)
          , Html.step (toString  config.step)
          
          , Html.attribute "value" (toString config.value)
          --, Html.attribute "value" "0"
          , Helpers.blurOn "mouseup"
          ]
          []
      , background
      ]



-- COMPONENT


type alias Container c =
  { c | slider : Indexed Model }


{-| Component render.
-}
render :
  (Parts.Msg (Container c) -> m)
  -> Parts.Index
  -> Container c
  -> List (Property m)
  -> List (Html m)
  -> Html m
render =
  Parts.create view update .slider (\x y -> { y | slider = x }) defaultModel
