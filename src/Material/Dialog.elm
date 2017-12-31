module Material.Dialog
    exposing
        ( view
        , header
        , title
        , body
        , scrollable
        , footer
        , acceptButton
        , cancelButton
        , openOn
        , closeOn
        )

{-| From the [Material Design Lite documentation](https://getmdl.io/components/#cards-section):

> The Material Design Lite (MDL) dialog component allows for verification of user
> actions, simple data input, and alerts to provide extra information to users.
>
> To use the dialog component, you must be using a browser that supports the
> dialog element. Only Chrome and Opera have native support at the time of
> writing. For other browsers you will need to include the dialog polyfill
> or create your own.

Refer to [this site](http://debois.github.io/elm-mdl/#dialog)
for a live demo.

@docs view

# Contents
@docs title, body, header, footer, scrollable

# Opening & closing
@docs openOn, closeOn

# Buttons
@docs acceptButton, cancelButton

-}

import Html exposing (..)
import Html.Attributes as Html
import Material.Options as Options exposing (Style, Property, cs)
import Material.Internal.Options as Internal


{-| Dialog header
-}
header : List (Style a) -> List (Html a) -> Html a
header options =
    Options.div (cs "mdc-dialog__header"::options)


{-| Dialog title
-}
title : List (Style a) -> List (Html a) -> Html a
title options =
    Options.div (cs "mdc-dialog__header__title"::options)


{-| Dialog body
-}
body : List (Style a) -> List (Html a) -> Html a
body options =
    Options.div (cs "mdc-dialog__body"::options)


{-| Make dialog body scrollable
-}
scrollable : Style a
scrollable =
    cs "mdc-dialog__body--scrollable"


{-| Generate an actions content block
-}
footer : List (Style a) -> List (Html a) -> Html a
footer options =
    Options.div (cs "mdc-dialog__footer"::options)


{-| Dialog's accept button
-}
acceptButton
  : (List (Options.Property s a) -> List (Html a) -> Html a)
  -> List (Options.Property s a)
  -> List (Html a)
  -> Html a
acceptButton button options =
    button (cs "mdc-dialog__footer__button"::cs "mdc-dialog__footer__button--accept"::options)


{-| Dialog's cancel button
-}
cancelButton
    : (List (Options.Property s a) -> List (Html a) -> Html a)
    -> List (Options.Property s a)
    -> List (Html a)
    -> Html a
cancelButton button options =
    button (cs "mdc-dialog__footer__button"::cs "mdc-dialog__footer__button--cancel"::options)


theDialog : String
theDialog =
    "elm-mdc-singleton-dialog"


{-| Open dialog in response to given DOM event. The DOM must also contain a
`dialog` produced using `Dialog.view`.  Use like this:

    Button.render Mdl [0] model.mdl
      [ Dialog.openOn "click" ]
      [ text "Open dialog" ]
-}
openOn : String -> Property c m
openOn =
    let
        handler =
            """
      // Don't mess up the elm runtime.
      try {
        var dialog = document.getElementById('""" ++ theDialog ++ """');
        if (! dialog) {
          console.log ('Cannot display dialog: No dialog element. Use `Dialog.view` to construct one.');
          return;
        }
        if (! dialog.showModal) {
          if (typeof dialogPolyfill !== 'undefined' && dialogPolyfill.registerDialog) {
            dialogPolyfill.registerDialog(dialog);
          } else {
            console.log ('Cannot display dialog: Your browser does not support the <dialog> element. Get a polyfill at:\\n\\nhttps://github.com/GoogleChrome/dialog-polyfill\\n');
            return;
          }
        }
        dialog.showModal();
      }
      catch (e)
      {
        console.log ("A dialog method threw an exception. This is not supposed to happen; likely you're using a broken polyfill. If not, please file an issue:\\n\\nhttps://github.com/debois/elm-mdl/issues/new", e);
      }
      """
    in
        \event ->
            Html.attribute ("on" ++ event) handler
                |> Internal.attribute


{-| Close the dialog. The dialog must be open. Use like this:

    Button.render Mdl [1] model.mdl
      [ Dialog.closeOn "click" ]
      [ text "Close" ]
-}
closeOn : String -> Property c m
closeOn =
    let
        handler =
            """
      // Don't mess up the elm runtime!
      try {
        var dialog = document.getElementById('""" ++ theDialog ++ """');
        if (! dialog) {
          console.log ('Cannot close dialog: No dialog element. Use `Dialog.view` to construct one.');
          return;
        }
        if (! dialog.open) {
          console.log ('Cannot close dialog: The dialog is not open. Use `Dialog.closeOn` only on components rendered inside the dialog.');
          return;
        }
        if (! dialog.close) {
          console.log ('Cannot close dialog: The dialog does not have a `close` method. Perhaps you forgot a polyfill? Get one at:\\n\\nhttps://github.com/GoogleChrome/dialog-polyfill\\n');
          return;
        }
        dialog.close();
      }
      catch (e)
      {
        console.log ("A dialog method threw an exception. This is not supposed to happen; likely you're using a broken polyfill. If not, please file an issue:\\n\\nhttps://github.com/debois/elm-mdl/issues/new", e);
      }
      """
    in
        \event ->
            Html.attribute ("on" ++ event) handler
                |> Internal.attribute


{-| Construct a dialog.

- If you target browser not supporting
`<dialog>` natively, you will need to load [this
polyfill](https://github.com/GoogleChrome/dialog-polyfill).
- Using this polyfill [places
restrictions](https://github.com/GoogleChrome/dialog-polyfill#limitations) on
where in the DOM you can put the output of this function.
- The elm-mdl library currently support only one dialog pr. application.
Installing more than one dialog will result in a random one showing.
-}
view : List (Style a) -> List (Html a) -> Html a
view styling nodes =
    Options.styled_ (Html.node "dialog")
        (cs "mdc-dialog" :: styling)
        [ Html.id theDialog ]
        [ Html.div [ Html.class "mdc-dialog__surface" ] nodes
        , Html.div [ Html.class "mdc-dialog__backdrop" ] []
        ]
