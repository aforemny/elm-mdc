module Material.Infix where

import Maybe

(|?>): Maybe a -> (a -> b) -> Maybe b
(|?>) x f = Maybe.map f x

(|??>) : Maybe a -> (a -> Maybe b) -> Maybe b
(|??>) = Maybe.andThen

(|?) : Maybe a -> a -> a
(|?) x y = Maybe.withDefault y x
