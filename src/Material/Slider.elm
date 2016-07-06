module Material.Slider exposing (..)

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#TEMPLATE-section):

> ...

See also the
[Material Design Specification]([https://www.google.com/design/spec/components/TEMPLATE.html).

Refer to [this site](http://debois.github.io/elm-mdl#/template)
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
import Material.Options as Options exposing (cs, css)
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
  , listener : Maybe (Float -> m)
  }


defaultConfig : Config m
defaultConfig =
  { value = 0
  , min = 0
  , max = 100
  , listener = Nothing
  }


type alias Property m =
  Options.Property (Config m) m


value : Float -> Property m
value v =
  Options.set (\options -> { options | value = v })


onChange : (Float -> m) -> Property m
onChange l =
  Options.set (\options -> { options | listener = Just l })



{- See src/Material/Button.elm for an example of, e.g., an onClick handler. -}
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
  in
    Options.styled Html.div
      [ cs "mdl-slider__container"
      ]
      [ Html.input
          [ Html.classList
              [ ( "mdl-slider", True )
              , ( "mdl-js-slider", True )
              , ( "is-upgraded", True )
              , ( "is-lowest-value", fraction == 0 )
              ]
          , Html.type' "range"
          , Html.min "0"
          , Html.max "100"
            --, Html.value
          , Html.attribute "value" "0"
          , case config.listener of
              Just l ->
                Html.on "change" (Json.map l floatVal)

              Nothing ->
                Helpers.noAttr
          , case config.listener of
              Just l ->
                Html.on "input" (Json.map l floatVal)

              Nothing ->
                Helpers.noAttr
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
