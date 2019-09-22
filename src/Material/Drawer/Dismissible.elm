module Material.Drawer.Dismissible exposing
    ( Property
    , view
    , content
    , header
    , title
    , subTitle
    , onClose
    , open
    , appContent
    )

{-| Dismissible drawers are by default hidden off screen, and can
slide into view. Dismissible drawers should be used when navigation is
not common, and the main app content is prioritized.


# Resources

  - [Material Design guidelines: Navigation drawer](https://material.io/design/components/navigation-drawer.html)
  - [Drawers - Material Components for the Web](https://material.io/develop/web/components/drawers/)
  - [Demo: Modal Drawer](https://aforemny.github.io/elm-mdc/#modal-drawer)
  - [Demo: Dismissible Drawer](https://aforemny.github.io/elm-mdc/#dismissible-drawer)
  - [Demo: Permanent Drawer](https://aforemny.github.io/elm-mdc/#permanent-drawer)


# Example

    import Html exposing (Html, text, h3, h6)
    import Html.Attributes as Html
    import Material.Options as Options exposing (styled)
    import Material.Drawer.Dismissible as Drawer
    import Material.List as Lists


    Drawer.view Mdc "my-drawer" model.mdc
        [ Drawer.open |> when model.is_drawer_open ]
        [ Drawer.header [ ]
            [ styled h3 [ Drawer.title ] [ text "Mail" ]
            , styled h6 [ Drawer.subTitle ] [ text "email@material.io" ]
            ]
        , Drawer.content []
              [ Lists.nav Mdc "my-list" model.mdc
                    [ Lists.singleSelection
                    , Lists.useActivated
                    ]
                    [ Lists.a
                          [ Options.attribute (Html.href "#persistent-drawer")
                          , Lists.activated
                          ]
                          [ Lists.graphicIcon [] "inbox"
                          , text "Inbox"
                          ]
                    , Lists.a
                          [ Options.attribute (Html.href "#persistent-drawer")
                          ]
                          [ Lists.graphicIcon [] "star"
                          , text "Star"
                          ]
                    , Lists.divider [] []
                    , Lists.a
                          [ Options.attribute (Html.href "#persistent-drawer")
                          ]
                          [ Lists.graphicIcon [] "send"
                          , text "Sent Mail"
                          ]
                    , Lists.a
                          [ Options.attribute (Html.href "#persistent-drawer")
                          ]
                          [ Lists.graphicIcon [] "drafts"
                          , text "Drafts"
                          ]
                    ]
              ]
        ]

To make keyboard navigation work, you will need to add
Lists.onSelectListItem to the list above.


# Usage

@docs Property
@docs view
@docs content
@docs header
@docs title
@docs subTitle
@docs onClose
@docs open
@docs appContent

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Drawer.Dismissible.Implementation as Drawer
import Material


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


{-| Class to style a title in drawer header.
-}
title : Property m
title =
    Drawer.title


{-| Class to style a subtitle in drawer header.
-}
subTitle : Property m
subTitle =
    Drawer.subTitle


{-| Container to contain the drawer contents.
-}
content : List (Property m) -> List (Html m) -> Html m
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


{-| Apply the mdc-drawer-app-content class to the sibling element
after the drawer for the open/close animations to work.
-}
appContent : Property m
appContent =
    Drawer.appContent
