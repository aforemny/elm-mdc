module Material.Chip exposing
  (..)

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/index.html#chips-section):

> The Material Design Lite (MDL) chip component is a small, interactive element.
> Chips are commonly used for contacts, text, rules, icons, and photos.

See also the
[Material Design Specification](https://www.google.com/design/spec/components/chips.html).

Refer to [this site](http://debois.github.io/elm-mdl/#chips)
for a live demo.


@docs chip, contact, deletable, text, action, contactItem
-}

import Html exposing (..)

import Material.Options as Options exposing (cs)


{-|
-}
chip : Options.Property c m
chip =
  cs "mdl-chip"


{-|
-}
contact : Options.Property c m
contact =
  cs "mdl-chip--contact"


{-|
-}
deletable : Options.Property c m
deletable =
  cs "mdl-chip--deletable"


{-|
-}
text : Options.Property c m
text =
  cs "mdl-chip__text"


{-|
-}
action : Options.Property c m
action =
  cs "mdl-chip__action"


{-|
-}
contactItem : Options.Property c m
contactItem =
  cs "mdl-chip__contact"
