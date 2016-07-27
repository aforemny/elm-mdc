module Material.Dialog exposing
  ( dialog
  , title
  , content
  , actions
  , fullWidth
  )

{-| From the [Material Design Lite documentation](https://getmdl.io/components/#cards-section):

> The Material Design Lite (MDL) dialog component allows for verification of user > actions, simple data input, and alerts to provide extra information to users.

> To use the dialog component, you must be using a browser that supports the dialog element. Only Chrome and Opera have native support at the time of writing. For other browsers you will need to include the dialog polyfill or create your own.


Refer to [this site](http://debois.github.io/elm-mdl/#/dialog)
for a live demo.

@docs Model, model, Msg, update
@docs view

# Component support

@docs Container, Observer, Instance, instance, fwdTemplate
-}

import Html exposing (..)
import Material.Options as Options exposing (Style, cs)


{-| Add the full-width class to a dialog's actions.
-}
fullWidth : Style a
fullWidth = Options.cs "mdl-dialog__actions--full-width"


{-| Within a dialog specific types of content can exist
-}
type ContentBlock a
  = Title (List (Style a)) (List (Html a))
  | Content (List (Style a)) (List (Html a))
  | Actions (List (Style a)) (List (Html a))

{-| Generate a title content block
-}
title : List (Style a) -> List (Html a) -> ContentBlock a
title styling content =
  Title styling content

{-| Generate a supporting text content block
-}
content : List (Style a) -> List (Html a) -> ContentBlock a
content styling content =
  Content styling content

{-| Generate an actions content block
-}
actions : List (Style a) -> List (Html a) -> ContentBlock a
actions styling content =
  Actions styling content

{-| Render supplied content block
-}
contentBlock : ContentBlock a -> Html a
contentBlock block =
  case block of
    Title styling content ->
      Options.div (cs "mdl-dialog__title" :: styling) content

    Content styling content ->
      Options.div (cs "mdl-dialog__content" :: styling) content

    Actions styling content ->
      Options.div (cs "mdl-dialog__actions" :: styling) content


{-| Construct a dialog with options.
-}
dialog : List (Style a) -> List (ContentBlock a) -> Html a
dialog styling contentBlocks =
  Options.div (cs "mdl-dialog" :: styling) (List.map (contentBlock) contentBlocks)
