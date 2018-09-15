module Material.Drawer.Dismissible
    exposing
        ( Property
        , content
        , header
        , headerContent
        , open
        , view
        )

{-| The navigation drawer slides in from the left and contains the
navigation destinations for your app. Dismissible drawers are by
default hidden off screen, and can slide into view. Dismissible
drawers should be used when navigation is not common, and the main app
content is prioritized.


# Resources

  - [Material Design guidelines: Navigation drawer](https://material.io/design/components/navigation-drawer.html)
  - [Demo: Modal Drawer](https://aforemny.github.io/elm-mdc/#modal-drawer)
  - [Demo: Dismissible Drawer](https://aforemny.github.io/elm-mdc/#dismissible-drawer)
  - [Demo: Permanent Drawer](https://aforemny.github.io/elm-mdc/#permanent-drawer)


# Example

    import Html exposing (text)
    import Material.Drawer.Dismissible as Drawer
    import Material.List as Lists


    Drawer.view Mdc "my-drawer" model.mdc []
        [ Drawer.header []
              [ text "Header here" ]
        , styled Html.div
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


Apply the mdc-drawer-app-content class to the sibling element after
the drawer for the open/close animations to work.


# Usage

@docs Property
@docs view
@docs content
@docs header
@docs headerContent
@docs open

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Drawer.Dismissible.Implementation as Drawer
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


{-| When present, makes the drawer open.
-}
open : Property m
open =
    Drawer.open
