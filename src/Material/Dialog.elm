module Material.Dialog exposing
    ( accept
    , backdrop
    , body
    , Property
    , cancel
    , footer
    , header
    , open
    , scrollable
    , surface
    , title
    , view
    , openOn
    )

{-|
The Dialog component is a spec-aligned dialog component adhering to the
Material Design dialog pattern. It implements a modal dialog window that traps
focus when opening and restores focus when closing.  

The current implementation requires that a dialog has as first child a
`surface` element and as second child a `backdrop` element.


# Resources

- [Material Design guidelines: Dialogs](https://material.io/guidelines/components/dialogs.html)
- [Demo](https://aforemny.github.io/elm-mdc/#dialog)


# Example

```elm
import Html exposing (text)
import Material.Button as Button
import Material.Dialog as Dialog
import Material.Options as Options exposing (styled)


Dialog.view Mdc [0] model.mdc
    [ Dialog.open
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
                  Button.view Mdc [0,0] model.mdc
                      [ Button.ripple
                      , Dialog.cancel
                      , Options.onClick Cancel
                      ]
                      [ text "Decline"
                      ]
                ,
                  Button.view Mdc [0,1] model.mdc
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
```


# Usage

@docs Property
@docs view
@docs open
@docs openOn
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
import Material.Button as Button
import Material.Component exposing (Indexed, Index)
import Material.Internal.Dialog.Implementation as Dialog
import Material.Msg
import Material.Options as Options


{-| Dialog property.
-}
type alias Property m =
    Dialog.Property m


type alias Store s =
    { s | dialog : Indexed Dialog.Model }


{-| Dialog view.
-}
view
    : (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
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


{-| Opens the dialog on an event on another component.

```elm
Button.view Mdc [1] model.mdc
    [ Dialog.openOn Mdc [0] "click"
    ]
    [ text "Show Dialog with index [0]"
    ]
```
-}
openOn : (Material.Msg.Msg m -> m) -> List Int -> String -> Options.Property c m
openOn =
    Dialog.openOn
