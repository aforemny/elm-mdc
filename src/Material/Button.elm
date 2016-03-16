module Material.Button
  ( Model, model, Action(Click), update
  , Coloring(..)
  , flat, raised, fab, minifab, icon
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
@docs Model, model, Action, update

# View
Refer to the
[Material Design Specification](https://www.google.com/design/spec/components/buttons.html)
for details about what type of buttons are appropriate for which situations.

@docs Coloring, flat, raised, fab, minifab, icon

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects, none)

import Material.Helpers as Helpers
import Material.Ripple as Ripple

{-| MDL button.
-}


-- MODEL


{-| Model of the button; common to all kinds of button.
Use `model` to initalise it.
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


{-| Component action. The `Click` action fires when the button is clicked.
-}
type Action
  = Ripple Ripple.Action
  | Click


{-| Component update.
-}
update : Action -> Model -> (Model, Effects Action)
update action model =
  case action of
    Click ->
      (model, none)

    Ripple action' ->
      case model of
        S (Just ripple) ->
          let (ripple', e) = Ripple.update action' ripple
          in
            (S (Just ripple'), Effects.map Ripple e)
        S Nothing ->
          (model, none)


-- VIEW


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


view : String -> Signal.Address Action -> Model -> Coloring -> List Html -> Html
view kind addr model coloring html =
  button
    [ classList
      [ ("mdl-button", True)
      , ("mdl-js-button", True)
      , ("mdl-js-ripple-effect", model /= S Nothing)
      -- Color effect.
      , ("mdl-button--colored", coloring == Colored)
      , ("mdl-button--primary", coloring == Primary)
      , ("mdl-button--accent",  coloring == Accent)
      -- Kind.
      , (kind, kind /= "")
      ]
    , Helpers.blurOn "mouseup"
    , Helpers.blurOn "mouseleave"
    , onClick addr Click
    ]
    (case model of
      S (Just ripple) ->
        Ripple.view
          (Signal.forwardTo addr Ripple)
          [ class "mdl-button__ripple-container"
          , Helpers.blurOn "mouseup" ]
          ripple
        :: html
      _ -> html)


{-| From the
[Material Design Specification](https://www.google.com/design/spec/components/buttons.html#buttons-flat-buttons):

> Flat buttons are printed on material. They do not lift, but fill with color on
> press.
>
> Use flat buttons in the following locations:
>
>  - On toolbars
>  - In dialogs, to unify the button action with the dialog content
>  - Inline, with padding, so the user can easily find them

Example use (uncolored flat button, assuming properly setup model):

    import Material.Button as Button

    flatButton : Html
    flatButton = Button.flat addr model Button.Plain [text "Click me!"]

-}
flat : Signal.Address Action -> Model -> Coloring -> List Html -> Html
flat = view ""


{-| From the
[Material Design Specification](https://www.google.com/design/spec/components/buttons.html#buttons-raised-buttons):

> Raised buttons add dimension to mostly flat layouts. They emphasize functions
> on busy or wide spaces.
>
> Raised buttons behave like a piece of material resting on another sheet –
> they lift and fill with color on press.

Example use (colored raised button, assuming properly setup model):

    import Material.Button as Button

    raisedButton : Html
    raisedButton = Button.raised addr model Button.Colored [text "Click me!"]

-}
raised : Signal.Address Action -> Model -> Coloring -> List Html -> Html
raised = view "mdl-button--raised"


{-| Floating Action Button. From the
[Material Design Specification](https://www.google.com/design/spec/components/buttons-floating-action-button.html):

> Floating action buttons are used for a promoted action. They are distinguished
> by a circled icon floating above the UI and have motion behaviors that include
> morphing, launching, and a transferring anchor point.
>
> Floating action buttons come in two sizes:
>
>  - Default size: For most use cases
>  - Mini size: Only used to create visual continuity with other screen elements

This constructor produces the default size, use `minifab` to get the mini-size.

Example use (colored with a '+' icon):

    import Material.Button as Button
    import Material.Icon as Icon

    fabButton : Html
    fabButton = fab addr model Colored [Icon.i "add"]
-}
fab : Signal.Address Action -> Model -> Coloring -> List Html -> Html
fab = view "mdl-button--fab"


{-| Mini-sized variant of a Floating Action Button; refer to `fab`.
-}
minifab : Signal.Address Action -> Model -> Coloring -> List Html -> Html
minifab = view "mdl-button--mini-fab"


{-| The [Material Design Lite implementation](https://www.getmdl.io/components/index.html#buttons-section)
also offers an "icon button", which we
re-implement here. See also
[Material Design Specification](http://www.google.com/design/spec/components/buttons.html#buttons-toggle-buttons).
Example use (no color, displaying a '+' icon):

    import Material.Button as Button
    import Material.Icon as Icon

    iconButton : Html
    iconButton = icon addr model Plain [Icon.i "add"]
-}
icon : Signal.Address Action -> Model -> Coloring -> List Html -> Html
icon = view "mdl-button--icon"
