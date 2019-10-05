module Material.TopAppBar exposing
    ( Property
    , view
    , fixed
    , dense
    , prominent
    , short
    , collapsed
    , hasActionItem
    , section
    , alignStart
    , alignEnd
    , navigationIcon
    , title
    , actionItem
    , fixedAdjust
    , denseFixedAdjust
    , prominentFixedAdjust
    , onScroll
    )

{-| A top app bar is a container for items such as application title,
navigation icon, and action items.


# Resources

  - [Top App Bar - Internal.Components for the Web](https://material.io/develop/web/components/top-app-bar/)
  - [Material Design guidelines: Top app bar](https://material.io/go/design-app-bar-top)
  - [Demo](https://aforemny.github.io/elm-mdc/#top-app-bar)


# Example

    import Html exposing (text)
    import Material.TopAppBar as TopAppBar


    TopAppBar.view Mdc "my-top-app-bar" model.mdc
        [ TopAppBar.fixed ]
        [ TopAppBar.section [ TopAppBar.alignStart ]
              [ TopAppBar.navigationIcon Mdc "my-menu" model.mdc
                    [ Options.onClick OpenDrawer ] "menu"
              , TopAppBar.title [] [ text title ]
              ]
          , TopAppBar.section [ TopAppBar.alignEnd ]
              [ TopAppBar.actionItem Mdc "my-download" model.mdc [] "file_download"
              , TopAppBar.actionItem Mdc "my-print" model.mdc [] "print"
              , TopAppBar.actionItem Mdc "my-bookmark" model.mdc [] "bookmark"
              ]
        ]


# Usage

@docs Property
@docs view


## Standard variant

@docs onScroll


## Fixed variant

@docs fixed


## Dense varianet

@docs dense


## Prominent variant

@docs prominent


## Short variant

@docs short
@docs collapsed
@docs hasActionItem


## Sections

@docs section
@docs alignStart
@docs alignEnd


## Section elements

@docs navigationIcon
@docs title
@docs actionItem


## Fixed adjusts

@docs fixedAdjust
@docs denseFixedAdjust
@docs prominentFixedAdjust

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.TopAppBar.Implementation as TopAppBar
import Material
import Material.Icon as Icon
import Material.Options as Options exposing (cs)


{-| TopAppBar property.
-}
type alias Property m =
    TopAppBar.Property m


{-| TopAppBar view.

Note that you will have to mark your page's content with the property
`TopAppBar.fixedAdjust`. Otherwise, the top app bar will overlap your content.

-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    TopAppBar.view


{-| TopAppBar section.

A TopAppBar should have at least one section. Without arguments the
section will be centered. Use `alignStart` and `alignEnd` to create
sections that align left and right respectively.

-}
section : List (Property m) -> List (Html m) -> Html m
section =
    TopAppBar.section


{-| Add a title to the top app bar.
-}
title : List (Property m) -> List (Html m) -> Html m
title =
    TopAppBar.title


{-| Action item placed on the side opposite of the navigation icon.
-}
actionItem :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Icon.Property m)
    -> String
    -> Html m
actionItem lift index model options name =
    TopAppBar.actionItem lift index model (cs "mdc-top-app-bar__action-item" :: options) name


{-| Make section align to the start.
-}
alignStart : Property m
alignStart =
    TopAppBar.alignStart


{-| Make section align to the end.
-}
alignEnd : Property m
alignEnd =
    TopAppBar.alignEnd


{-| Represent the navigation element in the top left corner.
-}
navigationIcon :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Icon.Property m)
    -> String
    -> Html m
navigationIcon lift index model options name =
    TopAppBar.actionItem lift index model (cs "mdc-top-app-bar__navigation-icon" :: options) name


{-| Fixed top app bars stay at the top of the page and elevate above
the content when scrolled.
-}
fixed : Property m
fixed =
    TopAppBar.fixed


{-| The dense top app bar is denser.
-}
dense : Property m
dense =
    TopAppBar.dense


{-| The prominent top app bar is taller.
-}
prominent : Property m
prominent =
    TopAppBar.prominent


{-| Short top app bars are top app bars that can collapse to the
navigation icon side when scrolled. Short top app bars should be used
with no more than 1 action item.
-}
short : Property m
short =
    TopAppBar.short


{-| Short top app bars can be configured to always appear collapsed.
-}
collapsed : Property m
collapsed =
    TopAppBar.collapsed


{-| Use this class if the short top app bar has an action item.
-}
hasActionItem : Property m
hasActionItem =
    TopAppBar.hasActionItem


{-| Adds a top margin to the element so that it is not covered by a top app
bar.

Not only the `fixed` TopAppBar requires this, but also the standard variant.
See below for special `dense` and `prominent` variants.

-}
fixedAdjust : Options.Property c m
fixedAdjust =
    TopAppBar.fixedAdjust


{-| Adds a top margin to the element so that it is not covered by a dense top
app bar.
-}
denseFixedAdjust : Options.Property c m
denseFixedAdjust =
    TopAppBar.denseFixedAdjust


{-| Adds a top margin to the element so that it is not covered by a prominent
top app bar.
-}
prominentFixedAdjust : Options.Property c m
prominentFixedAdjust =
    TopAppBar.prominentFixedAdjust


{-| When you have a standard top app bar, but are using a dismissible
drawer, you may wish to scroll the drawer's contents (the element that
will have the `DismissibleDrawer.AppContent`) class. In such a case
the global window does not scroll, so the drawer will behave like if
you had used `fixed`. Set this property on the application contents
class in order to scroll the top app bar when you scroll inside the
div where you had set this property.

```
styled div
  [ DismissibleDrawer.appContent
  , TopAppBar.appContent
  , TopAppBar.onScroll Mdc "my-top-appbar"
  ]
  [ ... ]
```
-}
onScroll :
    (Material.Msg m -> m)
    -> Index
    -> Options.Property c m
onScroll =
    TopAppBar.onScroll
