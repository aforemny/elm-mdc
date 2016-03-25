module Material.Icon
  ( size18, size24, size36, size48
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

@docs i, view, size18, size24, size36, size48
-}


import Html exposing (i, text, Html, Attribute)
import Html.Attributes exposing (class)
import Material.Style exposing (Style, cs, styled)

{-| Icon size styling to indicate their pixel size. This style gives a size of 18px. 
-}
size18 :  Style
size18 = 
  cs "md-18"

{-| Icon size styling to indicate their pixel size. This style gives a size of 24px. 
-}
size24 :  Style
size24 = 
  cs "md-24"

{-| Icon size styling to indicate their pixel size. This style gives a size of 36px. 
-}
size36 :  Style
size36 = 
  cs "md-36"

{-| Icon size styling to indicate their pixel size. This style gives a size of 48px. 
-}
size48 :  Style
size48 = 
  cs "md-48"

{-| View function for icons. Supply the
[Material Icons Library](https://design.google.com/icons/) name as
the first argument (replace spaces with underscores); and the size of the icon
as the second (as a list of styles). Do not use this function to produce clickable icons; use
icon buttons in Material.Button for that.

If you doesn't specify any style size, it gives you the default size, 24px.

I.e., to produce a 48px
["trending flat"](https://design.google.com/icons/#ic_trending_flat) icon with
no attributes:

    import Material.Icon as Icon

    icon : Html
    icon = Icon.view "trending_flat" [Icon.size48] []

This function will override any `class` set in `List Attribute`.
-}
view : String -> List Style -> List Attribute-> Html
view name styling attrs=
  styled Html.i
    (  cs "material-icons"
    :: styling
    )
    attrs
    [text name]
  
{-| Render a default-sized icon with no behaviour. The
`String` argument must be the name of a [Material Icon](https://design.google.com/icons/)
(replace spaces with underscores).

I.e., to produce a default size (24xp) "trending flat" icon:

    import Material.Icon as Icon

    icon : Html
    icon = Icon.i "trending_flat"
-}
i : String -> Html
i name = view name [] []
