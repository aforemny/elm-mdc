module Material.Slider exposing
  ( Model, defaultModel, Msg, update, view
  , Property
  , render
  )

-- TEMPLATE. Copy this to a file for your component, then update.

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


import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Html.Attributes as Html
import Html.Events as Html

import Parts exposing (Indexed)
import Material.Options as Options exposing (Style, cs, css)


-- MODEL


{-| Component model.
-}
type alias Model =
  {
  }


{-| Default component model constructor.
-}
defaultModel : Model
defaultModel =
  {
  }


-- ACTION, UPDATE


{-| Component action.
-}
type Msg
  = MyMsg


{-| Component update.
-}
update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  (model, none)


-- PROPERTIES


type alias Config =
  {
  }


defaultConfig : Config
defaultConfig =
  {
  }


type alias Property m =
  Options.Property Config m


{- See src/Material/Button.elm for an example of, e.g., an onClick handler.
-}


-- VIEW
{-
  MaterialSlider.prototype.CssClasses_ = {
    IE_CONTAINER: 'mdl-slider__ie-container',
    SLIDER_CONTAINER: 'mdl-slider__container',
    BACKGROUND_FLEX: 'mdl-slider__background-flex',
    BACKGROUND_LOWER: 'mdl-slider__background-lower',
    BACKGROUND_UPPER: 'mdl-slider__background-upper',
    IS_LOWEST_VALUE: 'is-lowest-value',
    IS_UPGRADED: 'is-upgraded'
  };
-}


{-| Component view.
-}
view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options elems =
  let
    summary =
      Options.collect defaultConfig options

    config =
      summary.config

    background =
      Options.styled Html.div
        [cs "mdl-slider__background-flex"]
        [ Options.styled Html.div
            [ cs "mdl-slider__background-lower"
            , css "flex" "0 1 0%"
            ]
            []
        , Options.styled Html.div
            [ cs "mdl-slider__background-upper"
            , css "flex" "1 1 0%"
            ]
            []
        ]
  in
    Options.styled Html.div
      [cs "mdl-slider__container"]
      [ Html.input
          [ Html.classList [ ("mdl-slider", True)
                           , ("mdl-js-slider", True)
                           , ("is-upgraded", True)
                           , ("is-lowest-value", True)
                           ]

          , Html.type' "range"
          , Html.min "0"
          , Html.max "100"
          , Html.value "0"
          ]
          []
      , background
      ]


-- COMPONENT

type alias Container c =
  { c | slider : Indexed Model }


{-| Component render.
-}
render
  : (Parts.Msg (Container c) -> m)
  -> Parts.Index
  -> (Container c)
  -> List (Property m)
  -> List (Html m)
  -> Html m
render =
  Parts.create view update .slider (\x y -> {y | slider = x}) defaultModel

{- See src/Material/Layout.mdl for how to add subscriptions. -}
