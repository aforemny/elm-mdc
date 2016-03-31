module Material.Button
  ( Model, model, Action(Click), update
  , flat, raised, fab, minifab, icon
  , colored, primary, accent
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

# Style
@docs colored, primary, accent

# View
Refer to the
[Material Design Specification](https://www.google.com/design/spec/components/buttons.html)
for details about what type of buttons are appropriate for which situations.

@docs flat, raised, fab, minifab, icon

-}

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Effects exposing (Effects, none)
import Signal exposing (Address, forwardTo)

import Material.Helpers as Helpers
import Material.Style exposing (Style, cs, cs', styled)
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


{-| Color button with primary or accent color depending on button type.
-}
colored : Style
colored =
  cs "mdl-button--colored"


{-| Color button with primary color.
-}
primary : Style
primary =
  cs "mdl-button--primary"


{-| Color button with accent color. 
-}
accent : Style
accent = 
  cs "mdl-button--accent"


view : String -> Address Action -> Model -> List Style -> List Html -> Html
view kind addr model styling html =
  styled button 
    (  cs "mdl-button"
    :: cs "mdl-js-button"
    :: cs' "mdl-js-ripple-effect" (model /= S Nothing)
    :: cs' kind (kind /= "")
    :: styling
    )
    [ Helpers.blurOn "mouseup"
    , Helpers.blurOn "mouseleave"
    , onClick addr Click
    ]
    (case model of
      S (Just ripple) ->
        Ripple.view
          (forwardTo addr Ripple)
          [ class "mdl-button__ripple-container"
          , Helpers.blurOn "mouseup" 
          ]
          ripple
        :: html
      _ -> html)


-- Fake address (for link buttons). 


addr : Signal.Address Action
addr = (Signal.mailbox Click).address



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
flat : Address Action -> Model -> List Style -> List Html -> Html
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
raised : Address Action -> Model -> List Style -> List Html -> Html
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
fab : Address Action -> Model -> List Style -> List Html -> Html
fab = view "mdl-button--fab"


{-| Mini-sized variant of a Floating Action Button; refer to `fab`.
-}
minifab : Address Action -> Model -> List Style -> List Html -> Html
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
icon : Address Action -> Model -> List Style -> List Html -> Html
icon = view "mdl-button--icon"

