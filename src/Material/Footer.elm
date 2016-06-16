module Material.Footer exposing
  ( mini
  , logo
  , links
  , link, href
  , onClick
  , button
  , left, right
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


import Html exposing (..)
import Html.Attributes as Html

import Html.Events as Events

import Material.Options as Options exposing (Style, cs)

import Material.Helpers as Helpers -- exposing (filter, delay, pure, map1st, map2nd)

import Material.Options.Internal exposing (attribute)

-- PROPERTIES

-- Helpers
-- TODO: Should these be moved somewhere else?

type LinkProp = LinkProp

type alias LinkProperty m =
  Options.Property LinkProp m

{-| onClick for Links and Buttons.
-}
onClick : m -> LinkProperty m
onClick =
  Events.onClick >> attribute

{-| href for Links.
-}
href : String -> LinkProperty m
href =
  Html.href >> attribute


{-| Link.
-}
link : List (LinkProperty m) -> List (Html m) -> Html m
link styles contents =
  Options.styled a
    styles
    contents


button : Style m
button = cs "mdl-mini-footer__social-btn"


left : List (Style m) -> List (Html m) -> Html m
left styles content =
  Options.styled Html.div
    (cs "mdl-mini-footer__left-section" :: styles)
      content

right : List (Style m) -> List (Html m) -> Html m
right styles content =
  Options.styled Html.div
    (cs "mdl-mini-footer__right-section" :: styles)
      content

logo : List (Style m) -> List (Html m) -> Html m
logo styles content =
  Options.styled Html.div
    (cs "mdl-logo" :: styles)
      content

links : List (Style m) -> List (Html m) -> Html m
links styles content =
  Options.styled Html.ul
    (cs "mdl-mini-footer__link-list" :: styles)
      content

-- VIEW

{-| View function to render a mini-footer
-}
mini : List (Style m) -> List (Html m) -> Html m
mini styles content =
  Options.styled Html.footer
    (cs "mdl-mini-footer" :: styles)
    content
