module Material.PlainTooltip exposing
    ( Property
    , hide
    , show
    , shown
    , view
    , withTooltip
    , withTooltipPosition
    )

{-| Tooltips display informative text when users hover over, focus on, or tap an element.

# Resources

  - [Tooltip - Material Components for the Web](https://github.com/material-components/material-components-web/tree/master/packages/mdc-tooltip)
  - [Material Design guidelines: Sliders](https://material.io/components/tooltips)
  - [Demo](https://aforemny.github.io/elm-mdc/tooltip)


# Example

    import Material.Options as Options exposing (styled)
    import Material.PlainTooltip as Tooltip exposing (withTooltip)

    view =
        div
            [ Tooltip.view Mdc "my-tooltip" model.mdc
                []
                [ text "lorem ipsum dolor" ]
            , styled a
                [ attribute <| href "www.google.com"
                , withTooltip (lift << Mdc) "link-id" "tooltip-id"
                ]
                [ text "Link" ]
            ]

# Usage


## Tooltip

@docs Property
@docs view
@docs shown

## Anchor

@docs show
@docs hide
@docs withTooltip

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Options as Options
import Internal.Tooltip.Implementation as Tooltip
import Internal.Tooltip.Model as Tooltip
import Material.Tooltip.XPosition as XPosition exposing (XPosition)
import Material.Tooltip.YPosition as YPosition exposing (YPosition)
import Internal.Msg exposing (Msg)
import Material


{-| Properties for Tooltip options.
-}
type alias Property m =
    Tooltip.Property m



{-| Tooltip view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Tooltip.view


{-| Force showing the tooltip without animation.

Only useful for our demo. Has no other use.
-}
shown : Property m
shown =
    Tooltip.shown



{-| Message to make tooltip appear next to its anchor.

You probably want to use `withTooltip` instead.
-}
show : Index -> Index -> XPosition -> YPosition -> Msg m
show anchor_id tooltip_id xposition yposition =
    Internal.Msg.TooltipMsg tooltip_id <| Tooltip.ShowPlainTooltip anchor_id tooltip_id xposition yposition


{-| Message to hide tooltip.

You probably want to use `withTooltip` instead.
-}
hide : Index -> Msg m
hide =
    Tooltip.hide


{-| Option to add to anchor element to link it to a given tooltip.

It also adds the `id` and `aria-describedby` attributes to the anchor element.

Example:

```
import Material.Options as Options exposing (styled)
import Material.Tooltip as Tooltip exposing (withTooltip)

styled a
  [ attribute <| href "www.google.com"
  , withTooltip Mdc "link-id" "tooltip-id"
  ]
  [ text "Link" ]
```
-}
withTooltip :
    (Material.Msg m -> m)
    -> Index
    -> Index
    -> Property m
withTooltip lift anchor_id tooltip_id =
    withTooltipPosition lift anchor_id tooltip_id XPosition.Detected YPosition.Detected


{-| As `withTooltip` but allows you to set the preferred x and y position of the tooltip.

```
import Material.PlainTooltip exposing (withTooltipPosition)
import Material.Tooltip.XPosition as XPosition exposing (XPosition)
import Material.Tooltip.YPosition as YPosition exposing (YPosition)

[ withTooltipPosition Mdc "link-id" "tooltip-id" XPosition.End YPosition.Above ]
```
-}
withTooltipPosition :
    (Material.Msg m -> m)
    -> Index
    -> Index
    -> XPosition
    -> YPosition
    -> Property m
withTooltipPosition lift anchor_id tooltip_id xposition yposition =
    Options.many
        [ Options.id anchor_id
        , Options.aria "describedby" tooltip_id
        , Options.onMouseEnter ( lift <| show anchor_id tooltip_id xposition yposition )
        , Options.onMouseLeave ( lift <| hide tooltip_id )
        , Options.onFocus ( lift <| show anchor_id tooltip_id xposition yposition )
        , Options.onBlur ( lift <| hide tooltip_id )
        ]
