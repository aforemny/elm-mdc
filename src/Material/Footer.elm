module Material.Footer exposing
  ( mini
  , logo
  , links
  , link, href
  , onClick
  , button
  , left, right
  )

{-| From the [Material Design Lite documentation](https://getmdl.io/components/index.html#layout-section/footer):

> The Material Design Lite (MDL) footer component is a comprehensive container
> intended to present a substantial amount of related content in a visually
> attractive and logically intuitive area. Although it is called "footer", it
> may be placed at any appropriate location on a device screen, either before or
> after other content.
>
> An MDL footer component takes two basic forms: mega-footer and mini-footer. As
> the names imply, mega-footers contain more (and more complex) content than
> mini-footers. A mega-footer presents multiple sections of content separated by
> horizontal rules, while a mini-footer presents a single section of content. Both
> footer forms have their own internal structures, including required and optional
> elements, and typically include both informational and clickable content, such
> as links.
>
> Footers, as represented by this component, are a fairly new feature in user
> interfaces, and allow users to view discrete blocks of content in a coherent and
> consistently organized way. Their design and use is an important factor in the
> overall user experience.

See also the
[Material Design Specification](https://material.google.com/layout/structure.html).

Refer to [this site](http://debois.github.io/elm-mdl#/footer)
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
