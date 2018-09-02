module Material.Toolbar
    exposing
        ( Property
        , alignEnd
        , alignStart
        , backgroundImage
        , fixed
        , fixedAdjust
        , fixedLastRow
        , flexible
        , flexibleDefaultBehavior
        , icon
        , iconToggle
        , menuIcon
        , row
        , section
        , shrinkToFit
        , title
        , view
        , waterfall
        )

{-| The toolbar component has been deprecated by the Google Team. Some of
its functionality will be available in TopAppBar.

A toolbar is a container for multiple rows that contain items such as the
application's title, navigation menu and tabs, among other things.

By default a toolbar scrolls with the view. You can change this using the
`fixed` or `waterfall` properties. A `flexible` toolbar changes its height when
the view is scrolled.


# Resources

  - [Material Design guidelines: Toolbars](https://material.io/guidelines/components/toolbars.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#toolbar)


# Example

    import Html exposing (text)
    import Material.Toolbar as Toolbar
    import Material.Icon as Icon


    Toolbar.view Mdc "my-toolbar" model.mdc []
        [ Toolbar.row []
              [ Toolbar.section
                    [ Toolbar.alignStart
                    ]
                    [ Icon.view [ Toolbar.menuIcon ] "menu"
                    , Toolbar.title [] [ text "Title" ]
                    ]
              , Toolbar.section
                    [ Toolbar.alignEnd
                    ]
                    [ Icon.view [ Toolbar.icon ] "file_download"
                    , Icon.view [ Toolbar.icon ] "print"
                    , Icon.view [ Toolbar.icon ] "bookmark"
                    ]
              ]
        ]


# Usage

@docs Property
@docs view
@docs fixed
@docs waterfall
@docs flexible
@docs flexibleDefaultBehavior
@docs fixedLastRow
@docs backgroundImage
@docs row
@docs section
@docs alignStart
@docs alignEnd
@docs shrinkToFit
@docs menuIcon
@docs title
@docs icon, iconToggle
@docs fixedAdjust

-}

import Html exposing (Html)
import Internal.Component exposing (Index)
import Internal.Toolbar.Implementation as Toolbar
import Material
import Material.Icon as Icon
import Material.IconToggle as IconToggle
import Material.Options as Options


{-| Toolbar property.
-}
type alias Property m =
    Toolbar.Property m


{-| Toolbar view.

The first child of this function has to be a `row`.

-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Toolbar.view


{-| Make the toolbar fixed to the top and apply a persistent elevation.
-}
fixed : Property m
fixed =
    Toolbar.fixed


{-| Make the toolbar gain elevation only when the window is scrolled.
-}
waterfall : Property m
waterfall =
    Toolbar.waterfall


{-| Make the height of the toolbar change as the window is scrolled.

You will likely want to specify `flexibleDefaultBehavior` as well.

-}
flexible : Property m
flexible =
    Toolbar.flexible


{-| Make use of the flexible default behavior.
-}
flexibleDefaultBehavior : Property m
flexibleDefaultBehavior =
    Toolbar.flexibleDefaultBehavior


{-| Make the last row of the toolbar fixed.
-}
fixedLastRow : Property m
fixedLastRow =
    Toolbar.fixedLastRow


{-| Add a background image to the toolbar.
-}
backgroundImage : String -> Property m
backgroundImage =
    Toolbar.backgroundImage


{-| Toolbar row.

A row is divided into several `section`s. There has to be at least one row as
direct child of `view`.

-}
row : List (Property m) -> List (Html m) -> Html m
row =
    Toolbar.row


{-| Toolbar section.

By default sections share the available space of a row equally.

Has to be a child of `row`.

-}
section : List (Property m) -> List (Html m) -> Html m
section =
    Toolbar.section


{-| Make section align to the start.
-}
alignStart : Property m
alignStart =
    Toolbar.alignStart


{-| Make section align to the end.
-}
alignEnd : Property m
alignEnd =
    Toolbar.alignEnd


{-| Make a section take the width of its contents.
-}
shrinkToFit : Property m
shrinkToFit =
    Toolbar.shrinkToFit


{-| Style an icon to be the menu icon of the toolbar.
-}
menuIcon : Icon.Property m
menuIcon =
    Toolbar.menuIcon


{-| Add a title to the toolbar.

Has to be a child of `section`.

-}
title : List (Property m) -> List (Html m) -> Html m
title =
    Toolbar.title


{-| Style an icon as an icon at the end of the toolbar.

Should be applied to a `Icon.view`.

-}
icon : Icon.Property m
icon =
    Toolbar.icon


{-| Style an icon toggle as an icon at the end of the toolbar.

Should be applied to a `IconToggle.view`.

-}
iconToggle : IconToggle.Property m
iconToggle =
    Toolbar.iconToggle


{-| Adds a top margin to the element so that it is not covered by the toolbar.

Should be applied to a direct sibling of `view`.

-}
fixedAdjust : Index -> Material.Model m -> Options.Property c m
fixedAdjust =
    Toolbar.fixedAdjust
