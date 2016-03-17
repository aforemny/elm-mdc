module Material.Color
  ( Color(..)
  , cssName
  ) where

{-| Fixed Material Design Lite color palette.

@docs Color(..)

# Internals

These are used internally in the Material package and is likely not useful
to you.

@docs cssName : Color -> String
-}


{-| Color palette.
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
  -- Not actual colors
  | Primary
  | Accent


{-| MDL CSS name of given color.
-}
cssName : Color -> String
cssName color =
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
    Primary -> "primary"
    Accent -> "accent"
