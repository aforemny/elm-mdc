module Material.Badge
  ( noBackground
  , overlap
  , withBadge
  ) where

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

@docs viewDefault, view, BadgeInfo, Options
-}

import String 
import Html exposing (Attribute)
import Html.Attributes exposing (attribute)
import Material.Style exposing (Style, cs, attrib, multiple)


{-| No background for badge 
-}
noBackground : Style
noBackground = 
  cs "mdl-badge--no-background"

{-| Overlap Badge 
-}
overlap : Style
overlap = 
  cs "mdl-badge--overlap"


{-| Style function for Badge
    
    First parameter will set Badge options. See Options for more info.
    Last parameter will set a value to data-badge="value".	Assigns string value to badge

    import Material.Badge as Badge

    badgeStyleList : List Style
    badgeStyleList = Badge.badgeStyle { overlap = False, noBackground = False} "3"
-}
withBadge : String -> Style
withBadge databadge = 
  multiple [cs "mdl-badge", attrib "data-badge" databadge]
