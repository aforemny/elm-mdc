module Material.List
    exposing
        ( ul
        , li
        , content
        , subtitle
        , withSubtitle
        , body
        , withBody
        , icon
        , avatarIcon
        , avatarImage
        , avatar
        , content2
        , info2
        , action2
        )

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/index.html#lists-section):

> Lists present multiple line items vertically as a single continuous element.
> Refer the Material Design Spec to know more about the content options.

See also the
[Material Design Specification]([https://material.google.com/components/lists.html).

Refer to [this site](http://debois.github.io/elm-mdl/#lists)
for a live demo and example code.

# List and item containers
@docs ul, li

# Primary content
@docs content
@docs subtitle, withSubtitle, body, withBody

## Icons & avatars
@docs avatarIcon, avatarImage, avatar, icon

# Secondary content
@docs content2, action2, info2

-}

import Html exposing (Html, Attribute)
import Html.Attributes
import Material.Options as Options exposing (Property, Style, cs, css, nop)
import Material.Icon as Icon


{-| Container for list items. (Use this rather than `Html.ul`.)
-}
ul : List (Property c m) -> List (Html m) -> Html m
ul options =
    Options.styled Html.ul (cs "mdl-list" :: options)


{-| List-item, no secondary content. (Use this rather than `Html.li`.)
-}
li : List (Property c m) -> List (Html m) -> Html m
li options =
    Options.styled Html.li (cs "mdl-list__item" :: options)


{-| Adjust item spacing to accomodate a 2-line body. Option for `li`. Don't set
both this and `withSubtitle`.
-}
withBody : Property c m
withBody =
    cs "mdl-list__item--three-line"


{-| Adjust inter-item spacing to accomodate a 1-line subtitle. Option for `li`.
Don't set both this and `withBody`.
-}
withSubtitle : Property c m
withSubtitle =
    cs "mdl-list__item--two-line"


{-| Defines the primary content sub-division. Use within `li`.
-}
content : List (Property a m) -> List (Html m) -> Html m
content options =
    Options.span (cs "mdl-list__item-primary-content" :: options)


{-| Set an avatar icon. Like `Icon.view`.
-}
avatarIcon : String -> List (Property a m) -> Html m
avatarIcon i options =
    {- Google MDL doesn't properly center icons of non-maximal size. -}
    Options.div
        [ Options.center
        , Options.many options
        , avatar
        ]
        [ Icon.i i ]


{-| Set an avatar image. `src` is a value for `Html.Attributes.src`.
-}
avatarImage : String -> List (Property a m) -> Html m
avatarImage src options =
    Options.styled_ Html.img
        (avatar :: options)
        [ Html.Attributes.src src ]
        []


{-| If you need fine-grained control of the avatar, specify whatever element
you want, then add this property. (You may want to use this in conjunction with
  `Options.img`.)
-}
avatar : Property c m
avatar =
    cs "mdl-list__item-avatar"


{-| Set an icon. Refer to `Icon.view`.
-}
icon : String -> List (Icon.Property m) -> Html m
icon i options =
    Icon.view i (cs "mdl-list__item-icon" :: options)


{-| Defines the text-body sub-division.	Use within `content`. You need to
adjust list-item spacing by applying `withBody` to `li` if you use this.
Mutually exclusive with `subtitle`.
-}
body : List (Property c m) -> List (Html m) -> Html m
body options =
    Options.span (cs "mdl-list__item-text-body" :: options)


{-| Defines the subtitle sub-division.	Use within `content`. You need to
adjust list-item spacing by applying `withSubtitle` to `li` if you use this.
Mutually exclusive with `body`.
-}
subtitle : List (Property c m) -> List (Html m) -> Html m
subtitle options =
    Options.span (cs "mdl-list__item-sub-title" :: options)


{-| Defines the secondary content sub-division.	Use within `li`.
-}
content2 : List (Property a m) -> List (Html m) -> Html m
content2 options =
    Options.span (cs "mdl-list__item-secondary-content" :: options)


{-| Defines the information sub-division.	Applicable only within `content2`.
-}
info2 : List (Property c m) -> List (Html m) -> Html m
info2 options =
    Options.span (cs "mdl-list__item-secondary-info" :: options)


{-| Defines the secondary action sub-division. (The primary action is clicking
the primary content.)
-}
action2 : Property a m
action2 =
    cs "mdl-list__item-secondary-action"
