module Material.Badge
    exposing
        ( noBackground
        , overlap
        , add
        )

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#badges-section):

> The Material Design Lite (MDL) badge component is an onscreen notification element.
> A badge consists of a small circle, typically containing a number or other characters,
> that appears in proximity to another object. A badge can be both a notifier that there
> are additional items associated with an object and an indicator of how many items there are.
>
> You can use a badge to unobtrusively draw the user's attention to items they might not
> otherwise notice, or to emphasize that items may need their attention. For example:
>
> A "New messages" notification might be followed by a badge containing the number of unread messages.
> A "You have unpurchased items in your shopping cart" reminder might include a badge
> showing the number of items in the cart.
> A "Join the discussion!" button might have an accompanying badge indicating the number of
> users currently participating in the discussion.
> A badge is almost always positioned near a link so that the user has a convenient way to access
> the additional information indicated by the badge. However, depending on the intent, the
> badge itself may or may not be part of the link.
>
> Badges are a new feature in user interfaces, and provide users with a visual clue to help them
> discover additional relevant content. Their design and use is therefore an important
> factor in the overall user experience.

Refer to
[this site](https://debois.github.io/elm-mdl/#badges)
for a live demo.

@docs add, noBackground, overlap
-}

import Material.Options as Options exposing (Property, cs, many)


{-| No background for badge.
-}
noBackground : Property c m
noBackground =
    cs "mdl-badge--no-background"


{-| Badge overlaps text/contents.
-}
overlap : Property c m
overlap =
    cs "mdl-badge--overlap"


{-| Add a badge to the containing element.
-}
add : String -> Property c m
add str =
    Options.many
        [ Options.data "badge" str
        , cs "mdl-badge"
        ]
