module Material.Drawer.Temporary
    exposing
        ( Property
        , content
        , header
        , headerContent
        , onClose
        , open
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

    import Html exposing (text)
    import Material.Drawer.Temporary as Drawer
    import Material.List as Lists


    Drawer.view Mdc "my-drawer" model.mdc []
        [ Drawer.toolbarSpacer [] []
        , Lists.ul
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


# Usage

@docs Property
@docs view
@docs content
@docs toolbarSpacer
@docs header
@docs headerContent
@docs onClose
@docs open

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Drawer.Temporary.Implementation as Drawer
import Material
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


{-| Message that must be sent when the drawer wants to be close
-}
onClose : m -> Property m
onClose =
    Drawer.onClose


{-| When present, makes the drawer open.
-}
open : Property m
open =
    Drawer.open
