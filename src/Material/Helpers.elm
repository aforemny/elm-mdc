module Material.Helpers where

import Html
import Html.Attributes
import Effects exposing (Effects)

filter : (a -> List b -> c) -> a -> List (Maybe b) -> c
filter elem attr html =
  elem attr (List.filterMap (\x -> x) html)


effect : Effects b -> a -> (a, Effects b)
effect e x = (x, e)


pure : a -> (a, Effects b)
pure = effect Effects.none


addFx : Effects a -> (model, Effects a) -> (model, Effects a)
addFx effect1 (model, effect2) =
  (model, Effects.batch [effect1, effect2])

mapFx : (a -> b) -> (model, Effects a) -> (model, Effects b)
mapFx f (model, effect) =
  (model, Effects.map f effect)

clip : comparable -> comparable -> comparable -> comparable
clip lower upper k = Basics.max lower (Basics.min k upper)


blurOn : String -> Html.Attribute
blurOn evt =
  Html.Attributes.attribute ("on" ++ evt) <| "this.blur()"


-- TUPLES


map1 : (a -> a') -> (a, b, c) -> (a', b, c)
map1 f (x,y,z) = (f x, y, z)


map2 : (b -> b') -> (a, b, c) -> (a, b', c)
map2 f (x,y,z) = (x, f y, z)


map1st : (a -> c) -> (a,b) -> (c,b)
map1st f (x,y) = (f x, y)


map2nd : (b -> c) -> (a,b) -> (a,c)
map2nd f (x,y) = (x, f y)


