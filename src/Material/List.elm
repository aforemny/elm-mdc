module Material.List exposing
    ( ChildList
    , Property
    , ListItem
    , ul, ol
    , nonInteractive
    , dense
    , avatarList
    , twoLine
    , nav
    , selectedIndex
    , onSelectListItem
    , singleSelection
    , radioGroup
    , useActivated
    , node
    , li
    , a
    , listItemClass
    , text
    , primaryText
    , secondaryText
    , selected, activated, disabled
    , graphic, graphicIcon, graphicImage, graphicClass
    , meta, metaText, metaIcon, metaImage, metaClass
    , asListItem
    , aRippled
    , group
    , subheader
    , subheaderClass
    , divider
    , hr
    , padded
    , inset
    )

{-| Lists present multiple line items vertically as a single
continuous element. Both single-line and two-line lists are supported.

The elements inside a list are not regular `Html m` elements but
`ListItem m` elements. This to make lists easy to use while still
providing ripple support.

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
@docs node


## List Items

Lists do not take the normal `Html m` elements, as that would lead to
an awkward interface. They need a ListItem type. Usually this is
transparent, but you'll notice when you try to use ordinary html
inside a list. In that case prefix your html with `asListItem`.

List items automatically get keyboard focus. Here's the algorithm
elm-mdc follows:

* If `selectedIndex` is set, that item will receive the focus.
* Else the first list item which has the `selected` or `activated` state will receive the focus.
* Else the first list item will receive the focus.

@docs ListItem
@docs ChildList
@docs li
@docs a
@docs listItemClass
@docs text
@docs primaryText
@docs secondaryText
@docs selected, activated, disabled
@docs graphic, graphicIcon, graphicImage, graphicClass
@docs meta, metaText, metaIcon, metaImage, metaClass
@docs asListItem
@docs aRippled


## List Groups

@docs group
@docs subheader
@docs subheaderClass


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


{-| Use to set the appropriate type for ListItem.children in case you create your own `ListItem`.
-}
type alias ChildList m =
    List.ChildList m


{-| The ListItem type as returned by `li` and `divider` and such. As
Html m nodes cannot be manipulated, we use pseudo nodes, which can
render themselves when needed.
-}
type alias ListItem m =
    List.ListItem m


{-| A list rendered with an Html.ul node.
-}
ul :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (ListItem m)
    -> Html m
ul =
    List.view


{-| A list rendered with an Html.ol node.
-}
ol :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (ListItem m)
    -> Html m
ol lift domId model options items =
    List.view lift domId model (List.node Html.ol :: options) items


{-| A list rendered with an Html.nav node.
-}
nav :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (ListItem m)
    -> Html m
nav lift domId model options items =
    List.view lift domId model (List.node Html.nav :: options) items


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


{-| Optional, modifier to style list with two lines (primary and secondary lines).
-}
twoLine : Property m
twoLine =
    List.twoLine


{-| List item element.
-}
li : List (Property m) -> List (Html m) -> ListItem m
li =
    List.li


{-| List item element as anchor element `<a>`.

-}
a : List (Property m) -> List (Html m) -> ListItem m
a options items =
    List.li (List.node Html.a :: options) items


{-| A list item that can be used outside a list, and still has ripple effects.
-}
aRippled :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
aRippled =
    List.aRippled


{-| The class that marks an element as a list item.
-}
listItemClass : Property m
listItemClass =
    List.listItemClass


{-| Wrapper element for text in list item. Required when using `primaryText` and `secondaryText`.
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


{-| Styles a row in the selected state.
-}
selected : Property m
selected =
    List.selected


{-| Styles a row in the activated state. This will only take effect
when the `singleSelection` and useActivated` options have been set on
the list.

NOTE: In Material Design, the selected and activated states apply in
different, mutually-exclusive situations:

  - Selected state should be applied on the list item when it is likely
    to frequently change due to user choice. E.g., selecting one or more
    photos to share in Google Photos.

  - Activated state is more permanent than selected state, and will NOT
    change soon relative to the lifetime of the page. Common examples
    are navigation components such as the list within a navigation
    drawer.

-}
activated : Property m
activated =
    List.activated


{-| Styles a row in the disabled state.

Disabled rows will not ripple. Disabled rows will not trigger `onSelectListItem`.

Disabled list item will be included in the keyboard navigation. Please
see [Focusability of disabled
controls](https://www.w3.org/TR/wai-aria-practices-1.1/#kbd_disabled_controls)
section in ARIA practices article.

-}
disabled : Property m
disabled =
    List.disabled


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


{-| Class to use to mark an element as the first tile in a
row. Typically small text, icon. or image.
-}
graphicClass : Options.Property c m
graphicClass =
    List.graphicClass


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


{-| Insert arbitrary html into a list by prefixing it with `asListItem`.
-}
asListItem : (List (Html.Attribute m) -> List (Html m) -> Html m) -> List (Property m) -> List (Html m) -> ListItem m
asListItem =
    List.asListItem


{-| Wrapper around two or more list elements to be grouped together.
-}
group : List (Property m) -> List (Html m) -> Html m
group =
    List.group


{-| Heading text displayed above each list in a group.

Thed default node is a div, but you can emit an h3 with:

    import Html exposing (text)
    import Material.List as Lists

    Lists.subheader [ Lists.node Html.h3 ] [ text "List 1" ]

-}
subheader : List (Property m) -> List (Html m) -> Html m
subheader =
    List.subheader


{-| The class that makes an item a group subheader.

Usually using `subheader` is sufficient.

This class is used both inside a list to label elements in a drawer, or outside
a list to mark a group.

-}
subheaderClass : Options.Property c m
subheaderClass =
    List.subheaderClass


{-| List divider list item.
-}
divider : List (Property m) -> List (Html m) -> ListItem m
divider =
    List.divider


{-| List divider element.
-}
hr : List (Property m) -> List (Html m) -> ListItem m
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
`selected` and `activated` classes and aria elements are applied
automatically.

Note: the index currently includes dividers.

-}
selectedIndex : Int -> Property m
selectedIndex =
    List.selectedIndex


{-| Msg to send when a list item has been selected.

Disabled list items will be ignored.

Perhaps a bug: the index sent includes dividers, i.e. it's an index
into the list you passed.

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


{-| Set this property on a list if the selection logic needs to
apply/remove the `activated` class, instead of the `selected` class.

-}
useActivated : Property m
useActivated =
    List.useActivated


{-| Set the Html node to use when rendering a List or a ListItem.

Example:

    import Html exposing (text)
    import Material.List as Lists

    Lists.subHeader [ Lists.node Html.h3 ] [ text "List 1" ]

-}
node : (List (Html.Attribute m) -> List (Html m) -> Html m) -> Property m
node =
    List.node
