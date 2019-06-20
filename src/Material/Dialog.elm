module Material.Dialog exposing
    ( Property
    , view
    , open
    , onClose
    , title
    , content
    , scrollable
    , actions
    , cancel
    , accept
    , noScrim
    )

{-| Dialogs inform users about a specific task and may contain
critical information, require decisions, or involve multiple tasks.

Because a Dialog animates when closing, it should not be removed from DOM. Use
`Dialog.open` conditionally instead.


# Resources

  - [Dialogs - Material Components for the Web](https://material.io/develop/web/components/dialogs/)
  - [Material Design guidelines: Dialogs](https://material.io/design/components/dialogs.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#dialog)


# Example

    import Html exposing (text)
    import Material.Button as Button
    import Material.Dialog as Dialog
    import Material.Options as Options exposing (styled, when)


    Dialog.view Mdc "my-dialog" model.mdc
        [ Dialog.open |> when model.showDialog
        , Dialog.onClose Cancel
        ]
        [ styled Html.h2
              [ Dialog.title
              ]
              [ text "Use Google's location service?"
              ]
        , Dialog.content []
              [ text
                    """
                     Let Google help apps determine location. This means
                     sending anonymous location data to Google, even when
                     no apps are running.
                     """
              ]
        , Dialog.actions []
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


# Aria role

The default role is
"[alertdialog](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/ARIA_Techniques/Using_the_alertdialog_role)". If
the dialog is not an alert dialog, override the default by passing in
a different role, typically the "[dialog](https://developer.mozilla.org/en-US/docs/Web/Accessibility/ARIA/Roles/dialog_role)" role.


    import Material.Dialog as Dialog
    import Material.Options as Options exposing (role, when)

    Dialog.view Mdc "my-dialog" model.mdc
        [ Dialog.open |> when model.showDialog
        , Dialog.onClose Cancel
        , role "dialog"
        ]
        [ ]



# Usage

@docs Property
@docs view
@docs open
@docs onClose
@docs title
@docs content
@docs scrollable
@docs actions
@docs cancel
@docs accept
@docs noScrim

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


{-| Dialog content.

This element wraps the dialog's content except for `header` and `actions`
content.

-}
content : List (Property m) -> List (Html m) -> Html m
content =
    Dialog.content


{-| Make the dialog's body scrollable.
-}
scrollable : Property m
scrollable =
    Dialog.scrollable


{-| Dialog title.
-}
title : Options.Property c m
title =
    Dialog.title


{-| Dialog actions, appearing as a footer.
-}
actions : List (Property m) -> List (Html m) -> Html m
actions =
    Dialog.actions


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


{-| Property to indicate that no scrim should be added. Only useful for the hero example dialog.
-}
noScrim : Property m
noScrim =
    Dialog.noScrim
