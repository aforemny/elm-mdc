module Material.List exposing
    ( Property
    , ul, ol
    , nonInteractive
    , dense
    , avatarList
    , twoLine
    , nav
    , li
    , text
    , primaryText
    , secondaryText
    , selected
    , activated
    , graphic, graphicIcon, graphicImage
    , meta, metaClass, metaText, metaIcon, metaImage
    , a
    , group
    , subheader
    , divider
    , hr
    , padded
    , inset
    , selectedIndex
    , onSelectListItem
    , singleSelection
    , radioGroup
    , useActivated
    )

{-| Lists present multiple line items vertically as a single
continuous element. Both single-line and two-line lists are supported.

The module currently presents two interfaces: one for regular lists,
which is built using `ListItem` elements. The other is for use with
menus and drawers, and builds the nodes with methods which return an `Html m`
elements. The latter will probably change too when we add ripple support here.

To avoid namespace conflicts with the `List` module, this module should be
imported qualified as `Lists`.


# Resources

  - [Material Components for the Web: List](https://material-components.github.io/material-components-web-catalog/#/component/list)
  - [Material Design guidelines: Lists](https://material.io/design/components/lists.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#lists)


# Example

    import Html exposing (text)
    import Material.List as Lists


    Lists.ul Mdc "my-list" model.mdc
        [ Lists.twoLine
        , Lists.avatarList
        ]
        [ Lists.li []
              [ Lists.graphicIcon [] "folder"
              , Lists.text []
                    [ Lists.primaryText []
                          [ text "Photos"
                          ]
                    , Lists.secondaryText []
                          [ text "Jan 9, 2014"
                          ]
                    ]
              , Lists.metaIcon [] "info"
              ]
        , Lists.li []
              [ Lists.graphicIcon [] "folder"
              , Lists.text []
                    [ Lists.primaryText []
                          [ text "Recipes"
                          ]
                    , Lists.secondaryText []
                          [ text "Jan 17, 2014"
                          ]
                    ]
              , Lists.metaIcon [] "info"
              ]
        , Lists.li []
              [ Lists.graphicIcon [] "folder"
              , Lists.text []
                    [ Lists.primaryText []
                          [ text "Work"
                          ]
                    , Lists.secondaryText []
                          [ text "Jan 28, 2014"
                          ]
                    ]
              , Lists.metaIcon [] "info"
              ]
        ]


# Usage


## Lists

@docs Property
@docs ul, ol
@docs nonInteractive
@docs dense
@docs avatarList
@docs twoLine
@docs nav
@docs selectedIndex
@docs onSelectListItem
@docs singleSelection
@docs radioGroup
@docs useActivated


## List Items

@docs li
@docs text
@docs primaryText
@docs secondaryText
@docs selected
@docs activated
@docs graphic, graphicIcon, graphicImage
@docs meta, metaClass, metaText, metaIcon, metaImage
@docs a


## List Groups

@docs group
@docs subheader


## Dividers

@docs divider
@docs hr
@docs padded
@docs inset

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Icon.Implementation as Icon
import Internal.List.Implementation as List
import Material
import Material.Options as Options


{-| List property.
-}
type alias Property m =
    List.Property m


{-| The list element.
-}
ul :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (List.ListItem m)
    -> Html m
ul =
    List.view


{-| The list element.
-}
ol : List (Property m) -> List (Html m) -> Html m
ol =
    List.ol


{-| The list element rendered as `<nav>`.
-}
nav : List (Property m) -> List (Html m) -> Html m
nav =
    List.nav


{-| Disables interactivity affordances.
-}
nonInteractive : Property m
nonInteractive =
    List.nonInteractive


{-| Make the list appear more compact.
-}
dense : Property m
dense =
    List.dense


{-| Configure the leading tiles of each row to display images instead of icons.
-}
avatarList : Property m
avatarList =
    List.avatarList


{-| List items have primary and secondary lines.
-}
twoLine : Property m
twoLine =
    List.twoLine


{-| List item element.
-}
li : List (Property m) -> List (Html m) -> List.ListItem m
li =
    List.li


{-| List item element as anchor element `<a>`.
-}
a : List (Property m) -> List (Html m) -> Html m
a =
    List.a


{-| Primary text for the row.
-}
text : List (Property m) -> List (Html m) -> Html m
text =
    List.text


{-| Primary text for the row, in case the list is `twoLine`.
-}
primaryText : List (Property m) -> List (Html m) -> Html m
primaryText =
    List.primaryText


{-| Secondary text for the row, in case the list is `twoLine`.
-}
secondaryText : List (Property m) -> List (Html m) -> Html m
secondaryText =
    List.secondaryText


{-| Styles a row in selected state.
-}
selected : Property m
selected =
    List.selected


{-| Styles a row in activated state.
-}
activated : Property m
activated =
    List.activated


{-| The first tile in a row, typically an icon or image.
-}
graphic : List (Property m) -> List (Html m) -> Html m
graphic =
    List.graphic


{-| The first tile in a row as an icon.

The second argument is a Material Icon identifier.

-}
graphicIcon : List (Icon.Property m) -> String -> Html m
graphicIcon =
    List.graphicIcon


{-| The first tile in a row as an image.

The second argument is the URL of the image.

-}
graphicImage : List (Property m) -> String -> Html m
graphicImage =
    List.graphicImage


{-| The last tile in a row, typically small text, and icon or image.
-}
meta : List (Property m) -> List (Html m) -> Html m
meta =
    List.meta


{-| The last tile in a row as text.
-}
metaText : List (Property m) -> String -> Html m
metaText =
    List.metaText


{-| The last tile in a row as an icon.

The second argument is a Material Icon identifier.

-}
metaIcon : List (Icon.Property m) -> String -> Html m
metaIcon =
    List.metaIcon


{-| The last tile in a row as an image.

The second argument is the url of the image.

-}
metaImage : List (Property m) -> String -> Html m
metaImage =
    List.metaImage


{-| Class to use to mark an element as the last tile in a
row. Typically small text, icon. or image.
-}
metaClass : Options.Property c m
metaClass =
    List.metaClass


{-| Wrapper around two or more list elements to be grouped together.
-}
group : List (Property m) -> List (Html m) -> Html m
group =
    List.group


{-| Heading text displayed above each list in a group.
-}
subheader : List (Property m) -> List (Html m) -> Html m
subheader =
    List.subheader


{-| List divider list item, use this in lists.
-}
divider : List (Property m) -> List (Html m) -> List.ListItem m
divider =
    List.divider


{-| List divider element, use this in drawer lists.
-}
hr : List (Property m) -> List (Html m) -> Html m
hr =
    List.hr


{-| Leaves a gap on each side of the divider to match the padding of `meta`.
-}
padded : Property m
padded =
    List.padded


{-| Increases the leading margin of the divider so that it does not intersect
the avatar column.
-}
inset : Property m
inset =
    List.inset


{-| The currently selected item in list.

Only makes sense for single selection lists. If this is set, the
selected and activated classes and aria elements are applied
automatically.

Bug: the index currently includes dividers.
-}
selectedIndex : Int -> Property m
selectedIndex =
    List.selectedIndex


{-| Msg to send when a list item has been selected.

Bug: the index sent includes dividers.
-}
onSelectListItem : (Int -> m) -> Property m
onSelectListItem =
    List.onSelectListItem


{-| MDC List can handle selecting/deselecting list elements based on
click or keyboard action. When enabled, the space and enter keys (or
click event) will trigger an single list item to become selected and
any other previous selected element to become deselected.
-}
singleSelection : Property m
singleSelection =
    List.singleSelection


{-| Render list as a radio group.
-}
radioGroup : Property m
radioGroup =
    List.radioGroup


{-| In Material Design, the selected and activated states apply in
different, mutually-exclusive situations:

* Selected state should be applied on the .mdc-list-item when it is
  likely to frequently change due to user choice. E.g., selecting one
  or more photos to share in Google Photos.
* Activated state is more permanent than selected state, and will NOT
  change soon relative to the lifetime of the page. Common examples
  are navigation components such as the list within a navigation
  drawer.
-}
useActivated : Property m
useActivated =
    List.useActivated
