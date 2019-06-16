module Material.IconButton exposing
    ( Property
    , view
    , on
    , icon, icon1
    , iconElement, onIconElement
    , label, label1
    , disabled
    , className
    )

{-| Icons are appropriate for buttons that allow a user to take actions or make a selection, such as adding or removing a star to an item.


# Resources

  - [Material Design guidelines: Toggle buttons](https://material.io/guidelines/components/buttons.html#buttons-toggle-buttons)
  - [Demo](https://aforemny.github.io/elm-mdc/#icon-button)


# Example

    import Material.IconButton as IconButton
    import Material.Options as Options


    IconButton.view Mdc "my-icon-button" model.mdc
        [ IconButton.icon
              { on = "favorite_border"
              , off = "favorite"
              }
        , IconButton.label
              { on = "Remove from favorites"
              , off = "Add to favorites"
              }
        , IconButton.on
        , Options.onClick Toggle
        ]
        []


# Usage

@docs Property
@docs view
@docs on
@docs icon, icon1
@docs iconElement, onIconElement
@docs label, label1
@docs disabled
@docs className

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.IconButton.Implementation as IconButton
import Material


{-| IconButton property.
-}
type alias Property m =
    IconButton.Property m


{-| IconButton view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    IconButton.view


{-| Make the icon toggle appear in its "on" state.

Defaults to "off". Use `Options.when` to make it interactive.

-}
on : Property m
on =
    IconButton.on


{-| Sets an alternate classname of the icon.

Useful if you want to use a different icon set. For example use `"fa"` for
FontAwesome.

-}
className : String -> Property m
className =
    IconButton.className


{-| Set the icon.

Specify an icon for the icon toggle's "on" and "off" state. Using a
separate "on" and "off" icon makes this a icon button toggle.

-}
icon : { on : String, off : String } -> Property m
icon =
    IconButton.icon


{-| Set the icon.

Uses the same icon for the icon toggle's "on" and "off" state.

-}
icon1 : String -> Property m
icon1 =
    IconButton.icon1


{-| When using SVG or image icons, use this as the class name.
-}
iconElement : Property m
iconElement =
    IconButton.iconElement


{-| When using SVG or image icons, use this in addition to iconElement
to specify the on icon.
-}
onIconElement : Property m
onIconElement =
    IconButton.onIconElement


{-| Set the icon toggle's aria label.

Specify a aria label for the icon toggle's "on" and "off" state.

-}
label : { on : String, off : String } -> Property m
label =
    IconButton.label


{-| Set the label.

Uses the same aria label for both the icon toggle's "on" and "off" state.

-}
label1 : String -> Property m
label1 =
    IconButton.label1


{-| Disable the icon toggle.
-}
disabled : Property m
disabled =
    IconButton.disabled
