module Material.Button
  ( model, update
  , Kind(..), Coloring(..), Config
  , view
  ) where

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#buttons-section):

> The Material Design Lite (MDL) button component is an enhanced version of the
> standard HTML `<button>` element. A button consists of text and/or an image that
> clearly communicates what action will occur when the user clicks or touches it.
> The MDL button component provides various types of buttons, and allows you to
> add both display and click effects.
> 
> Buttons are a ubiquitous feature of most user interfaces, regardless of a
> site's content or function. Their design and use is therefore an important
> factor in the overall user experience. See the button component's Material
> Design specifications page for details.
> 
> The available button display types are flat (default), raised, fab, mini-fab,
> and icon; any of these types may be plain (light gray) or colored, and may be
> initially or programmatically disabled. The fab, mini-fab, and icon button
> types typically use a small image as their caption rather than text.

See also the
[Material Design Specification]([https://www.google.com/design/spec/components/buttons.html).

# Component
@docs model, update

# View
@docs Kind, Coloring, Config, view

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Effects exposing (Effects)

import Material.Aux as Aux
import Material.Ripple as Ripple

{-| MDL button.
-}


-- MODEL


{-| Model of the button. Determines if the button will ripple when clicked;
use `initState` to initalise it.
-}
type Model = S (Maybe Ripple.Model)


{-| Model initialiser. Call with `True` if the button should ripple when
clicked, `False` otherwise.
-}
model : Bool -> Model
model shouldRipple =
  if shouldRipple then
    S (Just Ripple.model)
  else
    S Nothing


-- ACTION, UPDATE


{-| Component action. This exists exclusively to support ripple-animations.
To repsond to clicks, disable the button etc., supply event-handler attributes
to `view` as you would a regular button.
-}
type alias Action = Ripple.Action


{-| Component update.
-}
update : Action -> Model -> (Model, Effects Action)
update action model =
  case model of
    S (Just ripple) ->
      let (ripple', e) = Ripple.update action ripple
      in
        (S (Just ripple'), e)
    S Nothing ->
      (model, Effects.none)


-- VIEW


{-| Type of button. Refer to the
[Material Design Specification](https://www.google.com/design/spec/components/buttons.html)
for what these look like and what they
are supposed to be used for.
-}
type Kind
  = Flat
  | Raised
  | FAB
  | MiniFAB
  | Icon


{-| Coloring of a button. `Plain` respectively `Colored` is the button's
uncolored respectively colored defaults.
`Primary` respectively `Accent` chooses a colored button with the indicated
color.
-}
type Coloring
  = Plain
  | Colored
  | Primary
  | Accent


{-| Button configuration: Its `Kind` and `Coloring`.
-}
type alias Config =
  { kind : Kind
  , coloring : Coloring
  }


{-| Construct a button view. Kind and coloring is given by 
`Config`. To interact with the button, supply the usual
event-handler attributes, e.g., `onClick`. To disable the button, add the
standard HTML `disabled` attribute.

NB! This implementation will override the properties `class`, `onmouseup`, 
and `onmouseleave` even if you specify them as part of `List Attributes`. 
-}
view : Signal.Address Action -> Config -> Model -> List Attribute -> List Html -> Html
view addr config model attrs html =
  button
    (classList
      [ ("mdl-button", True)
      , ("mdl-js-button", True)
      , ("mdl-js-ripple-effect", model /= S Nothing)
      -- Color effect.
      , ("mdl-button--colored", config.coloring == Colored)
      , ("mdl-button--primary", config.coloring == Primary)
      , ("mdl-button--accent",  config.coloring == Accent)
      -- Kind.
      , ("mdl-button--raised",   config.kind == Raised)
      , ("mdl-button--fab",      config.kind == FAB || config.kind == MiniFAB)
      , ("mdl-button--mini-fab", config.kind == MiniFAB)
      , ("mdl-button--icon",     config.kind == Icon)
      ]
      :: Aux.blurOn "mouseup"
      :: Aux.blurOn "mouseleave"
      :: attrs)
     (case model of
        S (Just ripple) ->
          Ripple.view
            addr
            [ class "mdl-button__ripple-container"
            , Aux.blurOn "mouseup" ]
            ripple
          :: html
        _ -> html)
