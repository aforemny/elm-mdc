module Material.Card
    exposing
        ( view
        , border
        , expand
        , title
        , menu
        , media
        , text
        , actions
        , subhead
        , head
        , Block
        )

{-| From the [Material Design Lite documentation](https://getmdl.io/components/#cards-section):

> The Material Design Lite (MDL) card component is a user interface element
> representing a virtual piece of paper that contains related data — such as a
> photo, some text, and a link — that are all about a single subject.
>
> Cards are a convenient means of coherently displaying related block that is
> composed of different types of objects. They are also well-suited for presenting
> similar objects whose size or supported actions can vary considerably, like
> photos with captions of variable length. Cards have a constant width and a
> variable height, depending on their block.
>
> Cards are a fairly new feature in user interfaces, and allow users an access
> point to more complex and detailed information. Their design and use is an
> important factor in the overall user experience. See the card component's
> Material Design specifications page for details.

Refer to [this site](http://debois.github.io/elm-mdl/#cards)
for a live demo.

# Render
@docs view, Block

# Content blocks
@docs title, media, text, actions

## Title block
@docs subhead, head

# Misc
@docs expand, border, menu
-}

import Html exposing (..)
import Html.Attributes
import Material.Options as Options exposing (Style, cs, css)
import Material.Options.Internal as Internal


{-| Separate given content block from others by adding a thin border.
-}
border : Style a
border =
    Options.cs "mdl-card--border"


{-| Set given content block to expand or compress vertically as necessary.
-}
expand : Style a
expand =
    Options.cs "mdl-card--expand"


{-| Type of a content block within a card.
-}
type Block a
    = Title (List (Style a)) (List (Html a))
    | Menu (List (Style a)) (List (Html a))
    | Media (List (Style a)) (List (Html a))
    | SupportingText (List (Style a)) (List (Html a))
    | Actions (List (Style a)) (List (Html a))


{-| Generate a title block
-}
title : List (Style a) -> List (Html a) -> Block a
title styling block =
    Title
        {- MDL has a known bug (or missing feature), which will cause the subhead
           to come out wrong in title blocks; the bug remains unfixed in 1.3.x
           because of backwards compatibility concerns. We don't have those yet,
           so we fix it here.

           https://github.com/google/material-design-lite/issues/1002
        -}
        [ Options.many styling
        , css "justify-content" "flex-end"
        , css "flex-direction" "column"
        , css "align-items" "flex-start"
        ]
        block


{-| Head for title block. (This is called "title" in the Material Design
Specification.)
-}
head : List (Style a) -> List (Html a) -> Html a
head styling =
    Options.styled Html.h1
        (cs "mdl-card__title-text"
            :: css "align-self" "flex-start"
            :: styling
        )


{-| Sub-head for title block. (This is called "subtitle" in the Material Design
Specification.
-}
subhead : List (Style a) -> List (Html a) -> Html a
subhead styling =
    Options.span
        (cs "mdl-card__subtitle-text"
            :: css "padding-top" "8px"
            :: styling
        )


{-| Generate a menu block
-}
menu : List (Style a) -> List (Html a) -> Block a
menu styling block =
    Menu styling block


{-| Generate a media block
-}
media : List (Style a) -> List (Html a) -> Block a
media =
    Media


{-| Generate a supporting text block
-}
text : List (Style a) -> List (Html a) -> Block a
text =
    SupportingText


{-| Generate an actions block
-}
actions : List (Style a) -> List (Html a) -> Block a
actions =
    Actions



{- Cards should be clickable; however, clicks on the menu or controls in the
   action block obviously shouldn't also trigger the card-wide click event. We
   can't use `Html.Events.onWithOptions` because we can't construct a
   `Json.Decoder a` that doesn't fail. Hence this hack.
-}


stopClick : Style a
stopClick =
    Internal.attribute <|
        Html.Attributes.attribute
            "onclick"
            "var event = arguments[0] || window.event; event.stopPropagation();"


{-| Render supplied block
-}
block : Block a -> Html a
block block =
    case block of
        Title styling block ->
            Options.div (cs "mdl-card__title" :: styling) block

        Media styling block ->
            Options.div (cs "mdl-card__media" :: styling) block

        SupportingText styling block ->
            Options.div (cs "mdl-card__supporting-text" :: styling) block

        Actions styling block ->
            Options.div (cs "mdl-card__actions" :: stopClick :: styling) block

        Menu styling block ->
            Options.div (cs "mdl-card__menu" :: stopClick :: styling) block


{-| Construct a card.

Notes. Google's MDL implementation sets `min-height: 200px`; this precludes a
number of the examples from [the specification](https://material.google.com/components/cards.html#cards-usage),
so the elm-mdl implementation sets `min-height: 0px`. Add `css "min-height"
"200px"` as an option to `view` to adhere to the MDL implementation.
-}
view : List (Style a) -> List (Block a) -> Html a
view styling views =
    Options.div
        [ Options.many styling
        , cs "mdl-card"
        , css "min-height" "0px"
        ]
        (List.map block views)
