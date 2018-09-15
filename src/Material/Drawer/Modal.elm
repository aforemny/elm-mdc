module Material.Drawer.Modal
    exposing
        ( Property
        , content
        , header
        , headerContent
        , onClose
        , open
        , scrim
        , view
        )

{-| The navigation drawer slides in from the left and contains the
navigation destinations for your app. Modal drawers are elevated above
most of the app’s UI and don’t affect the screen’s layout grid.


# Resources

  - [Material Design guidelines: Navigation drawer](https://material.io/design/components/navigation-drawer.html)
  - [Demo: Modal Drawer](https://aforemny.github.io/elm-mdc/#modal-drawer)
  - [Demo: Dismissible Drawer](https://aforemny.github.io/elm-mdc/#dismissible-drawer)
  - [Demo: Permanent Drawer](https://aforemny.github.io/elm-mdc/#permanent-drawer)


# Example

    import Html exposing (text)
    import Material.Drawer.Modal as Drawer
    import Material.List as Lists


    Drawer.view Mdc "my-drawer" model.mdc []
        [ styled Html.div
              [ Drawer.content ]
              [ Lists.nav []
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
        ]


# Usage

@docs Property
@docs view
@docs content
@docs header
@docs headerContent
@docs onClose
@docs open
@docs scrim

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Drawer.Modal.Implementation as Drawer
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


{-| The mdc-drawer-scrim next sibling element protects the app’s UI
from interactions while the drawer is open.
-}
scrim : m -> Html m
scrim click =
    Drawer.scrim click
