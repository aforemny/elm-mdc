module Material.Menu
  ( Model, defaultModel
  , Item
  , Action, update
  , view
  , Property
  , bottomLeft, bottomRight, topLeft, topRight, ripple
  , render
  ) where

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#menus-section):

> The Material Design Lite (MDL) menu component is a user interface element
> that allows users to select one of a number of options. The selection
> typically results in an action initiation, a setting change, or other
> observable effect. Menu options are always presented in sets of two or
> more, and options may be programmatically enabled or disabled as required.
> The menu appears when the user is asked to choose among a series of
> options, and is usually dismissed after the choice is made.

> Menus are an established but non-standardized feature in user interfaces,
> and allow users to make choices that direct the activity, progress, or
> characteristics of software. Their design and use is an important factor in
> the overall user experience. See the menu component's Material Design
> specifications page for details.

See also the
[Material Design Specification]([https://www.google.com/design/spec/components/menus.html).

Refer to
[this site](https://debois.github.io/elm-mdl/#/menus)
for a live demo.

# Elm architecture
@docs Model, model, Action, update, View

# Alignment
@docs bottomLeft, bottomRight, topLeft, topRight, unaligned
-}


import Array exposing (Array)
import Dict exposing (Dict)
import Effects exposing (Effects, none)
import Html.Attributes as Html exposing (..)
import Html.Events as Html exposing (defaultOptions)
import Html exposing (..)
import Json.Decode as Json exposing (Decoder)
import Json.Encode exposing (string)
import Material.Helpers exposing (..)
import String
import Task
import Signal exposing (Address)

import Material.Menu.Geometry as Geometry exposing (Geometry)
import Material.Ripple as Ripple
import Material.Options as Options exposing (Style, cs, css, styled, styled')
import Material.Icon as Icon
import Parts exposing (Indexed, Index)


-- CONSTANTS


constant :
  { transitionDurationSeconds  : Float
  , transitionDurationFraction : Float
  , closeTimeout               : Float
  }
constant =
  { transitionDurationSeconds  = 0.3
  , transitionDurationFraction = 0.8
  , closeTimeout               = 150
  }


-- TODO: Key codes are not implemented yet.


--keycodes =
--  { enter     = 13
--  , escape    = 27
--  , space     = 32
--  , upArrow   = 38
--  , downArrow = 40
--  }


-- MODEL


{-| TODO. 
-}
type alias Model =
  { items : Dict Int Ripple.Model
  , animationState : AnimationState
  , geometry : Maybe Geometry
  }


type AnimationState
  = Idle
  | Opening
  | Opened
  | Closing


{-| TODO.
-}
defaultModel : Model
defaultModel =
  { items = Dict.empty
  , animationState = Idle
  , geometry = Nothing
  }


-- ITEM


{-| Item model.
-}
type alias Item =
  { divider : Bool
  , enabled : Bool
  , html : Html
  }


-- ACTION, UPDATE


{-| Component action.
-}
type Action
  = Open Geometry
  | Select Int Geometry
  | Close Geometry
  | Tick
  | Ripple Int Ripple.Action


{-| Component update.
-}
update : Action -> Model -> (Model, Effects Action)
update action model =

  case action of
    Open geometry ->
      ( { model 
        | animationState =
            case model.animationState of
              Opened  -> Opened
              _       -> Opening
        , geometry = Just geometry
        }
      , fx Tick
      )

    Tick ->
      ( { model | animationState = Opened }
      , Effects.none 
      )

    Close geometry ->
      ( { model 
        | animationState = Idle
        , geometry = Just geometry
        }
      , Effects.none
      )

    Select idx geometry ->
      -- Close the menu after some delay for the ripple effect to show.
      ( { model | animationState = Closing }
      , Effects.task
          <| Task.andThen (Task.sleep constant.closeTimeout) << always
          <| Task.succeed (Close geometry) 
      )

    Ripple idx action ->
      let
        (model', effects) = 
          Dict.get idx model.items
           |> Maybe.withDefault Ripple.model
           |> Ripple.update action
      in
        ( { model | items = Dict.insert idx model' model.items }
        , Effects.map (Ripple idx) effects 
        )


-- PROPERTIES


{-| Menu alignment.
This specifies where the menu opens in relation to the
button, rather than where the menu is positioned.
-}
type Alignment =
    BottomLeft
  | BottomRight
  | TopLeft
  | TopRight


type alias Config = 
  { alignment : Alignment 
  , ripple : Bool 
  }


defaultConfig : Config 
defaultConfig = 
  { alignment = BottomLeft
  , ripple = False
  }


type alias Property = 
  Options.Property Config


{-|
-}
ripple : Property 
ripple = 
  Options.set (\config -> { config | ripple = True })


{-|
-}
bottomLeft : Property 
bottomLeft = 
  Options.set (\config -> { config | alignment = BottomLeft })


{-|
-}
bottomRight : Property 
bottomRight = 
  Options.set (\config -> { config | alignment = BottomRight })


{-|
-}
topLeft : Property 
topLeft = 
  Options.set (\config -> { config | alignment = TopLeft })


{-|
-}
topRight : Property 
topRight = 
  Options.set (\config -> { config | alignment = TopRight })



-- VIEW



{-| Component view.
-}


containerGeometry : Config -> Geometry -> List Property
containerGeometry config geometry =
  [ css "width" <| toPx geometry.menu.bounds.width 
  , css "height" <| toPx geometry.menu.bounds.height 
  , if (config.alignment == BottomRight) || (config.alignment == BottomLeft) then
      css "top" <| toPx (geometry.button.offsetTop + geometry.button.offsetHeight)
    else 
      Options.nop
  , if (config.alignment == BottomRight) || (config.alignment == TopRight) then
      let
        right e = e.bounds.left + e.bounds.width
      in
        css "right" <| toPx (right geometry.container - right geometry.menu)
    else
      Options.nop
  , if (config.alignment == TopLeft) || (config.alignment == TopRight) then
      let
        bottom =
          geometry.container.bounds.top + geometry.container.bounds.height
      in
        css "bottom" <| toPx (bottom - geometry.button.bounds.top) 
    else
      Options.nop
  , if (config.alignment == TopLeft) || (config.alignment == BottomLeft) then
      css "left" <| toPx geometry.menu.offsetLeft 
    else
      Options.nop
  ]


outlineGeometry : Config -> Geometry -> List Style
outlineGeometry config geometry = 
  [] 

view : Address Action -> Model -> List Property -> List Item -> Html
view addr model properties items =
  let 
    summary = Options.collect defaultConfig properties
    config = summary.config
  in
    div 
      []
      [ styled' button
        [ cs "mdl-button"
        , cs "mdl-js-button"
        , cs "mdl-button--icon"
        ]
        [ onClick addr Geometry.decode 
            (if model.animationState == Opened then Close else Open)
        ]
        [ Icon.view "more_vert" 
          [ cs "material-icons"
          , css "pointer-events" "none"
          ]
        ]
      , styled div
        [ cs "mdl-menu__container"
        , cs "is-upgraded"
        , cs' "is-visible" 
            ((model.animationState == Opened) || (model.animationState == Closing))
        , model.geometry 
            |> Maybe.map (containerGeometry config >> Options.many)
            |> Maybe.withDefault (Options.nop)
        ]
        [ styled div
          [ cs "mdl-menu__outline"
          , model.geometry 
              |> Maybe.map (\geometry -> 
                  [ css "width" <| toPx (geometry.menu.bounds.width)
                  , css "height" <| toPx (geometry.menu.bounds.height)
                  ])
              |> Maybe.withDefault []
              |> Options.many
          , case config.alignment of
              BottomLeft  -> cs "mdl-menu--bottom-left"
              BottomRight -> cs "mdl-menu--bottom-right"
              TopLeft     -> cs "mdl-menu--top-left"
              TopRight    -> cs "mdl-menu--top-right"
          ]
          []
        , styled ul
            [ cs "mdl-menu"
            , cs "mdl-js-menu"
            , case config.alignment of
                BottomLeft -> cs "mdl-menu--bottom-left"
                BottomRight -> cs "mdl-menu--bottom-right"
                TopLeft -> cs "mdl-menu--top-left"
                TopRight -> cs "mdl-menu--top-right"
            , cs' "is-animating" 
                ((model.animationState == Opening) 
                || (model.animationState == Closing))
            , model.geometry
                |> Maybe.map (\geometry -> 
                   let
                     width  = geometry.menu.bounds.width
                     height = geometry.menu.bounds.height
                   in
                     (if (model.animationState == Opened) 
                       || (model.animationState == Closing) 
                     then
                         rect 0 width height 0
                     else
                       case config.alignment of
                         BottomRight -> rect 0 width 0 width
                         TopLeft -> rect height 0 height 0
                         TopRight -> rect height width height width
                         _ -> ""
                     ) |> css "clip"
                   )
                |> Maybe.withDefault Options.nop
            ]
            (List.map2 (makeItem addr config model) [1..List.length items] items)
        ]
      ]


makeItem : Address Action -> Config -> Model -> Int -> Item -> Html
makeItem addr config model n item =
  let
    transitionDuration =
      constant.transitionDurationSeconds *
      constant.transitionDurationFraction

    offsetTop n =
      model.geometry
        |> flip Maybe.andThen (.offsetTops >> Array.get (n-1)) -- n is 1-based
        |> Maybe.withDefault 0

    offsetHeight n =
      model.geometry 
        |> flip Maybe.andThen (.offsetHeights >> Array.get (n-1)) -- n is 1-based
        |> Maybe.withDefault 0

    height =
      model.geometry 
        |> Maybe.map (\geometry -> geometry.menu.bounds.height)
        |> Maybe.withDefault 0

    itemDelay =
      if config.alignment == TopLeft || config.alignment == TopRight then
        (height - offsetTop n - offsetHeight n) / height * transitionDuration
        |> toString
        |> flip (++) "s"
      else
        ((offsetTop n) / height * transitionDuration)
        |> toString
        |> flip (++) "s"

    addr' = 
      Signal.forwardTo addr (Ripple n)

  in
    styled' li
      [ cs "mdl-menu__item"
      , css' "transition-delay" itemDelay 
          ((model.animationState == Opening) || (model.animationState == Opened))
      , cs' "mdl-js-ripple-effect" config.ripple
      , cs' "mdl-menu__item--full-bleed-divider" item.divider
      ]
      [ if item.enabled then
           onClick addr Geometry.decode' (Select n)
         else
           Html.attribute "disabled" "disabled"
      , Html.property "tabindex" (string "-1")
      , Ripple.downOn "mousedown" addr'
      , Ripple.downOn "touchstart" addr'
      , Ripple.upOn "mouseup" addr'
      , Ripple.upOn "mouseleave" addr'
      , Ripple.upOn "touchend" addr'
      , Ripple.upOn "blur" addr'
      ]
      ( if config.ripple then
          [ item.html
          , Ripple.view
            ( Signal.forwardTo addr (Ripple n))
            [ Html.class "mdl-menu__item-ripple-container" ]
            ( Dict.get n model.items
              |> Maybe.withDefault Ripple.model)
          ]
        else
          [ item.html ]
      )


-- COMPONENT


{-|
-}
type alias Container c =
  { c | menu : Indexed Model }


{-|
-}
render 
  : (Parts.Action (Container c) obs -> obs)
  -> Parts.Index
  -> Address obs
  -> Container c
  -> List Property
  -> List Item
  -> Html
render = 
  Parts.create view update .menu (\x y -> {y | menu=x}) defaultModel 
    
  
-- HELPERS


onClick :
  Address Action
  -> Decoder Geometry
  -> (Geometry -> Action)
  -> Attribute
onClick addr decoder action =
  Html.onWithOptions
  "click"
  defaultOptions
  decoder
  (Signal.message addr << action)


rect : Float -> Float -> Float -> Float -> String
rect x y w h =
 [x,y,w,h]
 |> List.map toPx
 |> String.join " "
 |> (\coords -> "rect(" ++ coords ++ ")")


toPx : Float -> String
toPx = toString >> flip (++) "px"


cs' : String -> Bool -> Options.Property a
cs' c p = 
  if p then cs c else Options.nop


css' : String -> String -> Bool -> Options.Property a
css' k v p = 
  if p then css k v else Options.nop 

