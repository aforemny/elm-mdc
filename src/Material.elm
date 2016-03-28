module Material
  ( Color(..), topWithColors, top
  ) where

{-| Material Design component library for Elm based on Google's
[Material Design Lite](https://www.getmdl.io/).

This file contains CSS loaders only.

@docs Color, topWithColors, top
-}


import String
import Html exposing (..)
import Html.Attributes exposing (..)


{-| Possible colors for color scheme.
-}
type Color
  = Indigo
  | Blue
  | LightBlue
  | Cyan
  | Teal
  | Green
  | LightGreen
  | Lime
  | Yellow
  | Amber
  | Orange
  | Brown
  | BlueGrey
  | Grey
  | DeepOrange
  | Red
  | Pink
  | Purple
  | DeepPurple


toString : Color -> String
toString color =
  case color of
    Indigo -> "indigo"
    Blue -> "blue"
    LightBlue -> "light-blue"
    Cyan -> "cyan"
    Teal -> "teal"
    Green -> "green"
    LightGreen -> "light-green"
    Lime -> "lime"
    Yellow -> "yellow"
    Amber -> "amber"
    Orange -> "orange"
    Brown -> "brown"
    BlueGrey -> "blue-grey"
    Grey -> "grey"
    DeepOrange -> "deep-orange"
    Red -> "red"
    Pink -> "pink"
    Purple -> "purple"
    DeepPurple -> "deep-purple"


css : Color -> Color -> String
css primary accent =
  let cssFile =
    case accent of
      Grey -> ""
      Brown -> ""
      BlueGrey -> ""
      _ -> "." ++ toString primary ++ "-" ++ toString accent
  in
    [ "https://code.getmdl.io/1.1.3/material" ++ cssFile ++ ".min.css"
    , "https://fonts.googleapis.com/icon?family=Material+Icons"
    , "https://fonts.googleapis.com/css?family=Roboto:400,300,500|Roboto+Mono|Roboto+Condensed:400,700&subset=latin,latin-ext"
    ]
    |> List.map (\url -> "@import url(" ++ url ++ ");")
    |> String.join "\n"



{-| Top-level container for Material components. This will force loading of
Material Design Lite CSS files. Any component you use must be contained
in this container, OR you must manually add something like the following to
your .html file:

    <!-- MDL -->
    <link href='https://fonts.googleapis.com/css?family=Roboto:400,300,500|Roboto+Mono|Roboto+Condensed:400,700&subset=latin,latin-ext' rel='stylesheet' type='text/css'>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://code.getmdl.io/1.1.3/material.min.css" />

Supply primary and accent colors as parameters. Refer to the
Material Design Lite [Custom CSS theme builder](https://www.getmdl.io/customize/index.html)
to preview combinations.

Please be aware that Grey, Blue Grey, and Brown cannot be secondary colors. If
you choose them as such anyway, you will get the default theme.

Using this top-level container is not recommended, as most browsers will load
css concurrently with rendering the initial page, which will produce a flicker
on page load. The container is included only to provide an option to get started
quickly and for use with elm-reactor. 

-}
topWithColors : Color -> Color -> Html -> Html
topWithColors primary accent content =
  div [] <|
  {- Trick from Peter Damoc to load CSS outside of <head>.
     https://github.com/pdamoc/elm-mdl/blob/master/src/Mdl.elm#L63
   -}
  [ node "style"
    [ type' "text/css"]
    [ text <| css primary accent]
  , content
  ]


{-| Top-level container with default color scheme.
-}
top : Html -> Html
top content =
  -- Force default color-scheme by picking an invalid combination.
  topWithColors Grey Grey content
