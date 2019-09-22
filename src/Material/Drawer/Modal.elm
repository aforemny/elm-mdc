module Material.Drawer.Modal exposing
    ( Property
    , view
    , content
    , header
    , title
    , subTitle
    , onClose
    , open
    , scrim
    )

{-| Modal drawers are elevated above most of the app’s UI and don’t
affect the screen’s layout grid.


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
    import Material.Drawer.Modal as Drawer
    import Material.List as Lists


    [ Drawer.view Mdc "my-drawer" model.mdc
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
    , Drawer.scrim [ Options.onClick CloseDrawer ] []
    , styled Html.div
        [ cs "drawer-frame-app-content" ]
        [ p [] [ text "content" ] ]
    ]

This example also demonstrates the use of `Drawer.scrim`, a sibling
element that needs to be present in the HTML for the animation to work.

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
@docs scrim

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Drawer.Modal.Implementation as Drawer
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


{-| Container to create drawer body.
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


{-| The next sibling element is required, to protect the app’s UI from
interactions while the modal drawer is open.
-}
scrim : List (Property m) -> List (Html m) -> Html m
scrim =
    Drawer.scrim
