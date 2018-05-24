module Material.TopAppBar exposing
    ( actionItem
    , alignEnd
    , alignStart
    , collapsed
    , dense
    , fixed
    , fixedAdjust
    , hasActionItem
    , navigation
    , prominent
    , Property
    , short
    , section
    , title
    , view
    )


{-|
A top app bar is a container for items such as application title,
navigation icon, and action items.


# Resources

- [Top App Bar - Material Components for the Web](https://material.io/develop/web/components/top-app-bar/)
- [Material Design guidelines: Top app bar](https://material.io/go/design-app-bar-top)
- [Demo](https://aforemny.github.io/elm-mdc/#topappbar)


# Example

```elm
import Html exposing (text)
import Material.TopAppBar as TopAppBar


TopAppBar.view Mdc [0] model.mdc []
    [ TopAppBar.fixed ]
    [ TopAppBar.section [ TopAppBar.alignStart ]
          [ TopAppBar.navigation [ Options.onClick OpenDrawer ] "menu"
          , TopAppBar.title [] [ text title ]
          ]
      , TopAppBar.section [ TopAppBar.alignEnd ]
          [ TopAppBar.actionItem [] "file_download"
          , TopAppBar.actionItem [] "print"
          , TopAppBar.actionItem [] "bookmark"
          ]
    ]
```


# Usage

@docs Property
@docs view
@docs dense
@docs fixed
@docs fixedAdjust
@docs prominent
@docs navigation
@docs actionItem
@docs short
@docs hasActionItem
@docs collapsed
@docs section
@docs alignStart
@docs alignEnd
@docs title
-}

import Html exposing (Html)
import Material
import Material.Component exposing (Index)
import Material.Icon as Icon
import Material.Internal.TopAppBar.Implementation as TopAppBar


{-| TopAppBar property.
-}
type alias Property m =
    TopAppBar.Property m


{-| TopAppBar view.
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

A TopAppBar should have at least one section.

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

actionItem : List (Icon.Property m) -> String -> Html m
actionItem options name =
    TopAppBar.actionItem options name


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
navigation : List (Icon.Property m) -> String -> Html m
navigation msg =
    TopAppBar.navigation msg


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



{-| Adds a top margin to the element so that it is not covered by the toolbar.

Should be applied to a direct sibling of `view`.

Note: this seems to be broken in 0.35.1, see some recent fixes, use with:
  css "padding-top" "56px", css "margin-top" "0"
-}
fixedAdjust : Property m
fixedAdjust =
    TopAppBar.fixedAdjust
