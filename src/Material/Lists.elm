module Material.Lists exposing (
    ul, li
  , twoLine, threeLine
  , itemPrimaryContent, itemAvatar, itemIcon, itemSecondaryContent, itemSecondaryInfo, itemSecondaryAction, itemTextBody, itemSubTitle
  )


{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/index.html#lists-section):

> Lists present multiple line items vertically as a single continuous element.
> Refer the Material Design Spec to know more about the content options.

See also the
[Material Design Specification]([https://material.google.com/components/lists.html).

Refer to [this site](http://debois.github.io/elm-mdl#/lists)
for a live demo.

Example use: 

    ul []
        [ li [  ] [  ]
        , li [  ] [  ]
        , li [  ] [  ]
        ]

# Main list elements
@docs ul, li

# List item configuration for multiple lines
@docs twoLine, threeLine

# Content configuration for one or multiple lines
@docs itemPrimaryContent, itemAvatar, itemIcon

# Content configuration for multiple lines
@docs itemSecondaryContent, itemSecondaryInfo, itemSecondaryAction, itemTextBody, itemSubTitle
-}


import Platform.Cmd exposing (Cmd, none)
import Html.Events as Html
import Html exposing (Html, Attribute)

import Parts exposing (Indexed)
import Material.Options as Options exposing (Property, Style, cs, nop)


{-| Main list function
-}
ul
  :  List (Property {} m)
  -> List (Html m)
  -> Html m
ul options nodes =
  let
   summary =
      Options.collect {} options
  in
    Options.apply summary Html.ul
    [ cs "mdl-list"
    ]
    [
    ]
    nodes


type ListItemLinesVariant 
  = OneLine
  | TwoLine
  | ThreeLine

type alias ListItemConfig =
  { listItemLinesVariant : ListItemLinesVariant
  }

defaultListItemConfig : ListItemConfig
defaultListItemConfig =
  { listItemLinesVariant = OneLine
  }


{-| List item should have two lines
-}
twoLine : Property { a | listItemLinesVariant : ListItemLinesVariant } m
twoLine =
  listItemLines TwoLine

{-| List item should have three lines
-}
threeLine : Property { a | listItemLinesVariant : ListItemLinesVariant } m
threeLine =
  listItemLines ThreeLine

{-| List item should have the given number of lines
-}
listItemLines : ListItemLinesVariant -> Property { a | listItemLinesVariant : ListItemLinesVariant } m
listItemLines lines =
  Options.set <| \self -> { self | listItemLinesVariant = lines }


{-| List item
-}
li
  :  List (Property ListItemConfig m)
  -> List (Html m)
  -> Html m
li options nodes =
  let
    ({ config } as summary) =
      Options.collect defaultListItemConfig options
  in
    Options.apply summary Html.li
    [ case config.listItemLinesVariant of
          OneLine -> Options.nop
          TwoLine -> cs "mdl-list__item--two-line"
          ThreeLine -> cs "mdl-list__item--three-line"
    , cs "mdl-list__item" 
    ]
    [
    ]
    nodes    


{-| Defines the primary content sub-division
-}
itemPrimaryContent : Property a m
itemPrimaryContent = cs "mdl-list__item-primary-content"

{-| Defines the avatar sub-division
-}
itemAvatar : Property a m
itemAvatar = cs "mdl-list__item-avatar"

{-| Defines the icon sub-division
-}
itemIcon : Property a m
itemIcon = cs "mdl-list__item-icon"

{-| Defines the secondary content sub-division.	Requires an item with twoLine or threeLine.
-}
itemSecondaryContent : Property a m
itemSecondaryContent = cs "mdl-list__item-secondary-content"

{-| Defines the information sub-division.	Requires an item with twoLine or threeLine.
-}
itemSecondaryInfo : Property a m
itemSecondaryInfo = cs "mdl-list__item-secondary-info"

{-| Defines the Action sub-division.	Requires an item with twoLine or threeLine.
-}
itemSecondaryAction : Property a m
itemSecondaryAction = cs "mdl-list__item-secondary-action"

{-| Defines the Text Body sub-division.	Requires an item with twoLine or threeLine.
-}
itemTextBody : Property a m
itemTextBody = cs "mdl-list__item-text-body"

{-| Defines the Sub title sub-division.	Requires an item with twoLine or threeLine. 
-}
itemSubTitle : Property a m
itemSubTitle = cs "mdl-list__item-sub-title"


