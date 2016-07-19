module Material.Lists
    exposing
        ( ul
        , li
        , li2
        , li3
        , primaryContent
        , avatar
        , icon
        , secondaryContent
        , secondaryInfo
        , secondaryAction
        , textBody
        , subTitle
        )

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/index.html#lists-section):

> Lists present multiple line items vertically as a single continuous element.
> Refer the Material Design Spec to know more about the content options.

See also the
[Material Design Specification]([https://material.google.com/components/lists.html).

Refer to [this site](http://debois.github.io/elm-mdl#/lists)
for a live demo and example code.

# Main list elements
@docs ul, li, li2, li3

# Content configuration for one or multiple lines
@docs primaryContent, avatar, icon

# Content configuration for multiple lines
@docs secondaryContent, secondaryInfo, secondaryAction, textBody, subTitle
-}

import Platform.Cmd exposing (Cmd, none)
import Html.Events as Html
import Html exposing (Html, Attribute)
import Parts exposing (Indexed)
import Material.Options as Options exposing (Property, Style, cs, nop)


{-| Main list function
-}
ul :
    List (Property {} m)
    -> List (Html m)
    -> Html m
ul options nodes =
    let
        summary =
            Options.collect {} options
    in
        Options.apply summary
            Html.ul
            [ cs "mdl-list"
            ]
            []
            nodes



{-| Default List item
-}
li :
    List (Property {} m)
    -> List (Html m)
    -> Html m
li options nodes =
    let
        ({ config } as summary) =
            Options.collect {} options
    in
        Options.apply summary
            Html.li
            [ cs "mdl-list__item" ]
            []
            nodes

{-| List item with two lines
-}
li2 :
    List (Property {} m)
    -> List (Html m)
    -> Html m
li2 options nodes =
    let
        ({ config } as summary) =
            Options.collect {} options
    in
        Options.apply summary
            Html.li
            [ cs "mdl-list__item"
            , cs "mdl-list__item--two-line"
            ]
            []
            nodes

{-| List item with three lines
-}
li3 :
    List (Property {} m)
    -> List (Html m)
    -> Html m
li3 options nodes =
    let
        ({ config } as summary) =
            Options.collect {} options
    in
        Options.apply summary
            Html.li
            [ cs "mdl-list__item"
            , cs "mdl-list__item--three-line"
            ]
            []
            nodes


{-| Defines the primary content sub-division
-}
primaryContent : Property a m
primaryContent =
    cs "mdl-list__item-primary-content"


{-| Defines the avatar sub-division
-}
avatar : Property a m
avatar =
    cs "mdl-list__item-avatar"


{-| Defines the icon sub-division
-}
icon : Property a m
icon =
    cs "mdl-list__item-icon"


{-| Defines the secondary content sub-division.	Requires an item with twoLine or threeLine.
-}
secondaryContent : Property a m
secondaryContent =
    cs "mdl-list__item-secondary-content"


{-| Defines the information sub-division.	Requires an item with twoLine or threeLine.
-}
secondaryInfo : Property a m
secondaryInfo =
    cs "mdl-list__item-secondary-info"


{-| Defines the Action sub-division.	Requires an item with twoLine or threeLine.
-}
secondaryAction : Property a m
secondaryAction =
    cs "mdl-list__item-secondary-action"


{-| Defines the Text Body sub-division.	Requires an item with twoLine or threeLine.
-}
textBody : Property a m
textBody =
    cs "mdl-list__item-text-body"


{-| Defines the Sub title sub-division.	Requires an item with twoLine or threeLine.
-}
subTitle : Property a m
subTitle =
    cs "mdl-list__item-sub-title"
