module Material.RichTooltip exposing
    ( Property
    , actions
    , button
    , content
    , contentLink
    , hide
    , interactive
    , show
    , shown
    , title
    , view
    , withInteractiveTooltip
    , withTooltip
    , wrapper
    )

{-| Tooltips display informative text when users hover over, focus on, or tap an element.

# Resources

  - [Tooltip - Material Components for the Web](https://github.com/material-components/material-components-web/tree/master/packages/mdc-tooltip)
  - [Material Design guidelines: Sliders](https://material.io/components/tooltips)
  - [Demo](https://aforemny.github.io/elm-mdc/tooltip)


# Rich tooltips

Rich tooltips have two variants: non-interactive and interactive. An
interactive tooltip has a link or a button.

A rich tooltip can also be persisent. The default is not persistent.

Default rich tooltips are shown when users hover over or focus on
their anchor element. They remain shown when users focus/hover over
the contents of the rich tooltip, but becomes hidden if the users
focus/hover outside of the anchor element or the tooltip contents. If
the user clicks within the contents of the tooltip, the tooltip will
also be hidden.

TODO: Persistent rich tooltips' visibility is toggled by clicks and
enter/space bar keystrokes on their anchor element. When shown, they
remain visible when users focus/hover over the contents of the rich
tooltip, as well as when users hover outside of the anchor element or
the tooltip contents. However, they become hidden when the users focus
outside of the anchor element or the tooltip contents. If the user
clicks within the contents of the tooltip, the tooltip remains
shown. If the user clicks outside the contents of the tooltip, the
tooltip will be hidden. It is recommended that persistent rich
tooltips are not added to anchor elements that already have an click
action; the click action for the anchor element should be used solely
to toggle the visibility of the rich tooltip.


# Non-interactive rich tooltip example

Non-interactive rich tooltips have neither a link nor action
button. Use `withTooltip` to link the anchor to the tooltip.

```
import Material.Options as Options exposing (styled)
import Material.PlainTooltip as Tooltip exposing (withTooltip)

view =
  div []
    [ RichTooltip.wrapper
      [ id "rich-tooltip-wrapper" ]
      [ Button.view Mdc
        "rich-tooltip-button"
        model.mdc
        [ Button.ripple
        , RichTooltip.withTooltip Mdc "rich-tooltip-wrapper" "rich-tooltip-button" "tt0"
        ]
        [ text "Button"
        ]
      , RichTooltip.view Mdc
        "tt0"
        model.mdc
        [ id "tt0" ]
        [ styled p [ RichTooltip.content ]
              [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur pretium vitae est et dapibus. Aenean sit amet felis eu lorem fermentum aliquam sit amet sit amet eros." ]
        ]
      ]
    ]
```

# Interactive rich tooltip example

Interactive rich tooltips have a link or action button. Use
`withRichTooltip` to link the anchor to the tooltip.

```
div []
  [ RichTooltip.wrapper
    [ id "rich-interactive-tooltip-wrapper" ]
    [ Button.view Mdc
      "rich-interactive-tooltip-button"
      model.mdc
      [ Button.ripple
      , RichTooltip.withInteractiveTooltip Mdc model.mdc "rich-interactive-tooltip-wrapper" "rich-interactive-tooltip-button" "tt1"
      ]
      [ text "Button"
      ]
    , RichTooltip.view Mdc
      "tt1"
      model.mdc
      [ id "tt1"
      , RichTooltip.interactive
      ]
      [ styled h2 [ RichTooltip.title ] [ text "Lorem Ipsum" ]
      , styled p [ RichTooltip.content ]
        [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur pretium vitae est et dapibus. Aenean sit amet felis eu lorem fermentum aliquam sit amet sit amet eros. "
        , styled a [ RichTooltip.contentLink, attribute <| href "google.com" ] [ text "link" ]
        ]
      , RichTooltip.actions []
        [ RichTooltip.button [] [ text "action" ]
        ]
      ]
    ]
  ]
```

# Usage

## Rich tooltip

@docs Property
@docs view
@docs shown
@docs title
@docs content

## Interactive tooltip

@docs interactive
@docs contentLink
@docs button
@docs actions

## Anchor

@docs show
@docs hide
@docs withTooltip
@docs withInteractiveTooltip

## Wrapper for tooltip and anchor

@docs wrapper

-}

import Dict
import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Options as Options exposing (aria, cs, when)
import Internal.Tooltip.Implementation as Tooltip
import Internal.Tooltip.Model as Tooltip
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
view lift domId store options nodes =
    Tooltip.view lift domId store ( Tooltip.rich :: options ) nodes


{-| Class to use for content.

Example:
```
import Material.RichTooltip as RichTooltip

RichTooltip.view Mdc "tt1" model.mdc
    [ id "tt1" ]
    [ styled p
          [ RichTooltip.content ]
          [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur pretium vitae est et dapibus. Aenean sit amet felis eu lorem fermentum aliquam sit amet sit amet eros."
          ]
    ]
```
-}
content : Property m
content =
    Tooltip.content


{-| Class to use for a link inside `content`. This is needed to make
sure the link is formatted properly.

Example:
```
import Material.RichTooltip as RichTooltip

RichTooltip.view Mdc "tt1" model.mdc
    [ id "tt1" ]
    [ styled p
          [ RichTooltip.content ]
          [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur pretium vitae est et dapibus. Aenean sit amet felis eu lorem fermentum aliquam sit amet sit amet eros."
          , styled a [ RichTooltip.contentLink, href "google.com" ] [ text "link" ]
          ]
    ]
```
-}
contentLink : Property m
contentLink =
    Tooltip.contentLink


{-| Class to use for a tooltip title.

Example:
```
import Material.RichTooltip as RichTooltip

RichTooltip.view Mdc "tt1" model.mdc
    [ id "tt1" ]
    [ styled h2 [ RichTooltip.title ] [ text "Lorem Ipsum" ]
    , styled p
        [ RichTooltip.content ]
        [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur pretium vitae est et dapibus. Aenean sit amet felis eu lorem fermentum aliquam sit amet sit amet eros." ]
    ]
```
-}
title : Property m
title =
    Tooltip.title


{-| Force showing the tooltip without animation.

Only useful for our demo. Has no other use.
-}
shown : Property m
shown =
    Tooltip.shown


{-| Set this property if the tooltip is interactive.

Interactive tooltips have either a link or an action button.
-}
interactive : Property m
interactive =
    Tooltip.interactive



{-| Message to make tooltip appear next to its anchor.

You probably want to use `withTooltip` instead.
-}
show : Index -> Index -> Index -> Msg m
show wrapper_id anchor_id tooltip_id =
    Internal.Msg.TooltipMsg tooltip_id <| Tooltip.ShowRichTooltip wrapper_id anchor_id tooltip_id


{-| Message to hide tooltip.

You probably want to use `withTooltip` instead.
-}
hide : Index -> Msg m
hide =
    Tooltip.hide


{-| Option to set on anchor element to link it to a non-interactive rich tooltip.

It also adds the `id` attribute to the anchor element.

Example:

```
import Material.Options as Options exposing (styled)
import Material.Tooltip as Tooltip exposing (withTooltip)

div []
    [ RichTooltip.wrapper
          [ id "rich-tooltip-wrapper" ]
          [ Button.view Mdc
                "rich-tooltip-button"
                model.mdc
                [ Button.ripple
                , RichTooltip.withTooltip Mdc "rich-tooltip-wrapper" "rich-tooltip-button" "tt0"
                ]
                [ text "Button"
                ]
          , RichTooltip.view Mdc
                "tt0"
                model.mdc
                [ id "tt0" ]
                [ styled p [ RichTooltip.content ]
                      [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur pretium vitae est et dapibus. Aenean sit amet felis eu lorem fermentum aliquam sit amet sit amet eros." ]
                ]
          ]
    ]
```
-}
withTooltip :
    (Material.Msg m -> m)
    -> Index
    -> Index
    -> Index
    -> Options.Property c m
withTooltip lift wrapper_id anchor_id tooltip_id =
    Options.many
        [ Options.id anchor_id
        , aria "describedby" tooltip_id
        , Options.onMouseEnter ( lift <| show wrapper_id anchor_id tooltip_id  )
        , Options.onMouseLeave ( lift <| hide tooltip_id )
        , Options.onFocus ( lift <| show wrapper_id anchor_id tooltip_id )
        , Options.onBlur ( lift <| hide tooltip_id )
        ]



{-| Option to set on anchor element to link it to the given tooltip.

It also adds the `id` attribute to the anchor element. Note that the
"aria-describedby" element is not set. This should be added to the
anchor element manually if the tooltip is not interactive.

Example:

```
import Material.Options as Options exposing (styled)
import Material.Tooltip as Tooltip exposing (withInteractiveTooltip)

div []
    [ RichTooltip.wrapper
          [ id "rich-tooltip-wrapper" ]
          [ Button.view Mdc
                "rich-tooltip-button"
                model.mdc
                [ Button.ripple
                , RichTooltip.withInteractiveTooltip Mdc model.mdc "rich-tooltip-wrapper" "rich-tooltip-button" "tt0"
                ]
                [ text "Button" ]
          , RichTooltip.view Mdc
                "tt0"
                model.mdc
                [ id "tt0"
                , RichTooltip.interactive
                ]
                [ styled p [ RichTooltip.content ]
                      [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
                      , styled a [ RichTooltip.contentLink, attribute <| href "google.com" ] [ text "link" ]
                      ]
                ]
          , RichTooltip.actions []
                [ RichTooltip.button [] [ text "action" ]
                ]
          ]
    ]
```
-}
withInteractiveTooltip :
    (Material.Msg m -> m)
    -> Material.Model m
    -> Index
    -> Index
    -> Index
    -> Options.Property c m
withInteractiveTooltip lift mdc wrapper_id anchor_id tooltip_id =
    let
        tooltip = Dict.get tooltip_id mdc.tooltip

        is_expanded =
            case tooltip of
                Just t -> t.state == Tooltip.Showing || t.state == Tooltip.Shown
                Nothing -> False
    in
    Options.many
        [ Options.id anchor_id
        , aria "haspopup" "dialog"
        , aria "expanded" (if is_expanded then "true" else "false")
        , Options.onMouseEnter ( lift <| show wrapper_id anchor_id tooltip_id  )
        , Options.onMouseLeave ( lift <| hide tooltip_id )
        , Options.onFocus ( lift <| show wrapper_id anchor_id tooltip_id )
        , Options.onBlur ( lift <| hide tooltip_id )
        ]




{-| Wrapper element for both the rich tooltip and its anchor.

Needs to have an id attribute that is passed with `withTooltip`.
-}
wrapper : List (Property m) -> List (Html m) -> Html m
wrapper =
    Tooltip.wrapper


{-| Wrapper for `button` element which are actions in this tooltip.
-}
actions : List (Property m) -> List (Html m) -> Html m
actions =
    Tooltip.actions


{-| A button inside `actions`.
-}
button : List (Property m) -> List (Html m) -> Html m
button =
    Tooltip.button
