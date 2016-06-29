module Material.Card exposing
  ( card
  , ContentBlock(..)
  , width
  , height
  , border
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


type ContentBlock msg
  = Title (List (Style msg)) String
  | TitleAndSubtitle (List (Style msg)) String String
  | Menu (List (Style msg)) (List (Html msg))
  | Media (List (Style msg)) (List (Html msg))
  | SupportingText (List (Style msg)) (List (Html msg))
  | Actions (List (Style msg)) (List (Html msg))


contentBlock : ContentBlock msg -> Html msg
contentBlock block =
  case block of
    Title styling title ->
      Options.div (cs "mdl-card__title" :: styling)
        [ Options.styled Html.h2
          (cs "mdl-card__title-text" :: styling)
          [ text title
          ]
        ]
    TitleAndSubtitle styling title subtitle ->
      Options.div (cs "mdl-card__title" :: styling)
        [ Options.styled Html.h2
          (cs "mdl-card__title-text" :: styling)
          [ text title ]
        , Options.span (cs "mdl-card__subtitle-text" :: styling) [text subtitle]
        ]
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
card : List (Style msg) -> List (ContentBlock msg) -> Html msg
card styling contentBlocks =
  Options.div (cs "mdl-card" :: styling) (List.map (contentBlock) contentBlocks)
