module Material.Drawer.Permanent exposing
    ( content
    , header
    , headerContent
    , Property
    , toolbarSpacer
    , view
    )

{-| The Drawer component is a spec-aligned drawer component adhering to the
Material Design navigation drawer pattern. It implements permanent, persistent,
and temporary drawers.


# Resources

- [Material Design guidelines: Navigation drawer](https://material.io/guidelines/patterns/navigation-drawer.html)
- [Demo: Temporary Drawer](https://aforemny.github.io/elm-mdc/#temporary-drawer)
- [Demo: Persistent Drawer](https://aforemny.github.io/elm-mdc/#persistent-drawer)
- [Demo: Permanent Drawer Above Toolbar](https://aforemny.github.io/elm-mdc/#permanent-drawer-above)
- [Demo: Permanent Drawer Below Toolbar](https://aforemny.github.io/elm-mdc/#permanent-drawer-below)


# Example


```elm
import Html exposing (text)
import Material.Drawer.Permanent as Drawer
import Material.List as Lists


Drawer.view Mdc "my-drawer" model.mdc []
    [ Lists.ul
          [ Drawer.content
          ]
          [ Lists.li []
                [ Lists.graphicIcon [] "inbox"
                , text "Inbox"
                ]
          , Lists.li []
                [ Lists.graphicIcon [] "star"
                , text "Star"
                ]
          , Lists.li []
                [ Lists.graphicIcon [] "send"
                , text "Sent Mail"
                ]
          , Lists.li []
                [ Lists.graphicIcon [] "drafts"
                , text "Drafts"
                ]
          ]
    ]
```


# Usage

@docs Property
@docs view
@docs content
@docs toolbarSpacer
@docs header
@docs headerContent
-}

import Html exposing (Html)
import Material
import Internal.Component exposing (Index)
import Internal.Drawer.Permanent.Implementation as Drawer
import Material.List as Lists


{-| Drawer property.
-}
type alias Property m =
    Drawer.Property m


{-| Drawer view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Drawer.view


{-| Container to create a 16:9 drawer header.
-}
header : List (Property m) -> List (Html m) -> Html m
header =
    Drawer.header


{-| Content node inside `header`.
-}
headerContent : List (Property m) -> List (Html m) -> Html m
headerContent =
    Drawer.headerContent


{-| Should be set on the list of items inside the drawer.
-}
content : Lists.Property m
content =
    Drawer.content


{-| Provide the matching amount of space for toolbar.
-}
toolbarSpacer : List (Property m) -> List (Html m) -> Html m
toolbarSpacer =
    Drawer.toolbarSpacer
