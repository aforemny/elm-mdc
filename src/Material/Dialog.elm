module Material.Dialog
    exposing
        ( view
        , title
        , content
        , actions
        , fullWidth
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
@docs title, content, actions, fullWidth

# Opening & closing
@docs openOn, closeOn

-}

import Html exposing (..)
import Html.Attributes
import Material.Options as Options exposing (Style, Property, cs)
import Material.Options.Internal as Internal


{-| Option to `actions`. If set, each control takes up the full width of the
dialog.
-}
fullWidth : Style a
fullWidth =
    Options.cs "mdl-dialog__actions--full-width"


{-| Within a dialog specific types of content can exist
-}
type Block a
    = Title (List (Style a)) (List (Html a))
    | Content (List (Style a)) (List (Html a))
    | Actions (List (Style a)) (List (Html a))


{-| Generate a title content block
-}
title : List (Style a) -> List (Html a) -> Block a
title =
    Title


{-| Generate a supporting text content block
-}
content : List (Style a) -> List (Html a) -> Block a
content =
    Content


{-| Generate an actions content block
-}
actions : List (Style a) -> List (Html a) -> Block a
actions =
    Actions


{-| Render supplied content block
-}
contentBlock : Block a -> Html a
contentBlock block =
    case block of
        Title styling content ->
            Options.div (cs "mdl-dialog__title" :: styling) content

        Content styling content ->
            Options.div (cs "mdl-dialog__content" :: styling) content

        Actions styling content ->
            Options.div (cs "mdl-dialog__actions" :: styling) content


theDialog : String
theDialog =
    "elm-mdl-singleton-dialog"


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
        console.log ("A dialog method threw an exception. This is not supposed to happen; likely you're using a broken polyfill. If not, please file an issue:\\n\\nhttps://github.com/debois/elm-mdl/issues/new");
      }
      """
    in
        \event ->
            Html.Attributes.attribute ("on" ++ event) handler
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
        console.log ("A dialog method threw an exception. This is not supposed to happen; likely you're using a broken polyfill. If not, please file an issue:\\n\\nhttps://github.com/debois/elm-mdl/issues/new");
      }
      """
    in
        \event ->
            Html.Attributes.attribute ("on" ++ event) handler
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
view : List (Style a) -> List (Block a) -> Html a
view styling contentBlocks =
    Options.styled_ (Html.node "dialog")
        (cs "mdl-dialog" :: styling)
        [ Html.Attributes.id theDialog ]
        (List.map (contentBlock) contentBlocks)
