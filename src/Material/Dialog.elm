module Material.Dialog
    exposing
        ( Property
        , accept
        , backdrop
        , body
        , cancel
        , footer
        , header
        , onClose
        , open
        , scrollable
        , surface
        , title
        , view
        )

{-| The Dialog component is a spec-aligned dialog component adhering to the
Material Design dialog pattern. It implements a modal dialog window that traps
focus when opening and restores focus when closing.

The current implementation requires that a dialog has as first child a
`surface` element and as second child a `backdrop` element.

Because a Dialog animates when closing, it should not be removed from DOM. Use
`Dialog.open` conditionally instead.


# Resources

  - [Dialogs - Internal.Components for the Web](https://material.io/develop/web/components/dialogs/)
  - [Material Design guidelines: Dialogs](https://material.io/guidelines/components/dialogs.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#dialog)


# Example

    import Html exposing (text)
    import Material.Button as Button
    import Internal.Component exposing (Index)
    import Material.Dialog as Dialog
    import Material.Options as Options exposing (styled)


    Dialog.view Mdc "my-dialog" model.mdc
        [ Dialog.open
        , Dialog.onClose Cancel
        ]
        [ Dialog.surface []
              [
                Dialog.header []
                [ styled Html.h2
                      [ Dialog.title
                      ]
                      [ text "Use Google's location service?"
                      ]
                ]
              ,
                Dialog.body []
                    [ text
                        """
    Let Google help apps determine location. This means
    sending anonymous location data to Google, even when
    no apps are running.
                        """
                    ]
              ,
                Dialog.footer []
                    [
                      Button.view Mdc "my-cancel-button" model.mdc
                          [ Button.ripple
                          , Dialog.cancel
                          , Options.onClick Cancel
                          ]
                          [ text "Decline"
                          ]
                    ,
                      Button.view Mdc "my-accept-button" model.mdc
                          [ Button.ripple
                          , Dialog.accept
                          , Options.onClick Accept
                          ]
                          [ text "Continue"
                          ]
                    ]
              ]
        , Dialog.backdrop [] []
        ]


# Usage

@docs Property
@docs view
@docs open
@docs onClose
@docs surface
@docs backdrop
@docs header
@docs title
@docs body
@docs scrollable
@docs footer
@docs cancel
@docs accept

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Dialog.Implementation as Dialog
import Material
import Material.Button as Button
import Material.Options as Options


{-| Dialog property.
-}
type alias Property m =
    Dialog.Property m


{-| Dialog view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Dialog.view


{-| Make the dialog visible.
-}
open : Property m
open =
    Dialog.open


{-| Sends an event when user clicks on the dialog's backdrop.
-}
onClose : m -> Property m
onClose =
    Dialog.onClose


{-| Dialog surface.

This element is required to be the first child of `view` and wraps all the
dialog's content such as the `header`, `body` and `footer`.

-}
surface : List (Property m) -> List (Html m) -> Html m
surface =
    Dialog.surface


{-| Dialog backdrop.

This element is required to be the second child of `view` and adds a backdrop
to the dialog.

-}
backdrop : List (Property m) -> List (Html m) -> Html m
backdrop =
    Dialog.backdrop


{-| Dialog body.

This element wraps the dialog's content except for `header` and `footer`
content.

-}
body : List (Property m) -> List (Html m) -> Html m
body =
    Dialog.body


{-| Make the dialog's body scrollable.
-}
scrollable : Property m
scrollable =
    Dialog.scrollable


{-| Dialog header.
-}
header : List (Property m) -> List (Html m) -> Html m
header =
    Dialog.header


{-| Dialog title.
-}
title : Options.Property c m
title =
    Dialog.title


{-| Dialog footer.
-}
footer : List (Property m) -> List (Html m) -> Html m
footer =
    Dialog.footer


{-| Style the button as cancel button.
-}
cancel : Button.Property m
cancel =
    Dialog.cancel


{-| Style the button as accept button.
-}
accept : Button.Property m
accept =
    Dialog.accept
