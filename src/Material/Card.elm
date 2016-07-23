module Material.Card exposing
  ( card
  , width
  , height
  , border
  , expand
  , title
  , menu
  , media
  , supportingText
  , actions
  , subTitle
  , h1
  , h2
  , h3
  , h4
  , h5
  , h6
  )

{-| From the [Material Design Lite documentation](https://getmdl.io/components/#cards-section):

> The Material Design Lite (MDL) card component is a user interface element
> representing a virtual piece of paper that contains related data — such as a
> photo, some text, and a link — that are all about a single subject.
>
> Cards are a convenient means of coherently displaying related content that is
> composed of different types of objects. They are also well-suited for presenting
> similar objects whose size or supported actions can vary considerably, like
> photos with captions of variable length. Cards have a constant width and a
> variable height, depending on their content.
>
> Cards are a fairly new feature in user interfaces, and allow users an access
> point to more complex and detailed information. Their design and use is an
> important factor in the overall user experience. See the card component's
> Material Design specifications page for details.

Refer to [this site](http://debois.github.io/elm-mdl/#/card)
for a live demo.

@docs Model, model, Msg, update
@docs view

# Component support

@docs Container, Observer, Instance, instance, fwdTemplate
-}

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Parts exposing (Indexed)
import Material.Options as Options exposing (Style, cs)


{-| Set card width. Width must be a valid CSS dimension.
-}
width : String -> Style a
width w = Options.css "width" w


{-| Set card height. Height must be a valid CSS dimension.
-}
height : String -> Style a
height h = Options.css "height" h


{-| Add a border to the card.
-}
border : Style a
border = Options.cs "mdl-card--border"


{-| Add the expand class to the card.
-}
expand : Style a
expand = Options.cs "mdl-card--expand"

{-| Within a card specific types of content can exist
-}
type ContentBlock a
  = Title (List (Style a)) (List (Html a))
  | Menu (List (Style a)) (List (Html a))
  | Media (List (Style a)) (List (Html a))
  | SupportingText (List (Style a)) (List (Html a))
  | Actions (List (Style a)) (List (Html a))

{-| Generate a title content block
-}
title : List (Style a) -> List (Html a) -> ContentBlock a
title styling content =
  Title styling content

{-| Generate a menu content block
-}
menu : List (Style a) -> List (Html a) -> ContentBlock a
menu styling content =
  Menu styling content

{-| Generate a media content block
-}
media : List (Style a) -> List (Html a) -> ContentBlock a
media styling content =
  Media styling content

{-| Generate a supporting text content block
-}
supportingText : List (Style a) -> List (Html a) -> ContentBlock a
supportingText styling content =
  SupportingText styling content

{-| Generate an actions content block
-}
actions : List (Style a) -> List (Html a) -> ContentBlock a
actions styling content =
  Actions styling content

{-| Generate a subtitle element for use within a title content block
-}
subTitle : List (Style a) -> List (Html a) -> Html a
subTitle styling content =
  Options.span (cs "mdl-card__subtitle-text" :: styling) content

{-| Generate a header element (h1) for use within a title content block
-}
h1 : List (Style a) -> List (Html a) -> Html a
h1 styling content =
  Options.styled Html.h1 (cs "mdl-card__title-text" :: styling) content

{-| Generate a header element (h2) for use within a title content block
-}
h2 : List (Style a) -> List (Html a) -> Html a
h2 styling content =
  Options.styled Html.h2 (cs "mdl-card__title-text" :: styling) content

{-| Generate a header element (h3) for use within a title content block
-}
h3 : List (Style a) -> List (Html a) -> Html a
h3 styling content =
  Options.styled Html.h3 (cs "mdl-card__title-text" :: styling) content

{-| Generate a header element (h4) for use within a title content block
-}
h4 : List (Style a) -> List (Html a) -> Html a
h4 styling content =
  Options.styled Html.h4 (cs "mdl-card__title-text" :: styling) content

{-| Generate a header element (h5) for use within a title content block
-}
h5 : List (Style a) -> List (Html a) -> Html a
h5 styling content =
  Options.styled Html.h5 (cs "mdl-card__title-text" :: styling) content

{-| Generate a header element (h6) for use within a title content block
-}
h6 : List (Style a) -> List (Html a) -> Html a
h6 styling content =
  Options.styled Html.h6 (cs "mdl-card__title-text" :: styling) content

{-| Render supplied content block
-}
contentBlock : ContentBlock a -> Html a
contentBlock block =
  case block of
    Title styling content ->
      Options.div (cs "mdl-card__title" :: styling) content

    Menu styling content ->
      Options.div (cs "mdl-card__menu" :: styling) content

    Media styling content ->
      Options.div (cs "mdl-card__media" :: styling) content

    SupportingText styling content ->
      Options.div (cs "mdl-card__supporting-text" :: styling) content

    Actions styling content ->
      Options.div (cs "mdl-card__actions" :: styling) content


{-| Construct a card with options.
-}
card : List (Style a) -> List (ContentBlock a) -> Html a
card styling contentBlocks =
  Options.div (cs "mdl-card" :: styling) (List.map (contentBlock) contentBlocks)
