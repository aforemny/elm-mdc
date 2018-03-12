module Material.Dialog exposing
    ( accept
    , backdrop
    , body
    , Property
    , cancel
    , footer
    , header
    , open
    , scrollable
    , surface
    , title
    , Model
    , view
    , openOn
    , react
    )

{-|
The Dialog component is a spec-aligned dialog component adhering to the
Material Design dialog pattern. It implements a modal dialog window that traps
focus when opening and restores focus when closing.  

The current implementation requires that a dialog has as first child a
`surface` element and as second child a `backdrop` element.


# Resources

- [Material Design guidelines: Dialogs](https://material.io/guidelines/components/dialogs.html)
- [Demo](https://aforemny.github.io/elm-mdc/#dialog)


# Example

```elm
import Html exposing (text)
import Material.Button as Button
import Material.Dialog as Dialog
import Material.Options as Options exposing (styled)


Dialog.view Mdc [0] model.mdc
    [ Dialog.open
    ]
    [ Dialog.surface []
          [
            Dialog.header []
            [ styled Html.h2
                  [ Dialog.title
                  ]
                  [ text "Use Google's location service?"
                  ]
            ]
          ,
            Dialog.body []
                [ text
                    """
Let Google help apps determine location. This means
sending anonymous location data to Google, even when
no apps are running.
                    """
                ]
          ,
            Dialog.footer []
                [
                  Button.view Mdc [0,0] model.mdc
                      [ Button.ripple
                      , Dialog.cancel
                      , Options.onClick Cancel
                      ]
                      [ text "Decline"
                      ]
                ,
                  Button.view Mdc [0,1] model.mdc
                      [ Button.ripple
                      , Dialog.accept
                      , Options.onClick Accept
                      ]
                      [ text "Continue"
                      ]
                ]
          ]
    , Dialog.backdrop [] []
    ]
```


# Usage

@docs Property
@docs view
@docs open
@docs openOn
@docs surface
@docs backdrop
@docs header
@docs title
@docs body
@docs scrollable
@docs footer
@docs cancel
@docs accept


# Internal

@docs Model
@docs react
-}

import DOM
import Html exposing (..)
import Json.Decode as Json exposing (Decoder)
import Material.Button as Button
import Material.Component as Component exposing (Index, Indexed)
import Material.Internal.Dialog exposing (Msg(..))
import Material.Internal.Options as Internal
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when) 


{-| Dialog model.

Internal use only.
-}
type alias Model =
    { open : Bool
    , animating : Bool
    }


defaultModel : Model
defaultModel =
    { open = False
    , animating = False
    }


update : (Msg -> m) -> Msg -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    case msg of
        NoOp ->
            ( Nothing, Cmd.none )

        Open ->
            ( Just { model | open = True, animating = True }, Cmd.none )

        Close ->
            ( Just { model | open = False, animating = True }, Cmd.none )

        AnimationEnd ->
            ( Just { model | animating = False }, Cmd.none )


type alias Store s =
    { s | dialog : Indexed Model }


( get, set ) =
    Component.indexed .dialog (\x c -> { c | dialog = x }) defaultModel


{-| Dialog react.

Internal use only.
-}
react
    : (Material.Msg.Msg m -> msg)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd msg )
react =
    Component.react get set Material.Msg.DialogMsg update


{-| Dialog view.
-}
view
    : (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m       
view lift index store options =
    Component.render get dialog Material.Msg.DialogMsg lift index store
        (Internal.dispatch lift :: options)


type alias Config =
    {}


defaultConfig : Config
defaultConfig =
    {}


{-| Dialog property.
-}
type alias Property m =
    Options.Property Config m


dialog : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
dialog lift model options =
    styled Html.aside
    ( cs "mdc-dialog"
    :: ( when model.open << Options.many <|
         [ cs "mdc-dialog--open"
         , Options.data "focustrap" "mdc-dialog__footer__button--accept"
         ]
       )
    :: when model.animating (cs "mdc-dialog--animating")
    :: Options.on "click" (Json.map lift close)
    :: Options.on "transitionend" (Json.succeed (lift AnimationEnd))
    :: options
    )


{-| Make the dialog visible.
-}
open : Property m
open =
    cs "mdc-dialog--open"


{-| Dialog surface.

This element is required to be the first child of `view` and wraps all the
dialog's content such as the `header`, `body` and `footer`.
-}
surface : List (Property m) -> List (Html m) -> Html m
surface options =
    styled Html.div (cs "mdc-dialog__surface" :: options)


{-| Dialog backdrop.

This element is required to be the second child of `view` and adds a backdrop
to the dialog.
-}
backdrop : List (Property m) -> List (Html m) -> Html m
backdrop options =
    styled Html.div (cs "mdc-dialog__backdrop" :: options)


{-| Dialog body.

This element wraps the dialog's content except for `header` and `footer`
content.
-}
body : List (Property m) -> List (Html m) -> Html m
body options =
    styled Html.div (cs "mdc-dialog__body"::options)


{-| Make the dialog's body scrollable.
-}
scrollable : Property m
scrollable =
    cs "mdc-dialog__body--scrollable"


{-| Dialog header.
-}
header : List (Property m) -> List (Html m) -> Html m
header options =
    styled Html.div (cs "mdc-dialog__header"::options)


{-| Dialog title.
-}
title : Options.Property c m
title =
    cs "mdc-dialog__header__title"


{-| Dialog footer.
-}
footer : List (Property m) -> List (Html m) -> Html m
footer options =
    styled Html.div (cs "mdc-dialog__footer"::options)


{-| Style the button as cancel button.
-}
cancel : Button.Property m
cancel =
    cs "mdc-dialog__footer__button mdc-dialog__footer__button--cancel"


{-| Style the button as accept button.
-}
accept : Button.Property m
accept =
    cs "mdc-dialog__footer__button mdc-dialog__footer__button--accept"


{-| Opens the dialog on an event on another component.

```elm
Button.view Mdc [1] model.mdc
    [ Dialog.openOn Mdc [0] "click"
    ]
    [ text "Show Dialog with index [0]"
    ]
```
-}
openOn : (Material.Msg.Msg m -> m) -> List Int -> String -> Options.Property c m
openOn lift index event =
    Options.on event (Json.succeed (lift (Material.Msg.DialogMsg index Open)))


close : Decoder Msg
close =
    DOM.target <|
    Json.map (\ className ->
         let
           hasClass class =
               String.contains (" " ++ class ++ " ") (" " ++ className ++ " ")
         in
         if hasClass "mdc-dialog__backdrop" then
             Close
         else if hasClass "mdc-dialog__footer__button" then
             Close
         else
             NoOp
       )
       (Json.at ["className"] Json.string)
