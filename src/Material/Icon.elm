module Material.Icon
  ( Size(..)
  , viewWithOptions
  , view
  , i
  ) where

{-| Convenience functions for producing Material Design Icons. Refer to
[the Material Design Icons page](https://google.github.io/material-design-icons),
or skip straight to the [Material Icons Library](https://design.google.com/icons/).

This implementation assumes that you have

    <link href="https://fonts.googleapis.com/icon?family=Material+Icons"
      rel="stylesheet">

or an equivalent means of loading the icons in your HTML header.

@docs i, Size, viewWithOptions, view
-}

import Html exposing (i, text, Html, Attribute)
import Html.Attributes exposing (class, attribute)
import Material.Badge as Badge

{-| Size of an icon. Constructors indicate their pixel size, i.e.,
`S18` is 18px. The constructor `S` gives you the default size, 24px.
-}
type Size
  = S18 | S24 | S36 | S48 | S

{-| Options
See Badge on how to create a badge.
-}
type alias Options =
  { 
    badgeInfo : Maybe Badge.BadgeInfo
  }

{-| default options
See Badge on how to create a badge.
-}
defaultOptions : Options
defaultOptions =
  { 
    badgeInfo = Nothing
  }


{-| View function for icons. Supply the
[Material Icons Library](https://design.google.com/icons/) name as
the first argument (replace spaces with underscores); and the size of the icon
as the second. Do not use this function to produce clickable icons; use
icon buttons in Material.Button for that.

I.e., to produce a 48px
["trending flat"](https://design.google.com/icons/#ic_trending_flat) icon with
no attributes:

See Badge for info on how to create a badge for options.

    import Material.Icon as Icon

    icon : Html
    icon = Icon.viewWithOptions "trending_flat" Icon.S48 []  { badgeInfo = Just (Badge.viewDefault "16")

This function will override any `class` set in `List Attribute`.
-}
viewWithOptions : String -> Size -> List Attribute -> Options-> Html
viewWithOptions name size attrs options =
  let
    sz =
      case size of
        S18 -> " md-18"
        S24 -> " md-24"
        S36 -> " md-36"
        S48 -> " md-48"
        S -> ""
    appAttrs = 
      case options.badgeInfo of
        Just badgeInfo -> List.append attrs [badgeInfo.dataBadge] 
        Nothing -> attrs
    optionClasses = 
      case options.badgeInfo of
        Just badgeInfo -> badgeInfo.classes 
        Nothing -> ""
  in
    Html.i (class ("material-icons" ++ sz ++ optionClasses ) :: appAttrs) [text name]

{-| View function for icons. Supply the
[Material Icons Library](https://design.google.com/icons/) name as
the first argument (replace spaces with underscores); and the size of the icon
as the second. Do not use this function to produce clickable icons; use
icon buttons in Material.Button for that.

I.e., to produce a 48px
["trending flat"](https://design.google.com/icons/#ic_trending_flat) icon with
no attributes:

    import Material.Icon as Icon

    icon : Html
    icon = Icon.view "trending_flat" Icon.S48 []

This function will override any `class` set in `List Attribute`.
-}

view : String -> Size -> List Attribute -> Html
view name size attrs = viewWithOptions name size attrs defaultOptions


{-| Render a default-sized icon with no behaviour. The
`String` argument must be the name of a [Material Icon](https://design.google.com/icons/)
(replace spaces with underscores).

I.e., to produce a default size (24xp) "trending flat" icon:

    import Material.Icon as Icon

    icon : Html
    icon = Icon.i "trending_flat"
-}
i : String -> Html
i name = view name S [] 
