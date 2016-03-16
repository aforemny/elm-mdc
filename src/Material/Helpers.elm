module Material.Helpers where

import Html
import Html.Attributes
import Effects exposing (Effects)

filter : (a -> List b -> c) -> a -> List (Maybe b) -> c
filter elem attr html =
  elem attr (List.filterMap (\x -> x) html)


mapWithIndex : (Int -> a -> b) -> List a -> List b
mapWithIndex f xs =
  let
    loop k ys =
      case ys of
        [] -> []
        y :: ys -> f k y :: loop (k+1) ys
  in
    loop 0 xs


effect : Effects b -> a -> (a, Effects b)
effect e x = (x, e)


pure : a -> (a, Effects b)
pure = effect Effects.none


clip : comparable -> comparable -> comparable -> comparable
clip lower upper k = Basics.max lower (Basics.min k upper)


blurOn : String -> Html.Attribute
blurOn evt =
  Html.Attributes.attribute ("on" ++ evt) <| "this.blur()"
