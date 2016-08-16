module Material.Chip exposing
  ( chip, chip'
  , text, text'
  , contactItem, contactItem'
  , action, button
  , contact, deletable
  , HtmlElement
  )

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/index.html#chips-section):

> The Material Design Lite (MDL) chip component is a small, interactive element.
> Chips are commonly used for contacts, text, rules, icons, and photos.

See also the
[Material Design Specification](https://www.google.com/design/spec/components/chips.html).

Refer to [this site](http://debois.github.io/elm-mdl/#chips)
for a live demo.


# Elements
@docs chip, chip'
@docs text, text'
@docs contactItem, contactItem'
@docs action
@docs button

# Attributes
@docs contact, deletable

# Helper
@docs HtmlElement

-}

import Html exposing (Attribute, Html)
import Material.Options as Options exposing (cs)


{-| Helper for a `Html m` function. e.g. `Html.div`
-}
type alias HtmlElement msg =
  List (Attribute msg) -> List (Html msg) -> Html msg



{-| Create a chip contained in the given element
-}
chip' : HtmlElement msg -> List (Options.Property c msg) -> List (Html msg) -> Html msg
chip' element props content =
  Options.styled element
    (cs "mdl-chip" :: props)
    content


{-| Creates a chip using `Html.span`
-}
chip : List (Options.Property c msg) -> List (Html msg) -> Html msg
chip =
  chip' Html.span


{-| Create a chip text contained in the given element
-}
text' : HtmlElement msg -> List (Options.Property c msg) -> List (Html msg) -> Html msg
text' element props content =
  Options.styled element
    (cs "mdl-chip__text" :: props)
    content


{-| Create a text element using `Html.span`
-}
text : List (Options.Property c msg) -> List (Html msg) -> Html msg
text =
  text' Html.span


{-| Create a chip action contained in the given element
-}
action : HtmlElement msg -> List (Options.Property c msg) -> List (Html msg) -> Html msg
action element props content =
  Options.styled element
    (cs "mdl-chip__action" :: props)
    content


{-| Create a chip action `Html.button`
-}
button : List (Options.Property c msg) -> List (Html msg) -> Html msg
button props =
  action Html.button ((Options.type' "button") :: props)


{-| Create a chip contact contained in the given element
-}
contactItem' : HtmlElement msg -> List (Options.Property c msg) -> List (Html msg) -> Html msg
contactItem' element props content =
  Options.styled element
    (cs "mdl-chip__contact" :: props)
    content


{-| Create a chip contact using `Html.span`
-}
contactItem : List (Options.Property c msg) -> List (Html msg) -> Html msg
contactItem =
  contactItem' Html.span


{-| Defines a chip as a contact style chip
-}
contact : Options.Property c m
contact =
  cs "mdl-chip--contact"


{-| Defines a chip as a deletable style chip
-}
deletable : Options.Property c m
deletable =
  cs "mdl-chip--deletable"
